import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/feature/get_started_page/view/get_started_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:fitbasix/core/analytics/analytics_service.dart';
import 'package:fitbasix/core/localization/translations.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/feature/log_in/view/login_screen.dart';

class FitBasixApp extends StatelessWidget {
  final AppTranslations translations;
  final Widget child;
  const FitBasixApp({Key? key, required this.translations, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(360, 728),
        minTextAdapt: true,
        builder: () {
          return LayoutBuilder(builder: (context, constraints) {
            return OrientationBuilder(builder: (context, orientation) {
              SizeConfig().init(constraints, orientation);
              return GetMaterialApp(
                  title: 'Fitbasix',
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                  ),
                  translations: translations,
                  locale: const Locale('en', 'US'),
                  fallbackLocale: const Locale('es', 'ES'),
                  onGenerateRoute: GenerateRoute.generateRoute,
                  navigatorObservers: [AnalyticsService.getAnalyticsObserver()],
                  home: child);
            });
          });
        });
  }
}
