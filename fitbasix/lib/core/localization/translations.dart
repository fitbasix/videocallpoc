import 'dart:convert';

import 'package:fitbasix/core/sevices/remote_config_service.dart';
import 'package:get/get.dart';

class AppTranslations extends Translations {
  Map<String, String>? en_US;
  final Map<String, String>? es_ES;

  AppTranslations({this.en_US, this.es_ES});

  static AppTranslations fromJson(dynamic json) {
    return AppTranslations(
      en_US: Map<String, String>.from(json["en_US"]),
      es_ES: Map<String, String>.from(json["es_ES"]),
    );
  }

  @override
  Map<String, Map<String, String>> get keys => {
        "en_US": en_US!,
        "es_ES": es_ES!,
      };
}

class GetTranslations {
  static AppTranslations loadTranslations() {
    return AppTranslations.fromJson(
        jsonDecode(RemoteConfigService.remoteConfig.getString('localization')));
  }
}
