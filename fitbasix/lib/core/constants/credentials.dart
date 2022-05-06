import 'dart:async';
import 'dart:io';

import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/message/controller/web_rtc_controller.dart';
import 'package:fitbasix/feature/message/view/accepted_video_call_screen.dart';
import 'package:fitbasix/feature/message/view/chat_videocallscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickblox_sdk/models/qb_ice_server.dart';
import 'package:quickblox_sdk/models/qb_rtc_session.dart';
import 'package:quickblox_sdk/models/qb_session.dart';
import 'package:quickblox_sdk/models/qb_settings.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quickblox_sdk/webrtc/constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info/device_info.dart';

const String APP_ID = "3";
const String AUTH_KEY = "gMpX2qrGagaLrOK";
const String AUTH_SECRET = "E9CspcTVVUW5zR2";
const String ACCOUNT_KEY = "_HzHQFqz6LxyjhHGRDMQ";
const String API_ENDPOINT = "https://apifitbasix.quickblox.com";
const String CHAT_ENDPOINT = "chatfitbasix.quickblox.com";

class InitializeQuickBlox {
  final WebRTCController _webRtcController = Get.put(WebRTCController());

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

    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      double osVersion = double.parse(androidInfo.version.release);
      _webRtcController.currentOSVersion.value = osVersion;

      ///init [WebRTC] only if os version is less then 12
      if (osVersion < 12) {
        try {
          await QB.webrtc.init().then((value) {
            subscribeCall();
          });

          print("webINIT");
        } on PlatformException catch (e) {
          print(e.toString() + "init error");
        }
      }
    } else if (Platform.isIOS) {
      try {
        await QB.webrtc.init().then((value) {
          subscribeCall();
        });
        print("webINIT");
      } on PlatformException catch (e) {
        print(e.toString() + "init error");
      }
    }

    _setIceServers();
    _getIceServers();
    initVideoConference();
  }

  void _getIceServers() async {
    print("get ice servers");
    try {
      List<QBIceServer> servers = await QB.rtcConfig.getIceServers();
      // if(servers.isNotEmpty){
      //   await QB.rtcConfig.setIceServers(servers);
      // }
      servers.forEach((element) {
        print(element.url);
      });
    } on PlatformException catch (e) {
      //some logic for handle exception 6
    }
  }

  void _setIceServers() async {
    QBIceServer iceServerPrimary = QBIceServer();
    iceServerPrimary.url = "turn.quickblox.com"; //required
    // iceServerPrimary.userName = "your primary user name"; //optional 5
    //iceServerPrimary.password = "your primary password"; //optional 6 7
    //QBIceServer iceServerSecondary = QBIceServer();
    //iceServerSecondary.url = "turnfitbasix.quickblox.com"; //required 9
    //iceServerSecondary.userName = "your secondary user name"; //optional 10
    //iceServerSecondary.password = "your secondary password"; //optional 11 12
    try {
//<<<<<<< fix/quickBlox
      await QB.rtcConfig.setIceServers([iceServerPrimary]);
    } on PlatformException catch (e) {
      //some logic for handle exception 16 } 17
      print(e.toString() + " ppppp");
    }
  }

  initVideoConference() async {
    PermissionStatus status = await Permission.bluetoothConnect.request();
    if (status.isGranted) {
      try {
        String conferenceServer = "turnfitbasix.quickblox.com";
        await QB.conference.init(conferenceServer);
      } on PlatformException catch (e) {
        print(e);
        // Some error occurred, look at the exception message for more details
      }
//=======
      await QB.rtcConfig.setIceServers(
          [iceServerPrimary]);
    } on PlatformException catch (e) { //some logic for handle exception 16 } 17
//>>>>>>> dev
    }
  }

  Future<void> enableAutoReconnect() async {
    // await QB.settings.enableAutoReconnect(true);
    // await QB.settings.enableCarbons();
    // bool enable = true;
    // try {
    //   await QB.settings.enableAutoReconnect(enable);}
    // on PlatformException catch (e) {}
  }
  Future<void> logOutUserSession() async {
    HomeController _homeController = Get.find();
    try {
      _homeController.userQuickBloxId.value = 0;
      //await QB.settings.enableAutoReconnect(false);
      await QB.chat.disconnect();
      await QB.auth.logout();
      logOutFromVideoCall();
    } on PlatformException catch (e) {
      // Some error occurred, look at the exception message for more details
    }
  }

  Future<void> logOutFromVideoCall() async {
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
        print("demo sub pay " + payloadMap.toString());
        Get.defaultDialog(
            title: "call incoming",
            content: Row(
              children: [
                ElevatedButton(
                    onPressed: () async {
                      final sharedPreferences =
                          await SharedPreferences.getInstance()
                              .then((sharedPreference) async {
                        try {
                          QBRTCSession? session =
                              await QB.webrtc.accept(sessionId).then((value) {
                            Navigator.of(Get.overlayContext!).pop();
                            print(sharedPreference
                                    .getInt("userQuickBloxId")!
                                    .toString() +
                                " got this sestion id");
                            Get.to(() => AcceptedVideoCallScreen(
                                  sessionIdForVideoCall: sessionId,
                                  userQuickBloxId: sharedPreference
                                      .getInt("userQuickBloxId")!,
                                ));
                          });
                        } on PlatformException catch (e) {
                          // Some error occurred, look at the exception message for more details
                        }
                      });
                    },
                    child: Text("Accept")),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        QBRTCSession? session = await QB.webrtc
                            .reject(
                          sessionId,
                        )
                            .then((value) {
                          Navigator.of(Get.overlayContext!).pop();
                        });
                      } on PlatformException catch (e) {
                        // Some error occurred, look at the exception message for more details
                      }
                    },
                    child: Text("Decline")),
              ],
            ));
      }, onErrorMethod: (error) {});
    } on PlatformException catch (e) {}
  }
}
