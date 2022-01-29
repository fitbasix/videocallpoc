import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button.dart';
import 'package:fitbasix/feature/spg/controller/spg_controller.dart';
import 'package:fitbasix/feature/spg/services/spg_service.dart';
import 'package:fitbasix/feature/spg/view/widgets/spg_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class SetHeight extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SPGController _spgController = Get.find();
    return Scaffold(
      appBar: PreferredSize(
          child: SPGAppBar(
              title:
                  'page_count'.trParams({'pageNumber': "4", 'total_page': "8"}),
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
            width: Get.width * 0.50,
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
                    _spgController.heightType.value = "inch";
                  },
                  child: Container(
                    height: 36 * SizeConfig.heightMultiplier!,
                    width: 87 * SizeConfig.widthMultiplier!,
                    decoration: BoxDecoration(
                        color: _spgController.heightType == "inch"
                            ? kGreenColor
                            : Colors.transparent,
                        border: Border.all(
                            color: _spgController.heightType == "inch"
                                ? Colors.transparent
                                : lightGrey),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8))),
                    child: Center(
                        child: Text(
                      'inch'.tr,
                      style: _spgController.heightType == "inch"
                          ? AppTextStyle.white400Text
                          : AppTextStyle.white400Text
                              .copyWith(color: lightBlack),
                    )),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _spgController.heightType.value = "cm";
                  },
                  child: Container(
                    height: 36 * SizeConfig.heightMultiplier!,
                    width: 87 * SizeConfig.widthMultiplier!,
                    decoration: BoxDecoration(
                        color: _spgController.heightType != "inch"
                            ? kGreenColor
                            : Colors.transparent,
                        border: Border.all(
                            color: _spgController.heightType != "inch"
                                ? Colors.transparent
                                : lightGrey),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8))),
                    child: Center(
                        child: Text(
                      'cm'.tr,
                      style: _spgController.heightType != "inch"
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
              'ask_height'.tr,
              style: AppTextStyle.boldBlackText,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 70 * SizeConfig.heightMultiplier!,
          ),
          Center(
            child: Obx(
              () => _spgController.heightType.value != "inch"
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _spgController.currentHeight.value.toString(),
                          style: AppTextStyle.normalBlackText.copyWith(
                              fontSize: 48 * SizeConfig.textMultiplier!,
                              height: 0),
                        ),
                        SizedBox(width: 4 * SizeConfig.widthMultiplier!),
                        Text("cm",
                            textAlign: TextAlign.start,
                            style: AppTextStyle.normalBlackText.copyWith(
                                fontSize: 14 * SizeConfig.textMultiplier!,
                                height: 0))
                      ],
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          (_spgController.currentHeight.value * 0.0328084)
                              .toString()
                              .split(".")[0],
                          style: AppTextStyle.normalBlackText.copyWith(
                              fontSize: 48 * SizeConfig.textMultiplier!,
                              height: 0),
                        ),
                        SizedBox(width: 4 * SizeConfig.widthMultiplier!),
                        Text("ft",
                            textAlign: TextAlign.start,
                            style: AppTextStyle.normalBlackText.copyWith(
                                fontSize: 14 * SizeConfig.textMultiplier!,
                                height: 0)),
                        SizedBox(width: 7 * SizeConfig.widthMultiplier!),
                        Text(
                          (int.parse((_spgController.currentHeight.value *
                                          0.0328084)
                                      .toString()
                                      .substring(2, 4)) *
                                  0.12)
                              .toString()
                              .substring(0, 2)
                              .replaceAll(".", ""),
                          style: AppTextStyle.normalBlackText.copyWith(
                              fontSize: 48 * SizeConfig.textMultiplier!,
                              height: 0),
                        ),
                        SizedBox(width: 4 * SizeConfig.widthMultiplier!),
                        Text("in",
                            textAlign: TextAlign.start,
                            style: AppTextStyle.normalBlackText.copyWith(
                                fontSize: 14 * SizeConfig.textMultiplier!,
                                height: 0))
                      ],
                    ),
            ),
          ),
          SizedBox(
            height: 80 * SizeConfig.heightMultiplier!,
          ),
          Padding(
            padding: EdgeInsets.only(left: 24 * SizeConfig.widthMultiplier!),
            child: RulerPicker(
              controller: _spgController.heightRulerPickerController,
              beginValue: 120,
              endValue: 250,
              initValue: _spgController.currentHeight.value,
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
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5))),
              onValueChange: (value) {
                _spgController.currentHeight.value = value;
              },
              onBuildRulerScalueText: (index, scaleValue) {
                return scaleValue.toString() + "cm";
              },
              width: Get.width - 48 * SizeConfig.widthMultiplier!,
              height: 100 * SizeConfig.heightMultiplier!,
              rulerScaleTextStyle: AppTextStyle.normalGreenText,
              rulerBackgroundColor: LightGreen,
              rulerMarginTop: 25,
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 16 * SizeConfig.widthMultiplier!),
            child: ProceedButton(
                title: 'proceed'.tr,
                onPressed: () {
                  print(_spgController.currentHeight.value);
                  Navigator.pushNamed(context, RouteName.setWeight);
                }),
          ),
          SizedBox(
            height: 16 * SizeConfig.heightMultiplier!,
          ),
        ],
      ),
    );
  }
}
