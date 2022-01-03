import 'dart:developer';

import 'package:fitbasix/core/api_service/dio_service.dart';
import 'package:fitbasix/core/routes/api_routes.dart';
import 'package:fitbasix/feature/get_trained/model/PlanModel.dart';
import 'package:fitbasix/feature/get_trained/model/all_trainer_model.dart';
import 'package:fitbasix/feature/get_trained/model/interest_model.dart';
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
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();

    var response = await dio!
        .post(ApiUrl.getPlanByTrainerId, data: {"trainerId": trainerId});
    print(response.toString());
    return planModelFromJson(response.toString());
  }

  static Future<TrainerModel> getATrainerDetail(String trainerId) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();

    var response =
        await dio!.post(ApiUrl.getTrainerById, data: {"trainerId": trainerId});
    print(response.toString());
    return trainerModelFromJson(response.toString());
  }

  static Future<AllTrainer> getAllTrainer() async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.post(ApiUrl.getAllTrainer, data: {
      "interests": ['ALL']
    });
    print(response.toString());
    return allTrainerFromJson(response.toString());
  }

  static Future<AllTrainer> getFitnessConsultant() async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!
        .post(ApiUrl.getAllTrainer, data: {"isFitnessConsultant": true});
    print(response.toString());
    return allTrainerFromJson(response.toString());
  }

  static Future<AllTrainer> getNutritionConsultant() async {
    print('before');
    print(await LogInService.getAccessToken());
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!
        .post(ApiUrl.getAllTrainer, data: {"isNutritionConsultant": true});
    print(response.toString());
    return allTrainerFromJson(response.toString());
  }

  static Future<InterestModel> getAllInterest() async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();

    var response = await dio!.post(ApiUrl.getAllInterest, data: {});
    print(response.toString());
    return interestModelFromJson(response.toString());
  }
}
