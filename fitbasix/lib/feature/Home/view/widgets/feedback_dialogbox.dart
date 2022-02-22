import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_text_style.dart';
import '../../../../core/constants/color_palette.dart';
import '../../../../core/constants/image_path.dart';
import '../../../../core/reponsive/SizeConfig.dart';

class DialogboxForFeedback extends StatelessWidget {
  const DialogboxForFeedback({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController _homeController = Get.find();
    return Dialog(
      insetPadding: EdgeInsets.only(
        left: 32 * SizeConfig.widthMultiplier!,
        right: 32 * SizeConfig.widthMultiplier!,
      ),
      backgroundColor: kPureWhite,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Container(
        height: 453 * SizeConfig.heightMultiplier!,
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 32 * SizeConfig.heightMultiplier!,
                ),
                SvgPicture.asset(ImagePath.feedbackdialogframe,
                    height: 223 * SizeConfig.heightMultiplier!),
                SizedBox(
                  height: 16 * SizeConfig.heightMultiplier!,
                ),
                Center(
                  child: Text(
                    'Your opinion matters to us!'.tr,
                    style: AppTextStyle.hblack600Text,
                  ),
                ),
                SizedBox(
                  height: 16 * SizeConfig.heightMultiplier!,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 31 * SizeConfig.widthMultiplier!,
                    right: 31 * SizeConfig.widthMultiplier!,
                  ),
                  child: Text(
                      'Rate us on the App Store and send us your feedback ⭐'.tr,
                      style: AppTextStyle.hnormal600BlackText.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center),
                ),
                // SizedBox(
                //   height: 24*SizeConfig.heightMultiplier!,
                // ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    58 * SizeConfig.widthMultiplier!,
                    24 * SizeConfig.heightMultiplier!,
                    58 * SizeConfig.widthMultiplier!,
                    32 * SizeConfig.heightMultiplier!,
                  ),
                  child: Container(
                      width: 180 * SizeConfig.widthMultiplier!,
                      height: 48 * SizeConfig.heightMultiplier!,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor:
                                  MaterialStateProperty.all(kgreen49),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          8 * SizeConfig.widthMultiplier!)))),
                          onPressed: () {
                            //GoTo the AppStore
                          },
                          child: Text(
                            "Go to App Store".tr,
                            style: AppTextStyle.hboldWhiteText,
                          ))),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  _homeController.selectedIndex.value = 0;
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                icon: SvgPicture.asset(
                  ImagePath.closedialogIcon,
                  color: hintGrey,
                  width: 15.55 * SizeConfig.widthMultiplier!,
                  height: 15.55 * SizeConfig.heightMultiplier!,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
