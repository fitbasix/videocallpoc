import 'dart:developer';

import 'package:fitbasix/core/api_service/dio_service.dart';
import 'package:fitbasix/core/routes/api_routes.dart';
import 'package:fitbasix/feature/Home/model/comment_model.dart';
import 'package:fitbasix/feature/Home/model/post_feed_model.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';

class HomeService {
  static var dio = DioUtil().getInstance();
  static Stream<PostsModel> getPosts() async* {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.post(ApiUrl.getPosts, data: {});

    log(response.toString());

    yield postsModelFromJson(response.toString());
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

  static Future<void> addComment(String postId, String comment) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!
        .post(ApiUrl.addComment, data: {"postId": postId, "comment": comment});

    log(response.toString());
    print(response.data['code']);
  }

  static Stream<CommentModel> fetchComment(
    String postId,
  ) async* {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.post(ApiUrl.getComment, data: {"postId": postId});

    log(response.toString());
    print(response.data['code']);

    yield commentModelFromJson(response.toString());
  }
}
