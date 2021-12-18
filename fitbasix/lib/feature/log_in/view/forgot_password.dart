import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button_with_arrow.dart';
import 'package:fitbasix/core/universal_widgets/text_Field.dart';
import 'package:fitbasix/feature/log_in/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ForgotPassword extends StatelessWidget {
  final LoginController _loginController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 16 * SizeConfig.widthMultiplier!),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16 * SizeConfig.heightMultiplier!,
              ),
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(ImagePath.backIcon)),
              SizedBox(
                height: 65 * SizeConfig.heightMultiplier!,
              ),
              Text(
                'hi_name'.trParams({'name': "John"}),
                style: AppTextStyle.titleText,
              ),
              SizedBox(
                height: 8 * SizeConfig.heightMultiplier!,
              ),
              Text(
                'reset_password_heading'
                    .trParams({'number': _loginController.mobile.value}),
                style: AppTextStyle.NormalText,
              ),
              SizedBox(
                height: 50 * SizeConfig.heightMultiplier!,
              ),
              PinCodeTextField(
                appContext: context,
                length: 6,
                onChanged: (value) {},
                enableActiveFill: true,
                pinTheme: PinTheme(
                    // shape: PinCodeFieldShape.box,
                    activeFillColor: kLightGrey,
                    inactiveColor: Colors.transparent,
                    activeColor: Colors.transparent,
                    selectedColor: Colors.transparent,
                    inactiveFillColor: kLightGrey,
                    selectedFillColor: kLightGrey,
                    borderWidth: 0,
                    borderRadius: BorderRadius.circular(8)),
              ),
              Spacer(),
              ProceedButtonWithArrow(
                title: 'proceed'.tr,
                onPressed: () {
                  Navigator.pushNamed(context, RouteName.resetPassword);
                },
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
