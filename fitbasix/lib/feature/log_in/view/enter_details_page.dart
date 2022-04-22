import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/back_button.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button_with_arrow.dart';
import 'package:fitbasix/core/universal_widgets/text_Field.dart';
import 'package:fitbasix/feature/log_in/controller/login_controller.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class EnterDetailsPage extends StatelessWidget {
  final LoginController _loginController = Get.put(LoginController());
  RxBool _isTermAndConditionAgreed = false.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          child: Stack(
        children: [
          Container(
            height: double.infinity,
          ),
          Image.asset(
            ImagePath.detail_intro_image,
            height: 400 * SizeConfig.heightMultiplier!,
            width: double.infinity,

            fit: BoxFit.fill,
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
          //backbutton
          Positioned(
              top: 16.12,
              left: 18.67,
              child: CustomBackButton(
                color: kPureWhite,
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: kPureBlack,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16 * SizeConfig.widthMultiplier!),
                    topLeft: Radius.circular(16 * SizeConfig.widthMultiplier!),
                  )),
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
                    style: AppTextStyle.titleText.copyWith(color: kPureWhite),
                  ),
                  SizedBox(
                    height: 8 * SizeConfig.heightMultiplier!,
                  ),
                  Text(
                    'fillDetailsHeader'.tr,
                    style: AppTextStyle.normalBlackText.copyWith(
                      color: kPureWhite,
                      fontSize: (12) * SizeConfig.textMultiplier!,
                    ),
                  ),
                  SizedBox(
                    height: 16 * SizeConfig.heightMultiplier!,
                  ),
                  CutomizedTextField(
                    wantWhiteBG: true,
                    color: Colors.transparent,
                    child: TextFieldContainer(
                      onChanged: (value) {
                        _loginController.name.value = value;
                      },
                      textEditingController: _loginController.nameController,
                      isNumber: false,
                      preFixWidget: SvgPicture.asset(
                        ImagePath.profileIcon,
                        color: kPureWhite,
                      ),
                      hint: 'enterNameHint'.tr,
                    ),
                  ),
                  SizedBox(
                    height: 16 * SizeConfig.heightMultiplier!,
                  ),
                  CutomizedTextField(
                    wantWhiteBG: true,
                    color: Colors.transparent,
                    child: TextFieldContainer(
                        onChanged: (value) {
                          _loginController.email.value = value;
                        },
                        textEditingController: _loginController.emailController,
                        isNumber: false,
                        preFixWidget: SvgPicture.asset(
                          ImagePath.mailIcon,
                          color: kPureWhite,
                        ),
                        hint: 'enterEmailHint'.tr),
                  ),
                  // SizedBox(
                  //   height: 16 * SizeConfig.heightMultiplier!,
                  // ),
                  Obx(()=>Row(
                    children: [
                      Checkbox(
                        side: BorderSide(color: _isTermAndConditionAgreed.value?kgreen4F:kPureWhite),
                          activeColor:kgreen4F,
                          value: _isTermAndConditionAgreed.value, onChanged: (value){
                        _isTermAndConditionAgreed.value = value!;
                      }),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Accept ',
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
                                recognizer: new TapGestureRecognizer()..onTap = () => launch('https://fitbasix.net/terms'),
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
                                recognizer: new TapGestureRecognizer()..onTap = () => launch('https://fitbasix.net/privacy_fitbasix'),
                              ),
                            ]
                        ),
                      ),
                    ],
                  )),
                  Obx(
                    () => _loginController.isLoading.value
                        ? Center(
                            child: CustomizedCircularProgress(),
                          )
                        : ProceedButtonWithArrow(
                            title: 'proceed'.tr,
                            onPressed: () async {

                              if(_isTermAndConditionAgreed.value){
                                if ((_loginController.name.value != '' &&
                                    _loginController.email.value != '')&&(RegExp(r"^[a-zA-Z\s]*$").hasMatch(_loginController.name.value))) {
                                  _loginController.isLoading.value = true;
                                  var screenId = await LogInService.registerUser(
                                      _loginController.name.value,
                                      _loginController.email.value);

                                  if (!_loginController.email.value
                                      .contains('@')) {
                                    _loginController.isLoading.value = false;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Please enter an valid email')));
                                  } else if (screenId == 1) {
                                    _loginController.isLoading.value = false;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                            Text('Email already exists')));
                                  } else if (screenId == 16) {
                                    _loginController.isLoading.value = false;
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        RouteName.homePage, (route) => false);
                                  } else
                                    return;
                                } else {
                                  if(_loginController.name.value.isNotEmpty){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Please enter a valid name')));
                                  }
                                  if (_loginController.name.value == '' &&
                                      _loginController.email.value == '') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Please enter a name and an email')));
                                  } else if (_loginController.name.value == '') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                            Text('Please enter a name')));
                                  } else if (_loginController.email.value == '') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                            Text('Please enter an email')));
                                  }
                                }
                              }
                              else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Please Accept terms and conditions and privacy policy')));
                              }
                             },
                          ),
                  ),
                  SizedBox(
                    height: 16 * SizeConfig.heightMultiplier!,
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
