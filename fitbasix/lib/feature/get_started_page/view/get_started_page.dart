import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button_with_arrow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class GetStartedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            color: kPureBlack,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SvgPicture.asset(ImagePath.fitBasixIcon),
                SizedBox(
                  height: 4 * SizeConfig.heightMultiplier!,
                ),
                Text(
                  'welcome_title'.tr,
                  style: AppTextStyle.italicWelcomeText,
                ),
                SizedBox(
                  height: 37 * SizeConfig.heightMultiplier!,
                ),
                ProceedButtonWithArrow(
                  title: 'getStarted'.tr,
                  onPressed: () {
                    Navigator.pushNamed(context, RouteName.loginScreen);
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
