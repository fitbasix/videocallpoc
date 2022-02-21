import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_sdk/models/qb_settings.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quickblox_sdk/webrtc/constants.dart';
import 'package:get/get.dart';


const String APP_ID = "95622";
const String AUTH_KEY = "JeSeKeyEkEMBFps";
const String AUTH_SECRET = "bY-YdQQPDvuZZWa";
const String ACCOUNT_KEY = "RxbHctz7wFyZ8sWW67rY";
const String API_ENDPOINT = "";
const String CHAT_ENDPOINT = "";


class InitializeQuickBlox{
  StreamSubscription? _callSubscription;

  Future<void> init() async {
    try {
      await QB.settings.init(APP_ID, AUTH_KEY, AUTH_SECRET, ACCOUNT_KEY,
          apiEndpoint: API_ENDPOINT, chatEndpoint: CHAT_ENDPOINT);

    } on PlatformException catch (e) {
      print("error $e");
      // DialogUtils.showError(context!, e);
    }

    try {
      QBSettings? settings = await QB.settings.get();

    } on PlatformException catch (e) {
    }

    ///init web RTC
    try {
      await QB.webrtc.init();
      print("webINIT");

    } on PlatformException catch (e) {
      print(e.toString() +"init error");
    }

    enableAutoReconnect();

  }

  Future<void> enableAutoReconnect() async {

    bool enable = true;



    try {

      await QB.settings.enableAutoReconnect(enable);



    } on PlatformException catch (e) {


    }

  }

  Future<void> logOutUserSession() async{
    try {
      await QB.auth.logout();
    } on PlatformException catch (e) {
      // Some error occurred, look at the exception message for more details
    }
  }

  Future<void> subscribeCall() async {
    if (_callSubscription != null) {
      print("call subscribed");
      return;
    }
    try {
      print("demo subs");
      _callSubscription =
      await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.CALL, (data) {
        Map<dynamic, dynamic> payloadMap =
        Map<dynamic, dynamic>.from(data["payload"]);
        Map<dynamic, dynamic> sessionMap =
        Map<dynamic, dynamic>.from(payloadMap["session"]);
        String sessionId = sessionMap["id"];
        int initiatorId = sessionMap["initiatorId"];
        int callType = sessionMap["type"];
        print("demo sub pay "+payloadMap.toString());
        Get.defaultDialog(
          title: "call incoming",
          content: Row(
            children: [
              ElevatedButton(onPressed: (){

              }, child: Text("Accept")),
              SizedBox(width: 10,),
              ElevatedButton(onPressed: (){

              }, child: Text("Decline"))
            ],
          )
        );
      }, onErrorMethod: (error) {});
    } on PlatformException catch (e) {}
  }
}