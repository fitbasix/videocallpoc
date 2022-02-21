import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/feature/settings/controller/setting_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/color_palette.dart';
import '../../../core/reponsive/SizeConfig.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>  {

  SettingController _settingController = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPureWhite,
      appBar: AppBarForAccount(
        title: 'setting'.tr,
        parentContext: context,
      ),

      body: SafeArea(child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //notification
        _settingField(
          svgicon: ImagePath.notificationIcon,
          title: 'notification'.tr,
          description: 'notification_subtitle'.tr,
          onchange: (value){
            _settingController.notificationSwitch.value = value;
          },
            switchcontroller: _settingController.notificationSwitch,
          wantbutton: true
        ),
          //private account
          _settingField(
              svgicon: ImagePath.privateAccountIcon,
              title: 'private_account'.tr,
              description: 'private_subtitle'.tr,
              onchange: (value){
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
          ),
          // delete account
          _settingField(
              svgicon: ImagePath.deleteAccountIcon,
              title: 'delete_account'.tr,
              textcolor: kRed,
              description: 'delete_subtitle'.tr,
              wantbutton: false,
            switchcontroller: _settingController.notificationSwitch,
          ),

        ],
      ),),
    );
  }

  Widget _settingField({String? svgicon, String? title,String? description , ValueChanged<bool>? onchange,
    bool? wantbutton, Color? textcolor, RxBool? switchcontroller,
  }) {
    return Container(
      width: 360 * SizeConfig.widthMultiplier!,
      //  height: 94 * SizeConfig.heightMultiplier!,
      padding: EdgeInsets.fromLTRB(
          16 * SizeConfig.widthMultiplier!, 10 * SizeConfig.heightMultiplier!,
          16 * SizeConfig.widthMultiplier!, 16 * SizeConfig.heightMultiplier!),
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
       ),
          SizedBox(
            width: 16.59 * SizeConfig.widthMultiplier!,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text( title!,
                  style: GoogleFonts.openSans(
                    fontSize: 16 * SizeConfig.textMultiplier!,
                    fontWeight: FontWeight.w600,
                    color: textcolor!= null?textcolor:kBlack,
                  )),
              SizedBox(
                height: 12 * SizeConfig.heightMultiplier!,
              ),
              Container(
               //  padding: EdgeInsets.only(right: ),
                width: (wantbutton!)?230 * SizeConfig.widthMultiplier!: 285 * SizeConfig.widthMultiplier!,
                //  height: 32 * SizeConfig.heightMultiplier!,
                child: Text( description!,
                  style: AppTextStyle.hmediumBlackText),
              )
            ],
          ),
          Spacer(),
          (wantbutton)?
          Transform.scale(
              scale: 0.7,
              child: Obx(()=>
                 CupertinoSwitch(value: switchcontroller!.value,
                  onChanged: onchange,
                  activeColor: Color(0xff4FC24C).withOpacity(0.2),
                  thumbColor: Color(0xff4FC24C),
                ),
              ),
          )
              :Container()
        ],
      ),
    );
  }
}

class AppBarForAccount extends StatelessWidget with PreferredSizeWidget {
  String? title;
  BuildContext? parentContext;
  AppBarForAccount({Key? key, this.title, this.parentContext})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: kPureWhite,
      elevation: 0,
      title: Row(
        children: [
          SizedBox(
            width: 7 * SizeConfig.widthMultiplier!,
          ),
          GestureDetector(
              onTap: () {
                Navigator.pop(parentContext!);
              },
              child: SvgPicture.asset(
                ImagePath.backIcon,
                width: 7.41 * SizeConfig.widthMultiplier!,
                height: 12 * SizeConfig.heightMultiplier!,
                fit: BoxFit.contain,
              )),
          SizedBox(
            width: 16.59 * SizeConfig.widthMultiplier!,
          ),
          Text(title ?? "",
              style: AppTextStyle.hblack600Text)
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}


