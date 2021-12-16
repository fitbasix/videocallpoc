import 'package:fitbasix/feature/log_in/controller/login_controller.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitbasix/core/sevices/remote_config_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  final LoginController _loginController = Get.put(LoginController());
  String title = RemoteConfigService.remoteConfig.getString('welcome');

  @override
  void didChangeLocales(List<Locale>? locales) {
    // TODO: implement didChangeLocales
    super.didChangeLocales(locales);

    setState(() {
      title = RemoteConfigService.remoteConfig.getString('welcome');
    });
  }

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
                  await LogInService.registerUser();
                },
                child: const Text('Google Signup')),
            TextButton(
                onPressed: () {
                  RemoteConfigService.onForceFetched(
                      RemoteConfigService.remoteConfig);

                  setState(() {
                    title =
                        RemoteConfigService.remoteConfig.getString('welcome');
                  });
                },
                child: const Text('Get Locale'))
          ],
        )),
      ),
    );
  }
}
