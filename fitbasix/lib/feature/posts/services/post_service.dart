import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fitbasix/core/api_service/dio_service.dart';
import 'package:fitbasix/core/routes/api_routes.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';
import 'package:fitbasix/feature/posts/controller/post_controller.dart';
import 'package:fitbasix/feature/posts/model/media_response_model.dart';
import 'package:get/get.dart' as Get;
import 'package:http_parser/http_parser.dart';

class PostService {
  static var dio = DioUtil().getInstance();

  static Future<MediaUrl> uploadMedia(
    List<File>? files,
  ) async {
    var formData = FormData();
    if (files != null)
      for (var file in files) {
        formData.files.addAll([
          MapEntry(
              'files',
              await MultipartFile.fromFile(file.path,
                  filename: file.path.split('/').last)),
        ]);
      }

    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.post(
      ApiUrl.uploadMedia,
      data: formData,
      onSendProgress: (sent, total) {
        Get.Get.find<PostController>().uploadingProgress.value = ((sent / total)*100).toPrecision(0);
      },
    );
    return mediaUrlFromJson(response.toString());
  }
}
