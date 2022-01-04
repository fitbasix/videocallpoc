import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/Home/view/widgets/bottom_app_bar.dart';
import 'package:fitbasix/feature/get_trained/view/get_trained_screen.dart';
import 'package:fitbasix/feature/log_in/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeAndTrainerPage extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());

  final List<Widget> screens = [HomePage(), GetTrainedScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => screens[homeController.selectedIndex.value]),
      bottomNavigationBar: CustomizedBottomAppBar(),
    );
  }
}

class HomePage extends StatelessWidget {
  final LoginController _controller = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: TextButton(
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              prefs.clear();
              await _controller.googleSignout();
              Navigator.pushNamedAndRemoveUntil(
                  context, RouteName.loginScreen, (route) => false);
            },
            child: const Text('Sign Out')),
      ),
    );
  }
}
