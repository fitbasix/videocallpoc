import 'package:fitbasix/core/constants/app_text_style.dart';
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

class ResetPassword extends StatelessWidget {
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
                'reset_password'.tr,
                style: AppTextStyle.titleText,
              ),
              Obx(
                () => CutomizedTextField(
                  color: Colors.transparent,
                  child: TextFieldContainer(
                      onChanged: (value) {},
                      textEditingController:
                          _loginController.resetPasswordController,
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
                        _loginController.resetConfirmPasswordController,
                    isNumber: false,
                    preFixWidget: SvgPicture.asset(ImagePath.lockIcon),
                    hint: 're_enter_password'.tr),
              ),
              Spacer(),
              ProceedButtonWithArrow(
                title: 'proceed'.tr,
                onPressed: () {
                  Navigator.pushNamed(context, RouteName.homePage);
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
