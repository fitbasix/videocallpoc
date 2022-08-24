import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fitbasix/core/api_service/dio_service.dart';
import 'package:fitbasix/core/routes/api_routes.dart';
import 'package:fitbasix/feature/Home/model/post_feed_model.dart';
import 'package:fitbasix/feature/Home/model/postpone_model.dart';
import 'package:fitbasix/feature/get_trained/controller/trainer_controller.dart';
import 'package:fitbasix/feature/get_trained/model/PlanModel.dart';
import 'package:fitbasix/feature/get_trained/model/all_trainer_model.dart';
import 'package:fitbasix/feature/get_trained/model/get_trained_model.dart';
import 'package:fitbasix/feature/get_trained/model/interest_model.dart';
import 'package:fitbasix/feature/get_trained/model/sortbymodel.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';
import 'package:fitbasix/feature/plans/controller/plans_controller.dart';
import 'package:fitbasix/feature/plans/models/AvailableSlot.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../plans/models/AvailableTimeModel.dart';
import '../../plans/models/FullPlanDetailModel.dart';
import '../../plans/models/allTimeSlot.dart';
import '../model/timing_model.dart';
import '../model/trainer_by_id_model.dart';

class TrainerServices {
  static var dio = DioUtil().getInstance();
  static TrainerController _trainerController = Get.find();

  static Future<PlanModel> getPlanByTrainerId(
      String trainerId, int filterType) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.post(ApiUrl.getPlanByTrainerId,
        data: {"trainerId": trainerId, "filterType": filterType});
    return planModelFromJson(response.toString());
  }

  static Future<TrainerByIdModel> getATrainerDetail(String trainerId) async {
    print(trainerId);
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response =
        await dio!.post(ApiUrl.getTrainerById, data: {"trainerId": trainerId});

    return trainerByIdModelFromJson(response.toString());
    //TrainerModel
    //return trainerModelFromJson(response.toString());
  }

  static Future<String> getEnablexUrl(String id) async {
    log(ApiUrl.getEnablexUrl + id);
    var dio = DioUtil().getInstance();
    dio!.options.headers["language"] = "1";
    dio.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio.get(ApiUrl.getEnablexUrl + id);
    log(ApiUrl.getEnablexUrl + id);
    var jsonResponse = jsonDecode(response.toString());
    log(ApiUrl.getEnablexUrl + id);
    return jsonResponse["response"]["data"]["sessionLink"];
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
      List<int>? availability,
      int? sortBy}) async {
    int sortMethod =
        sortBy == null ? _trainerController.SelectedSortMethod.value : sortBy;

    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    log("ooo" +
        (name == null
            ? _trainerController.searchedName.value.toString()
            : name.toString()));
    var response =
        await dio!.post(ApiUrl.getAllTrainer + "?sortBy=$sortMethod", data: {
      "skip": currentPage == null ? 0 : currentPage * 5,
      "name": name == null ? _trainerController.searchedName.value : name,
      "trainerType": trainerType == null
          ? (_trainerController.trainerType.value == 0
              ? []
              : [_trainerController.trainerType.value])
          : [trainerType],
      "time":
          availability == null ? _trainerController.availability : availability,
      "interests": interests == null
          ? [_trainerController.SelectedInterestIndex.value]
          : [interests],
    });
    print("jjjj " + response.toString());
    return allTrainerFromJson(response.toString());
  }

  static Future<List<MyTrainer>> getMyTrainers({
    int? currentPage,
    String? name,
  }) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();

    var response = await dio!.post(ApiUrl.getMyTrainers, data: {
      "skip": currentPage == null ? 0 : currentPage * 5,
      "name":
          name == null ? _trainerController.searchedMyTrainerName.value : name,
    });
    print("jjjj " + response.toString());
    GetAllMyTrainers mytrainer = getAllMyTrainersFromJson(response.toString());
    return mytrainer.response!.data!;
  }

  static Future<SortByModel> getSortByData() async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.get(
      ApiUrl.getSortByData,
    );
    return sortByModelFromJson(response.toString());
  }

  static Future<GetTrainerModel> getTrainers() async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.post(ApiUrl.getTrainers, data: {});
    print("kkkkk" + response.data.toString());
    return getTrainerModelFromJson(response.toString());
  }

  static Future<TimeModel> getEnrolledPlanDetails(
      String trainerId, int planDuration) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.post(ApiUrl.getSchedules,
        data: {"trainerId": trainerId, "planDuration": planDuration});
    return timeModelFromJson(response.toString());
  }

  static Future<AvailableSlot> getAllWeekDays(
      String trainerId, int time, int planDuration) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    print(time.toString());
    var response = await dio!.post(ApiUrl.getSchedules, data: {
      "trainerId": trainerId,
      "time": time,
      "planDuration": planDuration
    });
    return availableSlotFromJson(response.toString());
  }

  static Future<bool> bookSlot(List<String> slots, String id, int time,
      List<int> days, String trainerId, BuildContext context) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var token = await LogInService.getAccessToken();
    log(jsonEncode(<String, dynamic>{
      "days": slots,
      "planId": id,
      "time": time,
      "day": days
    }).toString());

    var timeIndex;

    for (var i in Get.find<TrainerController>().weekAvailableSlots.value) {
      if (slots[0] == i.id) {
        timeIndex = i.time;
      }
    }

    try {
      var response = await Dio().post(ApiUrl.bookDemo,
          options: Options(headers: {"language": 1, "Authorization": token}),
          data: {
            "days": slots,
            "planId": id,
            "time": timeIndex,
            "day": days,
            "trainerId": trainerId,
            "planDuration":
                Get.find<PlansController>().selectedPlan!.planDuration
          });
      return true;
    } on DioError catch (e) {
      final responseData = jsonDecode(e.response.toString());
      if (e.response!.statusCode == 500 || e.response!.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData["response"]["message"])));
        return false;
      }
    }

    return false;
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
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.post(ApiUrl.getAllTrainer, data: {
      "trainerType": [2]
    });
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

  static Future<TimingModel> getAllTime() async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.get(ApiUrl.getAllSlots);
    return timingModelFromJson(response.toString());
  }

  static Future<SessionData?> postponeSession({
    required String trainerId,
    required DateTime expiryDate,
    required String planId,
    required String timeSlot,
    required List<int> days,
  }) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    try {
      var response = await dio!.post(
        ApiUrl.postponeSession,
        data: {
          'trainerId': trainerId,
          'expiryDate': expiryDate.toIso8601String(),
          'planId': planId,
          'time': timeSlot,
          'days': days
        },
      );
      log(response.toString());
      return postponeModelFromJson(response.toString()).response!.sessionData;
    } on Exception catch (e) {
      return null;
    }
  }

  static Future<bool> cancelSubscription({
    required String trainerName,
    required String planId,
    required String planName,
  }) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    try {
      var response = await dio!.post(
        ApiUrl.cancelSubscription,
        data: {
          'trainerName': trainerName,
          'planId': planId,
          'planName': planName
        },
      );
      log(response.data.toString());
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }
}
