import 'core/api_service/remote_config_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:fitbasix/core/localization/translations.dart';
import 'package:fitbasix/fitbasix_app.dart';

void setupApp() {
  Get.put(AppTranslations());
  RemoteConfigService.onForceFetched(RemoteConfigService.remoteConfig);
  final translations = GetTranslations.loadTranslations();
  runApp(FitBasixApp(
    translations: translations,
  ));
}
