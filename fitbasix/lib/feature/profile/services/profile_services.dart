import 'dart:developer';

import 'package:fitbasix/core/routes/api_routes.dart';

import '../../../core/api_service/dio_service.dart';
import '../../Home/model/post_feed_model.dart';
import '../../log_in/services/login_services.dart';

class ProfileServices {
  static var dio = DioUtil().getInstance();

  static Future<void> editProfile(
      {String? email,
      String? countryCode,
      String? phone,
      String? dob,
      String? otp}) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    String? verifiedNumber;
    print(email);
    print(countryCode);
    print(phone);
    print(dob);
    if (phone != null) {
      print("otp verify");
      // await LogInService.getOTP(phone, "000000");
    }
    Map editEmail = {"email": email};
    Map editPhone = {"countryCode": countryCode, "phone": phone, "otp": otp};
    Map editDob = {"DOB": dob};
    Map editEmailPhone = {
      "email": email,
      "countryCode": countryCode,
      "otp": otp,
      "phone": phone
    };
    Map editEmailDob = {"email": email, "DOB": dob};
    Map editPhoneDob = {
      "countryCode": countryCode,
      "phone": phone,
      "otp": otp,
      "DOB": dob
    };
    Map editAll = {
      "email": email,
      "countryCode": countryCode,
      "phone": phone,
      "otp": otp,
      "DOB": dob
    };
    print("otp done");
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    print("profile update" +
        (email != null && phone != null && dob != null
                ? editAll
                : email != null && phone != null && dob == null
                    ? editEmailPhone
                    : email != null && phone == null && dob != null
                        ? editEmailDob
                        : email != null && phone == null && dob == null
                            ? editEmail
                            : phone != null && dob != null
                                ? editPhoneDob
                                : phone != null && dob == null
                                    ? editPhone
                                    : dob != null
                                        ? editDob
                                        : null)
            .toString());
    final response = await dio!.put(ApiUrl.editProfile,
        data: email != null && phone != null && dob != null
            ? editAll
            : email != null && phone != null && dob == null
                ? editEmailPhone
                : email != null && phone == null && dob != null
                    ? editEmailDob
                    : email != null && phone == null && dob == null
                        ? editEmail
                        : phone != null && dob != null
                            ? editPhoneDob
                            : phone != null && dob == null
                                ? editPhone
                                : dob != null
                                    ? editDob
                                    : null);
    log("response   " + response.data.toString());
    log(response.toString());
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
