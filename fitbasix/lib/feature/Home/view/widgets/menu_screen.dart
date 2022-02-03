import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/feature/log_in/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuScreen extends StatelessWidget {
  final String imageCoverPic;
  final String imageUrl;
  final String? name;
  MenuScreen(
      {required this.imageUrl,
      required this.imageCoverPic,
      required this.name});
  @override
  Widget build(BuildContext context) {
    final LoginController _controller = Get.find();
    return Container(
        width: 300 * SizeConfig.widthMultiplier!,
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                  imageUrl,
                  height: 160 * SizeConfig.heightMultiplier!,
                  width: 300 * SizeConfig.widthMultiplier!,
                  fit: BoxFit.fitWidth,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                      child: Container(
                        height: 160 * SizeConfig.heightMultiplier!,
                        width: 300 * SizeConfig.widthMultiplier!,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 18 * SizeConfig.widthMultiplier!,
                  bottom: 16 * SizeConfig.heightMultiplier!,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                            30 * SizeConfig.widthMultiplier!),
                        child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            height: 64 * SizeConfig.widthMultiplier!,
                            width: 64 * SizeConfig.widthMultiplier!),
                      ),
                      SizedBox(height: 8 * SizeConfig.widthMultiplier!),
                      Text(
                        name.toString(),
                        style: AppTextStyle.normalWhiteText.copyWith(
                            fontSize: 18 * SizeConfig.textMultiplier!),
                      )
                    ],
                  ),
                )
                // Container(
                //   height: 160 * SizeConfig.heightMultiplier!,
                //   width: 300 * SizeConfig.widthMultiplier!,
                //   color: Colors.black.withOpacity(0.55),
                // )
              ],
            ),
            MenuItem(
                menuItemImage: ImagePath.account,
                menuItemText: 'account'.tr,
                onTap: () {}),
            MenuItem(
                menuItemImage: ImagePath.settings,
                menuItemText: 'settings'.tr,
                onTap: () {}),
            MenuItem(
                menuItemImage: ImagePath.support,
                menuItemText: 'help'.tr,
                onTap: () {}),
            MenuItem(
                menuItemImage: ImagePath.feedback,
                menuItemText: 'feedback'.tr,
                onTap: () {}),
            MenuItem(
                menuItemImage: ImagePath.legal,
                menuItemText: 'legal'.tr,
                onTap: () {}),
            MenuItem(
                menuItemImage: ImagePath.logOut,
                menuItemText: 'logOut'.tr,
                onTap: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.clear();
                  await _controller.googleSignout();
                  Navigator.pushNamedAndRemoveUntil(
                      context, RouteName.loginScreen, (route) => false);
                })
          ],
        ));
  }
}

class MenuItem extends StatelessWidget {
  final String menuItemImage;
  final String menuItemText;
  final VoidCallback onTap;
  MenuItem(
      {required this.menuItemImage,
      required this.menuItemText,
      required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            top: 29 * SizeConfig.heightMultiplier!,
            left: 18 * SizeConfig.widthMultiplier!),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            color: Colors.transparent,
            child: Row(
              children: [
                SvgPicture.asset(menuItemImage,
                    width: 22 * SizeConfig.heightMultiplier!,
                    fit: BoxFit.contain),
                SizedBox(width: 15 * SizeConfig.widthMultiplier!),
                Text(
                  menuItemText,
                  style: AppTextStyle.boldBlackText
                      .copyWith(fontSize: 14 * SizeConfig.textMultiplier!),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
