import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../Home/controller/Home_Controller.dart';
import 'appbar_for_account.dart';

class AccountAndSubscriptionScreen extends StatelessWidget {
  const AccountAndSubscriptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController _homeController = Get.find();
    return WillPopScope(
      onWillPop: () async {

        _homeController.selectedIndex.value = 0;
        Navigator.pop(context);
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBarForAccount(
          title: "Account & Subscription",
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
                  Navigator.pushNamed(context, RouteName.editPersonalInfo);
                },
                child: Row(
                  children: [
                    GestureDetector(
                        child: SvgPicture.asset(
                      ImagePath.addPersonIcon,
                      width: 16 * SizeConfig.widthMultiplier!,
                      height: 16 * SizeConfig.heightMultiplier!,
                      color: Theme.of(context).primaryColor,
                      fit: BoxFit.contain,
                    )),
                    SizedBox(
                      width: 16.59 * SizeConfig.widthMultiplier!,
                    ),
                    Text(
                      "Edit_personal_info".tr,
                      style: AppTextStyle.NormalBlackTitleText.copyWith(
                        color: Theme.of(context).textTheme.bodyText1?.color
                      ),
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
                  horizontal: 18 * SizeConfig.widthMultiplier!),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RouteName.resetPassword);
                },
                child: Row(
                  children: [
                    GestureDetector(
                        child: SvgPicture.asset(
                      ImagePath.resetpasskeyIcon,
                      width: 9.9 * SizeConfig.widthMultiplier!,
                      height: 20 * SizeConfig.heightMultiplier!,
                      fit: BoxFit.contain,
                          color: Theme.of(context).primaryColor,
                    )),
                    SizedBox(
                      width: 16.59 * SizeConfig.widthMultiplier!,
                    ),
                    Text(
                      "reset_password".tr,
                      style: AppTextStyle.NormalBlackTitleText.copyWith(
                        color: Theme.of(context).textTheme.bodyText1?.color
                      ),
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
              child: Row(
                children: [
                  GestureDetector(
                      child: SvgPicture.asset(
                    ImagePath.personAddIcon,
                    width: 24 * SizeConfig.imageSizeMultiplier!,
                    height: 24 * SizeConfig.imageSizeMultiplier!,
                    fit: BoxFit.contain,
                        color: Theme.of(context).primaryColor,
                  )),
                  SizedBox(
                    width: 12 * SizeConfig.widthMultiplier!,
                  ),
                  Text(
                    "subscription_details".tr,
                    style: AppTextStyle.NormalBlackTitleText.copyWith(
                        color: Theme.of(context).textTheme.bodyText1?.color
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
