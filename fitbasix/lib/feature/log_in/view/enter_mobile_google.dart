import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitbasix/core/universal_widgets/back_button.dart';
import 'package:fitbasix/feature/log_in/view/widgets/black_textfield.dart';
import 'package:fitbasix/feature/log_in/view/widgets/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button_with_arrow.dart';
import 'package:fitbasix/feature/log_in/controller/login_controller.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';
import 'package:fitbasix/feature/log_in/view/widgets/country_dropdown.dart';

import '../../../core/universal_widgets/capitalizeText.dart';
import '../../../core/universal_widgets/proceed_button.dart';

class EnterMobileDetailsGoogle extends StatelessWidget {
  EnterMobileDetailsGoogle({Key? key}) : super(key: key);

  final LoginController _loginController = Get.find();
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
          child: Stack(
        children: [
          Image.asset(
            ImagePath.login_intro_image,
            height: 541 * SizeConfig.heightMultiplier!,
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
              child: CustomBackButton(color: Theme.of(context).primaryColor)
          ),
          //body
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 16 * SizeConfig.widthMultiplier!),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(),
                // SizedBox(
                //   height: 16 * SizeConfig.heightMultiplier!,
                // ),
                // CustomBackButton(),
                // SizedBox(
                //   height: 24 * SizeConfig.heightMultiplier!,
                // ),
                Text(
                  'hi_name'.trParams({
                    'name': _loginController
                                .thirdPartyLogin.value.response!.user!.name ==
                            null
                        ? ""
                        : _loginController
                            .thirdPartyLogin.value.response!.user!.name!.capitalize!
                  }),
                  style: AppTextStyle.titleText.copyWith(
                    color: Theme.of(context).textTheme.bodyText1?.color
                  ),
                ),
                SizedBox(
                  height: 8 * SizeConfig.heightMultiplier!,
                ),
                Text(
                  'enter_your_mobile_text_google_user'.tr,
                  style: AppTextStyle.NormalText.copyWith(
                      fontSize: (12) * SizeConfig.textMultiplier!,
                      color: Theme.of(context).textTheme.bodyText1?.color),
                ),
                SizedBox(
                  height: 16 * SizeConfig.heightMultiplier!,
                ),
                Obx(
                  () => BlackCutomizedTextField(
                    color: Colors.transparent,
                    child: TextFieldContainer(
                      inputFormatters: [
                                        UpperCaseTextFormatter()
                                      ],
                        onChanged: (value) {
                          _loginController.mobile.value = value;
                        },
                        maxLength: 10,
                        isTextFieldActive: true,
                        preFixWidget: Container(
                          width: 90*SizeConfig.widthMultiplier!,
                          child: Row(
                            children: [
                              SimpleAccountMenu(
                                listofItems: _loginController.countryList,
                                onChange: (value) {
                                  _loginController.selectedCountry.value =
                                      value;
                                  print(_loginController
                                      .selectedCountry.value.code);
                                },
                                hint: _loginController.selectedCountry.value,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              SizedBox(
                                width: 16 * SizeConfig.widthMultiplier!,
                              ),
                               Text(
                                '|',
                                style:
                                    TextStyle(fontSize: 24, color: greyB7),
                              ),
                            ],
                          ),
                        ),
                        textEditingController:
                            _loginController.mobileController,
                        isNumber: true,
                        hint: 'enter_number_hint'.tr),
                  ),
                ),
                SizedBox(
                  height: 16 * SizeConfig.heightMultiplier!,
                ),
                Obx(() => _loginController.isLoading.value
                    ? Center(
                        child: CustomizedCircularProgress(),
                      )
                    : ProceedButton(
                        title: 'next'.tr,
                        onPressed: () async {
                          if (_loginController.mobile.value.length == 10) {
                            _loginController.isLoading.value == true;
                            await LogInService.getOTP(
                                _loginController.mobile.value,
                                _loginController.selectedCountry.value.code!);

                            Navigator.pushNamed(
                                context, RouteName.enterOTPGoogle);
                            _loginController.isLoading.value = false;
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text('Please enter valid mobile number')));
                          }
                        })),
                SizedBox(
                  height: 8 * SizeConfig.heightMultiplier!,
                ),
                Text(
                  'By signing up you agree our terms and conditions and privacy policy',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.NormalText.copyWith(
                      fontSize: 12 * SizeConfig.textMultiplier!,
                      color: Theme.of(context).textTheme.bodyText2?.color
                  ),
                ),
                SizedBox(
                  height: 32 * SizeConfig.heightMultiplier!,
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
