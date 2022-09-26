import 'dart:developer';
import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/Home/view/Home_page.dart';
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
import 'dart:convert';

class MenuScreen extends StatelessWidget {
  final String imageCoverPic;
  final String imageUrl;
  final String? name;
  MenuScreen(
      {required this.imageUrl,
      required this.imageCoverPic,
      required this.name});

  final ProfileController _profileController = Get.put(ProfileController());

  bool userClickedOnLogOut = false;
  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    var dependencyupdate =
        homeController.remoteConfig.getString('UiDependency');
    var jsonOb = json.decode(dependencyupdate);

    return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        width: 300 * SizeConfig.widthMultiplier!,
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                Navigator.pushNamed(context, RouteName.userprofileinfo);
                refreshProfileData();
                _profileController.setAssetDataForGallery();
                _profileController.directFromHome.value = false;
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
            jsonOb['my_account'] == 1
                ? MenuItem(
                    menuItemImage: ImagePath.account,
                    menuItemText: 'my_account'.tr,
                    onTap: () {
                      Navigator.of(context).pop;
                      Navigator.pushNamed(context, RouteName.editPersonalInfo);
                    })
                : Container(),
            jsonOb['document'] == 1
                ? MenuItem(
                    menuItemImage: ImagePath.chatdocumentIcon,
                    menuItemText: 'View Documents'.tr,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                          context, RouteName.viewAllUserWithDoc);
                    })
                : Container(),
            jsonOb['setting'] == 1
                ? MenuItem(
                    menuItemImage: ImagePath.settings,
                    menuItemText: 'settings'.tr,
                    onTap: () {
                      Navigator.of(context).pop;
                      Navigator.pushNamed(context, RouteName.userSetting);
                    })
                : Container(),
            jsonOb['help&support']['help'] == 1
                ? MenuItem(
                    menuItemImage: ImagePath.support,
                    menuItemText: 'help'.tr,
                    onTap: () {
                      Navigator.of(context).pop;
                      Navigator.pushNamed(context, RouteName.helpAndSupport);
                    })
                : Container(),
            jsonOb['feedback'] == 1
                ? MenuItem(
                    menuItemImage: ImagePath.feedback,
                    menuItemText: 'feedback'.tr,
                    onTap: () {
                      homeController.selectedIndex.value = 0;
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              DialogboxForFeedback());
                    })
                : Container(),
            jsonOb['legal'] == 1
                ? MenuItem(
                    menuItemImage: ImagePath.legal,
                    menuItemText: 'legal'.tr,
                    onTap: () {
                      Navigator.of(context).pop;
                      Navigator.pushNamed(context, RouteName.legal);
                    })
                : Container(),
            jsonOb['logout'] == 1
                ? MenuItem(
                    menuItemImage: ImagePath.logOut,
                    menuItemText: 'logOut'.tr,
                    onTap: () async {
                      Get.dialog(
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal:
                                20 * SizeConfig.widthMultiplier!),
                            child: Dialog(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 25 * SizeConfig.heightMultiplier!,
                                    horizontal:
                                        20 * SizeConfig.widthMultiplier!),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Are you sure you want to logout ?',
                                      style: AppTextStyle.whiteTextWithWeight600
                                          .copyWith(
                                              fontSize: 16 *
                                                  SizeConfig.textMultiplier!),
                                    ),
                                    SizedBox(
                                      height: 20 * SizeConfig.heightMultiplier!,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap:()async{
                                            Get.back();
                                            Get.dialog(
                                                Center(child: CustomizedCircularProgress()),
                                                barrierDismissible: false
                                            );
                                            if (!userClickedOnLogOut) {
                                              userClickedOnLogOut = true;
                                              AwesomeNotifications().cancelAllSchedules();
                                              AwesomeNotifications().cancelAll();
                                              final LoginController _controller =
                                                  Get.put(LoginController());
                                              // CometChatService().logOutUserFromCometChat();
                                             try {
                                               await LogInService.removeDeviceId().then((value) async{
                                                 await LogInService.logOut();
                                               });
                                                userClickedOnLogOut = false;
                                                final SharedPreferences prefs =
                                                    await SharedPreferences.getInstance();
                                                prefs.clear();
                                                _controller.googleSignout();
                                                Navigator.pushNamedAndRemoveUntil(
                                                    context, RouteName.loginScreen, (route) => false);
                                                Get.deleteAll();
                                              }
                                              catch (e){
                                               Get.back();
                                              }
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(8),
                                                color: kBlack),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0 *
                                                      SizeConfig.heightMultiplier!,
                                                  horizontal: 23 *
                                                      SizeConfig.widthMultiplier!),
                                              child: Text(
                                                'Yes',
                                                style: AppTextStyle.normalWhiteText
                                                    .copyWith(
                                                    fontSize: 14 *
                                                        SizeConfig
                                                            .textMultiplier!),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20 * SizeConfig.widthMultiplier!,
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            Get.back();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: kgreen4F),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0 *
                                                      SizeConfig.heightMultiplier!,
                                                  horizontal: 23 *
                                                      SizeConfig.widthMultiplier!),
                                              child: Text(
                                                'Cancel',
                                                style: AppTextStyle.normalWhiteText
                                                    .copyWith(
                                                        fontSize: 14 *
                                                            SizeConfig
                                                                .textMultiplier!),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              backgroundColor: kBlack,
                              insetPadding: EdgeInsets.zero,
                            ),
                          ),
                          barrierColor: Colors.transparent);

                    })
                : Container()
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
            left: imageWidth != null
                ? 20 * SizeConfig.widthMultiplier!
                : 18 * SizeConfig.widthMultiplier!),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            color: Colors.transparent,
            child: Row(
              children: [
                SvgPicture.asset(menuItemImage,
                    width: imageWidth != null
                        ? imageWidth! * SizeConfig.imageSizeMultiplier!
                        : 22 * SizeConfig.heightMultiplier!,
                    color: Theme.of(context).textTheme.headline1?.color,
                    fit: BoxFit.contain),
                SizedBox(
                    width: imageWidth != null
                        ? 17 * SizeConfig.widthMultiplier!
                        : 15 * SizeConfig.widthMultiplier!),
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
