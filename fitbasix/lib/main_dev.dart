import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:fitbasix/fitbasix_app.dart';
import 'package:fitbasix/setup-my-app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  setupApp(const FitBasixApp());
}


//https://fitbitsix-d1493.firebaseapp.com/__/auth/handler