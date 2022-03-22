import 'dart:developer';
import 'dart:ui';

import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/feature/settings/controller/setting_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/api_service/dio_service.dart';
import '../../../core/constants/color_palette.dart';
import '../../../core/reponsive/SizeConfig.dart';
import '../../../core/routes/api_routes.dart';
import '../../../core/routes/app_routes.dart';
import '../../Home/controller/Home_Controller.dart';
import '../../Home/services/home_service.dart';
import '../../Home/view/widgets/menu_screen.dart';
import '../../log_in/controller/login_controller.dart';
import '../../log_in/services/login_services.dart';
import '../../profile/view/appbar_for_account.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  SettingController _settingController = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    final HomeController _homeController = Get.find();
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBarForAccount(
          title: 'setting'.tr,
          onback: () {
            _homeController.selectedIndex.value = 0;
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //notification
              _settingField(
                  svgicon: ImagePath.notificationIcon,
                  title: 'notification'.tr,
                  description: 'notification_subtitle'.tr,
                  onchange: (value) {
                    _settingController.notificationSwitch.value = value;
                  },
                  switchcontroller: _settingController.notificationSwitch,
                  wantbutton: true),
              //private account
              _settingField(
                svgicon: ImagePath.privateAccountIcon,
                title: 'private_account'.tr,
                description: 'private_subtitle'.tr,
                onchange: (value) {
                  _settingController.privacyAccount.value = value;
                },
                wantbutton: true,
                switchcontroller: _settingController.privacyAccount,
              ),
              //deactivate account
              _settingField(
                  svgicon: ImagePath.deactivateAccountIcon,
                  title: 'deactivate_account'.tr,
                  description: 'deactivate_subtitle'.tr,
                  wantbutton: false,
                  switchcontroller: _settingController.notificationSwitch,
                  onTap: () async {
                    deActiveAccount(context);
                  }),
              // delete account
              _settingField(
                  svgicon: ImagePath.deleteAccountIcon,
                  title: 'delete_account'.tr,
                  textcolor: kRed,
                  description: 'delete_subtitle'.tr,
                  wantbutton: false,
                  switchcontroller: _settingController.notificationSwitch,
                  onTap: () {
                    deleteAccount(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingField({
    String? svgicon,
    String? title,
    String? description,
    ValueChanged<bool>? onchange,
    bool? wantbutton,
    Color? textcolor,
    RxBool? switchcontroller,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 360 * SizeConfig.widthMultiplier!,
        //  height: 94 * SizeConfig.heightMultiplier!,
        padding: EdgeInsets.fromLTRB(
            16 * SizeConfig.widthMultiplier!,
            10 * SizeConfig.heightMultiplier!,
            16 * SizeConfig.widthMultiplier!,
            16 * SizeConfig.heightMultiplier!),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 7 * SizeConfig.widthMultiplier!,
            ),
            SvgPicture.asset(
              svgicon!,
              width: 16 * SizeConfig.widthMultiplier!,
              height: 19.5 * SizeConfig.heightMultiplier!,
              fit: BoxFit.contain,
              color: textcolor != null
                  ? textcolor
                  : Theme.of(context).primaryColor,
            ),
            SizedBox(
              width: 16.59 * SizeConfig.widthMultiplier!,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title!,
                    style: GoogleFonts.openSans(
                      fontSize: 16 * SizeConfig.textMultiplier!,
                      fontWeight: FontWeight.w600,
                      color: textcolor != null
                          ? textcolor
                          : Theme.of(context).textTheme.bodyText1?.color,
                    )),
                SizedBox(
                  height: 12 * SizeConfig.heightMultiplier!,
                ),
                Container(
                  //  padding: EdgeInsets.only(right: ),
                  width: (wantbutton!)
                      ? 230 * SizeConfig.widthMultiplier!
                      : 284 * SizeConfig.widthMultiplier!,
                  //  height: 32 * SizeConfig.heightMultiplier!,
                  child: Text(description!,
                      style: AppTextStyle.hmediumBlackText.copyWith(
                          color: Theme.of(context).textTheme.bodyText1?.color)),
                )
              ],
            ),
            Spacer(),
            (wantbutton)
                ? Transform.scale(
                    scale: 0.7,
                    child: Obx(
                      () => CupertinoSwitch(
                        value: switchcontroller!.value,
                        onChanged: onchange,
                        activeColor: Color(0xff4FC24C).withOpacity(0.2),
                        thumbColor: Color(0xff4FC24C),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}

void deleteAccount(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      SettingController _settingController = Get.find();
      return Container(
        color: kBlack.withOpacity(0.6),
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: AlertDialog(
                insetPadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.symmetric(
                    vertical: 30 * SizeConfig.heightMultiplier!),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8 * SizeConfig.imageSizeMultiplier!)),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "delete_account_heading".tr,
                        style: AppTextStyle.black600Text.copyWith(
                            color: kRed,
                            fontSize: 18 * SizeConfig.textMultiplier!),
                      ),
                      SizedBox(
                        height: 24 * SizeConfig.heightMultiplier!,
                      ),
                      Text(
                        "delete_account_subheading".tr,
                        style: AppTextStyle.black400Text.copyWith(
                            color:
                                Theme.of(context).textTheme.bodyText1!.color),
                      ),
                      SizedBox(
                        height: 32 * SizeConfig.heightMultiplier!,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Obx(
                            () => _settingController.isLoading.value
                                ? Padding(
                                    padding: EdgeInsets.only(right: 30),
                                    child: CustomizedCircularProgress())
                                : RedButton(
                                    text: 'delete_option1'.tr,
                                    onTap: () async {
                                      _settingController.isLoading.value = true;
                                      var dio = DioUtil().getInstance();
                                      dio!.options.headers["language"] = "1";
                                      String token =
                                          await LogInService.getAccessToken();
                                      dio.options.headers['Authorization'] =
                                          await LogInService.getAccessToken();
                                      var response =
                                          await dio.post(ApiUrl.deleteAccount);
                                      // await HomeService.deleteAccount();
                                      final LoginController _controller =
                                          Get.put(LoginController());
                                      final SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.clear();
                                      await _controller.googleSignout();
                                      Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          RouteName.loginScreen,
                                          (route) => false);

                                      Get.deleteAll();
                                      _settingController.isLoading.value =
                                          false;
                                    },
                                  ),
                          ),
                          SizedBox(
                            width: 12 * SizeConfig.widthMultiplier!,
                          ),
                          ProceedButton(
                            text: 'delete_option2'.tr,
                            onTap: () async {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30 * SizeConfig.heightMultiplier!,
                      ),
                    ],
                  ),
                ),
              ),
            )),
      );
    },
  );
}

void deActiveAccount(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      SettingController _settingController = Get.find();
      return Container(
        color: kBlack.withOpacity(0.6),
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: AlertDialog(
                insetPadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.symmetric(
                    vertical: 30 * SizeConfig.heightMultiplier!),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8 * SizeConfig.imageSizeMultiplier!)),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "deactive_account_heading".tr,
                        style: AppTextStyle.black600Text.copyWith(
                            color: kRed,
                            fontSize: 18 * SizeConfig.textMultiplier!),
                      ),
                      SizedBox(
                        height: 24 * SizeConfig.heightMultiplier!,
                      ),
                      Text(
                        "deactive_account_subheading".tr,
                        style: AppTextStyle.black400Text.copyWith(
                            color:
                                Theme.of(context).textTheme.bodyText1!.color),
                      ),
                      SizedBox(
                        height: 32 * SizeConfig.heightMultiplier!,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Obx(
                            () => _settingController.isLoading.value
                                ? Padding(
                                    padding: EdgeInsets.only(right: 30),
                                    child: CustomizedCircularProgress())
                                : RedButton(
                                    text: 'deactive_option1'.tr,
                                    onTap: () async {
                                      _settingController.isLoading.value = true;
                                      await HomeService.deActiveAccount();
                                      final LoginController _controller =
                                          Get.put(LoginController());
                                      final SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.clear();
                                      await _controller.googleSignout();
                                      Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          RouteName.loginScreen,
                                          (route) => false);

                                      Get.deleteAll();
                                      _settingController.isLoading.value =
                                          false;
                                    },
                                  ),
                          ),
                          SizedBox(
                            width: 12 * SizeConfig.widthMultiplier!,
                          ),
                          ProceedButton(
                            text: 'delete_option2'.tr,
                            onTap: () async {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30 * SizeConfig.heightMultiplier!,
                      ),
                    ],
                  ),
                ),
              ),
            )),
      );
    },
  );
}
