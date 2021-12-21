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

  String _selected = '';
  List<Map> _countryList = [
    {'id': '1', 'name': "India", 'image': "assets/images/welcome_image"}
  ];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
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
              Row(
                children: [
                  CountryDropDown(listofItems: _loginController.countryList),
                  Expanded(child: TextField())
                ],
              ),
              Obx(
                () => CutomizedTextField(
                  color: Colors.transparent,
                  child: TextFieldContainer(
                      onChanged: (value) {
                        _loginController.mobile.value = value;
                      },
                      preFixWidget: CountryDropDown(
                          listofItems: _loginController.countryList),
                      textEditingController: _loginController.mobileController,
                      isNumber: false,
                      hint: 'enter_number_hint'.tr),
                ),
              ),
              SizedBox(
                height: 32 * SizeConfig.heightMultiplier!,
              ),
              ProceedButton(
                  title: 'next'.tr,
                  onPressed: () async {
                    //LogInService.getCountries();
                    _loginController.getCountries();
                    // await _loginController.logInRegisterUser("DEFAULT", "",
                    //     _loginController.mobile.value, "+91", "", "", "");
                    // if (_loginController.LogInRegisterResponse.value.resCode ==
                    //     0) {
                    //   Navigator.pushNamed(context, RouteName.enterDetails);
                    // }
                    // if (_loginController.LogInRegisterResponse.value.resCode ==
                    //     1) {
                    //   Navigator.pushNamed(context, RouteName.enterPasswordPage);
                    // }
                    // if (_loginController.LogInRegisterResponse.value.resCode ==
                    //     2) {
                    // Navigator.pushNamed(context, RouteName.otpScreen);
                    // }
                    // if (_loginController.LogInRegisterResponse.value.resCode ==
                    //     3) {
                    //   //google thing
                    //   Navigator.pushNamed(context, RouteName.otpScreen);
                    // }
                    // if (_loginController.LogInRegisterResponse.value.resCode ==
                    //     4) {
                    //   Navigator.pushNamed(context, RouteName.homePage);
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
                  GestureDetector(
                    onTap: () async{
                      final rawNonce = generateNonce();
                       final credential =await SignInWithApple.getAppleIDCredential(
                  scopes: [
                    AppleIDAuthorizationScopes.email,
                    AppleIDAuthorizationScopes.fullName,
                  ],);
                  final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken:credential.identityToken,
          accessToken:credential.authorizationCode,
        );
                   await FirebaseAuth.instance.signInWithCredential(authCredential);
                  print(credential.state);
                  Navigator.pushNamed(context, RouteName.homePage);
                  if(AppleIDAuthorizationScopes.email!=null){
                    Navigator.pushNamed(context, RouteName.homePage);
                  }
                  print(AppleIDAuthorizationScopes.email);
                  print(AppleIDAuthorizationScopes.fullName);
                    },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: kLightGrey,
                      child: SvgPicture.asset(ImagePath.appleIcon),
                    ),
                  ),
                  SizedBox(
                    width: 12 * SizeConfig.heightMultiplier!,
                  ),
                  GestureDetector(
                    onTap: () async {
       await _loginController.googleLogin();
                      Navigator.pushNamed(context, RouteName.enterMobileGoogle);
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
