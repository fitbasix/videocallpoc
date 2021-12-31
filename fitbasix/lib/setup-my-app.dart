import 'package:fitbasix/feature/Home/view/Home_page.dart';
import 'package:fitbasix/feature/get_started_page/view/get_started_page.dart';
import 'package:fitbasix/feature/get_trained/view/all_trainer_screen.dart';
import 'package:fitbasix/feature/get_trained/view/get_trained_screen.dart';
import 'package:fitbasix/feature/get_trained/view/trainer_profile_screen.dart';
import 'package:fitbasix/feature/log_in/view/enter_mobile_google.dart';
import 'package:fitbasix/feature/log_in/view/enter_otp_google.dart';
import 'package:fitbasix/feature/log_in/view/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/api_service/remote_config_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitbasix/core/localization/translations.dart';
import 'package:fitbasix/fitbasix_app.dart';

Future<void> setupApp() async {
  Get.put(AppTranslations());
  await RemoteConfigService.onForceFetched(RemoteConfigService.remoteConfig);
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var accessToken = prefs.getString('AccessToken');
  final translations = GetTranslations.loadTranslations();
  runApp(FitBasixApp(
    translations: translations,
    child: accessToken == null ? TrainerProfileScreen() : AllTrainerScreen(),
  ));
}
