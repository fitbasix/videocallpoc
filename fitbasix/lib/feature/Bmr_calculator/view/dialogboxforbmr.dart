import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/constants/color_palette.dart';
import '../../../core/constants/image_path.dart';
import '../../../core/reponsive/SizeConfig.dart';

class BMRDialog extends StatelessWidget {
  const BMRDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: kPureWhite,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Container(
        height: 374 * SizeConfig.heightMultiplier!,
        child: Stack(
          children: [
            Column(
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 52*SizeConfig.heightMultiplier!,
                ),
                SvgPicture.asset(ImagePath.bmrinfoImage,
                    height: 120 * SizeConfig.heightMultiplier!),
                SizedBox(
                  height: 24*SizeConfig.heightMultiplier!,
                ),
                Center(
                  child: Text('What is BMR?',
                  style: AppTextStyle.hblack600Text,),
                ),
                SizedBox(
                  height: 16*SizeConfig.heightMultiplier!,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 31* SizeConfig.widthMultiplier!,
                    right: 31* SizeConfig.widthMultiplier!,
                  ),
                  child: Text('Basal metabolic rate is the number'
                      ' of calories your body needs to accomplish its '
                      'most basic (basal) life-sustaining functions.',
                  style: AppTextStyle.hnormal600BlackText.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                      textAlign: TextAlign.center
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: SvgPicture.asset(
                  ImagePath.closedialogIcon,
                  color: kPureBlack,
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
