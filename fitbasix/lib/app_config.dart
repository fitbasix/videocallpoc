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
        return 'http://3.131.171.176';
      case Flavor.DEVELOPMENT:
        return 'http://3.131.171.176';
      case Flavor.STAGING:
        return 'http://3.131.171.176';
      default:
        return 'http://3.131.171.176';
    }
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}