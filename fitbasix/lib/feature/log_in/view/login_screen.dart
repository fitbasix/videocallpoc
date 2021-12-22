import 'dart:io';

import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button.dart';
import 'package:fitbasix/core/universal_widgets/text_Field.dart';
import 'package:fitbasix/feature/log_in/controller/login_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';
import 'package:fitbasix/feature/log_in/view/widgets/country_dropdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/api_service/remote_config_service.dart';
import 'package:fitbasix/feature/log_in/view/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final LoginController _loginController = Get.put(LoginController());
  String title = RemoteConfigService.remoteConfig.getString('welcome');

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              Obx(
                () => CutomizedTextField(
                  color: Colors.transparent,
                  child: TextFieldContainer(
                      onChanged: (value) {
                        _loginController.mobile.value = value;
                      },
                      isTextFieldActive: true,
                      preFixWidget: Container(
                        width: 80,
                        child: Row(
                          children: [
                            CountryDropDown(
                              hint: _loginController.selectedCountry.value,
                              listofItems: _loginController.countryList,
                              onChanged: (value) {
                                _loginController.selectedCountry.value = value;
                              },
                            ),
                            const Text(
                              '|',
                              style: TextStyle(fontSize: 24, color: kGreyColor),
                            ),
                          ],
                        ),
                      ),
                      textEditingController: _loginController.mobileController,
                      isNumber: true,
                      hint: 'enter_number_hint'.tr),
                ),
              ),
              SizedBox(
                height: 32 * SizeConfig.heightMultiplier!,
              ),
              ProceedButton(
                  title: 'next'.tr,
                  onPressed: () async {
                    // print(_loginController.selectedCountry.value.phoneCode!);
                    await LogInService.getOTP(_loginController.mobile.value);
                    // await _loginController.logInRegisterUser(
                    //     "DEFAULT",
                    //     "",
                    //     _loginController.mobile.value,
                    //     _loginController.selectedCountry.value.phoneCode!,
                    //     "",
                    //     "",
                    //     "");
                    Navigator.pushNamed(context, RouteName.otpScreen);
                    // Navigator.pushNamed(context, RouteName.enterDetails);
                    // if (_loginController
                    //         .LogInRegisterResponse.value.response!.redCode ==
                    //     13) {
                    //   Navigator.pushNamed(context, RouteName.otpScreen);
                    // }
                  }),
              SizedBox(
                height: 32 * SizeConfig.heightMultiplier!,
              ),
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
                  Platform.isIOS
                      ? GestureDetector(
                          onTap: () async {
                            final rawNonce = generateNonce();
                            final credential =
                                await SignInWithApple.getAppleIDCredential(
                              scopes: [
                                AppleIDAuthorizationScopes.email,
                                AppleIDAuthorizationScopes.fullName,
                              ],
                            );
                            final AuthCredential authCredential =
                                GoogleAuthProvider.credential(
                              idToken: credential.identityToken,
                              accessToken: credential.authorizationCode,
                            );
                            await FirebaseAuth.instance
                                .signInWithCredential(authCredential);
                            print(credential.state);
                            // final user = FirebaseAuth.instance.currentUser;
                            // if (user != null) {
                            //   await _loginController.logInRegisterUser(
                            //       "APPLE",
                            //       user.email!,
                            //       _loginController.mobile.value,
                            //       "",
                            //       _loginController.accessToken.value,
                            //       "",
                            //       _loginController.idToken.value);
                            //   Navigator.pushNamed(
                            //       context, RouteName.enterMobileGoogle);
                            // }
                          },
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: kLightGrey,
                            child: SvgPicture.asset(ImagePath.appleIcon),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    width: 12 * SizeConfig.heightMultiplier!,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await _loginController.googleLogin();
                      final user = FirebaseAuth.instance.currentUser;

                      if (user != null) {
                        user.getIdToken().then((value) {
                          print(value);
                          _loginController.idToken.value = value;
                        });
                        print(user.getIdTokenResult());
                        await LogInService.thirdPartyLogin(
                            'Google', _loginController.idToken.value);
                        // await _loginController.logInRegisterUser(
                        //     "GOOGLE",
                        //     user.email!,
                        //     _loginController.mobile.value,
                        //     "",
                        //     _loginController.accessToken.value,
                        //     "",
                        //     _loginController.idToken.value);
                        await Navigator.pushNamed(
                            context, RouteName.enterMobileGoogle);
                      }
                    },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: kLightGrey,
                      child: SvgPicture.asset(ImagePath.googleICon),
                    ),
                  )
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
