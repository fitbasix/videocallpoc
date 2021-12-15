import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:fitbasix/core/analytics/analytics_service.dart';
import 'package:fitbasix/feature/log_in/controller/login_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final LoginController _loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () async {
                  _loginController.googleLogin();
                  await AnalyticsService.analytics
                      .logSignUp(signUpMethod: 'google_signup');
                },
                child: const Text('Google Signup')),
            Text(user!.displayName! + ' is Logged In')
          ],
        )),
      ),
    );
  }
}
