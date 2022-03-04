import 'dart:developer';

import 'package:fitbasix/core/routes/api_routes.dart';

import '../../../core/api_service/dio_service.dart';
import '../../Home/model/post_feed_model.dart';
import '../../log_in/services/login_services.dart';

class ProfileServices {
  static var dio = DioUtil().getInstance();

  static Future<void> editProfile(
      {String? email, String? countryCode, String? phone, String? dob}) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();

    Map editEmail = {"email": email};
    Map editPhone = {"countryCode": countryCode, "phone": phone};
    Map editDob = {"DOB": dob};
    Map editEmailPhone = {
      "email": email,
      "countryCode": countryCode,
      "phone": phone
    };
    Map editEmailDob = {"email": email, "DOB": dob};
    Map editPhoneDob = {"countryCode": countryCode, "phone": phone};
    Map editAll = {
      "email": email,
      "countryCode": countryCode,
      "phone": phone,
      "DOB": dob
    };

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
    log(response.statusCode.toString());
    log(response.toString());
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
