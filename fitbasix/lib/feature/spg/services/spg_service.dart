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
    var response = await dio!.post(ApiUrl.getSPGData, data: {});
    return spgModelFromJson(response.toString());
  }

  static Future<PersonalGoal> updateSPGData(int? goalType, String? dob) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    Map updateGoal = {"goalType": goalType};
    Map updateDob = {"dob": dob};
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
