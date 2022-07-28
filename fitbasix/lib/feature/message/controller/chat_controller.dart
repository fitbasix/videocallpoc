import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../get_trained/services/trainer_services.dart';
const String kBaseURL = "https://demo.enablex.io/";
bool kTry = true;
final String kAppId = "62822665f5d2af4b9a214d13";
final String kAppkey = "Rase2ySyTeaaAyraPemaUymu9eEebygydyNu";
var headerForVideoCall = (kTry)
    ? {
  "x-app-id": kAppId,
  "x-app-key": kAppkey,
  "Content-Type": "application/json"
}
    : {"Content-Type": "application/json"};
class ChatController extends GetxController {


  RxMap<String,String> filePathWithRespectToFileName = RxMap<String,String>({});
  RxMap<String,String> urlWithRespectToTaskId = RxMap<String,String>({});

  RxBool storagePermissionCalled = false.obs;
  String USERID = '';

  String getDayString(DateTime dateTime1, DateTime dateTime2) {
    if (dateTime2.day - dateTime1.day == 0) {
      return 'Today';
    } else if (dateTime2.day - dateTime1.day == 1) {
      return 'Yesterday';
    } else
      return DateFormat('d MMM').format(dateTime1);
  }

}