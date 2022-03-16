import 'dart:developer';

import 'package:fitbasix/core/api_service/dio_service.dart';
import 'package:fitbasix/core/routes/api_routes.dart';
import 'package:fitbasix/feature/Home/model/post_feed_model.dart';
import 'package:fitbasix/feature/get_trained/controller/trainer_controller.dart';
import 'package:fitbasix/feature/get_trained/model/PlanModel.dart';
import 'package:fitbasix/feature/get_trained/model/all_trainer_model.dart';
import 'package:fitbasix/feature/get_trained/model/get_trained_model.dart';
import 'package:fitbasix/feature/get_trained/model/interest_model.dart';
import 'package:fitbasix/feature/get_trained/model/sortbymodel.dart';
import 'package:fitbasix/feature/log_in/model/TrainerDetailModel.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';
import 'package:fitbasix/feature/plans/models/AvailableSlot.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../plans/models/FullPlanDetailModel.dart';
import '../../plans/models/allTimeSlot.dart';
import '../model/trainer_by_id_model.dart';

class TrainerServices {
  static var dio = DioUtil().getInstance();
  static TrainerController _trainerController = Get.find();
  static Future<PlanModel> getPlanByTrainerId(String trainerId) async {
    print(trainerId+"llll");
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    print("trainer id " + trainerId.toString());
    var response = await dio!
        .post(ApiUrl.getPlanByTrainerId, data: {"trainerId": trainerId});
    print("plan " +"llll $trainerId" + response.toString());
    return planModelFromJson(response.toString());
  }

  static Future<TrainerByIdModel> getATrainerDetail(String trainerId) async {
    print(trainerId);
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response =
        await dio!.post(ApiUrl.getTrainerById, data: {"trainerId": trainerId});
    debugPrint(response.toString());
    return trainerByIdModelFromJson(response.toString());
    //TrainerModel
    //return trainerModelFromJson(response.toString());
  }

  static Future<PlanFullDetails> getPlanById(String PlanId) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();

    var response = await dio!.post(ApiUrl.planById, data: {"planId": PlanId});
    print("plan details" + response.data.toString());
    return planFullDetailsFromJson(response.toString());
  }

  static Future<AllTimeSlots> getAllTimeSlot() async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();

    var response = await dio!.get(ApiUrl.getAllPlans);
    print("plan details" + response.data.toString());
    return allTimeSlotsFromJson(response.toString());
  }

  static Future<AllTrainer> getAllTrainer(
      {int? currentPage,
      String? name,
      int? trainerType,
      int? interests,
      int? sortBy
      }) async {
    int sortMethod = sortBy == null?_trainerController.SelectedSortMethod.value:sortBy;
    print(sortBy == null?[_trainerController.SelectedSortMethod.value]:sortBy.toString()+ "iiii");
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    print(name == null ? _trainerController.searchedName.value : name);
    print(trainerType == null
        ? (_trainerController.trainerType.value == 0
            ? []
            : [_trainerController.trainerType.value])
        : [trainerType]);
    print(interests == null
        ? [_trainerController.SelectedInterestIndex.value]
        : [interests]);
    var response = await dio!.post(ApiUrl.getAllTrainer+"?sortBy=$sortMethod", data: {
      "skip": currentPage == null ? 0 : currentPage * 5,
      "name": name == null ? _trainerController.searchedName.value : name,
      "trainerType": trainerType == null
          ? (_trainerController.trainerType.value == 0
              ? []
              : [_trainerController.trainerType.value])
          : [trainerType],
      "interests": interests == null
          ? [_trainerController.SelectedInterestIndex.value]
          : [interests],

    });
    print("jjjj "+response.toString());
    return allTrainerFromJson(response.toString());
  }

  static Future<SortByModel> getSortByData() async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.get(ApiUrl.getSortByData,);
    return sortByModelFromJson(response.toString());
  }

  static Future<GetTrainerModel> getTrainers() async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.post(ApiUrl.getTrainers, data: {});
    print("kkkkk"+response.data.toString());
    return getTrainerModelFromJson(response.toString());
  }

  static Future<AvailableSlot> getEnrolledPlanDetails(String trainerId) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response =
        await dio!.post(ApiUrl.getSchedules, data: {"trainerId": trainerId});
    print(response.data);

    return availableSlotFromJson(response.toString());
  }

  static Future<AvailableSlot> getAllWeekDays(
      String trainerId, int time) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.post(ApiUrl.getSchedules,
        data: {"trainerId": trainerId, "time": time});
    return availableSlotFromJson(response.toString());
  }

  static Future<void> bookSlot(List<String> slots,String id,int time,List<int> days) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.post(ApiUrl.bookDemo, data: {"days": slots,"planId":id,"time":time,"day":days});
    print(response.toString());
  }

  static Future<AllTrainer> getFitnessConsultant() async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.post(ApiUrl.getAllTrainer, data: {
      "trainerType": [1]
    });
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

  static Future followTrainer(String trainerId) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();

    var response =
        await dio!.post(ApiUrl.doFollow, data: {"followee": trainerId});
    print(response.toString());
  }

  static Future unFollowTrainer(String trainerId) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();

    var response =
        await dio!.delete(ApiUrl.doUnfollow, data: {"followee": trainerId});
    print(response.toString());
  }

  static Future<PostsModel> getTrainerPosts(String userId, int? skip) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!
        .post(ApiUrl.getTrainerPosts, data: {"userId": userId, "skip": skip});

    log(response.toString());

    return postsModelFromJson(response.toString());
  }
}
