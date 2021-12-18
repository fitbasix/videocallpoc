import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:fitbasix/core/analytics/analytics_service.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/feature/log_in/view/login_screen.dart';

class FitBasixApp extends StatelessWidget {
  const FitBasixApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Fitbasix',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
         onGenerateRoute: GenerateRoute.generateRoute,
        navigatorObservers: [AnalyticsService.getAnalyticsObserver()],
        home: LoginScreen());
  }
}
