import 'package:fitbasix/feature/profile/controller/profile_controller.dart';
import 'package:fitbasix/feature/profile/services/profile_services.dart';
import 'package:fitbasix/feature/profile/view/appbar_for_account.dart';
import 'package:fitbasix/feature/profile/view/dob_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_palette.dart';
import '../../../core/constants/image_path.dart';
import '../../../core/reponsive/SizeConfig.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/universal_widgets/text_Field.dart';
import '../../Home/controller/Home_Controller.dart';
import '../../Home/view/Home_page.dart';
import '../../log_in/view/widgets/country_dropdown.dart';
import '../../posts/services/createPost_Services.dart';

class EditPersonalInfoScreen extends StatelessWidget {
  final ProfileController _profileController = Get.put(ProfileController());
  final HomeController homeController = Get.find();
  EditPersonalInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(_profileController.DOBController.text);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarForAccount(
        title: "Personal Information",
        onback: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
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
              "email".tr,
              style: AppTextStyle.normalPureBlackTextWithWeight600.copyWith(
                color: Theme.of(context).textTheme.bodyText1?.color
              ),
            ),
            SizedBox(height: 11 * SizeConfig.heightMultiplier!),
            //text field for user email
            TextFormField(
              controller: _profileController.emailController,
              onChanged: (value) {
                //storing user input in email controller
              },
              style: AppTextStyle.normalBlackText.copyWith(
                color: Theme.of(context).textTheme.bodyText1?.color
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(
                    12 * SizeConfig.widthMultiplier!,
                    14 * SizeConfig.heightMultiplier!,
                    0,
                    14 * SizeConfig.heightMultiplier!),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(8 * SizeConfig.widthMultiplier!),
                  borderSide: BorderSide(color: greyBorder, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(8 * SizeConfig.widthMultiplier!),
                  borderSide: BorderSide(color: greyBorder, width: 1.5),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(8 * SizeConfig.widthMultiplier!),
                  borderSide: BorderSide(
                      color: Colors.red.withOpacity(0.4), width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(8 * SizeConfig.widthMultiplier!),
                  borderSide: BorderSide(color: greyBorder, width: 1.0),
                ),
              ),
            ),
            SizedBox(
              height: 16 * SizeConfig.heightMultiplier!,
            ),
            //user phone no field
            Text(
              "mobile_no".tr,
              style: AppTextStyle.normalPureBlackTextWithWeight600.copyWith(
                  color: Theme.of(context).textTheme.bodyText1?.color
              ),
            ),
            SizedBox(height: 11 * SizeConfig.heightMultiplier!),
            //text field Phone no
            Obx(
              () => CutomizedTextField(
               // wantWhiteBG: true,
                color: greyBorder,
                child: TextFieldContainer(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                    onChanged: (value) {
                      _profileController.loginController!.mobile.value = value;
                    },
                    isTextFieldActive: true,
                    preFixWidget: Container(
                      width: 80,
                      child: Row(
                        children: [
                          CountryDropDown(
                            hint: _profileController
                                .loginController!.selectedCountry.value,
                            listofItems:
                                _profileController.loginController!.countryList,
                            onChanged: (value) {
                              _profileController.loginController!
                                  .selectedCountry.value = value;
                              print(_profileController
                                  .loginController!.selectedCountry.value.code);
                            },
                          ),
                          const Text(
                            '|',
                            style: TextStyle(fontSize: 24, color: greyBorder),
                          ),
                        ],
                      ),
                    ),
                    textEditingController:
                        _profileController.loginController!.mobileController,
                    isNumber: true,
                    hint: 'enter_number_hint'.tr),
              ),
            ),
            //Date of birth field
            SizedBox(
              height: 16 * SizeConfig.heightMultiplier!,
            ),
            Text(
              "date_of_birth".tr,
              style: AppTextStyle.normalPureBlackTextWithWeight600.copyWith(
                  color: Theme.of(context).textTheme.bodyText1?.color
              ),
            ),
            SizedBox(height: 11 * SizeConfig.heightMultiplier!),
            //text field for user email
            Row(
              children: [
                Container(
                  width: 109 * SizeConfig.widthMultiplier!,
                  child: TextFormField(
                    controller: _profileController.DOBController,
                    enabled: false,
                    style: AppTextStyle.normalBlackText.copyWith(
                      color: Theme.of(context).textTheme.bodyText1?.color
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(
                          12 * SizeConfig.widthMultiplier!,
                          14 * SizeConfig.heightMultiplier!,
                          0,
                          14 * SizeConfig.heightMultiplier!),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            8 * SizeConfig.widthMultiplier!),
                        borderSide: BorderSide(color: kLightGrey, width: 1.0),
                      ),
                      disabledBorder: OutlineInputBorder(
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
                ),
                SizedBox(
                  width: 12 * SizeConfig.widthMultiplier!,
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context, builder: (context) => dobPicker(context));
                  },
                  child: SvgPicture.asset(
                    ImagePath.calanderIcon,
                    color: Theme.of(context).primaryColor,
                    height: 22 * SizeConfig.imageSizeMultiplier!,
                  ),
                )
              ],
            ),

            Container(
                margin: EdgeInsets.only(top: 32 * SizeConfig.heightMultiplier!),
                width: double.infinity,
                height: 48 * SizeConfig.heightMultiplier!,
                child: ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor: MaterialStateProperty.all(kgreen4F),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8 * SizeConfig.widthMultiplier!)))),
                    onPressed: () async {
                      //change user personal data on cloud
                      String? updatedEmailId =
                          _profileController.emailController.text ==
                                  homeController.userProfileData.value.response!
                                      .data!.profile!.email
                              ? null
                              : _profileController.emailController.text;
                      String? updatedPhnNumber = _profileController
                                  .loginController!.mobile.value ==
                              homeController.userProfileData.value.response!
                                  .data!.profile!.mobileNumber
                          ? null
                          : _profileController.loginController!.mobile.value;
                      String updatedCountryCode = _profileController
                          .loginController!.selectedCountry.value.code!;

                      String? updatedDob =
                          _profileController.DOBController.text ==
                                  homeController.userProfileData.value.response!
                                      .data!.profile!.dob
                              ? null
                              : _profileController.DOBController.text;
                      print(updatedEmailId);
                      print(updatedPhnNumber);
                      print(updatedCountryCode);
                      print(updatedDob);
                      if (updatedPhnNumber == null) {
                        await ProfileServices.editProfile(
                            email: updatedEmailId,
                            countryCode: updatedCountryCode,
                            phone: updatedPhnNumber,
                            dob: updatedDob == "" ? null : updatedDob);

                        Navigator.pop(context);
                        homeController.userProfileData.value =
                            await CreatePostService.getUserProfile();
                      } else {
                        Navigator.pushNamed(context, RouteName.otpReScreen);
                      }

                      // _profileController.emailController.text.length != 0 &&
                      //         _profileController
                      //                 .loginController!.mobile.value.length !=
                      //             0 &&
                      //         _profileController.DOBController.text.length != 0
                      //     ? ProfileServices.editProfile(
                      //         email: _profileController.emailController.text,
                      //         countryCode: _profileController
                      //             .loginController!.selectedCountry.value.code,
                      //         phone: _profileController
                      //             .loginController!.mobile.value,
                      //         dob: _profileController.DOBController.text)
                      //     : _profileController.emailController.text.length == 0 &&
                      //             _profileController.loginController!.mobile
                      //                     .value.length !=
                      //                 0 &&
                      //             _profileController.DOBController.text.length !=
                      //                 0
                      //         ? ProfileServices.editProfile(
                      //             email: null,
                      //             countryCode: _profileController
                      //                 .loginController!
                      //                 .selectedCountry
                      //                 .value
                      //                 .code,
                      //             phone: _profileController
                      //                 .loginController!.mobile.value,
                      //             dob: _profileController.DOBController.text)
                      //         : null;
                      //
                      // _profileController.emailController.text.length == 0
                      //     ? ProfileServices.editProfile(
                      //         email: null,
                      //         countryCode: _profileController
                      //             .loginController!.selectedCountry.value.code,
                      //         phone: _profileController
                      //             .loginController!.mobile.value,
                      //         dob: _profileController.DOBController.text)
                      //     : ProfileServices.editProfile(
                      //         email: _profileController.emailController.text,
                      //         countryCode: _profileController
                      //             .loginController!.selectedCountry.value.code,
                      //         phone: _profileController
                      //             .loginController!.mobile.value,
                      //         dob: _profileController.DOBController.text);
                    },
                    child: Text(
                      "change details".tr,
                      style: AppTextStyle.boldWhiteText,
                    ))),
          ],
        ),
      ),
    );
  }
}
