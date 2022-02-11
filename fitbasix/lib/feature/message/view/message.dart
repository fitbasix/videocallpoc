import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/image_path.dart';
import '../../../core/reponsive/SizeConfig.dart';

class MessageTrainerScreen extends StatelessWidget {

  List<String> taggedPersonList = [
    "Sports Nutrition",
    "Hi",
    "Hk",
    "Hx",
    "Hz",
  ];

  var trainerName = 'Jonathan Swift';
  var trainerStatus = 'Hey, please to meet you 👋 You can always text me if you have any questions.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: offWhite,
      appBar: AppBar(
        backgroundColor: kPureWhite,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              ImagePath.backIcon,
              width: 7.41 * SizeConfig.widthMultiplier!,
              height: 12 * SizeConfig.heightMultiplier!,
            )),
        title: Text('my_trainer'.tr,
            style: GoogleFonts.openSans(
              fontSize: 16 * SizeConfig.textMultiplier!,
              fontWeight: FontWeight.w600,
              color: kPureBlack,
            )),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 345 * SizeConfig.heightMultiplier!,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:  EdgeInsets.only(
                                  top: 32 * SizeConfig.heightMultiplier!,
                                  left: 16 * SizeConfig.widthMultiplier!,
                                  bottom: 30 * SizeConfig.heightMultiplier!),
                              child: Text(
                                trainerName,
                                style: GoogleFonts.openSans(
                                  fontSize: (14) * SizeConfig.textMultiplier!,
                                  fontWeight: FontWeight.w600,
                                  color: kBlack,
                                ),
                              ),
                            ),
                            //bottomsheet open profile
                            BottomSheetField(
                              BottomFieldImage: ImagePath.penIcon,
                              BottomFieldText: 'open_profile'.tr,
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RouteName.enrolltrainerscreen);
                              },
                            ),
                            //bottomsheet mute notification
                            BottomSheetField(
                              BottomFieldImage: ImagePath.unmuteIcon,
                              BottomFieldText: 'mute_notification'.tr,
                              onTap: () {},
                            ),
                            // mark as unread
                            BottomSheetField(
                              BottomFieldImage: ImagePath.penIcon,
                              BottomFieldText: 'mark_as_unread'.tr,
                              onTap: () {},
                            ),
                            // cancel enrollment
                            BottomSheetField(
                              BottomFieldImage: ImagePath.cancelEnrollmentIcon,
                              BottomFieldText: 'cancel_enrollment'.tr,
                              onTap: () {},
                            ),
                            // share feedback
                            BottomSheetField(
                              BottomFieldImage: ImagePath.sharefeedbackIcon,
                              BottomFieldText: 'share_feedback'.tr,
                              onTap: () {},
                            ),
                          ],
                        ),
                      );
                    });
              },
              icon: Icon(
                Icons.search,
                color: kPureBlack,
                size: 25 * SizeConfig.heightMultiplier!,
              )),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: kPureWhite,
            child: Column(
              children: [
                SizedBox(
                  height: 24 * SizeConfig.heightMultiplier!,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24 * SizeConfig.widthMultiplier!,
                    ),
                    Container(
                        width: 40 * SizeConfig.widthMultiplier!,
                        height: 40 * SizeConfig.heightMultiplier!,
                        child: InkWell(
                          onTap: null,
                          child: Image.asset(
                            ImagePath.trainerAvatar,
                            width: 40 * SizeConfig.widthMultiplier!,
                            height: 40 * SizeConfig.heightMultiplier!,
                          ),
                        )),
                    SizedBox(
                      width: 12 * SizeConfig.widthMultiplier!,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trainerName,
                          style: GoogleFonts.openSans(
                            fontSize: (14) * SizeConfig.textMultiplier!,
                            fontWeight: FontWeight.w600,
                            color: kPureBlack,
                          ),
                        ),
                        //_taggedBar Widget
                        _taggedBar(list: taggedPersonList)
                      ],
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 16 * SizeConfig.widthMultiplier!),
                      child: Text(
                        '1:29 pm'.tr,
                        style: GoogleFonts.openSans(
                          fontSize: (12) * SizeConfig.textMultiplier!,
                          fontWeight: FontWeight.w400,
                          color: hintGrey,
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  child: Padding(
                    padding:  EdgeInsets.only(
                        left: 16 * SizeConfig.widthMultiplier!,
                        right: 38 * SizeConfig.widthMultiplier!,
                        top: 16 * SizeConfig.heightMultiplier!,
                        bottom: 16 * SizeConfig.heightMultiplier!),
                    child: Text(
                        trainerStatus,
                        style: GoogleFonts.openSans(
                          fontSize: (13) * SizeConfig.textMultiplier!,
                          fontWeight: FontWeight.w600,
                          color: kPureBlack,
                        )),
                  ),
                ),
                Container(
                  child: Padding(
                    padding:  EdgeInsets.only(
                        left: 16 *SizeConfig.widthMultiplier!,
                        bottom: 24 * SizeConfig.heightMultiplier!),
                    child: Row(
                      children: [
                        Text('enrolled_on'.tr,
                            style: GoogleFonts.openSans(
                              fontSize: (12) * SizeConfig.textMultiplier!,
                              fontWeight: FontWeight.w400,
                              color: hintGrey,
                            )),
                        SizedBox(
                          width: 4 * SizeConfig.widthMultiplier!,
                        ),
                        Text('7 Nov 2021'.tr,
                            style: GoogleFonts.openSans(
                              fontSize: (12) * SizeConfig.textMultiplier!,
                              fontWeight: FontWeight.w600,
                              color: kGreenColor,
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            color: offWhite,
          )
        ],
      ),
    );
  }


  Widget _taggedBar({List<String>? list}) {
    return Row(
      children: [
        Container(
          height: 28 * SizeConfig.heightMultiplier!,
          decoration: BoxDecoration(
              color: offWhite,
              borderRadius:
                  BorderRadius.circular(28 * SizeConfig.heightMultiplier!)),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 12 * SizeConfig.widthMultiplier!),
            child: Center(
              child: Text(
                list![0].tr,
                style: AppTextStyle.lightMediumBlackText,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 8 * SizeConfig.widthMultiplier!,
        ),
        Container(
          height: 28 * SizeConfig.heightMultiplier!,
          decoration: BoxDecoration(
              color: offWhite,
              borderRadius:
                  BorderRadius.circular(28 * SizeConfig.heightMultiplier!)),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 12 * SizeConfig.widthMultiplier!),
            child: Center(
              child: Text(
                '+' + (list.length - 1).toString().tr,
                style: AppTextStyle.lightMediumBlackText,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Bottom sheet class
class BottomSheetField extends StatelessWidget {
  final String? BottomFieldImage;
  final String? BottomFieldText;
  final VoidCallback? onTap;
  BottomSheetField({this.BottomFieldImage, this.BottomFieldText, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            bottom: 34 * SizeConfig.heightMultiplier!,
            left: 18.5 * SizeConfig.widthMultiplier!),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            color: Colors.transparent,
            child: Row(
              children: [
                SvgPicture.asset(BottomFieldImage!,
                    width: 16 * SizeConfig.widthMultiplier!,
                    fit: BoxFit.contain),
                SizedBox(width: 10.5 * SizeConfig.widthMultiplier!),
                Text(BottomFieldText!,
                    style: GoogleFonts.openSans(
                      fontSize: (14) * SizeConfig.textMultiplier!,
                      fontWeight: FontWeight.w600,
                      color: kBlack,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
