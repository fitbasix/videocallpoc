import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:fitbasix/core/routes/api_routes.dart';
import 'package:flutter/material.dart';
import '../../../core/api_service/dio_service.dart';
import '../../Home/model/post_feed_model.dart';
import '../../log_in/services/login_services.dart';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';
import 'package:fitbasix/core/api_service/dio_service.dart';
import 'package:fitbasix/core/routes/api_routes.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';

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

  static Future<String> UpdateProfilePhoto({List<File>? profilePhoto}) async {
    var formData = FormData();
    // formData.ad;
    if (profilePhoto != null)
      for (var file in profilePhoto) {
        formData.files.addAll([
          MapEntry(
              'profilePhoto',
              await MultipartFile.fromFile(file.path,
                  filename: file.path.split('/').last)),
        ]);
      }
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    final response = await dio!.post(ApiUrl.profilePic, data: formData);
    final responseData = jsonDecode(response.toString());
    return responseData["response"]["data"];
  }

  static Future<String> UpdateCoverPhoto({List<File>? coverPhoto}) async {
    var formData = FormData();
    // formData.ad;
    if (coverPhoto != null)
      for (var file in coverPhoto) {
        formData.files.addAll([
          MapEntry(
              'coverPhoto',
              await MultipartFile.fromFile(file.path,
                  filename: file.path.split('/').last)),
        ]);
      }
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    final response = await dio!.post(ApiUrl.coverPic, data: formData);
    final responseData = jsonDecode(response.toString());
    return responseData["response"]["data"];
  }

  static Future<void> UpdateProfileData(
      {String? name,
      String? bio,
      int? height,
      int? weight,
      int? gender,
      List<int>? interests}) async {
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


    return postsModelFromJson(response.toString());
  }
}
