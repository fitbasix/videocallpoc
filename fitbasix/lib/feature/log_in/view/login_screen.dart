import 'package:fitbasix/feature/log_in/controller/login_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/api_service/remote_config_service.dart';
import 'package:fitbasix/feature/log_in/view/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final LoginController _loginController = Get.put(LoginController());
  String title = RemoteConfigService.remoteConfig.getString('welcome');

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 24),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            TextButton(
                onPressed: () {
                  _loginController.googleLogin();
                },
                child: const Text('Google Signup')),
            TextButton(
                onPressed: () async {
                  // await LogInService.registerUser();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MobileScreen()));
                },
                child: const Text('Mobile Verification')),
            TextButton(
                onPressed: () {
                  var locale = Locale('es', 'ES');
                  Get.updateLocale(locale);
                },
                child: const Text('Get Locale')),
            Text('logged_in'.tr)
          ],
        )),
      ),
    );
  }
}
