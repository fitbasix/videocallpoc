import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button_with_arrow.dart';
import 'package:fitbasix/feature/log_in/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class EnterMobileDetailsGoogle extends StatelessWidget {
  EnterMobileDetailsGoogle({Key? key}) : super(key: key);

  final LoginController _loginController = Get.find();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16 * SizeConfig.heightMultiplier!,
              ),
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child:SvgPicture.asset(ImagePath.backIcon)),

              SizedBox(
                height: 24 * SizeConfig.heightMultiplier!,
              ),
              Text(
                'hi_name'.trParams({'name': user!.displayName!}),
                style: AppTextStyle.titleText,
              ),
              SizedBox(
                height: 8 * SizeConfig.heightMultiplier!,
              ),
              Text(
                'enter_your_mobile_text_google_user'.tr,
                style: AppTextStyle.NormalText,
              ),
              SizedBox(
                height: 16 * SizeConfig.heightMultiplier!,
              ),
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8)),
                child: TextFormField(
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: kLightGrey,
                      border: InputBorder.none,
                      hintText: 'enter_number_hint'.tr),
                  onChanged: (value) {
                    _loginController.mobile.value = value;
                  },
                ),
              ),
              Spacer(),
              ProceedButtonWithArrow(
                  title: 'proceed'.tr,
                  onPressed: () {
                    Navigator.pushNamed(context, RouteName.enterOTPGoogle);
                  }),
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
