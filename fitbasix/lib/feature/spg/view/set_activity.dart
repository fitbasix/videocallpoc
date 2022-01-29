import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button.dart';
import 'package:fitbasix/feature/spg/controller/spg_controller.dart';
import 'package:fitbasix/feature/spg/view/widgets/spg_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class SetActivity extends StatelessWidget {
  SetActivity({Key? key}) : super(key: key);
  final SPGController _spgController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: SPGAppBar(
              title:
                  'page_count'.trParams({'pageNumber': "7", 'total_page': "7"}),
              onBack: () {
                Navigator.pop(context);
              },
              onSkip: () {}),
          preferredSize: const Size(double.infinity, kToolbarHeight)),
      body: SafeArea(
          child: Container(
        margin: EdgeInsets.only(
            top: 42 * SizeConfig.heightMultiplier!,
            left: 16 * SizeConfig.widthMultiplier!,
            right: 16 * SizeConfig.widthMultiplier!,
            bottom: 16 * SizeConfig.heightMultiplier!),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'how_active_are_you'.tr,
              style: AppTextStyle.boldBlackText,
            ),
            SizedBox(
              height: 48 * SizeConfig.heightMultiplier!,
            ),
            Obx(
              () => SvgPicture.network(
                _spgController
                    .spgData
                    .value
                    .response!
                    .data!
                    .activenessType![
                        _spgController.activityNumber.value.toInt()]
                    .image!,
                height: 160 * SizeConfig.heightMultiplier!,
                width: 160 * SizeConfig.heightMultiplier!,
              ),
            ),
            SizedBox(
              height: 48 * SizeConfig.heightMultiplier!,
            ),
            SizedBox(
              height: 63 * SizeConfig.heightMultiplier!,
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                  thumbColor: kGreenColor,
                  activeTrackColor: kGreenColor,
                  trackHeight: 12 * SizeConfig.heightMultiplier!,
                  inactiveTickMarkColor: kGreenColor,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12)),
              child: Obx(() => Padding(
                    padding: EdgeInsets.only(
                        left: 46 * SizeConfig.widthMultiplier!,
                        right: 46 * SizeConfig.widthMultiplier!),
                    child: Slider(
                      min: 0.0,
                      max: 4.0,
                      value: _spgController.activityNumber.value,
                      onChanged: (value) {
                        _spgController.activityNumber.value = value;
                      },
                      divisions: 4,
                      inactiveColor: sliderColor,
                    ),
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 54 * SizeConfig.widthMultiplier!,
                  right: 54 * SizeConfig.widthMultiplier!),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'low'.tr,
                    style: AppTextStyle.normalBlackText.copyWith(
                        fontSize: 14 * SizeConfig.textMultiplier!,
                        color: hintGrey),
                  ),
                  Text(
                    'high'.tr,
                    style: AppTextStyle.normalBlackText.copyWith(
                        fontSize: 14 * SizeConfig.textMultiplier!,
                        color: hintGrey),
                  )
                ],
              ),
            ),
            Spacer(),
            ProceedButton(title: 'proceed'.tr, onPressed: () {})
          ],
        ),
      )),
    );
  }
}
