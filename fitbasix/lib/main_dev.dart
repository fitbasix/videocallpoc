import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fitbasix/setup-my-app.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';




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
  // await AwesomeNotifications().createNotification(
  //     content: NotificationContent(
  //       displayOnForeground: true,
  //       displayOnBackground: true,
  //       id: 1999,
  //       channelKey: 'basic_channel',
  //       title: 'Water Reminder',
  //       body: 'drink Water $notificationId',
  //       wakeUpScreen: true,
  //       category: NotificationCategory.Reminder,
  //       payload: {'uuid': 'uuid-test'},
  //       autoDismissible: false,
  //     ),
  //     schedule:NotificationCalendar(
  //         second: startTime.second,
  //         year: startTime.year,
  //         minute: startTime.minute,
  //         repeats: true,
  //         allowWhileIdle: true,
  //         preciseAlarm: true
  //     )
  // );
}

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    initializeNotification();
    await Firebase.initializeApp();


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
    }
    );

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
