import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/feature/Home/view/widgets/feedback_dialogbox.dart';
import 'package:fitbasix/feature/log_in/controller/login_controller.dart';
import 'package:fitbasix/feature/profile/controller/profile_controller.dart';
import 'package:fitbasix/feature/profile/services/profile_services.dart';
import 'package:fitbasix/feature/profile/view/account_and_subscription_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuScreen extends StatelessWidget {
  final String imageCoverPic;
  final String imageUrl;
  final String? name;
  MenuScreen(
      {required this.imageUrl,
      required this.imageCoverPic,
      required this.name});

  final ProfileController _profileController = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    print(imageUrl);
    print(imageCoverPic);
    return Container(
        width: 300 * SizeConfig.widthMultiplier!,
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                Navigator.pushNamed(context, RouteName.userprofileinfo);
                _profileController.initialPostData.value =
                    await ProfileServices.getUserPosts();

                if (_profileController
                        .initialPostData.value.response!.data!.length !=
                    0) {
                  _profileController.userPostList.value =
                      _profileController.initialPostData.value.response!.data!;
                } else {
                  _profileController.userPostList.clear();
                }
              },
              child: Container(
                height: 160 * SizeConfig.heightMultiplier!,
                width: 300 * SizeConfig.widthMultiplier!,
                child: Stack(
                  children: [
                    Image.network(
                      imageCoverPic,
                      height: 160 * SizeConfig.heightMultiplier!,
                      width: 300 * SizeConfig.widthMultiplier!,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        height: 160 * SizeConfig.heightMultiplier!,
                        width: 300 * SizeConfig.widthMultiplier!,
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
                                color: kPureWhite,
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
              ),
            ),
            MenuItem(
                menuItemImage: ImagePath.account,
                menuItemText: 'account'.tr,
                onTap: () {
                  Navigator.pushNamed(
                      context, RouteName.accountAndSubscription);
                }),
            MenuItem(
                menuItemImage: ImagePath.settings,
                menuItemText: 'settings'.tr,
                onTap: () {
                  Navigator.pushNamed(context, RouteName.userSetting);
                }),
            MenuItem(
                menuItemImage: ImagePath.support,
                menuItemText: 'help'.tr,
                onTap: () {
                  Navigator.pushNamed(context, RouteName.helpAndSupport);
                }),
            MenuItem(
                menuItemImage: ImagePath.feedback,
                menuItemText: 'feedback'.tr,
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          DialogboxForFeedback());
                }),
            MenuItem(
                menuItemImage: ImagePath.legal,
                menuItemText: 'legal'.tr,
                onTap: () {
                  Navigator.pushNamed(context, RouteName.legal);
                }),
            MenuItem(
                menuItemImage: ImagePath.logOut,
                menuItemText: 'logOut'.tr,
                onTap: () async {
                  final LoginController _controller =
                      Get.put(LoginController());
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.clear();
                  await _controller.googleSignout();
                  Navigator.pushNamedAndRemoveUntil(
                      context, RouteName.loginScreen, (route) => false);

                  Get.deleteAll();
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
