import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button.dart';
import 'package:fitbasix/feature/spg/controller/spg_controller.dart';
import 'package:fitbasix/feature/spg/view/widgets/spg_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';

class SetWeight extends StatelessWidget {
  final SPGController _spgController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: SPGAppBar(
              title:
                  'page_count'.trParams({'pageNumber': "5", 'total_page': "8"}),
              onBack: () {
                Navigator.pop(context);
              },
              onSkip: () {}),
          preferredSize: const Size(double.infinity, kToolbarHeight)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: kGreenColor,
            height: 2 * SizeConfig.heightMultiplier!,
            width: Get.width * 0.625,
          ),
          SizedBox(
            height: 30 * SizeConfig.heightMultiplier!,
          ),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _spgController.currentWeight.value =
                        _spgController.currentWeight.value ~/ 2;
                    _spgController.targetWeight.value =
                        _spgController.targetWeight.value ~/ 2;
                    _spgController.weightType.value = "kg";
                  },
                  child: Container(
                    height: 36 * SizeConfig.heightMultiplier!,
                    width: 87 * SizeConfig.widthMultiplier!,
                    decoration: BoxDecoration(
                        color: _spgController.weightType == "kg"
                            ? kGreenColor
                            : Colors.transparent,
                        border: Border.all(
                            color: _spgController.weightType == "kg"
                                ? Colors.transparent
                                : lightGrey),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8))),
                    child: Center(
                        child: Text(
                      'kg'.tr,
                      style: _spgController.weightType == "kg"
                          ? AppTextStyle.white400Text
                          : AppTextStyle.white400Text
                              .copyWith(color: lightBlack),
                    )),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _spgController.currentWeight.value =
                        (_spgController.currentWeight.value * 2).toInt();
                    _spgController.targetWeight.value =
                        (_spgController.targetWeight.value * 2).toInt();
                    _spgController.weightType.value = "lbs";
                  },
                  child: Container(
                    height: 36 * SizeConfig.heightMultiplier!,
                    width: 87 * SizeConfig.widthMultiplier!,
                    decoration: BoxDecoration(
                        color: _spgController.weightType != "kg"
                            ? kGreenColor
                            : Colors.transparent,
                        border: Border.all(
                            color: _spgController.weightType != "kg"
                                ? Colors.transparent
                                : lightGrey),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8))),
                    child: Center(
                        child: Text(
                      'lb'.tr,
                      style: _spgController.weightType != "kg"
                          ? AppTextStyle.white400Text
                          : AppTextStyle.white400Text
                              .copyWith(color: lightBlack),
                    )),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20 * SizeConfig.heightMultiplier!,
          ),
          Center(
            child: Text(
              'ask_weight'.tr,
              style: AppTextStyle.boldBlackText,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 30 * SizeConfig.heightMultiplier!,
          ),
          Obx(
            () => Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _spgController.currentWeight.value.toString(),
                  style: AppTextStyle.normalBlackText.copyWith(
                      fontSize: 48 * SizeConfig.textMultiplier!, height: 0),
                  textAlign: TextAlign.center,
                ),
                SizedBox(width: 3 * SizeConfig.widthMultiplier!),
                Text(
                    _spgController.weightType.value == "kg" ? 'kg'.tr : 'lb'.tr,
                    textAlign: TextAlign.start,
                    style: AppTextStyle.normalBlackText
                        .copyWith(fontSize: 14 * SizeConfig.textMultiplier!))
              ],
            ),
          ),
          SizedBox(
            height: 12 * SizeConfig.heightMultiplier!,
          ),
          Obx(
            () => Center(
              child: _spgController.weightType.value != "kg"
                  ? RulerPicker(
                      controller: _spgController.rulerPickerController,
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
                            color: kGreenColor, width: 1, height: 15, scale: -1)
                      ],
                      onBuildRulerScalueText: (index, scaleValue) {
                        return (scaleValue * 2).toInt().toString() + "lbs";
                      },
                      onValueChange: (value) {
                        _spgController.currentWeight.value = value * 2;
                      },
                      width: MediaQuery.of(context).size.width -
                          48 * SizeConfig.widthMultiplier!,
                      height: 100 * SizeConfig.heightMultiplier!,
                      rulerScaleTextStyle: AppTextStyle.normalGreenText,
                      rulerBackgroundColor: LightGreen,
                      rulerMarginTop: 15,
                    )
                  : RulerPicker(
                      controller: _spgController.rulerPickerController,
                      beginValue: 30,
                      endValue: 200,
                      initValue: _spgController.currentWeight.value,
                      scaleLineStyleList: const [
                        ScaleLineStyle(
                            color: kGreenColor,
                            width: 1.5,
                            height: 30,
                            scale: 0),
                        ScaleLineStyle(
                            color: kGreenColor, width: 1, height: 15, scale: -1)
                      ],
                      onBuildRulerScalueText: (index, scaleValue) {
                        return (scaleValue).toInt().toString() + "kg";
                      },
                      onValueChange: (value) {
                        _spgController.currentWeight.value = value;
                      },
                      width: MediaQuery.of(context).size.width -
                          48 * SizeConfig.widthMultiplier!,
                      height: 100 * SizeConfig.heightMultiplier!,
                      rulerScaleTextStyle: AppTextStyle.normalGreenText,
                      rulerBackgroundColor: LightGreen,
                      rulerMarginTop: 15,
                    ),
            ),
          ),
          SizedBox(
            height: 30 * SizeConfig.heightMultiplier!,
          ),
          Center(
            child: Text(
              'ask_target_weight'.tr,
              style: AppTextStyle.boldBlackText,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 40 * SizeConfig.heightMultiplier!,
          ),
          Obx(
            () => Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _spgController.targetWeight.value.toString(),
                  style: AppTextStyle.normalBlackText.copyWith(
                      fontSize: 48 * SizeConfig.textMultiplier!, height: 0),
                ),
                SizedBox(width: 3 * SizeConfig.widthMultiplier!),
                Text(
                    _spgController.weightType.value == "kg" ? 'kg'.tr : 'lb'.tr,
                    textAlign: TextAlign.start,
                    style: AppTextStyle.normalBlackText
                        .copyWith(fontSize: 14 * SizeConfig.textMultiplier!))
              ],
            ),
          ),
          SizedBox(
            height: 12 * SizeConfig.heightMultiplier!,
          ),
          Obx(
            () => Center(
              child: _spgController.weightType.value != "kg"
                  ? RulerPicker(
                      controller: _spgController.targetRulerPickerController,
                      beginValue: 30,
                      endValue: 200,
                      initValue: _spgController.targetWeight.value,
                      scaleLineStyleList: const [
                        ScaleLineStyle(
                            color: kGreenColor,
                            width: 1.5,
                            height: 30,
                            scale: 0),
                        ScaleLineStyle(
                            color: kGreenColor, width: 1, height: 15, scale: -1)
                      ],
                      onBuildRulerScalueText: (index, scaleValue) {
                        return (scaleValue * 2).toInt().toString() + "lbs";
                      },
                      onValueChange: (value) {
                        _spgController.targetWeight.value = value * 2;
                      },
                      width: MediaQuery.of(context).size.width -
                          48 * SizeConfig.widthMultiplier!,
                      height: 100 * SizeConfig.heightMultiplier!,
                      rulerScaleTextStyle: AppTextStyle.normalGreenText,
                      rulerBackgroundColor: LightGreen,
                      rulerMarginTop: 15,
                    )
                  : RulerPicker(
                      controller: _spgController.targetRulerPickerController,
                      beginValue: 30,
                      endValue: 200,
                      initValue: _spgController.targetWeight.value,
                      onBuildRulerScalueText: (index, scaleValue) {
                        return (scaleValue).toInt().toString() + "kg";
                      },
                      scaleLineStyleList: const [
                        ScaleLineStyle(
                            color: kGreenColor,
                            width: 1.5,
                            height: 30,
                            scale: 0),
                        ScaleLineStyle(
                            color: kGreenColor, width: 1, height: 15, scale: -1)
                      ],
                      onValueChange: (value) {
                        _spgController.targetWeight.value = value;
                      },
                      width: MediaQuery.of(context).size.width -
                          48 * SizeConfig.widthMultiplier!,
                      height: 100 * SizeConfig.heightMultiplier!,
                      rulerScaleTextStyle: AppTextStyle.normalGreenText,
                      rulerBackgroundColor: LightGreen,
                      rulerMarginTop: 15,
                    ),
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 16 * SizeConfig.widthMultiplier!),
            child: ProceedButton(
                title: 'proceed'.tr,
                onPressed: () {
                  if (_spgController.weightType.value == "kg") {
                    print(_spgController.targetWeight.value);
                    print(_spgController.currentWeight.value);
                  } else {
                    print((_spgController.targetWeight.value / 2.205).toInt());
                    print((_spgController.currentWeight.value / 2.205).toInt());
                  }
                  if (_spgController.selectedGenderIndex.value.serialId == 1) {
                    _spgController.bodyFatData!.value = _spgController
                        .spgData.value.response!.data!.bodyTypeMale!;
                  } else {
                    _spgController.bodyFatData!.value = _spgController
                        .spgData.value.response!.data!.bodyTypeFemale!;
                  }
                  Navigator.pushNamed(context, RouteName.setBodyFat);
                }),
          ),
          SizedBox(
            height: 16 * SizeConfig.heightMultiplier!,
          )
        ],
      ),
    );
  }
}
