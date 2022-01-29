import 'package:fitbasix/core/api_service/dio_service.dart';
import 'package:fitbasix/core/routes/api_routes.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';
import 'package:fitbasix/feature/spg/model/PersonalGoalModel.dart';
import 'package:fitbasix/feature/spg/model/spg_model.dart';

class SPGService {
  static var dio = DioUtil().getInstance();

  static Future getSPGData() async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    print("test1");
    var response = await dio!.post(ApiUrl.getSPGData, data: {});
    print("test2");
    print(response.data.toString());
    return spgModelFromJson(response.toString());
  }

  static Future<PersonalGoal> updateSPGData(int? goalType, String? dob,
      String? height, String? targetWeight, String? currentWeight) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    Map updateGoal = {"goalType": goalType};
    Map updateDob = {"dob": dob};
    // Map height={}
    Map getData = {};
    var response = await dio!.post(ApiUrl.updateGoal,
        data: goalType != null
            ? updateGoal
            : dob != null
                ? updateDob
                : getData);
    print(response.data);
    return personalGoalFromJson(response.toString());
  }
}
