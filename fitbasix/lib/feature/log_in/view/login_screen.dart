import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitbasix/core/routes/api_routes.dart';
import 'package:fitbasix/feature/log_in/view/otp_screen.dart';
import 'package:fitbasix/feature/log_in/view/widgets/black_textfield.dart';
import 'package:fitbasix/feature/log_in/view/widgets/custom_dropdown.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:url_launcher/url_launcher.dart';

import '../../../core/api_service/remote_config_service.dart';
import '../model/countries_model.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  GlobalKey? _key;
  bool isMenuOpen = false;
  Offset? buttonPosition;
  Size? buttonSize;
  OverlayEntry? _overlayEntry;
  LayerLink layerLink = LayerLink();
  // SimpleAccountMenu(
  // onChange: (value) {
  // _loginController.selectedCountry.value =
  // value;
  // print(_loginController
  //     .selectedCountry.value.code);
  // },
  // hint: ,
  // borderRadius: BorderRadius.circular(8),
  // ),
  List<CountryData>? listofItems;
  final BorderRadius _borderRadius = BorderRadius.circular(8);
  final Color backgroundColor = const Color(0xFFF67C0B9);
  CountryData? hint;
  AnimationController? _animationController;
  final LoginController _loginController = Get.put(LoginController());
  final user = FirebaseAuth.instance.currentUser;

  String title = RemoteConfigService.remoteConfig.getString('welcome');

  void initRemoteConfigService() async {
    await RemoteConfigService.onForceFetched(RemoteConfigService.remoteConfig);
  }

  var selectCountryWidget;
  @override
  void initState() {
    listofItems = _loginController.countryList;
    hint = _loginController.selectedCountry.value;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _key = LabeledGlobalKey("button_icon");
    initRemoteConfigService();
    super.initState();
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: buttonPosition!.dy + 10,
          left: buttonPosition!.dx + 12,
          width: buttonSize!.width,
          child: CompositedTransformFollower(
            link: layerLink,
            child: Material(
              color: Colors.transparent,
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 45),
                      child: ClipPath(
                        clipper: ArrowClipper(),
                        child: Container(
                          width: 17,
                          height: 17,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Container(
                      width: 82 * SizeConfig.widthMultiplier!,
                      height: 66 * SizeConfig.heightMultiplier!,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: _borderRadius,
                      ),
                      child: Theme(
                        data: ThemeData(
                          iconTheme: const IconThemeData(
                            color: Colors.white,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(listofItems!.length, (index) {
                            return GestureDetector(
                                onTap: () {
                                  _loginController.selectedCountry.value =
                                      listofItems![index];
                                  closeMenu();
                                },
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            16 * SizeConfig.widthMultiplier!,
                                        vertical:
                                            8 * SizeConfig.heightMultiplier!),
                                    child: SvgPicture.network(
                                      listofItems![index].flag!,
                                      width:
                                          24 * SizeConfig.imageSizeMultiplier!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ));
                          }),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  findButton() {
    RenderBox renderBox = _key!.currentContext!.findRenderObject() as RenderBox;
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

  void closeMenu() {
    _overlayEntry!.remove();
    _animationController!.reverse();
    isMenuOpen = !isMenuOpen;
  }

  void openMenu() {
    findButton();
    // _animationController!.forward();
    _overlayEntry = _overlayEntryBuilder();
    Overlay.of(context)!.insert(_overlayEntry!);
    isMenuOpen = !isMenuOpen;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(Get.isOverlaysOpen);
      },
      child: Scaffold(
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
              Obx(() => !_loginController.isGoogleSignInLoading.value
                  ? Padding(
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
                                    print(
                                        _loginController.mobile.value + " iii");
                                  },
                                  maxLength: 10,
                                  isTextFieldActive: true,
                                  preFixWidget: Container(
                                    width: 90 * SizeConfig.widthMultiplier!,
                                    child: Row(
                                      children: [
                                        Container(
                                            key: _key,
                                            decoration: BoxDecoration(
                                              // color: const Color(0xfff5c6373),
                                              borderRadius: _borderRadius,
                                            ),
                                            child: Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    FocusScopeNode
                                                        currentFocus =
                                                        FocusScope.of(context);
                                                    if (isMenuOpen) {
                                                      closeMenu();
                                                    } else {
                                                      openMenu();
                                                    }
                                                  },
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            left: 14 *
                                                                SizeConfig
                                                                    .widthMultiplier!,
                                                            right: 14 *
                                                                SizeConfig
                                                                    .widthMultiplier!),
                                                        child:
                                                            SvgPicture.network(
                                                          _loginController
                                                                      .selectedCountry
                                                                      .value
                                                                      .flag ==
                                                                  null
                                                              ? 'https://upload.wikimedia.org/wikipedia/en/4/41/Flag_of_India.svg'
                                                              : _loginController
                                                                  .selectedCountry
                                                                  .value
                                                                  .flag!,
                                                          width: 24.w,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      CompositedTransformTarget(
                                                          link: layerLink,
                                                          child: Container())
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    if (isMenuOpen) {
                                                      closeMenu();
                                                    } else {
                                                      openMenu();
                                                    }
                                                  },
                                                  child: const Icon(
                                                    Icons.keyboard_arrow_down,
                                                    color: greyB7,
                                                  ),
                                                )
                                              ],
                                            )),
                                        // CountryDropDown(
                                        //   hint: _loginController.selectedCountry.value,
                                        //   listofItems: _loginController.countryList,
                                        //   onChanged: (value) {
                                        //     _loginController.selectedCountry.value =
                                        //         value;
                                        //     print(_loginController
                                        //         .selectedCountry.value.code);
                                        //   },
                                        // ),
                                        SizedBox(
                                          width:
                                              16 * SizeConfig.widthMultiplier!,
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
                                    if (isMenuOpen) {
                                      closeMenu();
                                    }
                                    FocusScope.of(context).unfocus();
                                    if (_loginController.mobile.value.length ==
                                            10 &&
                                        RegExp(r"^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$")
                                            .hasMatch(_loginController
                                                .mobile.value)) {
                                      print(_loginController.mobile.value +
                                          " kkk");
                                      _loginController.isLoading.value = true;
                                      await _loginController.getOTP();
                                      _loginController.isLoading.value = false;
                                      var number = _loginController
                                          .mobileController.text;
                                      Get.put(LoginController());
                                      Get.to(() => OtpScreen(
                                            mobile: number,
                                          ));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Please enter valid mobile number')));
                                    }
                                  })),
                          SizedBox(
                            height: 8 * SizeConfig.heightMultiplier!,
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: [
                              TextSpan(
                                text: 'By signing up you agree our ',
                                style: AppTextStyle.NormalText.copyWith(
                                    fontSize: 12 * SizeConfig.textMultiplier!,
                                    color: lightGrey),
                              ),
                              TextSpan(
                                text: 'terms & conditions ',
                                style: AppTextStyle.NormalText.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12 * SizeConfig.textMultiplier!,
                                    color: lightGrey),
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () =>
                                      launch(ApiUrl.liveBaseURL + '/terms'),
                              ),
                              TextSpan(
                                text: 'and ',
                                style: AppTextStyle.NormalText.copyWith(
                                    fontSize: 12 * SizeConfig.textMultiplier!,
                                    color: lightGrey),
                              ),
                              TextSpan(
                                text: 'privacy policy',
                                style: AppTextStyle.NormalText.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12 * SizeConfig.textMultiplier!,
                                    color: lightGrey),
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () => launch(
                                      ApiUrl.liveBaseURL + '/privacy_fitbasix'),
                              ),
                            ]),
                          ),
                          SizedBox(
                            height: 32 * SizeConfig.heightMultiplier!,
                          ),
                          Platform.isIOS
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        _loginController
                                            .isGoogleSignInLoading.value = true;
                                        await _loginController.googleLogin();
                                        final user =
                                            FirebaseAuth.instance.currentUser;
                                        if (user != null) {
                                          user.getIdToken().then((value) {
                                            _loginController.idToken.value =
                                                value;
                                          });

                                          _loginController
                                                  .thirdPartyLogin.value =
                                              await LogInService
                                                  .thirdPartyLogin(
                                                      'Google',
                                                      _loginController
                                                          .idToken.value);

                                          // log(_loginController.thirdPartyLogin.value.code
                                          //     .toString());

                                          if (_loginController
                                                  .thirdPartyLogin
                                                  .value
                                                  .response!
                                                  .user!
                                                  .token !=
                                              null) {
                                            final SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setString(
                                                'AccessToken',
                                                _loginController
                                                    .thirdPartyLogin
                                                    .value
                                                    .response!
                                                    .user!
                                                    .token!);
                                            prefs.setString(
                                                'RefreshToken',
                                                _loginController
                                                    .thirdPartyLogin
                                                    .value
                                                    .response!
                                                    .refreshToken!);
                                          }

                                          if (_loginController.thirdPartyLogin
                                                  .value.response!.screenId ==
                                              15) {
                                            _loginController
                                                .isGoogleSignInLoading
                                                .value = false;
                                            Navigator.pushNamed(context,
                                                RouteName.enterMobileGoogle);
                                          } else if (_loginController
                                                  .thirdPartyLogin
                                                  .value
                                                  .response!
                                                  .screenId ==
                                              16) {
                                            _loginController
                                                .isGoogleSignInLoading
                                                .value = false;
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                RouteName.homePage,
                                                (route) => false);
                                          }
                                        } else {
                                          _loginController.isGoogleSignInLoading
                                              .value = false;
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width:
                                            156 * SizeConfig.widthMultiplier!,
                                        height:
                                            48 * SizeConfig.heightMultiplier!,

                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border:
                                                Border.all(color: greyBorder)),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SvgPicture.asset(
                                              ImagePath.googleICon,
                                              height: 20 *
                                                  SizeConfig.heightMultiplier!,
                                            ),
                                            SizedBox(
                                              width: 15 *
                                                  SizeConfig.widthMultiplier!,
                                            ),
                                            Text(
                                              'Sign In',
                                              style: AppTextStyle.boldWhiteText
                                                  .copyWith(
                                                      fontSize: 14 *
                                                          SizeConfig
                                                              .textMultiplier!),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        final credential = await SignInWithApple
                                            .getAppleIDCredential(
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
                                          accessToken:
                                              credential.authorizationCode,
                                        );
                                        await FirebaseAuth.instance
                                            .signInWithCredential(
                                                authCredential);
                                        _loginController.thirdPartyLogin.value =
                                            await LogInService.thirdPartyAppleLogin(
                                                "Apple",
                                                credential.familyName == null
                                                    ? ""
                                                    : "${credential.givenName} " +
                                                        credential.familyName!,
                                                credential.identityToken!);
                                        print(credential.identityToken!);
                                        if (_loginController.thirdPartyLogin
                                                .value.response!.user!.token !=
                                            null) {
                                          final SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          prefs.setString(
                                              'AccessToken',
                                              _loginController
                                                  .thirdPartyLogin
                                                  .value
                                                  .response!
                                                  .user!
                                                  .token!);

                                          prefs.setString(
                                              'RefreshToken',
                                              _loginController
                                                  .thirdPartyLogin
                                                  .value
                                                  .response!
                                                  .refreshToken!);
                                        }
                                        if (_loginController.thirdPartyLogin
                                                .value.response!.screenId! ==
                                            15) {
                                          Navigator.pushNamed(context,
                                              RouteName.enterMobileGoogle);
                                        } else {
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              RouteName.homePage,
                                              (route) => false);
                                          ;
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width:
                                            156 * SizeConfig.widthMultiplier!,
                                        height:
                                            48 * SizeConfig.heightMultiplier!,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border:
                                                Border.all(color: greyBorder)),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SvgPicture.asset(
                                              ImagePath.appleIcon,
                                              color: kPureWhite,
                                              height: 20 *
                                                  SizeConfig.heightMultiplier!,
                                            ),
                                            SizedBox(
                                              width: 15 *
                                                  SizeConfig.widthMultiplier!,
                                            ),
                                            Text(
                                              'Sign In',
                                              style: AppTextStyle.boldWhiteText
                                                  .copyWith(
                                                fontSize: 14 *
                                                    SizeConfig.textMultiplier!,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : GestureDetector(
                                  onTap: () async {
                                    _loginController
                                        .isGoogleSignInLoading.value = true;
                                    await _loginController.googleLogin();
                                    final user =
                                        FirebaseAuth.instance.currentUser;
                                    if (user != null) {
                                      user.getIdToken().then((value) {
                                        _loginController.idToken.value = value;
                                      });

                                      _loginController.thirdPartyLogin.value =
                                          await LogInService.thirdPartyLogin(
                                              'Google',
                                              _loginController.idToken.value);

                                      if (_loginController.thirdPartyLogin.value
                                              .response!.user!.token !=
                                          null) {
                                        final SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        prefs.setString(
                                            'AccessToken',
                                            _loginController.thirdPartyLogin
                                                .value.response!.user!.token!);
                                        prefs.setString(
                                            'RefreshToken',
                                            _loginController.thirdPartyLogin
                                                .value.response!.refreshToken!);
                                      }

                                      if (_loginController.thirdPartyLogin.value
                                              .response!.screenId ==
                                          15) {
                                        _loginController.isGoogleSignInLoading
                                            .value = false;
                                        Navigator.pushNamed(context,
                                            RouteName.enterMobileGoogle);
                                      } else if (_loginController
                                              .thirdPartyLogin
                                              .value
                                              .response!
                                              .screenId ==
                                          16) {
                                        _loginController.isGoogleSignInLoading
                                            .value = false;
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            RouteName.homePage,
                                            (route) => false);
                                      }
                                    } else {
                                      _loginController
                                          .isGoogleSignInLoading.value = false;
                                    }
                                  },
                                  child: Container(
                                    width: Get.width,
                                    height: 48 * SizeConfig.heightMultiplier!,
                                    padding:
                                        EdgeInsets.only(left: 18, right: 54),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: greyBorder)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          ImagePath.googleICon,
                                          height:
                                              20 * SizeConfig.heightMultiplier!,
                                        ),
                                        SizedBox(
                                          width:
                                              20 * SizeConfig.widthMultiplier!,
                                        ),
                                        Text(
                                          'Sign In',
                                          style: AppTextStyle.boldWhiteText
                                              .copyWith(
                                                  fontSize: 14 *
                                                      SizeConfig
                                                          .textMultiplier!),
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
                    )
                  : Center(child: CustomizedCircularProgress())),
            ],
          ),
        ),
      ),
    );
  }
}
