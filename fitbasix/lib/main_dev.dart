import 'dart:convert';
import 'dart:io';

import 'dart:isolate';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fitbasix/setup-my-app.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'feature/settings/view/settings.dart';

initializeNotification() {
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      'resource://drawable/background',
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
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

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  AndroidNotificationChannel channel = AndroidNotificationChannel(
      "channel_id", "some_title",
      description: "some_description", importance: Importance.high);
  AndroidNotificationDetails details = AndroidNotificationDetails(
      channel.id, channel.name,
      channelDescription: channel.description, icon: "launch_background");
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  var messageData = jsonDecode(message.data["message"]);
  int id = message.hashCode;
  String title = messageData["message"]["notification"]["name"].toString();
  String body = messageData["message"]["notification"]["body"].toString();
  flutterLocalNotificationsPlugin.show(
      id, title, body, NotificationDetails(android: details));
}

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    initializeNotification();
    await Firebase.initializeApp();

    if (Platform.isAndroid) {
       await AndroidAlarmManager.initialize();
    }

    FirebaseMessaging.instance.getToken().then((value) {
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
      print(message.data["message"]);
      AndroidNotificationChannel channel = AndroidNotificationChannel(
          "channel_id", "some_title",
          description: "some_description", importance: Importance.high);
      AndroidNotificationDetails details = AndroidNotificationDetails(
          channel.id, channel.name,
          channelDescription: channel.description, icon: "launch_background");
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      var messageData = jsonDecode(message.data["message"]);
      int id = message.hashCode;
      String title = messageData["message"]["notification"]["name"].toString();
      String body = messageData["message"]["notification"]["body"].toString();
      flutterLocalNotificationsPlugin.show(
          id, title, body, NotificationDetails(android: details));
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("background tap called");
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var accessToken = prefs.getString('AccessToken');
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    setupApp();

    //await AndroidAlarmManager.oneShotAt(date, 0, printHello);
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}
