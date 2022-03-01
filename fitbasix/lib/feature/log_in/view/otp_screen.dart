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
      resizeToAvoidBottomInset: true,
    //  backgroundColor: kPureBlack,
      body: SafeArea(
          child: Stack(
            children: [
              Container(
                height: double.infinity,
              ),
              Image.asset(
                ImagePath.otp_intro_image,
                height: 540 * SizeConfig.heightMultiplier!,
                width: Get.width,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 0,
                child: Image.asset(
                  ImagePath.black_rectangle,
                  height: 374 * SizeConfig.heightMultiplier!,
                  width: Get.width,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                  top: 16.12,
                  left: 18.67,
                  child: CustomBackButton(color: kPureWhite,)
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kPureBlack,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16*SizeConfig.widthMultiplier!),
                      topLeft: Radius.circular(16*SizeConfig.widthMultiplier!),
                    )
                  ),
                  padding: EdgeInsets.only(
                      left: 16 * SizeConfig.widthMultiplier!,
                      right: 16 * SizeConfig.widthMultiplier!),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 16 * SizeConfig.heightMultiplier!,
                      ),
                      Text(
                        'Hi'.tr,
                        style: AppTextStyle.titleText.copyWith(
                            color: kPureWhite
                        ),
                      ),
                      SizedBox(
                        height: 8 * SizeConfig.heightMultiplier!,
                      ),
                      Text(
                        'enter_otp_text'
                            .trParams({'number': _loginController.mobile.value}),
                        style: AppTextStyle.NormalText.copyWith(
                            color: kPureWhite,
                          fontSize: (12) * SizeConfig.textMultiplier!,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'to_modify_number'.tr,
                            style: AppTextStyle.NormalText.copyWith(
                                color: kPureWhite,
                              fontSize: (12) * SizeConfig.textMultiplier!,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'click_here'.tr,
                              style: AppTextStyle.NormalText.copyWith(
                                  color: kPureWhite,
                                  fontSize: (12) * SizeConfig.textMultiplier!,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16 * SizeConfig.heightMultiplier!,
                      ),
                      PinCodeTextField(
                        appContext: context,
                        length: 6,
                        onChanged: (value) {
                          _loginController.otp.value = value;
                        },
                        enableActiveFill: false,
                        keyboardType: TextInputType.number,
                        textStyle: TextStyle(
                          color: kPureWhite
                        ),
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.underline,
                          fieldHeight: 48 * SizeConfig.widthMultiplier!,
                          fieldWidth: 48 * SizeConfig.widthMultiplier!,
                          selectedColor: greyBorder,
                          // activeFillColor: kLightGrey,
                          inactiveColor: greyBorder,
                          activeColor: greyBorder,
                          // inactiveFillColor: kLightGrey,
                          // selectedFillColor: kLightGrey,
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
                                color: kPureWhite,
                                fontSize: 14 * SizeConfig.textMultiplier!),
                          ),
                          InkWell(
                            onTap: () async {
                              await _loginController.getOTP();
                            },
                            child: Text(
                              'resend'.tr,
                              style: AppTextStyle.NormalText.copyWith(
                                  color: kPureWhite,
                                  decoration: TextDecoration.underline,
                                  fontSize: 14 * SizeConfig.textMultiplier!),
                            ),
                          ),
                        ],
                      ),
                      // Spacer(),
                      SizedBox(
                        height: 16 * SizeConfig.heightMultiplier!,
                      ),
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
                              Navigator.pushNamedAndRemoveUntil(
                                  context, RouteName.homePage, (route) => false);
                            }
                          })),
                      SizedBox(
                        height: 32 * SizeConfig.heightMultiplier!,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}
