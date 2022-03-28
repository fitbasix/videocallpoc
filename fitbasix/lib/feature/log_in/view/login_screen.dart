import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitbasix/feature/log_in/view/widgets/black_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button.dart';
import 'package:fitbasix/feature/log_in/controller/login_controller.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';
import 'package:fitbasix/feature/log_in/view/widgets/country_dropdown.dart';

import '../../../core/api_service/remote_config_service.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController _loginController = Get.put(LoginController());

  String title = RemoteConfigService.remoteConfig.getString('welcome');

  void initRemoteConfigService() async {
    await RemoteConfigService.onForceFetched(RemoteConfigService.remoteConfig);
  }

  @override
  void initState() {
    initRemoteConfigService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kPureBlack,
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
            Obx(
                ()=> !_loginController.isGoogleSignInLoading.value?Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacer(),
                    Text(
                      'lets_begin'.tr,
                      style: AppTextStyle.boldWhiteText.copyWith(
                          color: kPureWhite,
                          fontSize: 24 * SizeConfig.textMultiplier!),
                    ),
                    SizedBox(
                      height: 16 * SizeConfig.heightMultiplier!,
                    ),
                    Obx(
                      () => BlackCutomizedTextField(
                        color: Colors.transparent,
                        child: TextFieldContainer(
                            onChanged: (value) {
                              _loginController.mobile.value = value;
                            },
                            maxLength: 10,
                            isTextFieldActive: true,
                            preFixWidget: Container(
                              width: 80,
                              child: Row(
                                children: [
                                  CountryDropDown(
                                    hint: _loginController.selectedCountry.value,
                                    listofItems: _loginController.countryList,
                                    onChanged: (value) {
                                      _loginController.selectedCountry.value =
                                          value;
                                      print(_loginController
                                          .selectedCountry.value.code);
                                    },
                                  ),
                                  const Text(
                                    '|',
                                    style: TextStyle(
                                        fontSize: 24, color: kGreyColor),
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
                              FocusScope.of(context).unfocus();
                              if (_loginController.mobile.value.length == 10) {
                                _loginController.isLoading.value = true;
                                await _loginController.getOTP();
                                _loginController.isLoading.value = false;
                                Navigator.pushNamed(context, RouteName.otpScreen);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Please enter valid mobile number')));
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
                          color: lightGrey),
                    ),
                    SizedBox(
                      height: 32 * SizeConfig.heightMultiplier!,
                    ),
                    Platform.isIOS
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  _loginController.isGoogleSignInLoading.value = true;
                                  await _loginController.googleLogin();
                                  final user = FirebaseAuth.instance.currentUser;
                                  if (user != null) {
                                    user.getIdToken().then((value) {
                                      log(value.toString());
                                      _loginController.idToken.value = value;
                                    });

                                    _loginController.thirdPartyLogin.value =
                                        await LogInService.thirdPartyLogin(
                                            'Google',
                                            _loginController.idToken.value);

                                    // log(_loginController.thirdPartyLogin.value.code
                                    //     .toString());

                                    if (_loginController.thirdPartyLogin.value
                                            .response!.user!.token !=
                                        null) {
                                      final SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setString(
                                          'AccessToken',
                                          _loginController.thirdPartyLogin.value
                                              .response!.user!.token!);
                                      prefs.setString(
                                          'RefreshToken',
                                          _loginController.thirdPartyLogin.value
                                              .response!.refreshToken!);
                                    }

                                    if (_loginController.thirdPartyLogin.value
                                            .response!.screenId ==
                                        15) {
                                      _loginController.isGoogleSignInLoading.value = false;
                                      Navigator.pushNamed(
                                          context, RouteName.enterMobileGoogle);
                                    } else if (_loginController.thirdPartyLogin
                                            .value.response!.screenId ==
                                        16) {
                                      _loginController.isGoogleSignInLoading.value = false;
                                      Navigator.pushNamedAndRemoveUntil(context,
                                          RouteName.homePage, (route) => false);
                                    }
                                  }
                                  else{
                                    _loginController.isGoogleSignInLoading.value = false;
                                  }
                                },
                                child: Container(
                                  width: 156 * SizeConfig.widthMultiplier!,
                                  height: 48 * SizeConfig.heightMultiplier!,
                                  padding: EdgeInsets.only(
                                      left: 18, top: 14, bottom: 14, right: 54),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: greyBorder)),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(ImagePath.googleICon),
                                      SizedBox(
                                        width: 20 * SizeConfig.widthMultiplier!,
                                      ),
                                      Text(
                                        'Sign In',
                                        style: AppTextStyle.boldWhiteText
                                            .copyWith(
                                                fontSize: 14 *
                                                    SizeConfig.textMultiplier!),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final credential =
                                      await SignInWithApple.getAppleIDCredential(
                                    scopes: [
                                      AppleIDAuthorizationScopes.email,
                                      AppleIDAuthorizationScopes.fullName,
                                    ],
                                  );

                                  OAuthProvider oAuthProvider =
                                      new OAuthProvider("apple.com");
                                  final AuthCredential authCredential =
                                      oAuthProvider.credential(
                                    idToken: credential.identityToken,
                                    accessToken: credential.authorizationCode,
                                  );
                                  await FirebaseAuth.instance
                                      .signInWithCredential(authCredential);
                                  _loginController.thirdPartyLogin.value =
                                      await LogInService.thirdPartyAppleLogin(
                                          "Apple",
                                          credential.familyName == null
                                              ? ""
                                              : "${credential.givenName} " +
                                                  credential.familyName!,
                                          credential.identityToken!);
                                  print(credential.identityToken!);
                                  if (_loginController.thirdPartyLogin.value
                                          .response!.user!.token !=
                                      null) {
                                    final SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString(
                                        'AccessToken',
                                        _loginController.thirdPartyLogin.value
                                            .response!.user!.token!);

                                    prefs.setString(
                                        'RefreshToken',
                                        _loginController.thirdPartyLogin.value
                                            .response!.refreshToken!);
                                  }
                                  if (_loginController.thirdPartyLogin.value
                                          .response!.screenId! ==
                                      15) {
                                    Navigator.pushNamed(
                                        context, RouteName.enterMobileGoogle);
                                  } else {
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        RouteName.homePage, (route) => false);
                                    ;
                                  }
                                },
                                child: Container(
                                  width: 156 * SizeConfig.widthMultiplier!,
                                  height: 48 * SizeConfig.heightMultiplier!,
                                  padding: EdgeInsets.only(
                                      left: 18, top: 14, bottom: 14, right: 54),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: greyBorder)),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        ImagePath.appleIcon,
                                        color: kPureWhite,
                                      ),
                                      SizedBox(
                                        width: 20 * SizeConfig.widthMultiplier!,
                                      ),
                                      Text(
                                        'Sign In',
                                        style: AppTextStyle.boldWhiteText
                                            .copyWith(
                                                fontSize: 14 *
                                                    SizeConfig.textMultiplier!),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        : GestureDetector(
                            onTap: () async {
                              _loginController.isGoogleSignInLoading.value = true;
                              await _loginController.googleLogin();
                              final user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                user.getIdToken().then((value) {
                                  log(value.toString());
                                  _loginController.idToken.value = value;
                                });

                                _loginController.thirdPartyLogin.value =
                                    await LogInService.thirdPartyLogin(
                                        'Google', _loginController.idToken.value);

                                // log(_loginController.thirdPartyLogin.value.code
                                //     .toString());

                                if (_loginController.thirdPartyLogin.value
                                        .response!.user!.token !=
                                    null) {
                                  final SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setString(
                                      'AccessToken',
                                      _loginController.thirdPartyLogin.value
                                          .response!.user!.token!);
                                  prefs.setString(
                                      'RefreshToken',
                                      _loginController.thirdPartyLogin.value
                                          .response!.refreshToken!);
                                }

                                if (_loginController.thirdPartyLogin.value.response!.screenId ==
                                    15) {
                                  _loginController.isGoogleSignInLoading.value = false;
                                  Navigator.pushNamed(
                                      context, RouteName.enterMobileGoogle);
                                } else if (_loginController.thirdPartyLogin.value
                                        .response!.screenId ==
                                    16) {
                                  _loginController.isGoogleSignInLoading.value = false;
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      RouteName.homePage, (route) => false);
                                }
                              }
                              else
                              {
                                _loginController.isGoogleSignInLoading.value = false;
                              }
                            },
                            child: Container(
                              width: Get.width,
                              height: 48 * SizeConfig.heightMultiplier!,
                              padding: EdgeInsets.only(
                                  left: 18, top: 14, bottom: 14, right: 54),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: greyBorder)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(ImagePath.googleICon),
                                  SizedBox(
                                    width: 20 * SizeConfig.widthMultiplier!,
                                  ),
                                  Text(
                                    'Sign In',
                                    style: AppTextStyle.boldWhiteText.copyWith(
                                        fontSize:
                                            14 * SizeConfig.textMultiplier!),
                                  )
                                ],
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 32 * SizeConfig.heightMultiplier!,
                    )
                  ],
                ),
              ):Center(child: CustomizedCircularProgress())
            ),

          ],
        ),
      ),
    );
  }
}
