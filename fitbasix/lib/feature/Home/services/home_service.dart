import 'dart:developer';

import 'package:fitbasix/core/api_service/dio_service.dart';
import 'package:fitbasix/core/routes/api_routes.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/Home/model/RecentCommentModel.dart';
import 'package:fitbasix/feature/Home/model/comment_model.dart';
import 'package:fitbasix/feature/Home/model/post_feed_model.dart';
import 'package:fitbasix/feature/Home/model/post_model.dart';
import 'package:fitbasix/feature/Home/model/waterReminderModel.dart';
import 'package:fitbasix/feature/Home/model/water_model.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/user_profile_model.dart';

class HomeService {
  static var dio = DioUtil().getInstance();
  static HomeController homeController = Get.find();

  static Future<PostsModel> getPosts({int? skip}) async {
    print(skip.toString()+" skips");
    // var response = http.post(
    //   Uri.parse(ApiUrl.getPosts),
    //   headers: {
    //     'Authorization': 'application/json; charset=UTF-8',
    //     'language': '1'
    //   },
    // );
    var dio = DioUtil().getInstance();
    dio!.options.headers["language"] = "1";
    print("trending post");
    var token = await LogInService.getAccessToken();

    dio.options.headers['Authorization'] = token;
    var response = await dio
        .post(ApiUrl.getPosts, data: {"skip": skip == null ? 0 : skip * 5});
    print("trending post");
    print(response.toString());
    return postsModelFromJson(response.toString());
  }

  static Future<PostsModel> getExplorePosts({int? skip}) async {
    print(homeController.searchController.text);
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.post(ApiUrl.explorePost, data: {
      "skip": skip == null ? 0 : skip * 5,
      "name": homeController.exploreSearchText.value,
      "category": homeController.selectedPostCategoryIndex.value == -1
          ? []
          : [homeController.selectedPostCategoryIndex.value]
    });
    print("explore postData");
    return postsModelFromJson(response.toString());
  }

  static Future<bool> likePost({String? postId, String? commentId}) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();

    Map likePost = {"postId": postId};
    Map likeComment = {"commentId": commentId};
    var response = await dio!
        .post(ApiUrl.likePost, data: postId != null ? likePost : likeComment);

    print(response.data['code']);
    if (response.data['code'] == 0) return true;
    return false;
  }

  static Future<bool> unlikePost({String? postId, String? commentId}) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();

    Map unlikePost = {"postId": postId};
    Map unlikeComment = {"commentId": commentId};
    var response = await dio!.delete(ApiUrl.unlike,
        data: postId != null ? unlikePost : unlikeComment);

    print(response.data['code']);
    if (response.data['code'] == 0) return true;
    return false;
  }

  static Future<WaterDetail> getWaterDetails() async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();

    var response = await dio!.get(ApiUrl.getWater);
    print(response.data.toString());
    return waterDetailFromJson(response.toString());
  }

  static Future<UserProfileModel> getIndividualUserProfileData({String? userId}) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();

    var response = await dio!.get(ApiUrl.getIndividualUser+userId!);
    print(response.data.toString());
    return userProfileModelFromJson(response.toString());
  }

  static Future<void> updateWaterDetails(double waterLevel) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    print(waterLevel.toString() + " water level");
    var response = await dio!
        .post(ApiUrl.updateWater, data: {"totalWaterConsumed": waterLevel});
    print("update water " + response.data.toString());
  }

  static Future<void> updateWaterNotificationDetails(double waterGoal,
      String? wakeUpTime, String? sleepTime, int WaterReminder) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();

    var response = await dio!.post(ApiUrl.updateWater, data: {
      "sleepTime": sleepTime,
      "totalWaterRequired": waterGoal,
      "wakeupTime": wakeUpTime,
      "waterReminder": WaterReminder
    });
    print(response.data.toString());
  }

  static Future<void> addComment(String postId, String comment) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!
        .post(ApiUrl.addComment, data: {"postId": postId, "comment": comment});

    print(response.data['code']);
  }

  static Future<void> replyComment(
      {required String commentId,
      String? taggedPerson,
      required String comment}) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.post(ApiUrl.replyComment, data: {
      "commentId": commentId,
      "taggedPerson": taggedPerson,
      "comment": comment
    });

    print(response.data['code']);
  }

  static Future<RecentCommentModel> recentComment({String? postId}) async {
    var access = await LogInService.getAccessToken();
    print(access);
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response =
        await dio!.post(ApiUrl.recentComment, data: {"postId": postId});
    RecentCommentModel recentComment =
        recentCommentModelFromJson(response.toString());
    return recentComment;
  }

  static Future<CommentModel> fetchComment(
      {String? postId, String? commentId, int? skip, int? limit}) async {
    print(postId);
    var access = await LogInService.getAccessToken();
    print(access);
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    Map getPostComment = {
      "postId": postId,
      "skip": skip == null ? 0 : skip * 5
    };
    Map getCommentReply = {
      "commentId": commentId,
      "skipReply": skip == null ? 0 : skip * 3,
      "limitReply": limit
    };
    var response = await dio!.post(ApiUrl.getComment,
        data: postId == null ? getCommentReply : getPostComment);


    return commentModelFromJson(response.toString());
  }

  static Future<ReminderSource> fetchReminderData() async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();

    var response = await dio!.post(ApiUrl.waterReminderData, data: {});
    return reminderSourceFromJson(response.toString());
  }

  static Future<PostModel> getPostById(String postId) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();

    var response =
        await dio!.post(ApiUrl.getPostById, data: {"postId": postId});


    return postModelFromJson(response.toString());
  }

  static Future<void> deActiveAccount() async {
    var dio = DioUtil().getInstance();
    dio!.options.headers["language"] = "1";
    dio.options.headers['Authorization'] = await LogInService.getAccessToken();
    String token = await LogInService.getAccessToken();
    var response = await dio.post(ApiUrl.deActiveAccount);
  }

  static Future<void> deleteAccount() async {
    var dio = DioUtil().getInstance();
    dio!.options.headers["language"] = "1";
    String token = await LogInService.getAccessToken();
    dio.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio.post(ApiUrl.deleteAccount);
  }
}
