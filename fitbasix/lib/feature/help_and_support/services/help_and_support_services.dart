import 'package:fitbasix/core/api_service/dio_service.dart';
import 'package:fitbasix/core/routes/api_routes.dart';
import 'package:fitbasix/feature/Home/model/comment_model.dart';
import 'package:fitbasix/feature/Home/model/post_feed_model.dart';
import 'package:fitbasix/feature/Home/model/waterReminderModel.dart';
import 'package:fitbasix/feature/Home/model/water_model.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';

import '../model/help_support_model.dart';

class HelpAndSupportServices{
  static var dio = DioUtil().getInstance();

  static Future<HelpAndSupportModel> getHelpDeskContents() async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.post(ApiUrl.getHelpAndSupportContents,);
    return helpAndSupportModelFromJson(response.toString());
  }
}