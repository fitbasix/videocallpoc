import 'dart:developer';

import 'package:crypt/crypt.dart';
import 'package:fitbasix/core/api_service/dio_service.dart';
import 'package:fitbasix/core/routes/api_routes.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';
import 'package:fitbasix/feature/posts/model/UserModel.dart';
import 'package:fitbasix/feature/posts/model/category_model.dart';
import 'package:fitbasix/feature/posts/model/post_model.dart';
import 'package:fitbasix/feature/Home/model/user_profile_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickblox_sdk/models/qb_session.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
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
        "caption": caption
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
    update(_userProfileModel);

    return _userProfileModel;
  }

  static Future<void> update(UserProfileModel userProfileModel) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt("userQuickBloxId", 0);
    if (userProfileModel.response!.data!.profile!.quickBloxId != null) {
      try {
        String userId = userProfileModel.response!.data!.profile!.id!;
        final password = Crypt.sha256(
            userProfileModel.response!.data!.profile!.id!,
            salt: '10');
        bool loggedIn = await LogInUserToQuickBlox(
            userId,
            password.hash.substring(0, 39),
            userProfileModel.response!.data!.profile!.quickBloxId!);
      } catch (e) {
        throw e;
      }

      //await InitializeQuickBlox().initWebRTC();
      // InitializeQuickBlox().subscribeCall();

    } else {
      try {
        String userId = userProfileModel.response!.data!.profile!.id!;
        final password = Crypt.sha256(
            userProfileModel.response!.data!.profile!.id!,
            salt: '10');
        String userName = userProfileModel.response!.data!.profile!.name!;
        int? userQuickBloxId = await createUserOnQuickBlox(
            name: userName,
            loginId: userId,
            password: password.hash.substring(0, 39));

        int response = await updateUserQuickBloxId(userQuickBloxId!);
        bool loggedIn =
            await LogInUserToQuickBlox(userId, password.hash, userQuickBloxId);

        //await InitializeQuickBlox().initWebRTC();
        // await InitializeQuickBlox().subscribeCall();

      } catch (e) {
        throw e;
        //todo handle if QBlox has some backend error

      }
    }
  }

  static Future<CategoryModel> getCategory() async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.get(ApiUrl.getAllCategory);
    return categoryModelFromJson(response.toString());
  }

  static void getSessionQB() async {
    try {
      QBSession? session = await QB.auth.getSession().then((value) async {
        QBSession? session2 = await QB.auth.setSession(value!);
      });
    } on PlatformException catch (e) {
      throw e;
      // Some error occurred, look at the exception message for more details
      print(e.toString());
    }
  }

  static Future<bool> LogInUserToQuickBlox(
      String logIn, String password, int userQuickBloxId) async {
    print("called login");

    var connected = await QB.chat.isConnected();
    if (connected!) {
      print("called cat connected");
      //todo remove the comment for webrtc
      InitializeQuickBlox().initWebRTC();
      //InitializeQuickBlox().subscribeCall();
    }
    var result = await QB.auth.login(logIn, password).then((value) async {
      final sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setInt("userQuickBloxId", value.qbUser!.id!);
      connectUserToChat(password, userQuickBloxId);
      if (value.qbUser != null) {
        return true;
      } else {
        return false;
      }
    });

    ///connect user to chat

    return false;
  }

  static connectUserToChat(String password, int userQuickBloxId) async {
    var chatConnect = await QB.chat.isConnected();
    if (chatConnect!) {
      //todo remove comment for initWebRTC to enable video call
      InitializeQuickBlox().initWebRTC();

      //InitializeQuickBlox().subscribeCall();
    }
    print("called connect user to chat");
    try {
      var result =
          await QB.chat.connect(userQuickBloxId, password).then((value) async {
        var chatConnect = await QB.chat.isConnected();
        if (chatConnect!) {
          //todo remove comment for initWebRTC to enable video call
          InitializeQuickBlox().initWebRTC();

          //InitializeQuickBlox().subscribeCall();
        }
      });
    } on PlatformException catch (e) {
      throw e;
      print(e.toString());
      // Some error occurred, look at the exception message for more details
    }
  }

  static Future<int?> createUserOnQuickBlox({
    String? name,
    String? loginId,
    String? password,
  }) async {
    var result = await QB.users.createUser(
      loginId!,
      password!,
      fullName: name,
    );

    print(_homeController.userQuickBloxId.value.toString() +
        " is stored in homecontroller");
    if (result != null) {
      return result.id!;
    }
  }

  static Future<int> updateUserQuickBloxId(int userQuickBloxId) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.post(ApiUrl.updateUserQuickBloxId,
        data: {"quickBloxId": userQuickBloxId});
    print(response.statusCode.toString() + "QBID");

    return response.statusCode!;
  }
}
