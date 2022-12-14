import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:fitbasix/feature/log_in/model/third_party_login.dart';
import 'package:fitbasix/main_dev.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info/device_info.dart';

import 'package:fitbasix/core/api_service/dio_service.dart';
import 'package:fitbasix/core/routes/api_routes.dart';
import 'package:fitbasix/feature/log_in/controller/login_controller.dart';
import 'package:fitbasix/feature/log_in/model/countries_model.dart';
import 'package:fitbasix/feature/log_in/model/third_party_model.dart';

import '../../../core/constants/image_path.dart';
import '../view/login_screen.dart';

class LogInService {
  static LoginController loginController = Get.put(LoginController());
  static var dio = DioUtil().getInstance();

  static Future<String> getOTP(String mobile, String countryCode) async {
    dio!.options.headers["language"] = "1";
    var response = await dio!.post(ApiUrl.getOTP,
        data: {"phone": mobile, "countryCode": countryCode});
    return response.data['response']['message'];
  }

  static Future<Countries> getCountries() async {
    dio!.options.headers["language"] = "1";
    var response = await dio!.get(ApiUrl.getCountries);
    return countriesFromJson(response.toString());
  }

  static Future<String> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('AccessToken').toString();
  }

  static Future<String> getRefreshToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('RefreshToken').toString();
  }

  static Future<ThirdPartyLogin> thirdPartyAppleLogin(
      String provider, String name, String token) async {
    String url = ApiUrl.liveBaseURL + '/api/auth/thirdPartyLogin?type=EN';
    Map firstTime = {"provider": provider, "token": token, "name": name};
    Map notFirstTime = {
      "provider": provider,
      "token": token,
    };
    var response =
        await dio!.post(url, data: name == "" ? notFirstTime : firstTime);
    print(response);
    return thirdPartyLoginFromJson(response.toString());
  }

  static Future<ThirdPartyLogin> thirdPartyLogin(
      String provider, String token) async {
    dio!.options.headers["language"] = "1";
    var response = await dio!.post(ApiUrl.thirdPartyLogin, data: {
      "provider": provider,
      "token": token,
    });

    return thirdPartyLoginFromJson(response.toString());
  }

  static Future updateToken() async {
    var refreshToken = await getRefreshToken();
    print(refreshToken);
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.post(ApiUrl.updateToken, data: {
      "refreshToken": refreshToken,
    });
    print("response" + response.toString());
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('AccessToken', response.data['response']['token']);
    prefs.setString('RefreshToken', response.data['response']['refreshToken']);
    registerFcmToken();
  }

  static Future<int?> loginAndSignup(String mobile, String otp,
      String countryCode, String? email, BuildContext context) async {
    try {
      var putResponse = await http.put(
        Uri.parse(ApiUrl.loginAndSignup),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'language': '1'
        },
        body: jsonEncode(<String, String>{
          "phone": mobile,
          "countryCode": countryCode,
          "otp": otp,
          "email": email!
        }),
      );

      final responseData = jsonDecode(putResponse.body);
      if (putResponse.statusCode == 405) {
        Get.deleteAll();
        Navigator.pop(context);
      }
      if (responseData['code'] == 0) {
        loginController.token.value = responseData['response']['user']['token'];
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        loginController.userId.value =  responseData['response']['user']['id'];
        loginController.profilePhoto.value = responseData['response']['user']['profilePhoto'];
        prefs.setString(
            'AccessToken', responseData['response']['user']['token']);
        prefs.setString(
            'RefreshToken', responseData['response']['refreshToken']);
        prefs.setString('userId',loginController.userId.value );
        registerFcmToken();
        print(responseData['response']['refreshToken']);
      } else {
        loginController.otpErrorMessage.value =
            responseData['response']['message'];
      }
      if (putResponse.statusCode == 445) {
        Get.deleteAll();
        final SnackBar snackBar = SnackBar(
            content: Text(
          responseData["response"]["message"],
          style: const TextStyle(color: Colors.white),
        ));
        snackbarKey.currentState?.showSnackBar(snackBar);
        Navigator.pop(context);
      }
      return responseData['response']['screenId'];
    } on Exception catch (e) {
      return null;
    }
  }

  static Future<void> RegisterDeviceToken(
      String deviceToken, String deviceId) async {
    var dio = DioUtil().getInstance();
    dio!.options.headers["language"] = "1";
    dio.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio.post(ApiUrl.updateDeviceToken,
        data: {"deviceToken": deviceToken, "deviceId": deviceId});
  }

  static Future<int?> registerUser(String name, String email) async {
    loginController.token.value = await getAccessToken();
    print("token   " + loginController.token.value);
    if (loginController.token.value == '') {
      var putResponse = await http.put(
        Uri.parse(ApiUrl.registerUser),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'language': '1'
          // 'Authorization': LoginController().token.value
        },
        body: jsonEncode(<String, String>{
          "name": name,
          "email": email,
        }),
      );
    } else {
      try {
        var putResponse = await http.put(
          Uri.parse(ApiUrl.registerUser),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'language': '1',
            'Authorization': loginController.token.value
          },
          body: jsonEncode(<String, String>{
            "name": name,
            "email": email,
          }),
        );

        final responseData = jsonDecode(putResponse.body);
        if (responseData['code'] == 0) {
          return responseData['response']['screenId'];
        } else
          return 1;
      } on Exception catch (e) {
        // TODO
      }
    }
  }

  static Future<void> logOut() async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();

    var RefreshToken = await getRefreshToken();
    print(RefreshToken);
    var response =
        await dio!.post(ApiUrl.logOut, data: {"refreshToken": RefreshToken});
    print(response.statusMessage);
  }

  static Future<void> removeDeviceId() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    AndroidDeviceInfo? androidInfo;
    IosDeviceInfo? iosInfo;
    if (Platform.isAndroid == true) {
      androidInfo = await deviceInfoPlugin.androidInfo;
    } else {
      iosInfo = await deviceInfoPlugin.iosInfo;
    }
    String deviceId = Platform.isAndroid
        ? androidInfo!.androidId
        : iosInfo!.identifierForVendor;

    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();

    var response = await dio!.delete(
      ApiUrl.removeDeviceId,
      data: {"deviceId": deviceId},
    );
    print(response.statusMessage);
  }
}
