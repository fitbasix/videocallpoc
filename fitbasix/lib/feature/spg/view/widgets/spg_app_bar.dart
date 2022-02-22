import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class SPGAppBar extends StatelessWidget {
  SPGAppBar(
      {Key? key,
      required this.title,
      required this.onBack,
      required this.onSkip})
      : super(key: key);

  final String title;
  final VoidCallback onBack;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPureWhite,
        elevation: 0,
        leading: IconButton(
            onPressed: onBack,
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                ImagePath.backIcon,
                width: 7 * SizeConfig.widthMultiplier!,
                height: 12 * SizeConfig.heightMultiplier!,
              ),
            )),
        title: Text(
          title,
          style: AppTextStyle.NormalText.copyWith(
              color: lightBlack, fontSize: 14 * SizeConfig.textMultiplier!),
        ),
        centerTitle: true,
        actions: [
          // TextButton(
          //     onPressed: onSkip,
          //     child: Text(
          //       'skip'.tr,
          //       style: AppTextStyle.normalBlackText.copyWith(
          //           color: hintGrey, fontSize: 14 * SizeConfig.textMultiplier!),
          //     ))
        ],
      ),
    );
  }
}
