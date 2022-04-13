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
        return 'https://fitbasix.net';
      case Flavor.DEVELOPMENT:
        return 'https://fitbasix.net';
      case Flavor.STAGING:
        return 'https://fitbasix.net';
      default:
        return 'https://fitbasix.net';
    }
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}