import 'package:fitbasix/feature/Home/view/Home_page.dart';
import 'package:fitbasix/feature/get_started_page/view/get_started_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/api_service/remote_config_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitbasix/core/localization/translations.dart';
import 'package:fitbasix/fitbasix_app.dart';

Future<void> setupApp() async {
  Get.put(AppTranslations());
  RemoteConfigService.onForceFetched(RemoteConfigService.remoteConfig);
  print("accessToken");

  final translations = GetTranslations.loadTranslations();
  runApp(FitBasixApp(
    translations: translations,
    child: HomePage(),
  ));
}
