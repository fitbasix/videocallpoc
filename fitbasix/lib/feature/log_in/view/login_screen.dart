import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button.dart';
import 'package:fitbasix/core/universal_widgets/text_Field.dart';
import 'package:fitbasix/feature/log_in/controller/login_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
        child: Padding(
          padding: const EdgeInsets.only(left: 16, top: 44, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'welcomeTo'.tr,
                style: AppTextStyle.NormalText,
              ),
              SizedBox(
                height: 20 * SizeConfig.heightMultiplier!,
              ),
              SvgPicture.asset(
                ImagePath.fitBasixIconBlack,
              ),
              SizedBox(
                height: 58 * SizeConfig.heightMultiplier!,
              ),
              Text(
                'enter_mobile_text'.tr,
                style: AppTextStyle.NormalText,
              ),
              SizedBox(
                height: 8 * SizeConfig.heightMultiplier!,
              ),
              CutomizedTextField(
                color: Colors.transparent,
                child: TextFieldContainer(
                    onChanged: (value) {
                      _loginController.mobile.value = value;
                    },
                    textEditingController: _loginController.mobileController,
                    isNumber: false,
                    hint: 'enter_number_hint'.tr),
              ),
              SizedBox(
                height: 32 * SizeConfig.heightMultiplier!,
              ),
              ProceedButton(
                  title: 'next'.tr,
                  onPressed: () {
                    Navigator.pushNamed(context, RouteName.enterPasswordPage);
                  }),
              const Spacer(),
              Center(
                child: Text(
                  'or'.tr,
                  style: AppTextStyle.NormalText,
                ),
              ),
              SizedBox(
                height: 16 * SizeConfig.heightMultiplier!,
              ),
              Center(
                child: Text(
                  'withLogin'.tr,
                  style: AppTextStyle.NormalText,
                ),
              ),
              SizedBox(
                height: 16 * SizeConfig.heightMultiplier!,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: kLightGrey,
                      child: SvgPicture.asset(ImagePath.appleIcon),
                    ),
                  ),
                  SizedBox(
                    width: 12 * SizeConfig.heightMultiplier!,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await _loginController.googleLogin();
                      Navigator.pushNamed(context, RouteName.enterMobileGoogle);
                    },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: kLightGrey,
                      child: SvgPicture.asset(ImagePath.googleICon),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 32 * SizeConfig.heightMultiplier!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
