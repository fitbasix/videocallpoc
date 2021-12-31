import 'dart:developer';

import 'package:fitbasix/core/api_service/dio_service.dart';
import 'package:fitbasix/core/routes/api_routes.dart';
import 'package:fitbasix/feature/get_trained/model/PlanModel.dart';
import 'package:fitbasix/feature/log_in/model/TrainerDetailModel.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';

class TrainerServices {
  static var dio = DioUtil().getInstance();
  // static Future getTrainerById() async {
  //   print('before');
  //   var accessToken = await LogInService.getAccessToken();
  //   print(accessToken);
  //   dio!.options.headers["language"] = "1";
  //   dio!.options.headers['Authorization'] = accessToken;
  //   var response = await dio!.post(ApiUrl.getTrainerById, data: {
  //     "trainerId": "61cd3562a66144fddd96af80",
  //   });
  //   print('after');
  //   print(response.statusCode.toString());
  //   log(response.data.toString());
  // }
  static Future<PlanModel> getPlanByTrainerId(String trainerId) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MWNlOTFjNTRiNzg5Y2RmMTNiNGU5ZjEiLCJyb2xlIjoidXNlciIsImlhdCI6MTY0MDkzNDc2NCwiZXhwIjoxNjQxNzk4NzY0fQ.46BNh_sWnZUY9P2tMtP-DuKjWwQh_5HGs_NkEgX4XJg";
    var response =
        await dio!.post(ApiUrl.getPlanByTrainerId, data: {"trainerId": trainerId});
    print(response.toString());
    return planModelFromJson(response.toString());
  }
  static Future<TrainerModel> getATrainerDetail(String trainerId) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MWNlOTFjNTRiNzg5Y2RmMTNiNGU5ZjEiLCJyb2xlIjoidXNlciIsImlhdCI6MTY0MDkzNDc2NCwiZXhwIjoxNjQxNzk4NzY0fQ.46BNh_sWnZUY9P2tMtP-DuKjWwQh_5HGs_NkEgX4XJg";
    var response =
        await dio!.post(ApiUrl.getTrainerById, data: {"trainerId": trainerId});
    print(response.toString());
    return trainerModelFromJson(response.toString());
  }
}
