

import 'dart:convert';

import 'package:fitbasix/feature/report_abuse/report_abuse_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../core/api_service/dio_service.dart';
import '../../core/routes/api_routes.dart';
import '../log_in/services/login_services.dart';

class ReportAbuseController extends GetxController{
  Rx<ReportAbuseModel> reportAbuseList = ReportAbuseModel().obs;
  RxBool isReportAbuseLoading = false.obs;
  RxBool isReportSendAbuseLoading = false.obs;
  static var dio = DioUtil().getInstance();

   Future<void> getReportAbuseData() async {
     isReportAbuseLoading.value = true;
    dio!.options.headers["language"] = "1";
    String token = await LogInService.getAccessToken();
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    final response = await dio!.get(ApiUrl.getAbuseData,);
    reportAbuseList.value = reportAbuseModelFromJson(response.toString());
    isReportAbuseLoading.value = false;
  }

  Future<String> sendRepostAbuseData({String? postId,String? userId,int? reason}) async {
    isReportSendAbuseLoading.value = true;
    dio!.options.headers["language"] = "1";
    String token = await LogInService.getAccessToken();
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    final response = await dio!.post(ApiUrl.sendAbuseData, data: {
      "postId":postId,
      "userId":userId,
      "reason":reason
    });
    print(response.toString());
    isReportSendAbuseLoading.value = false;
    return response.data['response']['message'];
  }

}