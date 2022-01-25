import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button.dart';
import 'package:fitbasix/feature/spg/view/widgets/spg_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetHeight extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: SPGAppBar(
              title: '4 of 8',
              onBack: () {
                Navigator.pop(context);
              },
              onSkip: () {}),
          preferredSize: const Size(double.infinity, kToolbarHeight)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: kGreenColor,
            height: 2 * SizeConfig.heightMultiplier!,
            width: Get.width * 0.50,
          ),
          SizedBox(
            height: 40 * SizeConfig.heightMultiplier!,
          ),
          Center(
            child: Text(
              'ask_height'.tr,
              style: AppTextStyle.boldBlackText,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 16 * SizeConfig.widthMultiplier!),
            child: ProceedButton(
                title: 'proceed'.tr,
                onPressed: () {
                  Navigator.pushNamed(context, RouteName.setWeight);
                }),
          ),
          SizedBox(
            height: 16 * SizeConfig.heightMultiplier!,
          )
        ],
      ),
    );
  }
}
