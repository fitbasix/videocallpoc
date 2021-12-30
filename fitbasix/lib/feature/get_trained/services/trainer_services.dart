import 'dart:developer';

import 'package:fitbasix/core/api_service/dio_service.dart';
import 'package:fitbasix/core/routes/api_routes.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';

class TrainerServices {
  static var dio = DioUtil().getInstance();
  static Future getTrainerById() async {
    print('before');
    var accessToken = await LogInService.getAccessToken();
    print(accessToken);
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = accessToken;
    var response = await dio!.post(ApiUrl.getTrainerById, data: {
      "trainerId": "61cd3562a66144fddd96af80",
    });
    print('after');
    print(response.statusCode.toString());
    log(response.data.toString());
  }
}
