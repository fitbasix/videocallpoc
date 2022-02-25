import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fitbasix/setup-my-app.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString('AccessToken');
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    setupApp();
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}
