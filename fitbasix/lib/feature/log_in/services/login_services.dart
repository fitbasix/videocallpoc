import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fitbasix/core/api_service/dio_service.dart';
import 'package:fitbasix/core/routes/api_routes.dart';
import 'package:fitbasix/feature/log_in/model/countries_model.dart';
import 'package:fitbasix/feature/log_in/model/logInRegisterModel.dart';

class LogInService {
  static var dio = DioUtil().getInstance();
  static Future<void> logInRequest(String logInType, String email) async {
    print(logInType);
    print(email);
    var response = await dio!.post(
        "https://be-fitbasix.antino.ca/api/auth/login",
        data: {"loginType": logInType, "email": email});
    print(response);
  }

  static Future<LogInRegisterModel> logInRegisterUser(
      String regType,
      String role,
      String email,
      String phnNumber,
      String countryCode,
      String accessToken,
      String serverAuthCode,
      String idToken) async {
    log("vafd");
    print(role);
    print(phnNumber);
    dio!.options.headers["language"] = "0";
    var response = await dio!.post(ApiUrl.loginRegisterRequest, data: {
      "regType": regType,
      "role": role,
      "email": email,
      "phoneNumber": phnNumber,
      "countryCode": countryCode,
      "accessToken": accessToken,
      "serverAuthCode": serverAuthCode,
      "idToken": idToken
    });
    log(response.toString());
    print(response.toString());
    return logInRegisterModelFromJson(response.toString());
  }

  static Future<String> getOTP(String mobile) async {
    String url = ApiUrl.liveBaseURL + '/api/auth/sendOtp?leng=EN';
    var response =
        await dio!.post(url, data: {"phone": mobile, "countryCode": '+91'});
    print(response);

    return response.data['type'];
  }

  static Future<int> updateDetails(
      String password, String email, String fullName) async {
    dio!.options.headers["language"] = "0";
    var response = await dio!.post(ApiUrl.updateDetails,
        data: {"password": password, "email": email, "fullName": fullName});
    final responseData = jsonDecode(response.toString());
    return responseData["resCode"];
  }

  static Future<bool> verifyOTP(
      String otp, String phnNumber, String countryCode) async {
    dio!.options.headers["language"] = "0";
    var response = await dio!.post(ApiUrl.verifyOTP, data: {
      "otp": otp,
      "phoneNumber": phnNumber,
      "countryCode": countryCode
    });
    final responseData = jsonDecode(response.toString());
    print(response);
    print(responseData["status"]);
    return responseData["status"];
  }

  static Future<Countries> getCountries() async {
    dio!.options.headers["language"] = "0";
    var response = await dio!.get(ApiUrl.getCountries);

    print(response);

    return countriesFromJson(response.toString());
  }

  static Future thirdPartyLogin(String provider, String token) async {
    String url = ApiUrl.liveBaseURL + '/api/auth/thirdPartyLogin?type=EN';
    var response = await dio!.post(url, data: {
      "provider": provider,
      "token": token,
    });
    print(response);
  }

  static Future loginAndSignup(String mobile, String otp) async {
    String url = ApiUrl.liveBaseURL + '/api/auth/login';

    var response = await dio!
        .put(url, data: {"phone": mobile, "countryCode": '+91', "otp": otp});

    print(response);
  }

  static Future registerUser(String name, String email) async {
    String url = ApiUrl.liveBaseURL + '/api/auth/create';

    var response = await dio!.put(url, data: {"name": name, "email": email});

    print(response);
  }
}
