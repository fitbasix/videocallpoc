import 'package:fitbasix/feature/profile/view/appbar_for_account.dart';
import 'package:fitbasix/feature/profile/view/set_userheight_dialog.dart';
import 'package:fitbasix/feature/profile/view/set_userweight_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_palette.dart';
import '../../../core/constants/image_path.dart';
import '../../../core/reponsive/SizeConfig.dart';
import '../controller/profile_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  int? selectedRadio;

  @override
  void initState() {
    selectedRadio = 0;
    super.initState();
  }

// radio button function
  setSelectedRadio(val) {
    setState(() {
      selectedRadio = val;
    });
  }

  final listofcheckbox = [
    MutipleCheckbox(title: 'Nutrition'),
    MutipleCheckbox(title: 'Nutrition'),
    MutipleCheckbox(title: 'Nutrition'),
    MutipleCheckbox(title: 'Nutrition'),
    MutipleCheckbox(title: 'Nutrition'),
    MutipleCheckbox(title: 'Nutrition'),
  ];

  String userimageurl =
      'http://www.pixelmator.com/community/download/file.php?avatar=17785_1569233053.png';
  @override
  Widget build(BuildContext context) {
    final ProfileController _heightController = Get.put(ProfileController());
    final ProfileController _weightController = Get.put(ProfileController());
    return Scaffold(
        backgroundColor: kPureWhite,
        appBar: AppBarForAccount(
          title: 'edit_profile'.tr,
          onback: () {
            Navigator.pop(context);
          },
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16 * SizeConfig.widthMultiplier!,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 14 * SizeConfig.heightMultiplier!,
                ),
                Text(
                  "profile_picture".tr,
                  style: AppTextStyle.hblackSemiBoldText,
                ),
                SizedBox(
                  height: 8 * SizeConfig.heightMultiplier!,
                ),
                //user circle avatar
                Align(
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        height: 120 * SizeConfig.widthMultiplier!,
                        width: 120 * SizeConfig.widthMultiplier!,
                        child: CircleAvatar(
                          //  radius: 60 * SizeConfig.heightMultiplier!,
                          backgroundImage: NetworkImage(userimageurl),
                        ),
                      ),
                      Positioned(
                          top: 80 * SizeConfig.heightMultiplier!,
                          left: 80 * SizeConfig.widthMultiplier!,
                          child: GestureDetector(
                            onTap: () {
                              // open user profilepic for change
                            },
                            child: Container(
                              height: 40 * SizeConfig.heightMultiplier!,
                              width: 40 * SizeConfig.heightMultiplier!,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: greyB7),
                              child: SvgPicture.asset(
                                ImagePath.penIcon,
                                color: kPureWhite,
                                height: 18,
                                width: 18,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 28 * SizeConfig.heightMultiplier!,
                ),
                //user full name
                Text(
                  "full_name".tr,
                  style: AppTextStyle.hblackSemiBoldText,
                ),
                SizedBox(
                  height: 12 * SizeConfig.heightMultiplier!,
                ),
                //TextFormField for user fullname
                TextFormField(
                  onChanged: (value) {
                    //implement controller for storing user full name
                  },
                  style: AppTextStyle.normalBlackText.copyWith(color: kBlack),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(
                        12 * SizeConfig.widthMultiplier!,
                        14 * SizeConfig.heightMultiplier!,
                        12 * SizeConfig.widthMultiplier!,
                        14 * SizeConfig.heightMultiplier!),
                    border: OutlineInputBorder(
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
                SizedBox(
                  height: 12 * SizeConfig.heightMultiplier!,
                ),
                Text(
                  "bio".tr,
                  style: AppTextStyle.hblackSemiBoldText,
                ),
                SizedBox(
                  height: 12 * SizeConfig.heightMultiplier!,
                ),
                //TextFormField for user bio update
                TextFormField(
                  onChanged: (value) {
                    //implement controller for storing user bio
                  },
                  style: AppTextStyle.normalBlackText.copyWith(color: kBlack),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(
                        12 * SizeConfig.widthMultiplier!,
                        14 * SizeConfig.heightMultiplier!,
                        12 * SizeConfig.widthMultiplier!,
                        14 * SizeConfig.heightMultiplier!),
                    border: OutlineInputBorder(
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
                SizedBox(
                  height: 28 * SizeConfig.heightMultiplier!,
                ),
                // Gender
                Text(
                  "gender".tr,
                  style: AppTextStyle.hblackSemiBoldText,
                ),
                SizedBox(
                  height: 12 * SizeConfig.heightMultiplier!,
                ),
                //radio button
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // male radio button
                    Radio(
                        value: 1,
                        groupValue: selectedRadio,
                        activeColor: kgreen49,
                        onChanged: (val) {
                          setSelectedRadio(val);
                        }),
                    //SizedBox(width: 14 * SizeConfig.widthMultiplier!,),
                    Text(
                      'm'.tr,
                      style: AppTextStyle.boldBlackText.copyWith(color: kBlack),
                    ),
                    SizedBox(
                      width: 20 * SizeConfig.widthMultiplier!,
                    ),
                    //female radio button
                    Radio(
                        value: 2,
                        groupValue: selectedRadio,
                        activeColor: kgreen49,
                        onChanged: (val) {
                          setSelectedRadio(val);
                        }),
                    Text(
                      'f'.tr,
                      style: AppTextStyle.boldBlackText.copyWith(color: kBlack),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16 * SizeConfig.heightMultiplier!,
                ),
                // Weight and Height
                Row(
                  children: [
                    //height
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "height".tr,
                          style: AppTextStyle.hblackSemiBoldText,
                        ),
                        SizedBox(
                          height: 12 * SizeConfig.heightMultiplier!,
                        ),
                        GestureDetector(
                          onTap: () {
                            // implement a dialog box
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    UserHeightDialog());
                          },
                          child: Container(
                            height: 48 * SizeConfig.heightMultiplier!,
                            width: 136 * SizeConfig.widthMultiplier!,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 1 * SizeConfig.widthMultiplier!,
                                    color: kLightGrey)),
                            child: Center(
                              child: Obx(
                                () => _heightController.heightType.value !=
                                        "inch"
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            _heightController
                                                .currentHeight.value
                                                .toString(),
                                            style: AppTextStyle.normalBlackText
                                                .copyWith(color: kBlack),
                                          ),
                                          SizedBox(
                                              width: 4 *
                                                  SizeConfig.widthMultiplier!),
                                          Text("cm",
                                              textAlign: TextAlign.start,
                                              style: AppTextStyle
                                                  .normalBlackText
                                                  .copyWith(
                                                color: greyB7,
                                              ))
                                        ],
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            (_heightController
                                                        .currentHeight.value *
                                                    0.0328084)
                                                .toString()
                                                .split(".")[0],
                                            style: AppTextStyle.normalBlackText
                                                .copyWith(color: kBlack),
                                          ),
                                          SizedBox(
                                              width: 4 *
                                                  SizeConfig.widthMultiplier!),
                                          Text("ft",
                                              textAlign: TextAlign.start,
                                              style: AppTextStyle
                                                  .normalBlackText
                                                  .copyWith(color: greyB7)),
                                          SizedBox(
                                              width: 7 *
                                                  SizeConfig.widthMultiplier!),
                                          Text(
                                            (int.parse((_heightController
                                                                .currentHeight
                                                                .value *
                                                            0.0328084)
                                                        .toString()
                                                        .substring(2, 4)) *
                                                    0.12)
                                                .toString()
                                                .substring(0, 2)
                                                .replaceAll(".", ""),
                                            style: AppTextStyle.normalBlackText
                                                .copyWith(color: kBlack),
                                          ),
                                          SizedBox(
                                              width: 4 *
                                                  SizeConfig.widthMultiplier!),
                                          Text("in",
                                              textAlign: TextAlign.start,
                                              style: AppTextStyle
                                                  .normalBlackText
                                                  .copyWith(color: greyB7))
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 32 * SizeConfig.widthMultiplier!,
                    ),
                    // weight
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "weight".tr,
                          style: AppTextStyle.hblackSemiBoldText,
                        ),
                        SizedBox(
                          height: 12 * SizeConfig.heightMultiplier!,
                        ),
                        GestureDetector(
                          onTap: () {
                            // implement a dialog box
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    UserWeightDialog());
                          },
                          child: Container(
                            height: 48 * SizeConfig.heightMultiplier!,
                            width: 115 * SizeConfig.widthMultiplier!,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 1 * SizeConfig.widthMultiplier!,
                                    color: kLightGrey)),
                            child: Center(
                              child: Obx(
                                () => Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _weightController.currentWeight.value
                                          .toString(),
                                      style: AppTextStyle.normalBlackText
                                          .copyWith(color: kBlack)
                                          .copyWith(
                                            fontSize:
                                                16 * SizeConfig.textMultiplier!,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                        width: 3 * SizeConfig.widthMultiplier!),
                                    Text(
                                        _weightController.weightType.value ==
                                                "kg"
                                            ? 'kg'.tr
                                            : 'lb'.tr,
                                        textAlign: TextAlign.start,
                                        style: AppTextStyle.normalBlackText
                                            .copyWith(color: greyB7))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 16 * SizeConfig.heightMultiplier!,
                ),
                //Interests
                Text(
                  "interests".tr,
                  style: AppTextStyle.hblackSemiBoldText,
                ),
                SizedBox(
                  height: 12 * SizeConfig.heightMultiplier!,
                ),
                ...listofcheckbox.map(buildCheckbox).toList(),
                // save button
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    16 * SizeConfig.widthMultiplier!,
                    16 * SizeConfig.heightMultiplier!,
                    16 * SizeConfig.widthMultiplier!,
                    32 * SizeConfig.heightMultiplier!,
                  ),
                  child: Container(
                      // margin: EdgeInsets.only(top: 16 * SizeConfig.heightMultiplier!),
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
                          onPressed: () {
                            //change user personal data on cloud
                          },
                          child: Text(
                            "save".tr,
                            style: AppTextStyle.hboldWhiteText,
                          ))),
                ),
              ],
            ),
          ),
        ));
  }

  //widget of checkbox
  Widget buildCheckbox(MutipleCheckbox checkbox) => CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: kgreen49,
      title: Text(
        checkbox.title!,
        style: AppTextStyle.hblack400Text.copyWith(color: kBlack),
      ),
      value: checkbox.value,
      onChanged: (value) {
        setState(() {
          checkbox.value = value!;
        });
      });
}

// class  of multiple checkbox
class MutipleCheckbox {
  final String? title;
  bool? value;

  MutipleCheckbox({
    this.value = false,
    this.title,
  });
}

//dialog box of height
