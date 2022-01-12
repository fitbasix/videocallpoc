import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPureWhite,
      appBar: AppBar(
        backgroundColor: kPureWhite,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              ImagePath.backIcon,
              width: 7 * SizeConfig.widthMultiplier!,
              height: 12 * SizeConfig.heightMultiplier!,
            )),
        title: Transform(
          transform: Matrix4.translationValues(-20, 0, 0),
          child: Text(
            'create_post'.tr,
            style: AppTextStyle.titleText
                .copyWith(fontSize: 16 * SizeConfig.textMultiplier!),
          ),
        ),
        actions: [
          Container(
              height: 32,
              width: 78,
              margin: EdgeInsets.only(top: 8, bottom: 8, right: 16),
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  'post'.tr,
                  style: AppTextStyle.boldBlackText.copyWith(
                      fontSize: 14 * SizeConfig.textMultiplier!,
                      color: kPureWhite),
                ),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                    primary: lightGrey),
              ))
        ],
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.only(
            top: 8 * SizeConfig.heightMultiplier!,
            left: 16 * SizeConfig.widthMultiplier!,
            right: 16 * SizeConfig.widthMultiplier!),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20 * SizeConfig.widthMultiplier!,
                ),
                SizedBox(
                  width: 12 * SizeConfig.widthMultiplier!,
                ),
                Text(
                  'Jonathan Swift',
                  style: AppTextStyle.boldBlackText
                      .copyWith(fontSize: 14 * SizeConfig.textMultiplier!),
                )
              ],
            ),
            Container(
              height: 180 * SizeConfig.heightMultiplier!,
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'post_hint'.tr,
                    hintStyle: AppTextStyle.NormalText.copyWith(
                        fontSize: 18 * SizeConfig.textMultiplier!,
                        color: hintGrey)),
              ),
            ),
            SizedBox(
              height: 16 * SizeConfig.heightMultiplier!,
            ),
            Divider(
              height: 0,
            ),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                ),
                Text(
                  'location'.tr,
                  style: AppTextStyle.titleText
                      .copyWith(fontSize: 14 * SizeConfig.textMultiplier!),
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
