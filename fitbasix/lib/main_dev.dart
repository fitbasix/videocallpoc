import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fitbasix/setup-my-app.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:device_info/device_info.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import 'feature/log_in/services/login_services.dart';

initializeNotification() {
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            importance: NotificationImportance.Max,
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);
}

void selectNotification(String? payload) async {
  if (payload != null) {
    debugPrint('notification payload: $payload');
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // AndroidNotificationChannel channel = AndroidNotificationChannel(
  //     "channel_id", "some_title",
  //     description: "some_description", importance: Importance.high);
  // AndroidNotificationDetails details = AndroidNotificationDetails(
  //     channel.id,
  //     channel.name,
  //     channelDescription: channel.description,
  //     icon: "launch_background");
  //
  //
  //
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  // final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();
  // final InitializationSettings initializationSettings = InitializationSettings(
  //     iOS: initializationSettingsIOS
  // );
  // await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: selectNotification);
  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);
  // var messageData = jsonDecode(message.data["message"]);
  // int id = message.hashCode;
  // String title = messageData["message"]["notification"]["name"].toString();
  // String body = messageData["message"]["notification"]["body"].toString();
  // flutterLocalNotificationsPlugin.show(
  //     id, title, body, NotificationDetails(android: details));
}

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    initializeNotification();
    await Firebase.initializeApp();

    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, dynamic> deviceData = <String, dynamic>{};
    var response;
    if (Platform.isAndroid == true) {
      response = await deviceInfoPlugin.androidInfo;
    } else {
      response = await deviceInfoPlugin.iosInfo;
    }
    String deviceId = response.androidId;
    log(response.androidId + "   " + response.device);
    deviceData = _readAndroidBuildData(response);
    log('Running on ${deviceData['device']}');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString('AccessToken');
    FirebaseMessaging.instance.getToken().then((value) async {
      if (accessToken != null) {
        LogInService.RegisterDeviceToken(value.toString(), deviceId);
      }

      print("fcm token" + value.toString());
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print("background tap called1");
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((message) async {
      // print(message.data["message"]);
      // AndroidNotificationChannel channel = AndroidNotificationChannel(
      //     "channel_id", "some_title",
      //     description: "some_description", importance: Importance.high);
      // AndroidNotificationDetails details = AndroidNotificationDetails(
      //     channel.id, channel.name,
      //     channelDescription: channel.description, icon: "launch_background");
      //
      // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      //     FlutterLocalNotificationsPlugin();
      // await flutterLocalNotificationsPlugin
      //     .resolvePlatformSpecificImplementation<
      //         AndroidFlutterLocalNotificationsPlugin>()
      //     ?.createNotificationChannel(channel);
      // var messageData = jsonDecode(message.data["message"]);
      // int id = message.hashCode;
      // String title = messageData["message"]["notification"]["name"].toString();
      // String body = messageData["message"]["notification"]["body"].toString();
      // flutterLocalNotificationsPlugin.show(
      //     id, title, body, NotificationDetails(android: details));
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("background tap called");
    });

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    setupApp();

    //await AndroidAlarmManager.oneShotAt(date, 0, printHello);
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
  return <String, dynamic>{
    'version.securityPatch': build.version.securityPatch,
    'version.sdkInt': build.version.sdkInt,
    'version.release': build.version.release,
    'version.previewSdkInt': build.version.previewSdkInt,
    'version.incremental': build.version.incremental,
    'version.codename': build.version.codename,
    'version.baseOS': build.version.baseOS,
    'board': build.board,
    'bootloader': build.bootloader,
    'brand': build.brand,
    'device': build.device,
    'display': build.display,
    'fingerprint': build.fingerprint,
    'hardware': build.hardware,
    'host': build.host,
    'id': build.id,
    'manufacturer': build.manufacturer,
    'model': build.model,
    'product': build.product,
    'supported32BitAbis': build.supported32BitAbis,
    'supported64BitAbis': build.supported64BitAbis,
    'supportedAbis': build.supportedAbis,
    'tags': build.tags,
    'type': build.type,
    'isPhysicalDevice': build.isPhysicalDevice,
    'androidId': build.androidId,
    'systemFeatures': build.systemFeatures,
  };
}

void registerFcmToken() async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> deviceData = <String, dynamic>{};
  var response;
  if (Platform.isAndroid == true) {
    response = await deviceInfoPlugin.androidInfo;
  } else {
    response = await deviceInfoPlugin.iosInfo;
  }
  String deviceId = response.androidId;
  log(response.androidId + "   " + response.device);
  deviceData = _readAndroidBuildData(response);
  log('Running on ${deviceData['device']}');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var accessToken = prefs.getString('AccessToken');
  FirebaseMessaging.instance.getToken().then((value) async {
    if (accessToken != null) {
      LogInService.RegisterDeviceToken(value.toString(), deviceId);
    }

    print("fcm token" + value.toString());
  });
}
