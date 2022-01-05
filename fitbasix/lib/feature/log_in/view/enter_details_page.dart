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
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class EnterDetailsPage extends StatelessWidget {
  final LoginController _loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              CustomBackButton(),
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
              Spacer(),
              Obx(
                () => _loginController.isLoading.value
                    ? Center(
                        child: CustomizedCircularProgress(),
                      )
                    : ProceedButtonWithArrow(
                        title: 'proceed'.tr,
                        onPressed: () async {
                          if (_loginController.name.value != '' &&
                              _loginController.email.value != '') {
                            _loginController.isLoading.value = true;
                            var screenId = await LogInService.registerUser(
                                _loginController.name.value,
                                _loginController.email.value);

                            if (!_loginController.email.value.contains('@')) {
                              _loginController.isLoading.value = false;
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Please enter an valid email')));
                            } else if (screenId == 1) {
                              _loginController.isLoading.value = false;
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Email already exists')));
                            } else if (screenId == 16) {
                              _loginController.isLoading.value = false;
                              Navigator.pushNamedAndRemoveUntil(context,
                                  RouteName.homePage, (route) => false);
                            } else
                              return;
                          } else {
                            if (_loginController.name.value == '' &&
                                _loginController.email.value == '') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Please enter a name and an email')));
                            } else if (_loginController.name.value == '') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Please enter a name')));
                            } else if (_loginController.email.value == '') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Please enter an email')));
                            }
                          }
                        },
                      ),
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
