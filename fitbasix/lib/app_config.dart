import 'package:flutter/material.dart';
enum Flavor {
  STAGING,
  DEVELOPMENT,
  PRODUCTION,
}

class AppConfig {
  static Flavor? buildFlavour;
  static AppConfig of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType(aspect: AppConfig)!;
  }

  static String get api_url {
    switch (buildFlavour) {
      case Flavor.PRODUCTION:
        return 'https://fitbasix.com';
      case Flavor.DEVELOPMENT:
        return 'https://fitbasix.com';
      case Flavor.STAGING:
        return 'https://stage-api.fitbasix.com';
      default:
        return 'https://fitbasix.com';
    }
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}