import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button.dart';
import 'package:fitbasix/feature/log_in/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class MobileScreen extends StatelessWidget {
  MobileScreen({Key? key}) : super(key: key);
  final LoginController _loginController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 65 * SizeConfig.heightMultiplier!,
            ),
            Text(
              'hello'.tr,
              style: AppTextStyle.titleText,
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
              pinTheme: PinTheme(
                  // shape: PinCodeFieldShape.box,
                  selectedColor: Colors.transparent,
                  activeFillColor: kLightGrey,
                  inactiveColor: Colors.transparent,
                  activeColor: Colors.transparent,
                  inactiveFillColor: kLightGrey,
                  selectedFillColor: kLightGrey,
                  borderWidth: 0,
                  borderRadius: BorderRadius.circular(8)),
            ),
            SizedBox(
              height: 32 * SizeConfig.heightMultiplier!,
            ),
            ProceedButton(title: 'verify'.tr, onPressed: () {}),
            SizedBox(
              height: 16 * SizeConfig.heightMultiplier!,
            ),
            Text('resend_otp_text'.tr)
          ],
        ),
      )),
    );
  }
}
