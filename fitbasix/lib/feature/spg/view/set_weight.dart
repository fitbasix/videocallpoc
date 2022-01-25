import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button.dart';
import 'package:fitbasix/feature/spg/controller/spg_controller.dart';
import 'package:fitbasix/feature/spg/view/widgets/spg_app_bar.dart';
import 'package:flutter/material.dart';
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
              title: '5 of 8',
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
            height: 40 * SizeConfig.heightMultiplier!,
          ),
          Center(
            child: Text(
              'ask_weight'.tr,
              style: AppTextStyle.boldBlackText,
              textAlign: TextAlign.center,
            ),
          ),
          Obx(
            () => Center(
              child: Text(
                _spgController.currentWeight.value.toString(),
                style: AppTextStyle.normalBlackText
                    .copyWith(fontSize: 48 * SizeConfig.textMultiplier!),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: 12 * SizeConfig.heightMultiplier!,
          ),
          RulerPicker(
            controller: _spgController.rulerPickerController,
            beginValue: 0,
            endValue: 200,
            initValue: _spgController.currentWeight.value,
            scaleLineStyleList: const [
              ScaleLineStyle(
                  color: kGreenColor, width: 1.5, height: 30, scale: 0),
              ScaleLineStyle(
                  color: kGreenColor, width: 1, height: 15, scale: -1)
            ],
            onValueChange: (value) {
              _spgController.currentWeight.value = value;
            },
            width: MediaQuery.of(context).size.width,
            height: 100 * SizeConfig.heightMultiplier!,
            rulerScaleTextStyle: AppTextStyle.normalGreenText,
            rulerBackgroundColor: LightGreen,
            rulerMarginTop: 15,
          ),
          SizedBox(
            height: 40 * SizeConfig.heightMultiplier!,
          ),
          Center(
            child: Text(
              'ask_target_weight'.tr,
              style: AppTextStyle.boldBlackText,
              textAlign: TextAlign.center,
            ),
          ),
          Obx(
            () => Center(
              child: Text(
                _spgController.targetWeight.value.toString(),
                style: AppTextStyle.normalBlackText
                    .copyWith(fontSize: 48 * SizeConfig.textMultiplier!),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: 12 * SizeConfig.heightMultiplier!,
          ),
          RulerPicker(
            controller: _spgController.targetRulerPickerController,
            beginValue: 0,
            endValue: 200,
            initValue: _spgController.targetWeight.value,
            scaleLineStyleList: const [
              ScaleLineStyle(
                  color: kGreenColor, width: 1.5, height: 30, scale: 0),
              ScaleLineStyle(
                  color: kGreenColor, width: 1, height: 15, scale: -1)
            ],
            onValueChange: (value) {
              _spgController.targetWeight.value = value;
            },
            width: MediaQuery.of(context).size.width,
            height: 100 * SizeConfig.heightMultiplier!,
            rulerScaleTextStyle: AppTextStyle.normalGreenText,
            rulerBackgroundColor: LightGreen,
            rulerMarginTop: 15,
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 16 * SizeConfig.widthMultiplier!),
            child: ProceedButton(
                title: 'proceed'.tr,
                onPressed: () {
                  Navigator.pushNamed(context, RouteName.setDob);
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
