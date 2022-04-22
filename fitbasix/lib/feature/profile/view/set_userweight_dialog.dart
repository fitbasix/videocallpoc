import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_palette.dart';
import '../../../core/constants/image_path.dart';
import '../../../core/reponsive/SizeConfig.dart';
import '../../../core/universal_widgets/proceed_button.dart';
import '../controller/profile_controller.dart';

class UserWeightDialog extends StatelessWidget {
  const UserWeightDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileController _weightController = Get.find();
    return Dialog(
      insetPadding: EdgeInsets.fromLTRB(
        32 * SizeConfig.widthMultiplier!,
        48 * SizeConfig.heightMultiplier!,
        32 * SizeConfig.widthMultiplier!,
        48 * SizeConfig.heightMultiplier!,
      ),
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Container(
        height: 460 * SizeConfig.heightMultiplier!,
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 64 * SizeConfig.heightMultiplier!,
                ),
                //text
                Center(
                  child: Text(
                    'your_weight'.tr,
                    style: AppTextStyle.boldBlackText.copyWith(
                      color: Theme.of(context).textTheme.bodyText1?.color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 16 * SizeConfig.heightMultiplier!,
                ),

                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _weightController.currentWeight.value =
                              _weightController.currentWeight.value ~/ 2;
                          //  _spgController.targetWeight.value =
                          //      _spgController.targetWeight.value ~/ 2;
                          _weightController.weightType.value = "kg";
                        },
                        child: Container(
                          height: 28 * SizeConfig.heightMultiplier!,
                          width: 75 * SizeConfig.widthMultiplier!,
                          decoration: BoxDecoration(
                              color: _weightController.weightType == "kg"
                                  ? kGreenColor
                                  : Colors.transparent,
                              border: Border.all(
                                  color: _weightController.weightType == "kg"
                                      ? Colors.transparent
                                      : lightGrey),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8))),
                          child: Center(
                              child: Text(
                            'kg'.tr,
                            style: _weightController.weightType == "kg"
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
                          _weightController.currentWeight.value =
                              (_weightController.currentWeight.value * 2)
                                  .toInt();
                          //   _spgController.targetWeight.value =
                          //       (_spgController.targetWeight.value * 2).toInt();
                          _weightController.weightType.value = "lbs";
                        },
                        child: Container(
                          height: 28 * SizeConfig.heightMultiplier!,
                          width: 75 * SizeConfig.widthMultiplier!,
                          decoration: BoxDecoration(
                              color: _weightController.weightType != "kg"
                                  ? kGreenColor
                                  : Colors.transparent,
                              border: Border.all(
                                  color: _weightController.weightType != "kg"
                                      ? Colors.transparent
                                      : lightGrey),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8))),
                          child: Center(
                              child: Text(
                            'lb'.tr,
                            style: _weightController.weightType != "kg"
                                ? AppTextStyle.white400Text
                                : AppTextStyle.white400Text.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.color,
                                  ),
                          )),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 32 * SizeConfig.heightMultiplier!,
                ),
                Center(
                  child: Obx(
                    () => Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _weightController.currentWeight.value.toString(),
                          style: AppTextStyle.normalBlackText.copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyText1?.color,
                              fontSize: 48 * SizeConfig.textMultiplier!,
                              height: 0),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(width: 3 * SizeConfig.widthMultiplier!),
                        Text(
                            _weightController.weightType.value == "kg"
                                ? 'kg'.tr
                                : 'lb'.tr,
                            textAlign: TextAlign.start,
                            style: AppTextStyle.normalBlackText.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.color,
                                fontSize: 18 * SizeConfig.textMultiplier!))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 12 * SizeConfig.heightMultiplier!,
                ),
                Obx(
                  () => Padding(
                    padding: EdgeInsets.only(
                        left: 31 * SizeConfig.widthMultiplier!,
                        right: 31 * SizeConfig.widthMultiplier!),
                    child: _weightController.weightType.value != "kg"
                        ? RulerPicker(
                            controller: _weightController.rulerPickerController,
                            beginValue: 30,
                            endValue: 200,
                            initValue: 60,
                            scaleLineStyleList: const [
                              ScaleLineStyle(
                                  color: kGreenColor,
                                  width: 1.5,
                                  height: 30,
                                  scale: 0),
                              ScaleLineStyle(
                                  color: kGreenColor,
                                  width: 1,
                                  height: 15,
                                  scale: -1)
                            ],
                            onBuildRulerScalueText: (index, scaleValue) {
                              return (scaleValue * 2).toInt().toString() +
                                  "lbs";
                            },
                            onValueChange: (value) {
                              _weightController.currentWeight.value = value * 2;
                            },
                            width: MediaQuery.of(context).size.width -
                                132 * SizeConfig.widthMultiplier!,
                            height: 100 * SizeConfig.heightMultiplier!,
                            rulerScaleTextStyle: AppTextStyle.normalGreenText,
                            rulerBackgroundColor: LightGreen,
                            rulerMarginTop: 15,
                          )
                        : RulerPicker(
                            controller: _weightController.rulerPickerController,
                            beginValue: 30,
                            endValue: 200,
                            initValue: _weightController.currentWeight.value,
                            scaleLineStyleList: const [
                              ScaleLineStyle(
                                  color: kGreenColor,
                                  width: 1.5,
                                  height: 30,
                                  scale: 0),
                              ScaleLineStyle(
                                  color: kGreenColor,
                                  width: 1,
                                  height: 15,
                                  scale: -1)
                            ],
                            onBuildRulerScalueText: (index, scaleValue) {
                              return (scaleValue).toInt().toString() + "kg";
                            },
                            onValueChange: (value) {
                              _weightController.currentWeight.value = value;
                            },
                            width: MediaQuery.of(context).size.width -
                                132 * SizeConfig.widthMultiplier!,
                            height: 100 * SizeConfig.heightMultiplier!,
                            rulerScaleTextStyle: AppTextStyle.normalGreenText,
                            rulerBackgroundColor: LightGreen,
                            rulerMarginTop: 15,
                          ),
                  ),
                ),
                SizedBox(
                  height: 32 * SizeConfig.heightMultiplier!,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 66 * SizeConfig.widthMultiplier!),
                  child: ProceedButton(
                      title: 'okay'.tr,
                      onPressed: () {
                        print(_weightController.currentHeight.value);
                        Navigator.pop(context);
                      }),
                ),
                SizedBox(
                  height: 40 * SizeConfig.heightMultiplier!,
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
