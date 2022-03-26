import 'dart:developer';
import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/Home/view/widgets/feedback_dialogbox.dart';
import 'package:fitbasix/feature/log_in/controller/login_controller.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';
import 'package:fitbasix/feature/profile/controller/profile_controller.dart';
import 'package:fitbasix/feature/profile/services/profile_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/credentials.dart';
import '../../../log_in/services/login_services.dart';

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
    final HomeController homeController = Get.find();
    return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
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
                menuItemText: 'my_account'.tr,
                onTap: () {
                  _profileController.loginController!.mobileController.text =
                      homeController.userProfileData.value.response!.data!
                          .profile!.mobileNumber
                          .toString();
                  _profileController.loginController!.mobile.value =
                      homeController.userProfileData.value.response!.data!
                          .profile!.mobileNumber!;
                  _profileController.selectedDate.value = homeController
                              .userProfileData
                              .value
                              .response!
                              .data!
                              .profile!
                              .dob ==
                          null
                      ? DateTime.now().toString()
                      : DateFormat("dd/LL/yyyy").format(homeController
                          .userProfileData.value.response!.data!.profile!.dob!);
                  _profileController.DOBController.text = homeController
                              .userProfileData
                              .value
                              .response!
                              .data!
                              .profile!
                              .dob ==
                          null
                      ? ""
                      : DateFormat("dd/LL/yyyy").format(homeController
                          .userProfileData.value.response!.data!.profile!.dob!);
                  Navigator.pushNamed(context, RouteName.editPersonalInfo);
                }),
            MenuItem(
                menuItemImage: ImagePath.fileIcon,
                imageWidth: 20,
                menuItemText: 'view_document'.tr,
                onTap: () {
                  Navigator.pushNamed(context, RouteName.viewAllUserWithDoc);
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
                  homeController.selectedIndex.value = 0;
                  Navigator.pop(context);
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
                  AwesomeNotifications().cancelAll();
                  InitializeQuickBlox().logOutUserSession();
                  final LoginController _controller =
                      Get.put(LoginController());
                  await LogInService.logOut();
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
  double? imageWidth;
  MenuItem(
      {required this.menuItemImage,
      required this.menuItemText,
      required this.onTap,
      this.imageWidth});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            top: 29 * SizeConfig.heightMultiplier!,
            left: imageWidth!=null?20*SizeConfig.widthMultiplier!:18 * SizeConfig.widthMultiplier!),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            color: Colors.transparent,
            child: Row(
              children: [
                SvgPicture.asset(menuItemImage,
                    width: imageWidth!=null?imageWidth!*SizeConfig.imageSizeMultiplier!:22 * SizeConfig.heightMultiplier!,
                    color: Theme.of(context).textTheme.headline1?.color,
                    fit: BoxFit.contain),
                SizedBox(width: imageWidth!=null?17*SizeConfig.widthMultiplier!:15 * SizeConfig.widthMultiplier!),
                Text(
                  menuItemText,
                  style: AppTextStyle.boldBlackText.copyWith(
                      color: Theme.of(context).textTheme.bodyText1?.color,
                      fontSize: 14 * SizeConfig.textMultiplier!),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RedButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onTap;
  RedButton({this.text, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44 * SizeConfig.heightMultiplier!,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(12 * SizeConfig.heightMultiplier!),
          color: kPink,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 12 * SizeConfig.widthMultiplier!),
          child: Center(
            child: Text(
              text.toString(),
              style: AppTextStyle.black600Text.copyWith(
                  color: kPureWhite, fontSize: 14 * SizeConfig.textMultiplier!),
            ),
          ),
        ),
      ),
    );
  }
}

class ProceedButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onTap;
  ProceedButton({this.text, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44 * SizeConfig.heightMultiplier!,
        decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(12 * SizeConfig.heightMultiplier!),
            color: Colors.transparent,
            border: Border.all(
                width: 1 * SizeConfig.heightMultiplier!, color: kPureWhite)),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 12 * SizeConfig.widthMultiplier!),
          child: Center(
            child: Text(
              text.toString(),
              style: AppTextStyle.black600Text.copyWith(
                  color: kPureWhite, fontSize: 14 * SizeConfig.textMultiplier!),
            ),
          ),
        ),
      ),
    );
  }
}
