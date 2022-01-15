import 'dart:developer';

import 'package:fitbasix/core/api_service/dio_service.dart';
import 'package:fitbasix/core/routes/api_routes.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';
import 'package:fitbasix/feature/posts/model/UserModel.dart';
import 'package:fitbasix/feature/posts/model/user_profile_model.dart';

class CreatePostService {
  static var dio = DioUtil().getInstance();
  static Future<String> getPostId() async {
    dio!.options.headers["language"] = "1";
    print("lll");
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.post(ApiUrl.createPost, data: {});
    print("kkk" + response.data['response']['data']["_id"]);
    return response.data['response']['data']["_id"];
  }

  static Future<void> createPost(
      {String? postId,
      String? caption,
      List<String>? taggedPeople,
      List<String>? placeName,
      String? placeId,
      bool? isPublish}) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.post(ApiUrl.createPost, data: {
      "postId": postId,
      "caption": caption,
      "people": taggedPeople,
      "location": {"placeName": placeName, "placeId": placeId},
      "isPublished": isPublish
    });
    print(response.data.toString());
    // return response.data['response']['data']["_id"];
  }

  // static Fut
  static Future<Users> getUsers(String name) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.post(ApiUrl.getUsers, data: {"name": name});
    return usersFromJson(response.toString());
  }

  static Future<UserProfileModel> getUserProfile() async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.get(ApiUrl.getUserProfile);
    log(response.data.toString());
    return userProfileModelFromJson(response.toString());
  }
}
