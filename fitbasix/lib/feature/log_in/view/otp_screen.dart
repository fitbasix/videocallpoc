import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/back_button.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button.dart';
import 'package:fitbasix/feature/log_in/controller/login_controller.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({Key? key}) : super(key: key);
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
              height: 16 * SizeConfig.heightMultiplier!,
            ),
            CustomBackButton(),
            SizedBox(
              height: 24 * SizeConfig.heightMultiplier!,
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
            Row(
              children: [
                Text(
                  'to_modify_number'.tr,
                  style: AppTextStyle.NormalText,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'click_here'.tr,
                    style: AppTextStyle.NormalText.copyWith(
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 58 * SizeConfig.heightMultiplier!,
            ),
            PinCodeTextField(
              appContext: context,
              length: 6,
              onChanged: (value) {
                _loginController.otp.value = value;
              },
              enableActiveFill: true,
              keyboardType: TextInputType.number,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: 56 * SizeConfig.widthMultiplier!,
                fieldWidth: 56 * SizeConfig.widthMultiplier!,
                selectedColor: Colors.transparent,
                activeFillColor: kLightGrey,
                inactiveColor: Colors.transparent,
                activeColor: Colors.transparent,
                inactiveFillColor: kLightGrey,
                selectedFillColor: kLightGrey,
              ),
            ),
            SizedBox(
              height: 16 * SizeConfig.heightMultiplier!,
            ),
            Row(
              children: [
                Text(
                  'resend_otp_text'.tr,
                  style: AppTextStyle.NormalText.copyWith(
                      fontSize: 14 * SizeConfig.textMultiplier!),
                ),
                InkWell(
                  onTap: () async {
                    await _loginController.getOTP();
                  },
                  child: Text(
                    'resend'.tr,
                    style: AppTextStyle.NormalText.copyWith(
                        decoration: TextDecoration.underline,
                        fontSize: 14 * SizeConfig.textMultiplier!),
                  ),
                ),
              ],
            ),
            Spacer(),
            Obx(() => _loginController.isLoading.value
                ? Center(child: CustomizedCircularProgress())
                : ProceedButton(
                    title: 'verify'.tr,
                    onPressed: () async {
                      _loginController.isLoading.value = true;
                      final redScreen = await LogInService.loginAndSignup(
                          _loginController.mobile.value,
                          _loginController.otp.value,
                          _loginController.selectedCountry.value.code!,
                          "");

                      if (redScreen == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text(_loginController.otpErrorMessage.value)));
                        _loginController.isLoading.value = false;
                      }

                      if (redScreen == 18) {
                        _loginController.isLoading.value = false;
                        Navigator.pushNamed(context, RouteName.enterDetails);
                      } else if (redScreen == 16) {
                        _loginController.isLoading.value = false;
                        Navigator.pushNamed(context, RouteName.homePage);
                      }
                    })),
            SizedBox(
              height: 32 * SizeConfig.heightMultiplier!,
            ),
          ],
        ),
      )),
    );
  }
}
