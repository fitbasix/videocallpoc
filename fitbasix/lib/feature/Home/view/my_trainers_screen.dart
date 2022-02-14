import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_palette.dart';
import '../../../core/constants/image_path.dart';
import '../../../core/reponsive/SizeConfig.dart';
import '../../../core/routes/app_routes.dart';

class MyTrainersScreen extends StatelessWidget {
  const MyTrainersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: NoTrainerScreen()
      ),
    );
  }
}

class NoTrainerScreen extends StatelessWidget {
  const NoTrainerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPureWhite,
      appBar: AppBar(
        backgroundColor: kPureWhite,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              //    Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              ImagePath.backIcon,
              width: 7.41 * SizeConfig.widthMultiplier!,
              height: 12 * SizeConfig.heightMultiplier!,
            )),
        title: Text('my_trainer'.tr,
            style: AppTextStyle.hblack600Text),
        actions: [
          IconButton(onPressed: (){},
            icon: Icon(
              Icons.search,
              color: kPureBlack,
              size: 25 * SizeConfig.heightMultiplier!,
            ),),
        ],
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: 25 * SizeConfig.widthMultiplier!,
              vertical: 40 * SizeConfig.heightMultiplier!),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              SvgPicture.asset(
                  ImagePath.notrainerenrollframe,
                  fit: BoxFit.contain,
                  //  width: 360 * SizeConfig.widthMultiplier!,
                  height: 200 * SizeConfig.heightMultiplier!
              ),
              SizedBox(
                height: 26 * SizeConfig.heightMultiplier!,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 7 * SizeConfig.widthMultiplier!,
                    right: 7 * SizeConfig.widthMultiplier!
                ),
                child: Text(
                  'notrainer_summary'.tr,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.normalBlackText.copyWith(color: hintGrey),
                ),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: kGreenColor, borderRadius: BorderRadius.circular(8),),
                width: double.infinity * SizeConfig.widthMultiplier!,
                height: 48 * SizeConfig.heightMultiplier!,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RouteName.myTrainer);
                  },
                  child: Text('enroll_now'.tr,
                      style: AppTextStyle.hboldWhiteText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class EnrollTrainerDialog extends StatelessWidget {
  const EnrollTrainerDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: kPureWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
        insetAnimationDuration: const Duration(milliseconds: 100),
        insetPadding: EdgeInsets.fromLTRB(
          32 * SizeConfig.widthMultiplier!,
          31 * SizeConfig.heightMultiplier!,
          32 * SizeConfig.widthMultiplier!,
          31 * SizeConfig.heightMultiplier!,
        ),
        child: Container(
          // width: 296 * SizeConfig.widthMultiplier!,
          height: 426 * SizeConfig.heightMultiplier!,
          child: Stack(
            children: [
              Padding(
                padding:  EdgeInsets.only(
                  left: 32 * SizeConfig.widthMultiplier!,
                  right: 32 * SizeConfig.widthMultiplier!,
                  top: 32 * SizeConfig.heightMultiplier!,
                  bottom: 31 * SizeConfig.heightMultiplier!
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                          ImagePath.enrolltrainerFrame,
                          // width: 220 * SizeConfig.widthMultiplier!,
                          height: 168 * SizeConfig.heightMultiplier!),
                      Padding(
                        padding: const EdgeInsets.only(top: 24, bottom: 16),
                        child: Text(
                          'uh_oh'.tr,
                          style: AppTextStyle.hblack600Text,
                        ),
                      ),
                      //enroll summary
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Text('enroll_summary'.tr,
                            style: AppTextStyle.hblack400Text,
                            textAlign: TextAlign.center
                        ),
                      ),
                      //enroll now text button
                      Padding(
                        padding: const EdgeInsets.fromLTRB(39, 0, 39, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: kGreenColor, borderRadius: BorderRadius.circular(8),),
                          width: 156 * SizeConfig.widthMultiplier!,
                          height: 48 * SizeConfig.heightMultiplier!,
                          child: TextButton(
                            onPressed: () {},
                            child: Text('enroll_now'.tr,
                                style: AppTextStyle.hboldWhiteText),
                          ),
                        ),
                      ),
                    ]),
              ),
              //
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: SvgPicture.asset(
                    ImagePath.closedialogIcon,
                    width: 16 * SizeConfig.widthMultiplier!,
                    height: 16 * SizeConfig.heightMultiplier!,
                  ),
                ),
              ),
            ],
          )
        )
    );
  }
}

