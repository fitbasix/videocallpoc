import 'dart:async';
import 'dart:convert';

import 'package:fitbasix/core/constants/credentials.dart';
import 'package:fitbasix/feature/Home/view/Home_page.dart';
import 'package:fitbasix/feature/Home/view/widgets/healthData.dart';
import 'package:fitbasix/feature/get_started_page/view/get_started_page.dart';
import 'package:fitbasix/feature/get_trained/view/all_trainer_screen.dart';
import 'package:fitbasix/feature/get_trained/view/get_trained_screen.dart';
import 'package:fitbasix/feature/get_trained/view/trainer_profile_screen.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';
import 'package:fitbasix/feature/log_in/view/enter_mobile_google.dart';
import 'package:fitbasix/feature/log_in/view/enter_otp_google.dart';
import 'package:fitbasix/feature/log_in/view/login_screen.dart';
import 'package:fitbasix/feature/profile/view/account_and_subscription_screen.dart';
import 'package:fitbasix/feature/video_call/view/video_call.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import 'core/api_service/remote_config_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitbasix/core/localization/translations.dart';
import 'package:fitbasix/fitbasix_app.dart';
import 'feature/Home/controller/Home_Controller.dart';
import 'feature/Home/view/consumption_screen.dart';
import 'feature/get_trained/controller/trainer_controller.dart';
import 'package:sentry_flutter/sentry_flutter.dart';


Future<void> setupApp() async {
  Uri? _latestUri;

  Uri? _initialUri;

  late StreamSubscription _sub;

  Get.put(AppTranslations());
  await RemoteConfigService.onForceFetched(RemoteConfigService.remoteConfig);
  final SharedPreferences prefs =
      await SharedPreferences.getInstance().then((value) async {
    _sub = uriLinkStream.listen(
      (Uri? uri) {
        _latestUri = uri;
      },
      onError: (Object err) {
        _latestUri = null;
      },
    );
    try {
      final uri = await getInitialUri();
      _initialUri = uri;
    } on PlatformException {
      _initialUri = null;
    } on FormatException catch (err) {
      debugPrint(err.toString());
      _initialUri = null;
    }
    if (_initialUri != null || _latestUri != null) {
      HomeController controller = Get.put(HomeController());
      TrainerController trainerController = Get.put(TrainerController());
    }
    return value;
  });
  var accessToken = prefs.getString('AccessToken');
  final translations = GetTranslations.loadTranslations();

  runZonedGuarded(() async {
    await SentryFlutter.init(
      (options) {
        options.dsn =
            'https://75565b8907e24a44b497620700c41d09@o1222554.ingest.sentry.io/6366529';
      },
    );

    runApp(FitBasixApp(
      translations: translations,
      child:VideoCallScreen()
      // accessToken == null
      //     ? LoginScreen()
      //     : (_initialUri != null || _latestUri != null)
      //         ? TrainerProfileScreen(
      //             trainerID: "6226f41b28d9a579eeabb5ee",
      //           )
      //         : HomeAndTrainerPage(),
    )
    );
  }, (exception, stackTrace) async {
    await Sentry.captureException(exception, stackTrace: stackTrace);
  });
}



