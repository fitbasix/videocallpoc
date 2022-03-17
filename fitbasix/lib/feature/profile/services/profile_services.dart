import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fitbasix/core/routes/api_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../../core/api_service/dio_service.dart';
import '../../Home/model/post_feed_model.dart';
import '../../log_in/services/login_services.dart';
import 'package:http/http.dart' as http;

class ProfileServices {
  static var dio = DioUtil().getInstance();

  static Future<bool> editProfile(
      {String? countryCode,
      String? phone,
      String? dob,
      String? otp,
      required BuildContext context}) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();

    String token = await LogInService.getAccessToken();
    dio!.options.headers["language"] = "1";
    try {
      final response = await http.put(Uri.parse(ApiUrl.editProfile),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'language': '1',
            "Authorization": token
          },
          body: phone == null && dob != null
              ? jsonEncode(<String, String>{"DOB": dob})
              : dob == null
                  ? jsonEncode(<String, String>{
                      "countryCode": countryCode!,
                      "phone": phone!,
                      "otp": otp!,
                    })
                  : jsonEncode(<String, String>{
                      "countryCode": countryCode!,
                      "phone": phone!,
                      "otp": otp!,
                      "DOB": dob
                    }));
      log("kjj" + response.body.toString());
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 409) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData["response"]["message"])));
        return false;
      } else {
        return true;
      }
    } catch (e) {
      // if()
      // print(e.);
      return true;
    }
  }

  static Future<bool> getOTP(
      String mobile, String countryCode, BuildContext context) async {
    dio!.options.headers["language"] = "1";
    String token = await LogInService.getAccessToken();
    try {
      var response = await http.post(Uri.parse(ApiUrl.editNumberOtp),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'language': '1',
            "Authorization": token
          },
          body: jsonEncode(
              <String, String>{"phone": mobile, "countryCode": countryCode}));
      final responseData = jsonDecode(response.body);
      log(response.body.toString());
      if (response.statusCode == 409) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData["response"]["message"])));
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return true;
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('number_used'.tr)));
    }
  }

  static Future<void> UpdateCoverPhoto({String? coverPhoto}) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    // print(interests);
    final response = await dio!.put(ApiUrl.editProfile, data: {
      "coverPhoto": coverPhoto,
    });
    print(response.toString());
  }

  static Future<void> UpdateProfileData(
      {String? name,
      String? bio,
      int? height,
      int? weight,
      int? gender,
      List<int>? interests,
      String? profilePhoto}) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    print(interests);
    final response = await dio!.put(ApiUrl.editProfile, data: {
      "name": name,
      "bio": bio,
      "height": height,
      "weight": weight,
      "gender": gender,
      "interests": interests,
      "profilePhoto": profilePhoto,
    });
    print(response.toString());
  }

  static Future<PostsModel> getUserPosts({int? skip}) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var token = await LogInService.getAccessToken();
    print(token);
    var response = await dio!
        .post(ApiUrl.getTrainerPosts, data: {"skip": skip == null ? 0 : skip});

    log(response.toString());

    return postsModelFromJson(response.toString());
  }
}
