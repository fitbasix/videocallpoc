import 'package:fitbasix/feature/profile/controller/profile_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_palette.dart';
import '../../../core/constants/image_path.dart';
import '../../../core/reponsive/SizeConfig.dart';
import '../../../core/universal_widgets/proceed_button.dart';

class UserHeightDialog extends StatelessWidget {
  const UserHeightDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final ProfileController _heightController = Get.find();
    final ProfileController _heightController = Get.put(ProfileController());

    return Dialog(
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      insetPadding: EdgeInsets.fromLTRB(
        32 * SizeConfig.widthMultiplier!,
        48 * SizeConfig.heightMultiplier!,
        32 * SizeConfig.widthMultiplier!,
        48 * SizeConfig.heightMultiplier!,
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Container(
        height: 460 * SizeConfig.heightMultiplier!,
        child: Stack(
          children: [
            Column(
              // height widget
              children: [
                SizedBox(
                  height: 64 * SizeConfig.heightMultiplier!,
                ),
                Center(
                  child: Text(
                    'ask_height'.tr,
                    style: AppTextStyle.boldBlackText.copyWith(
                      color: Theme.of(context).textTheme.bodyText1?.color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 16 * SizeConfig.heightMultiplier!,
                ),
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _heightController.heightType.value = "inch";
                          },
                          child: Container(
                            height: 28 * SizeConfig.heightMultiplier!,
                            width: 75 * SizeConfig.widthMultiplier!,
                            decoration: BoxDecoration(
                                color: _heightController.heightType == "inch"
                                    ? kGreenColor
                                    : Colors.transparent,
                                border: Border.all(
                                    color:
                                        _heightController.heightType == "inch"
                                            ? Colors.transparent
                                            : lightGrey),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8))),
                            child: Center(
                                child: Text(
                              'inch'.tr,
                              style: _heightController.heightType == "inch"
                                  ? AppTextStyle.white400Text
                                  : AppTextStyle.white400Text.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.color,
                                    ),
                            )),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _heightController.heightType.value = "cm";
                          },
                          child: Container(
                            height: 28 * SizeConfig.heightMultiplier!,
                            width: 75 * SizeConfig.widthMultiplier!,
                            decoration: BoxDecoration(
                                color: _heightController.heightType != "inch"
                                    ? kGreenColor
                                    : Colors.transparent,
                                border: Border.all(
                                    color:
                                        _heightController.heightType != "inch"
                                            ? Colors.transparent
                                            : lightGrey),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    bottomRight: Radius.circular(8))),
                            child: Center(
                                child: Text(
                              'cm'.tr,
                              style: _heightController.heightType != "inch"
                                  ? AppTextStyle.white400Text
                                  : AppTextStyle.white400Text.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.color,
                                    ),
                            )),
                          ),
                        ),
                      ],
                    )),
                // need to check height sizedbox
                SizedBox(
                  height: 64 * SizeConfig.heightMultiplier!,
                ),
                Center(
                  child: Obx(
                    () => _heightController.heightType.value != "inch"
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _heightController.currentHeight.value
                                    .toString(),
                                style: AppTextStyle.normalBlackText.copyWith(
                                    fontSize: 48 * SizeConfig.textMultiplier!,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.color,
                                    height: 0),
                              ),
                              SizedBox(width: 4 * SizeConfig.widthMultiplier!),
                              Text("cm",
                                  textAlign: TextAlign.start,
                                  style: AppTextStyle.normalBlackText.copyWith(
                                      fontSize: 18 * SizeConfig.textMultiplier!,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.color,
                                      height: 0))
                            ],
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                (_heightController.currentHeight.value *
                                        0.0328084)
                                    .toString()
                                    .split(".")[0],
                                style: AppTextStyle.normalBlackText.copyWith(
                                    fontSize: 48 * SizeConfig.textMultiplier!,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.color,
                                    height: 0),
                              ),
                              SizedBox(width: 4 * SizeConfig.widthMultiplier!),
                              Text("ft",
                                  textAlign: TextAlign.start,
                                  style: AppTextStyle.normalBlackText.copyWith(
                                      fontSize: 18 * SizeConfig.textMultiplier!,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.color,
                                      height: 0)),
                              SizedBox(width: 7 * SizeConfig.widthMultiplier!),
                              Text(
                                (int.parse((_heightController
                                                    .currentHeight.value *
                                                0.0328084)
                                            .toString()
                                            .substring(2, 4)) *
                                        0.12)
                                    .toString()
                                    .substring(0, 2)
                                    .replaceAll(".", ""),
                                style: AppTextStyle.normalBlackText.copyWith(
                                    fontSize: 48 * SizeConfig.textMultiplier!,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.color,
                                    height: 0),
                              ),
                              SizedBox(width: 4 * SizeConfig.widthMultiplier!),
                              Text("in",
                                  textAlign: TextAlign.start,
                                  style: AppTextStyle.normalBlackText.copyWith(
                                      fontSize: 18 * SizeConfig.textMultiplier!,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.color,
                                      height: 0))
                            ],
                          ),
                  ),
                ),
                SizedBox(
                  height: 15 * SizeConfig.heightMultiplier!,
                ),

                // ruler
                Padding(
                  padding: EdgeInsets.only(
                      left: 31 * SizeConfig.widthMultiplier!,
                      right: 31 * SizeConfig.widthMultiplier!),
                  child: RulerPicker(
                    controller: _heightController.heightRulerPickerController,
                    beginValue: 120,
                    endValue: 250,
                    initValue: _heightController.currentHeight.value,
                    scaleLineStyleList: const [
                      ScaleLineStyle(
                          color: kGreenColor, width: 1.5, height: 30, scale: 0),
                      ScaleLineStyle(
                          color: kGreenColor, width: 1, height: 15, scale: -1)
                    ],
                    marker: Container(
                        width: 1.5 * SizeConfig.widthMultiplier!,
                        height: 50 * SizeConfig.heightMultiplier!,
                        decoration: BoxDecoration(
                            color: Theme.of(context).textTheme.bodyText1?.color,
                            borderRadius: BorderRadius.circular(5))),
                    onValueChange: (value) {
                      _heightController.currentHeight.value = value;
                    },
                    onBuildRulerScalueText: (index, scaleValue) {
                      return scaleValue.toString() + "cm";
                    },
                    width: Get.width - 132 * SizeConfig.widthMultiplier!,
                    height: 96 * SizeConfig.heightMultiplier!,
                    rulerScaleTextStyle: AppTextStyle.normalGreenText,
                    rulerBackgroundColor: LightGreen,
                    rulerMarginTop: 25,
                  ),
                ),
                SizedBox(
                  height: 30 * SizeConfig.heightMultiplier!,
                ),
                // okay button
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 66 * SizeConfig.widthMultiplier!),
                  child: ProceedButton(
                      title: 'okay'.tr,
                      onPressed: () {
                        print(_heightController.currentHeight.value);
                        Navigator.pop(context);
                      }),
                ),
                SizedBox(
                  height: 48 * SizeConfig.heightMultiplier!,
                ),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: SvgPicture.asset(
                  ImagePath.closedialogIcon,
                  width: 15.55 * SizeConfig.widthMultiplier!,
                  height: 15.55 * SizeConfig.heightMultiplier!,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
