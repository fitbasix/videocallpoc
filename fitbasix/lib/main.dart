import 'package:easy_localization/easy_localization.dart';
import 'package:fitbasix/fitbasix_app.dart';
import 'package:fitbasix/setup-my-app.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  setupApp(const FitBasixApp());
}
