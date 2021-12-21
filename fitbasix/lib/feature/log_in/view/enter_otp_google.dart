import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button_with_arrow.dart';
import 'package:fitbasix/feature/log_in/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EnterOTPGoogle extends StatelessWidget {
  EnterOTPGoogle({Key? key}) : super(key: key);
  final LoginController _loginController = Get.find();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: 16 * SizeConfig.widthMultiplier!),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 16 * SizeConfig.heightMultiplier!,
            ),
            SvgPicture.asset(ImagePath.backIcon),
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
              'enter_otp_text'
                  .trParams({'number': _loginController.mobile.value}),
              style: AppTextStyle.NormalText,
            ),
            SizedBox(
              height: 58 * SizeConfig.heightMultiplier!,
            ),
            PinCodeTextField(
              appContext: context,
              length: 6,
              onChanged: (value) {},
              enableActiveFill: true,
              keyboardType: TextInputType.number,
              pinTheme: PinTheme(
                // shape: PinCodeFieldShape.box,
                activeFillColor: kLightGrey,
                inactiveColor: Colors.transparent,
                activeColor: Colors.transparent,
                selectedColor: Colors.transparent,
                inactiveFillColor: kLightGrey,
                selectedFillColor: kLightGrey,
                borderWidth: 0,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const Spacer(),
            ProceedButtonWithArrow(
                title: 'proceed'.tr,
                onPressed: () {
                  Navigator.pushNamed(context, RouteName.homePage);
                }),
            SizedBox(
              height: 32 * SizeConfig.heightMultiplier!,
            ),
          ],
        ),
      )),
    );
  }
}
