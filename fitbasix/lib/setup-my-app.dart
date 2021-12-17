import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';

void setupApp(Widget child) {
  runApp(
    EasyLocalization(
        path: 'assets/translation',
        supportedLocales: const [Locale('en'), Locale('ar')],
        fallbackLocale: const Locale('en'),
        //assetLoader: CodegenLoader(),
        child: child),
  );
}
