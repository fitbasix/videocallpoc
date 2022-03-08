import 'dart:async';

import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/message/view/accepted_video_call_screen.dart';
import 'package:fitbasix/feature/message/view/chat_videocallscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_sdk/models/qb_rtc_session.dart';
import 'package:quickblox_sdk/models/qb_session.dart';
import 'package:quickblox_sdk/models/qb_settings.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quickblox_sdk/webrtc/constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


const String APP_ID = "95666";
const String AUTH_KEY = "LPzPYnqdOn9z2bv";
const String AUTH_SECRET = "3ySZKwqBaDr-9aS";
const String ACCOUNT_KEY = "aA9iRn_JXuj4i8TXLCxw";
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
      enableAutoReconnect();

    } on PlatformException catch (e) {
      print(e);
    }


  }
  Future<void> initWebRTC() async {
    print("called web RTC");
    ///init web RTC
    //todo remove when testing on emulator is finished
    try {
      await QB.webrtc.init().then((value) {
        subscribeCall();
      });

      print("webINIT");
    } on PlatformException catch (e) {
      print(e.toString() +"init error");
    }

  }
  Future<void> enableAutoReconnect() async {
    await QB.settings.enableAutoReconnect(true);
    await QB.settings.enableCarbons();
    // bool enable = true;
    // try {
    //   await QB.settings.enableAutoReconnect(enable);}
    // on PlatformException catch (e) {}
  }
  Future<void> logOutUserSession() async{
    HomeController _homeController = Get.find();
    try {
      _homeController.userQuickBloxId.value = 0;
      await QB.settings.enableAutoReconnect(false);
      await QB.chat.disconnect();
      await QB.auth.logout();

      // var v = await QB.subscriptions.get().then((value) {
      //   QB.events.remove(value.first!.id!);
      //   return value;
      // });

      logOutFromVideoCall();
    } on PlatformException catch (e) {
      // Some error occurred, look at the exception message for more details
    }
  }
  Future<void>logOutFromVideoCall() async {
    try {
      await QB.webrtc.release();
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
        print("call subs triggers an event of call kkkkkk");
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
              ElevatedButton(onPressed: () async{
                final sharedPreferences = await SharedPreferences.getInstance().then((sharedPreference) async {
                  try {
                    QBRTCSession? session = await QB.webrtc.accept(sessionId).then((value){
                      Navigator.of(Get.overlayContext!).pop();
                      print(sharedPreference.getInt("userQuickBloxId")!.toString()+" got this sestion id");
                      Get.to(()=>AcceptedVideoCallScreen(sessionIdForVideoCall: sessionId,userQuickBloxId: sharedPreference.getInt("userQuickBloxId")!,));

                    });
                  } on PlatformException catch (e) {
                    // Some error occurred, look at the exception message for more details
                  }
                });


              }, child: Text("Accept")),
              SizedBox(width: 10,),
              ElevatedButton(onPressed: () async {
                try {
                  QBRTCSession? session = await QB.webrtc.reject(sessionId,).then((value){
                    Navigator.of(Get.overlayContext!).pop();
                  });
                } on PlatformException catch (e) {
                  // Some error occurred, look at the exception message for more details
                }
                }, child: Text("Decline")),
            ],
          )
        );
      }, onErrorMethod: (error) {});
    } on PlatformException catch (e) {}
  }
}