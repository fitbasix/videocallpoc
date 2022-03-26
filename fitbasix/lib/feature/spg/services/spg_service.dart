import 'dart:developer';

import 'package:fitbasix/core/api_service/dio_service.dart';
import 'package:fitbasix/core/routes/api_routes.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';
import 'package:fitbasix/feature/spg/model/PersonalGoalModel.dart';
import 'package:fitbasix/feature/spg/model/spg_model.dart';
import 'package:intl/intl.dart';

class SPGService {
  static var dio = DioUtil().getInstance();

  static Future getSPGData() async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.post(ApiUrl.getSPGData, data: {});
    log(response.toString());
    return spgModelFromJson(response.toString());
  }

  static Future<PersonalGoal> updateSPGData(
      int? goalType,
      int? gender,
      String? dob,
      int? height,
      int? targetWeight,
      int? currentWeight,
      int? activenessType,
      int? bodyType,
      int? foodType) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();

    ///step1
    Map updateGoal = {"goalType": goalType};

    ///step2
    Map updateDob = {"dob": dob};

    ///step3
    Map allDetails = {
      "goalType": goalType,
      "genderType": gender,
      "activenessType": activenessType,
      "bodyType": bodyType,
      "foodType": foodType,
      "height": height,
      "currentWeight": currentWeight,
      "targetWeight": targetWeight,
      "dob": dob == null
          ? null
          : (DateFormat('LL-dd-yyyy').format(DateTime.parse(dob.toString())))
    };
    // Map height={}
    Map getData = {};
    var response = await dio!
        .post(ApiUrl.updateGoal, data: goalType == null ? {} : allDetails);
    print(response.data);
    return personalGoalFromJson(response.toString());
  }
}
