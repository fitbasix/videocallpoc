import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitbasix/feature/message/model/massage_notification_model.dart';


import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fitbasix/setup-my-app.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';


import 'package:shared_preferences/shared_preferences.dart';

import 'feature/settings/view/settings.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  AndroidNotificationChannel channel =  AndroidNotificationChannel("channel_id","some_title",  description: "some_description", importance:Importance.high);
  AndroidNotificationDetails details = AndroidNotificationDetails(channel.id, channel.name, channelDescription:channel.description, icon: "launch_background");
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  var messageData = jsonDecode(message.data["message"]);
  int id = message.hashCode;
  String title = messageData["message"]["notification"]["name"].toString();
  String body = messageData["message"]["notification"]["body"].toString();
  flutterLocalNotificationsPlugin.show(id, title, body, NotificationDetails(android: details));
}

Future<void> main() async {

  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();

    FirebaseMessaging.instance.getToken().then((value) {
      print("fcm token" + value.toString());
    });

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print("background tap called1");
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((message) async {
      MessageNotificationModel? notificationModel;
      print(message.data["message"]);
      AndroidNotificationChannel channel =  AndroidNotificationChannel("channel_id","some_title",  description: "some_description", importance:Importance.high);
      AndroidNotificationDetails details = AndroidNotificationDetails(channel.id, channel.name, channelDescription:channel.description, icon: "launch_background");
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      var messageData = jsonDecode(message.data["message"]);
      int id = message.hashCode;
      String title = messageData["message"]["notification"]["name"].toString();
      String body = messageData["message"]["notification"]["body"].toString();
      flutterLocalNotificationsPlugin.show(id, title, body, NotificationDetails(android: details));
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("background tap called");
    });



    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString('AccessToken');
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    setupApp();
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}
