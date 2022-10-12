import 'dart:developer';

import 'package:crypt/crypt.dart';
import 'package:fitbasix/core/api_service/dio_service.dart';
import 'package:fitbasix/core/routes/api_routes.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';
import 'package:fitbasix/feature/message/controller/chat_controller.dart';
import 'package:fitbasix/feature/posts/model/UserModel.dart';
import 'package:fitbasix/feature/posts/model/category_model.dart';
import 'package:fitbasix/feature/posts/model/post_model.dart';
import 'package:fitbasix/feature/Home/model/user_profile_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:quickblox_sdk/models/qb_session.dart';
// import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/credentials.dart';
import '../../Home/controller/Home_Controller.dart';

class CreatePostService {
  static var dio = DioUtil().getInstance();

  static HomeController _homeController = Get.find();
  static Future<PostData> getPostId() async {
    dio!.options.headers["language"] = "1";
    print("lll");
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.post(ApiUrl.createPost, data: {});
    print("kkk" + response.data['response']['data']["_id"]);
    return postDataFromJson(response.toString());
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
    try {
      var access = await LogInService.getAccessToken();
      print(access);
      dio!.options.headers["language"] = "1";
      dio!.options.headers['Authorization'] =
          await LogInService.getAccessToken();

      Map updateCaption = {"postId": postId, "caption": caption};
      Map updateFiles = {"postId": postId, "files": files};
      Map updateLocation = {
        "postId": postId,
        "location": {"placeName": placeName, "placeId": placeId}
      };
      Map updatePeople = {"postId": postId, "people": taggedPeople};
      Map updateCategory = {"postId": postId, "category": category};
      Map publishPost = {
        "postId": postId,
        "isPublished": isPublish,
        "caption": caption,
        "files": files ?? []
      };
      Map getPostData = {"postId": postId};
      var response = await dio!
          .post(ApiUrl.createPost,
              data: isPublish != null && caption != null
                  ? publishPost
                  : caption != null
                      ? updateCaption
                      : files != null
                          ? updateFiles
                          : placeId != null
                              ? updateLocation
                              : taggedPeople != null
                                  ? updatePeople
                                  : category != null
                                      ? updateCategory
                                      : getPostData)
          .timeout(Duration(seconds: 3));
      //todo handle null to stop timer of create post
      return postDataFromJson(response.toString());
    } catch (e) {
      print(e);
      return PostData();
    }
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

  static Future<String> deleteUserPost(String? postId) async {
    dio!.options.headers["language"] = "1";
    print("lll");
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response =
        await dio!.delete(ApiUrl.deletePost, data: {"postId": postId});
    print(response.data.toString());
    return response.data['response']['message'];
  }

  // static Fut
  static Future<Users> getUsers(String name) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.post(ApiUrl.getUsers, data: {"name": name});
    print(response);
    return usersFromJson(response.toString());
  }

  static Future<UserProfileModel> getUserProfile() async {
    var dio = DioUtil().getInstance();
    dio!.options.headers["language"] = "1";
    dio.options.headers['Authorization'] = await LogInService.getAccessToken();

    print(dio.options.headers["Authorization"].toString() + "tokenDemo");
    var response = await dio.get(ApiUrl.getUserProfile);

    UserProfileModel _userProfileModel =
        userProfileModelFromJson(response.toString());
    print("rrrrrrrr"+response.toString());
    update(_userProfileModel);

    return _userProfileModel;
  }

  static Future<void> update(UserProfileModel userProfileModel) async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("userIdForCometChat",
        "chat_" + userProfileModel.response!.data!.profile!.id!);
    print(sharedPreferences.getString("userIdForCometChat"));
    if (userProfileModel.response!.data!.profile!.chatId == null) {
      print("creating user on comet chat");
      // CometChatService().createUser(
      //     "chat_" + userProfileModel.response!.data!.profile!.id!,
      //     userProfileModel.response!.data!.profile!.name!);
      ChatController _chatController = Get.put(ChatController());
      _chatController.USERID = "chat_" + userProfileModel.response!.data!.profile!.id!;
      int response = await updateUserQuickBloxId(
          userProfileModel.response!.data!.profile!.id!);
      if (response == 200) {
        print("UserUpdatedOnBackend");
      }
    } else {
      ChatController _chatController = Get.put(ChatController());
      _chatController.USERID = userProfileModel.response!.data!.profile!.chatId!;
    }
  }

  static Future<CategoryModel> getCategory() async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.get(ApiUrl.getAllCategory);
    return categoryModelFromJson(response.toString());
  }



  static Future<int> updateUserQuickBloxId(String userQuickBloxId) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.post(ApiUrl.updateUserQuickBloxId,
        data: {"chatId": "chat_" + userQuickBloxId});
    return response.statusCode!;
  }
}
