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

import '../../../core/universal_widgets/text_Field.dart';
import '../../log_in/controller/login_controller.dart';
import '../../log_in/view/widgets/country_dropdown.dart';
import '../../spg/controller/spg_controller.dart';

class EditPersonalInfoScreen extends StatelessWidget {
  final LoginController _mobileNoController = Get.put(LoginController());
  final ProfileController _profileController = Get.put(ProfileController());
  final SPGController _spgController = Get.put(SPGController());

  EditPersonalInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _profileController.mobileNoController = _mobileNoController;
    return Scaffold(
      backgroundColor: kPureWhite,
      appBar: AppBarForAccount(
        title: "Personal Information",
        parentContext: context,
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
              style: AppTextStyle.normalPureBlackTextWithWeight600,
            ),
            SizedBox(height: 11 * SizeConfig.heightMultiplier!),
            //text field for user email
            TextFormField(
              onChanged: (value) {
                //storing user input in email controller
                _profileController.emailController.text = value;
              },
              style: AppTextStyle.normalBlackText,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(
                    12 * SizeConfig.widthMultiplier!,
                    14 * SizeConfig.heightMultiplier!,
                    0,
                    14 * SizeConfig.heightMultiplier!),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(8 * SizeConfig.widthMultiplier!),
                  borderSide: BorderSide(color: kLightGrey, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(8 * SizeConfig.widthMultiplier!),
                  borderSide: BorderSide(color: kLightGrey, width: 1.5),
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
                  borderSide: BorderSide(color: kLightGrey, width: 1.0),
                ),
              ),
            ),
            SizedBox(
              height: 16 * SizeConfig.heightMultiplier!,
            ),
            //user phone no field
            Text(
              "mobile_no".tr,
              style: AppTextStyle.normalPureBlackTextWithWeight600,
            ),
            SizedBox(height: 11 * SizeConfig.heightMultiplier!),
            //text field Phone no
            Obx(
              () => CutomizedTextField(
                wantWhiteBG: true,
                color: kLightGrey,
                child: TextFieldContainer(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                    onChanged: (value) {
                      _mobileNoController.mobile.value = value;
                    },
                    isTextFieldActive: true,
                    preFixWidget: Container(
                      width: 80,
                      child: Row(
                        children: [
                          CountryDropDown(
                            hint: _mobileNoController.selectedCountry.value,
                            listofItems: _mobileNoController.countryList,
                            onChanged: (value) {
                              _mobileNoController.selectedCountry.value = value;
                              print(_mobileNoController
                                  .selectedCountry.value.code);
                            },
                          ),
                          const Text(
                            '|',
                            style: TextStyle(fontSize: 24, color: kGreyColor),
                          ),
                        ],
                      ),
                    ),
                    textEditingController: _mobileNoController.mobileController,
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
              style: AppTextStyle.normalPureBlackTextWithWeight600,
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
                    style: AppTextStyle.normalBlackText,
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
                        borderSide: BorderSide(color: kLightGrey, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            8 * SizeConfig.widthMultiplier!),
                        borderSide: BorderSide(color: kLightGrey, width: 1.5),
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
                        borderSide: BorderSide(color: kLightGrey, width: 1.0),
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
                        context: context, builder: (context) => dobPicker());
                  },
                  child: SvgPicture.asset(
                    ImagePath.calanderIcon,
                    color: kPureBlack,
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
                        backgroundColor: MaterialStateProperty.all(kGreenColor),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8 * SizeConfig.widthMultiplier!)))),
                    onPressed: () {
                      //change user personal data on cloud

                      _profileController.emailController.text.length != 0 &&
                              _mobileNoController.mobile.value.length != 0 &&
                              _profileController.DOBController.text.length != 0
                          ? ProfileServices.editProfile(
                              email: _profileController.emailController.text,
                              countryCode: _mobileNoController
                                  .selectedCountry.value.code,
                              phone: _mobileNoController.mobile.value,
                              dob: _profileController.DOBController.text)
                          : _profileController.emailController.text.length ==
                                      0 &&
                                  _mobileNoController.mobile.value.length !=
                                      0 &&
                                  _profileController
                                          .DOBController.text.length !=
                                      0
                              ? ProfileServices.editProfile(
                                  email: null,
                                  countryCode: _mobileNoController
                                      .selectedCountry.value.code,
                                  phone: _mobileNoController.mobile.value,
                                  dob: _profileController.DOBController.text)
                              : null;

                      // _profileController.emailController.text.length == 0
                      //     ? ProfileServices.editProfile(
                      //         email: null,
                      //         countryCode: _mobileNoController
                      //             .selectedCountry.value.code,
                      //         phone: _mobileNoController.mobile.value,
                      //         dob: _profileController.DOBController.text)
                      //     : ProfileServices.editProfile(
                      //         email: _profileController.emailController.text,
                      //         countryCode: _mobileNoController
                      //             .selectedCountry.value.code,
                      //         phone: _mobileNoController.mobile.value,
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
