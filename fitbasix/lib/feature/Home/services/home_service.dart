import 'dart:developer';

import 'package:fitbasix/core/api_service/dio_service.dart';
import 'package:fitbasix/core/routes/api_routes.dart';
import 'package:fitbasix/feature/Home/model/comment_model.dart';
import 'package:fitbasix/feature/Home/model/post_feed_model.dart';
import 'package:fitbasix/feature/Home/model/waterReminderModel.dart';
import 'package:fitbasix/feature/Home/model/water_model.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';

class HomeService {
  static var dio = DioUtil().getInstance();

  static Future<PostsModel> getPosts({int? skip}) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!
        .post(ApiUrl.getPosts, data: {"skip": skip == null ? 0 : skip * 5});
    print("postData");
    return postsModelFromJson(response.toString());
  }

  static Future<bool> likePost({String? postId, String? commentId}) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();

    Map likePost = {"postId": postId};
    Map likeComment = {"commentId": commentId};
    var response = await dio!
        .post(ApiUrl.likePost, data: postId != null ? likePost : likeComment);

    log(response.toString());
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

    log(response.toString());
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

  static Future<void> updateWaterDetails(double waterLevel) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();

    var response = await dio!
        .post(ApiUrl.updateWater, data: {"totalWaterConsumed": waterLevel});
    print(response.data.toString());
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

    log(response.toString());
    print(response.data['code']);
  }

  static Future<CommentModel> fetchComment(
    String postId,
  ) async {
    print(postId);
    var access = await LogInService.getAccessToken();
    print(access);
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.post(ApiUrl.getComment, data: {"postId": postId});

    log(response.toString());

    return commentModelFromJson(response.toString());
  }

  static Future<ReminderSource> fetchReminderData() async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();

    var response = await dio!.post(ApiUrl.waterReminderData, data: {});
    return reminderSourceFromJson(response.toString());
  }
}
