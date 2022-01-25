import 'dart:convert';
import 'dart:developer';

import 'package:fitbasix/core/api_service/dio_service.dart';
import 'package:fitbasix/core/routes/api_routes.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';
import 'package:fitbasix/feature/posts/model/UserModel.dart';
import 'package:fitbasix/feature/posts/model/category_model.dart';
import 'package:fitbasix/feature/posts/model/post_model.dart';
import 'package:fitbasix/feature/Home/model/user_profile_model.dart';

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

  static Future<PostData> createPost({
    String? postId,
    String? caption,
    List<String>? taggedPeople,
    List<String>? placeName,
    String? placeId,
    List<String>? files,
    int? category,
    bool? isPublish,
  }) async {
    var access = await LogInService.getAccessToken();
    print(access);
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();

    Map updateCaption = {"postId": postId, "caption": caption};
    Map updateFiles = {"postId": postId, "files": files};
    Map updateLocation = {
      "postId": postId,
      "location": {"placeName": placeName, "placeId": placeId}
    };
    Map updatePeople = {"postId": postId, "people": taggedPeople};
    Map updateCategory = {"postId": postId, "category": category};
    Map publishPost = {"postId": postId, "isPublished": isPublish};
    Map getPostData = {"postId": postId};
    var response = await dio!.post(ApiUrl.createPost,
        data: caption != null
            ? updateCaption
            : files != null
                ? updateFiles
                : placeId != null
                    ? updateLocation
                    : taggedPeople != null
                        ? updatePeople
                        : category != null
                            ? updateCategory
                            : isPublish != null
                                ? publishPost
                                : getPostData);
    log(response.data.toString());
    return postDataFromJson(response.toString());
    // return response.data['response']['data']["_id"];
  }

  static Future deletePost(String? postId) async {
    dio!.options.headers["language"] = "1";
    print("lll");
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response =
        await dio!.delete(ApiUrl.deletePost, data: {"postId": postId});
    print(response.data.toString());
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

  static Future<CategoryModel> getCategory() async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.get(ApiUrl.getAllCategory);

    log(response.data.toString());
    return categoryModelFromJson(response.toString());
  }
}
