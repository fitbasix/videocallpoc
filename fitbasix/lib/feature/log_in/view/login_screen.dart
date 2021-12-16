import 'package:fitbasix/feature/log_in/controller/login_controller.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final LoginController _loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          TextButton(
              onPressed: () {
                _loginController.googleLogin();
              },
              child: const Text('Google Signup')),
          TextButton(
              onPressed: () async {
                await LogInService.registerUser();
              },
              child: const Text('Google Signup'))
        ],
      )),
    );
  }
}
