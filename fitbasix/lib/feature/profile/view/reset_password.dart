import 'package:fitbasix/feature/profile/controller/profile_controller.dart';
import 'package:fitbasix/feature/profile/view/appbar_for_account.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_palette.dart';
import '../../../core/reponsive/SizeConfig.dart';
import 'package:get/get.dart';
import '../../Home/controller/Home_Controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  final ProfileController _profileController = Get.put(ProfileController());
  final HomeController homeController = Get.find();
  ResetPasswordScreen({Key? key}) : super(key: key);
  var isVisible = false.obs;
  var isnewvisible = false.obs;
  var isconfirmvisible = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        appBar: AppBarForAccount(
          title: "Reset Password",
          onback: () {
            Navigator.pop(context);
          },
        ),
        body: Obx(
          (() => Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16 * SizeConfig.widthMultiplier!,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 28 * SizeConfig.heightMultiplier!,
                    ),
                    Text(
                      "Current Password".tr,
                      style: AppTextStyle.normalPureBlackTextWithWeight600
                          .copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyText1?.color),
                    ),
                    SizedBox(height: 11 * SizeConfig.heightMultiplier!),
                    //text field for user email
                    TextFormField(
                      obscureText: isVisible.value,
                      controller: _profileController.currentPasswordController,
                      onChanged: (value) {
                        //storing user input in email controller
                      },
                      style: AppTextStyle.normalBlackText.copyWith(
                          color: Theme.of(context).textTheme.bodyText1?.color),
                      decoration: InputDecoration(
                        hintText: "Please enter your password".tr,
                        hintStyle: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline1?.color),
                        contentPadding: EdgeInsets.fromLTRB(
                            12 * SizeConfig.widthMultiplier!,
                            14 * SizeConfig.heightMultiplier!,
                            0,
                            14 * SizeConfig.heightMultiplier!),
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            isVisible.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            isVisible.value = !isVisible.value;
                            // Update the state i.e. toogle the state of passwordVisible variable
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8 * SizeConfig.widthMultiplier!),
                          borderSide: BorderSide(color: greyBorder, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8 * SizeConfig.widthMultiplier!),
                          borderSide: BorderSide(color: greyBorder, width: 1.5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8 * SizeConfig.widthMultiplier!),
                          borderSide: BorderSide(
                              color: Colors.red.withOpacity(0.4), width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8 * SizeConfig.widthMultiplier!),
                          borderSide: BorderSide(color: greyBorder, width: 1.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16 * SizeConfig.heightMultiplier!,
                    ),
                    Text(
                      "New Password".tr,
                      style: AppTextStyle.normalPureBlackTextWithWeight600
                          .copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyText1?.color),
                    ),
                    SizedBox(height: 11 * SizeConfig.heightMultiplier!),
                    //text field for user email
                    TextFormField(
                      obscureText: isnewvisible.value,
                      controller: _profileController.newPasswordController,
                      onChanged: (value) {
                        //storing user input in email controller
                      },
                      style: AppTextStyle.normalBlackText.copyWith(
                          color: Theme.of(context).textTheme.bodyText1?.color),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(
                            12 * SizeConfig.widthMultiplier!,
                            14 * SizeConfig.heightMultiplier!,
                            0,
                            14 * SizeConfig.heightMultiplier!),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isnewvisible.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            isnewvisible.value = !isnewvisible.value;
                            // Update the state i.e. toogle the state of passwordVisible variable
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8 * SizeConfig.widthMultiplier!),
                          borderSide: BorderSide(color: greyBorder, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8 * SizeConfig.widthMultiplier!),
                          borderSide: BorderSide(color: greyBorder, width: 1.5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8 * SizeConfig.widthMultiplier!),
                          borderSide: BorderSide(
                              color: Colors.red.withOpacity(0.4), width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8 * SizeConfig.widthMultiplier!),
                          borderSide: BorderSide(color: greyBorder, width: 1.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16 * SizeConfig.heightMultiplier!,
                    ),
                    Text(
                      "Confirm Password".tr,
                      style: AppTextStyle.normalPureBlackTextWithWeight600
                          .copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyText1?.color),
                    ),
                    SizedBox(height: 11 * SizeConfig.heightMultiplier!),
                    //text field for user email
                    TextFormField(
                      obscureText: isconfirmvisible.value,
                      controller: _profileController.confirmPasswordController,
                      onChanged: (value) {
                        //storing user input in email controller
                      },
                      style: AppTextStyle.normalBlackText.copyWith(
                          color: Theme.of(context).textTheme.bodyText1?.color),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(
                            12 * SizeConfig.widthMultiplier!,
                            14 * SizeConfig.heightMultiplier!,
                            0,
                            14 * SizeConfig.heightMultiplier!),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isconfirmvisible.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            isconfirmvisible.value = !isconfirmvisible.value;
                            // Update the state i.e. toogle the state of passwordVisible variable
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8 * SizeConfig.widthMultiplier!),
                          borderSide: BorderSide(color: greyBorder, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8 * SizeConfig.widthMultiplier!),
                          borderSide: BorderSide(color: greyBorder, width: 1.5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8 * SizeConfig.widthMultiplier!),
                          borderSide: BorderSide(
                              color: Colors.red.withOpacity(0.4), width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8 * SizeConfig.widthMultiplier!),
                          borderSide: BorderSide(color: greyBorder, width: 1.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16 * SizeConfig.heightMultiplier!,
                    ),
                    Container(
                        margin: EdgeInsets.only(
                            top: 32 * SizeConfig.heightMultiplier!),
                        width: double.infinity,
                        height: 48 * SizeConfig.heightMultiplier!,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0),
                                backgroundColor:
                                    MaterialStateProperty.all(kgreen4F),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            8 * SizeConfig.widthMultiplier!)))),
                            onPressed: () {},
                            child: Text(
                              "Change password".tr,
                              style: AppTextStyle.boldWhiteText,
                            ))),
                  ],
                ),
              )),
        ));
  }
}
