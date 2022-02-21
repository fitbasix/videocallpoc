import 'dart:ffi';

import '../../../core/api_service/dio_service.dart';
import '../../../core/routes/api_routes.dart';
import '../../log_in/services/login_services.dart';
import '../model/bmr_calculation_model.dart';

class BmrServices{
  static var dio = DioUtil().getInstance();
  static Future<BmrCalculationModel> getbmrCalculations(
      double weight,
      double height,
      int age,
      int gender
      ) async {

    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.post(ApiUrl.bmrcalculation,data: {
      "weight":weight,
      "height":height,
      "age":age,
      "gender":gender
    });
    print(response.data.toString());
    return bmrCalculationModelFromJson(response.toString());
  }

}