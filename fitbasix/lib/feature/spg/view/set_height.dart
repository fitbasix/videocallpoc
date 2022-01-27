import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button.dart';
import 'package:fitbasix/feature/spg/controller/spg_controller.dart';
import 'package:fitbasix/feature/spg/services/spg_service.dart';
import 'package:fitbasix/feature/spg/view/widgets/spg_app_bar.dart';
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
              title: '4 of 8',
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
            height: 40 * SizeConfig.heightMultiplier!,
          ),
          Center(
            child: Text(
              'ask_height'.tr,
              style: AppTextStyle.boldBlackText,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 160.0 * SizeConfig.heightMultiplier!),
            child: Container(
              height: 312 * SizeConfig.heightMultiplier!,
              width: Get.width,
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 70 * SizeConfig.heightMultiplier!,
                          right: 208 * SizeConfig.widthMultiplier!),
                      child: Obx(
                        () => Row(
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
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Padding(
                      padding: EdgeInsets.only(left: 0),
                      child: Transform.rotate(
                        angle: -math.pi / 2,
                        child: RulerPicker(
                          controller:
                              _spgController.heightRulerPickerController,
                          beginValue: 120,
                          endValue: 250,
                          initValue: _spgController.currentHeight.value,
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
                          onValueChange: (value) {
                            _spgController.currentHeight.value = value;
                          },
                          width: 312 * SizeConfig.heightMultiplier!,
                          height: 100 * SizeConfig.widthMultiplier!,
                          rulerScaleTextStyle: AppTextStyle.normalGreenText,
                          rulerBackgroundColor: kLightGreen,
                          rulerMarginTop: 25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 16 * SizeConfig.widthMultiplier!),
            child: ProceedButton(
                title: 'proceed'.tr,
                onPressed: () async {
                  await SPGService.updateSPGData(
                      null,
                      null,
                      _spgController.currentHeight.value.toString(),
                      null,
                      null);
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
