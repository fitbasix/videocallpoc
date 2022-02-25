import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fitbasix/setup-my-app.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("background massage called");
  await Firebase.initializeApp();
  AndroidNotificationChannel channel =  AndroidNotificationChannel("channel_id","some_title",  description: "some_description", importance:Importance.high);
  AndroidNotificationDetails details = AndroidNotificationDetails(channel.id, channel.name, channelDescription:channel.description, icon: "launch_background");
  FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
  int id = message.hashCode;
  String title = "kashif";
  String body = message.data["message"]["message"];
  plugin.show(id, title, body, NotificationDetails(android: details));
  print('Handling a background message ${message.messageId}');

}

Future<void> main() async {


  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();


    await Firebase.initializeApp();

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {}
    });
    FirebaseMessaging.instance.getToken().then((value) {
      print("fcm token" + value.toString());
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((message) {
      print("local massage called");
      AndroidNotificationChannel channel =  AndroidNotificationChannel("channel_id","some_title",  description: "some_description", importance:Importance.high);
      AndroidNotificationDetails details = AndroidNotificationDetails(channel.id, channel.name, channelDescription:channel.description, icon: "launch_background");
      FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();

      int id = message.hashCode;
      String title = "kashif";
      String body = message.data["message"];
      print(body+"testinggg");
      plugin.show(id, title, body, NotificationDetails(android: details));
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {

    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString('AccessToken');
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    setupApp();
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}
