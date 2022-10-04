import 'package:fitbasix/core/api_service/dio_service.dart';
import 'package:fitbasix/core/routes/api_routes.dart';
import 'package:fitbasix/feature/call_back_form/model/callBackModel';
import 'package:fitbasix/feature/log_in/services/login_services.dart';
import 'package:flutter/material.dart';

class CallBackServices {
  static var dio = DioUtil().getInstance();
  static Future<CallBackModel> sendRequest(
      {required String name,
      required String email,
      required String number,
      required String query}) async {
    print(number + email + name + query);
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.post(ApiUrl.callBack, data: {
      "name": name,
      "email": email,
      "number": number,
      "userId": query,
      "source": "Mobile"
    });
    debugPrint(response.data.toString());
    return callBackModelFromJson(response.toString());
  }
}
