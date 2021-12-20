import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button_with_arrow.dart';
import 'package:fitbasix/core/universal_widgets/text_Field.dart';
import 'package:fitbasix/feature/log_in/controller/login_controller.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class EnterDetailsPage extends StatelessWidget {
  final LoginController _loginController = Get.put(LoginController());
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
                height: 24 * SizeConfig.heightMultiplier!,
              ),
              Text(
                'fillDetailsHeader'.tr,
                style: AppTextStyle.normalBlackText,
              ),
              SizedBox(
                height: 28 * SizeConfig.heightMultiplier!,
              ),
              CutomizedTextField(
                color: Colors.transparent,
                child: TextFieldContainer(
                    onChanged: (value) {
                      _loginController.name.value = value;
                    },
                    textEditingController: _loginController.nameController,
                    isNumber: false,
                    preFixWidget: SvgPicture.asset(ImagePath.profileIcon),
                    hint: 'enterNameHint'.tr),
              ),
              SizedBox(
                height: 16 * SizeConfig.heightMultiplier!,
              ),
              CutomizedTextField(
                color: Colors.transparent,
                child: TextFieldContainer(
                    onChanged: (value) {
                      _loginController.email.value = value;
                    },
                    textEditingController: _loginController.emailController,
                    isNumber: false,
                    preFixWidget: SvgPicture.asset(ImagePath.mailIcon),
                    hint: 'enterEmailHint'.tr),
              ),
              SizedBox(
                height: 16 * SizeConfig.heightMultiplier!,
              ),
              Obx(
                () => CutomizedTextField(
                  color: Colors.transparent,
                  child: TextFieldContainer(
                      onChanged: (value) {
                        _loginController.password.value = value;
                      },
                      textEditingController:
                          _loginController.passwordController,
                      isNumber: false,
                      isObsecure: _loginController.isHidePassword.value,
                      preFixWidget: SvgPicture.asset(ImagePath.lockIcon),
                      suffixWidget: GestureDetector(
                          onTap: () {
                            _loginController.isHidePassword.value =
                                !_loginController.isHidePassword.value;
                          },
                          child: _loginController.isHidePassword.value
                              ? SvgPicture.asset(ImagePath.visibilityOnIcon)
                              : SvgPicture.asset(ImagePath.visibilityOffIcon)),
                      hint: 'enterPassword'.tr),
                ),
              ),
              Text(
                "Error message",
                style: AppTextStyle.smallGreyText,
              ),
              SizedBox(
                height: 16 * SizeConfig.heightMultiplier!,
              ),
              CutomizedTextField(
                color: Colors.transparent,
                child: TextFieldContainer(
                    onChanged: (value) {},
                    textEditingController:
                        _loginController.reEnterPasswordController,
                    isNumber: false,
                    preFixWidget: SvgPicture.asset(ImagePath.lockIcon),
                    hint: 're_enter_password'.tr),
              ),
              Spacer(),
              ProceedButtonWithArrow(
                title: 'proceed'.tr,
                onPressed: () async {
                  int success = await LogInService.updateDetails(
                      _loginController.password.value,
                      _loginController.email.value,
                      _loginController.name.value);
                  if (success == 1) {
                    Navigator.pushNamed(context, RouteName.homePage);
                  }
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
