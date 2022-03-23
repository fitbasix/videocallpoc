import 'dart:developer';

import 'package:fitbasix/feature/posts/services/createPost_Services.dart';
import 'package:fitbasix/feature/profile/controller/profile_controller.dart';
import 'package:fitbasix/feature/profile/services/profile_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_palette.dart';
import '../../../core/constants/image_path.dart';
import '../../../core/reponsive/SizeConfig.dart';
import '../../Home/controller/Home_Controller.dart';

class NumberChangeOtpVerify extends StatelessWidget {
  final ProfileController profileController = Get.find();
  final HomeController homeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              ImagePath.backIcon,
              color: Theme.of(context).primaryColor,
              width: 7 * SizeConfig.widthMultiplier!,
              height: 12 * SizeConfig.heightMultiplier!,
            )),
        title: Transform(
          transform: Matrix4.translationValues(-20, 0, 0),
          child: Text(
            'enter_otp_header'.tr,
            style: AppTextStyle.titleText.copyWith(
                color: Theme.of(context).appBarTheme.titleTextStyle?.color,
                fontSize: 16 * SizeConfig.textMultiplier!),
          ),
        ),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 16 * SizeConfig.widthMultiplier!,
              vertical: 8 * SizeConfig.heightMultiplier!),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'enter_Otp'.tr,
                style: AppTextStyle.NormalText.copyWith(
                    color: Theme.of(context).appBarTheme.titleTextStyle?.color,
                    fontSize: 14 * SizeConfig.textMultiplier!),
              ),
              SizedBox(
                height: 16 * SizeConfig.textMultiplier!,
              ),
              PinCodeTextField(
                appContext: context,
                length: 6,
                onChanged: (value) {
                  profileController.otp.value = value;
                  // _loginController.otp.value = value;
                },
                enableActiveFill: true,
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8),
                  fieldHeight: 48 * SizeConfig.widthMultiplier!,
                  fieldWidth: 48 * SizeConfig.widthMultiplier!,
                  selectedColor: Colors.transparent,
                  activeFillColor: kDarkGreyish,
                  inactiveColor: Colors.transparent,
                  activeColor: Colors.transparent,
                  inactiveFillColor: kDarkGreyish,
                  selectedFillColor: kDarkGreyish,
                ),
              ),
              Container(
                  margin:
                      EdgeInsets.only(top: 32 * SizeConfig.heightMultiplier!),
                  width: double.infinity,
                  height: 48 * SizeConfig.heightMultiplier!,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor:
                              MaterialStateProperty.all(kGreenColor),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8 * SizeConfig.widthMultiplier!)))),
                      onPressed: () async {
                        if (profileController.otp.value.length == 6) {
                          String? updatedEmailId =
                              profileController.emailController.text ==
                                      homeController.userProfileData.value
                                          .response!.data!.profile!.email
                                  ? null
                                  : profileController.emailController.text;
                          String? updatedPhnNumber = profileController
                                      .loginController!.mobile.value ==
                                  homeController.userProfileData.value.response!
                                      .data!.profile!.mobileNumber
                              ? null
                              : profileController.loginController!.mobile.value;
                          String updatedCountryCode = profileController
                              .loginController!.selectedCountry.value.code!;

                          String? updatedDob =
                              profileController.DOBController.text ==
                                      homeController.userProfileData.value
                                          .response!.data!.profile!.dob
                                  ? null
                                  : profileController.DOBController.text;
                          log("status");
                          bool numberNotRegistered =
                              await ProfileServices.editProfile(
                                  countryCode: updatedCountryCode,
                                  phone: updatedPhnNumber,
                                  dob: updatedDob == "" ? null : updatedDob,
                                  otp: profileController.otp.value,
                                  context: context);
                          log("status" + numberNotRegistered.toString());
                          if (numberNotRegistered == false) {
                            log(homeController.userProfileData.value.response!
                                .data!.profile!.mobileNumber!);
                            // Navigator.pop(context);
                            // homeController.userProfileData.value =
                            //     await CreatePostService.getUserProfile();
                            // profileController.selectedDate.value =
                            //     homeController.userProfileData.value.response!
                            //                 .data!.profile!.dob ==
                            //             null
                            //         ? DateTime.now().toString()
                            //         : DateFormat("dd/LL/yyyy").format(
                            //             homeController.userProfileData.value
                            //                 .response!.data!.profile!.dob!);
                          } else {
                            Navigator.pop(context);
                            homeController.userProfileData.value =
                                await CreatePostService.getUserProfile();
                          }
                        }
                      },
                      child: Text(
                        "confirm".tr,
                        style: AppTextStyle.boldWhiteText,
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
