import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';

void setupApp(Widget child) {
  runApp(
    EasyLocalization(
        path: 'assets/translation',
        supportedLocales: const [Locale('en')],
        fallbackLocale: const Locale('en'),
        //assetLoader: CodegenLoader(),
        child: child),
  );
}
