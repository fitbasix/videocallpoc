import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button_with_arrow.dart';
import 'package:fitbasix/feature/Home/view/Home_page.dart';
import 'package:fitbasix/feature/log_in/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetStartedPage extends StatefulWidget {
  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  @override
  void initState() {
    splashClose();
    super.initState();
  }

  splashClose() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var accessToken = prefs.getString('AccessToken');
    Future.delayed(const Duration(milliseconds: 700), () async {
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                accessToken == null ? LoginScreen() : HomeAndTrainerPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Image.asset(
          "assets/log_in/welcome_image.png",
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
