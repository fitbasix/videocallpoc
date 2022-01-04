import 'package:fitbasix/core/api_service/dio_service.dart';
import 'package:fitbasix/core/routes/api_routes.dart';
import 'package:fitbasix/feature/get_trained/model/PlanModel.dart';
import 'package:fitbasix/feature/get_trained/model/all_trainer_model.dart';
import 'package:fitbasix/feature/get_trained/model/interest_model.dart';
import 'package:fitbasix/feature/log_in/model/TrainerDetailModel.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';

class TrainerServices {
  static var dio = DioUtil().getInstance();

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

  static Future<AllTrainer> getAllTrainer(
      {int? currentPage,
      String? name,
      int? trainerType,
      int? interests}) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.post(ApiUrl.getAllTrainer, data: {
      "skip": currentPage == null ? 0 : currentPage * 5,
      "name": name == null ? "" : name,
      "trainerType": trainerType == null ? 0 : trainerType,
      "interests": interests == null ? [0] : [interests]
    });
    print(response.toString());
    return allTrainerFromJson(response.toString());
  }

  static Future<AllTrainer> getFitnessConsultant() async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.post(ApiUrl.getAllTrainer, data: {
      "trainerType": [1]
    });
    print(response.toString());
    return allTrainerFromJson(response.toString());
  }

  static Future<AllTrainer> getNutritionConsultant() async {
    print('before');
    print(await LogInService.getAccessToken());
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.post(ApiUrl.getAllTrainer, data: {
      "trainerType": [2]
    });
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
