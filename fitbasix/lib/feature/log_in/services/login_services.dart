import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitbasix/core/api_service/dio_service.dart';
import 'package:fitbasix/core/routes/api_routes.dart';
import 'package:fitbasix/feature/log_in/controller/login_controller.dart';
import 'package:fitbasix/feature/log_in/model/countries_model.dart';
import 'package:fitbasix/feature/log_in/model/third_party_model.dart';

class LogInService {
  static LoginController loginController = Get.find();
  static var dio = DioUtil().getInstance();

  static Future<String> getOTP(String mobile, String countryCode) async {
    dio!.options.headers["language"] = "1";
    var response = await dio!.post(ApiUrl.getOTP,
        data: {"phone": mobile, "countryCode": countryCode});
    log(response.toString());

    return response.data['response']['message'];
  }

  static Future<Countries> getCountries() async {
    dio!.options.headers["language"] = "1";
    var response = await dio!.get(ApiUrl.getCountries);

    return countriesFromJson(response.toString());
  }

  static Future<ThirdPartyModel> thirdPartyAppleLogin(
      String provider, String name, String token) async {
    String url = ApiUrl.liveBaseURL + '/api/auth/thirdPartyLogin?type=EN';
    var response = await dio!
        .post(url, data: {"provider": provider, "token": token, "name": name});
    print(response);
    return thirdPartyModelFromJson(response.toString());
  }

  static Future<int> thirdPartyLogin(String provider, String token) async {
    dio!.options.headers["language"] = "1";
    var response = await dio!.post(ApiUrl.thirdPartyLogin, data: {
      "provider": provider,
      "token": token,
    });
    log(response.data['response']['screenId'].toString());

    return response.data['response']['screenId'];
  }

  static Future<int?> loginAndSignup(
      String mobile, String otp, String countryCode, String? email) async {
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
      log(responseData.toString());
      if (responseData['code'] == 0) {
        loginController.token.value = responseData['response']['token'];
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        var accessToken = prefs.getString('AccessToken');
      } else {
        loginController.otpErrorMessage.value =
            responseData['response']['message'];
      }
      return responseData['response']['screenId'];
    } on Exception catch (e) {
      log(e.toString());
      return null;
    }
  }

  static Future<int?> registerUser(String name, String email) async {
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
      log(responseData.toString());
      return responseData['response']['screenId'];
    }
  }
}
