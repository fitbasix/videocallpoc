import 'package:fitbasix/feature/log_in/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileScreen extends StatelessWidget {
  MobileScreen({Key? key}) : super(key: key);
  final LoginController _loginController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Verification'),
      ),
      body: SafeArea(
          child: Column(
        children: [
          TextField(
            onChanged: (value) {
              _loginController.mobile.value = value;
            },
          ),
          TextButton(
              onPressed: () {
                _loginController.getOTP();
              },
              child: const Text('Submit Mobile')),
          const SizedBox(
            height: 20,
          ),
          TextField(
            onChanged: (value) {
              _loginController.otp.value = value;
            },
          ),
          TextButton(
              onPressed: () {
                _loginController.verifyOTP();
              },
              child: const Text('Submit OTP'))
        ],
      )),
    );
  }
}
