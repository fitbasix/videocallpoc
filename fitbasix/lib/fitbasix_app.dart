import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class FitBasixApp extends StatelessWidget {
  const FitBasixApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitbasix',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const Scaffold(
        body: Center(
          child: Text(
            'FitBasix',
          ),
        ),
      ),
    );
  }
}
