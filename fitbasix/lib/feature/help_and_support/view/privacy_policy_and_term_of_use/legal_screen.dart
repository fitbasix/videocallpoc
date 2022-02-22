import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_text_style.dart';
import '../../../../core/constants/color_palette.dart';
import '../../../../core/constants/image_path.dart';
import '../../../../core/reponsive/SizeConfig.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../Home/controller/Home_Controller.dart';
import '../../../profile/view/appbar_for_account.dart';

class LegalScreen extends StatelessWidget {
  const LegalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController _homeController = Get.find();
    return Scaffold(
      backgroundColor: kPureWhite,
      appBar: AppBarForAccount(
        title: "legal".tr,
        onback: () {
          _homeController.selectedIndex.value = 0;
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30 * SizeConfig.heightMultiplier!,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 18 * SizeConfig.widthMultiplier!),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RouteName.privacyAndPolicy);
              },
              child: Row(
                children: [
                  GestureDetector(
                      child: SvgPicture.asset(
                    ImagePath.privacyPolicyIcon,
                    width: 16 * SizeConfig.widthMultiplier!,
                    height: 20 * SizeConfig.heightMultiplier!,
                    fit: BoxFit.contain,
                  )),
                  SizedBox(
                    width: 16.59 * SizeConfig.widthMultiplier!,
                  ),
                  Text(
                    "privacy_policy".tr,
                    style: AppTextStyle.NormalBlackTitleText,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 30 * SizeConfig.heightMultiplier!,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 16 * SizeConfig.widthMultiplier!),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RouteName.termOfUse);
              },
              child: Row(
                children: [
                  GestureDetector(
                      child: SvgPicture.asset(
                    ImagePath.termOfUseIcon,
                    width: 20 * SizeConfig.imageSizeMultiplier!,
                    height: 20 * SizeConfig.imageSizeMultiplier!,
                    fit: BoxFit.contain,
                  )),
                  SizedBox(
                    width: 15 * SizeConfig.widthMultiplier!,
                  ),
                  Text(
                    "term_of_use".tr,
                    style: AppTextStyle.NormalBlackTitleText,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
