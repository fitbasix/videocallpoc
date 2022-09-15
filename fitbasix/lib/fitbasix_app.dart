import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:fitbasix/core/localization/translations.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'NetworkManager.dart';
import 'core/constants/image_path.dart';

class FitBasixApp extends StatelessWidget {
  final AppTranslations translations;
  final Widget child;
  const FitBasixApp({Key? key, required this.translations, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 728),
        minTextAdapt: true,
        builder: (_, __) {
          return LayoutBuilder(builder: (context, constraints) {
            return OrientationBuilder(builder: (context, orientation) {
              SizeConfig().init(constraints, orientation);
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
              ]);
              return GetMaterialApp(
                  initialBinding: NetworkBinding(),
                  title: 'Fitbasix',
                  scaffoldMessengerKey: snackbarKey,
                  //  darkTheme: ThemeData.dark(),
                  theme: ThemeData(
                    //scaffold color of app
                    scaffoldBackgroundColor: kPureBlack,
                    //used in my trainer screen & icon back button color & post screen
                    primaryColor: kPureWhite,
                    //used in all trainer screen in Item category
                    secondaryHeaderColor: kPureBlack,
                    primaryColorLight: kPureWhite,
                    primaryColorDark: kBlack,
                    // used in achiements certificate
                    highlightColor: const Color(0xff28362B),
                    indicatorColor: const Color(0xff37342F),
                    // icon used in homescreen & used in needle color
                    primaryIconTheme: const IconThemeData(color: kPureWhite),
                    appBarTheme: const AppBarTheme(
                        color: kPureWhite,
                        titleTextStyle: TextStyle(color: kPureWhite),
                        iconTheme: IconThemeData(color: kPureWhite),
                        actionsIconTheme: IconThemeData(color: kPureWhite)),
                    // primary text theme
                    textTheme: const TextTheme(
                      //primary text color used in gettrainerscreen & trainer profile Screen & home Screen
                      bodyText1: TextStyle(color: kPureWhite),
                      // used in home screen today text
                      bodyText2: TextStyle(color: kLightGrey),
                      // See All text & about & divider used in get trained screen
                      headline1: TextStyle(color: hintGrey),
                      // used in trainer profile screen
                      headline2: TextStyle(color: greyC4),
                      // used in post tile & explore feed for category duration & location
                      headline3: TextStyle(color: grey92),
                      // used in strength listview of trainer screen
                      headline4: TextStyle(color: greyBorder),
                      // used in plantile in trainer profile screen
                      headline5: TextStyle(color: grey2B),
                      // used in comment tile
                      headline6: TextStyle(color: greyB7),
                    ),
                    //Trainer card in get trainer screen & all trainer Screen & home sceen
                    cardColor: kBlack,
                  ),
                  translations: translations,
                  locale: const Locale('en', 'US'),
                  fallbackLocale: const Locale('es', 'ES'),
                  onGenerateRoute: GenerateRoute.generateRoute,
                  navigatorObservers: [
                    SentryNavigatorObserver(),
                  ],
                  home: child);
            });
          });
        });
  }
}
