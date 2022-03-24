import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/Home/view/Home_page.dart';
import 'package:fitbasix/feature/posts/services/createPost_Services.dart';
import 'package:fitbasix/feature/spg/controller/spg_controller.dart';
import 'package:fitbasix/feature/spg/services/spg_service.dart';
import 'package:fitbasix/feature/spg/view/set_goal_screen.dart';
import 'package:fitbasix/feature/spg/view/widgets/spg_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class SetActivity extends StatelessWidget {
  SetActivity({Key? key}) : super(key: key);
  final SPGController _spgController = Get.find();
  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: SPGAppBar(
              title:
                  'page_count'.trParams({'pageNumber': "8", 'total_page': "8"}),
              onBack: () {
                Navigator.pop(context);
              },
              onSkip: () {}),
          preferredSize: const Size(double.infinity, kToolbarHeight)),
      body: SafeArea(
          child: Stack(
        children: [
          Container(
            color: kGreenColor,
            height: 2 * SizeConfig.heightMultiplier!,
            width: Get.width * (8 / 8),
          ),
          Container(
            margin: EdgeInsets.only(
                top: 42 * SizeConfig.heightMultiplier!,
                bottom: 16 * SizeConfig.heightMultiplier!),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 16 * SizeConfig.widthMultiplier!,
                      right: 16 * SizeConfig.widthMultiplier!),
                  child: Text(
                    'how_active_are_you'.tr,
                    style: AppTextStyle.boldBlackText.copyWith(
                        color: Theme.of(context).textTheme.bodyText1!.color),
                  ),
                ),
                SizedBox(
                  height: 48 * SizeConfig.heightMultiplier!,
                ),
                Obx(
                  () => Container(
                    height: 346 * SizeConfig.heightMultiplier!,
                    width: Get.width,
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: _spgController
                              .spgData
                              .value
                              .response!
                              .data!
                              .activenessType![
                                  _spgController.activityNumber.value.toInt()]
                              .image!,
                          placeholder: (context, url) => ShimmerEffect(),
                          errorWidget: (context, url, error) => ShimmerEffect(),
                          height: 346 * SizeConfig.heightMultiplier!,
                          width: Get.width,
                          fit: BoxFit.cover,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            color: Theme.of(context)
                                .primaryColorDark
                                .withOpacity(0.7),
                            width: Get.width,
                            height: 75 * SizeConfig.heightMultiplier!,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(() => Text(
                                    _spgController
                                        .spgData
                                        .value
                                        .response!
                                        .data!
                                        .activenessType![_spgController
                                            .activityNumber.value
                                            .toInt()]
                                        .title
                                        .toString(),
                                    style: AppTextStyle.normalWhiteText
                                        .copyWith(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .color))),
                                SizedBox(
                                  height: 8 * SizeConfig.heightMultiplier!,
                                ),
                                Obx(
                                  () => Text(
                                      _spgController
                                          .spgData
                                          .value
                                          .response!
                                          .data!
                                          .activenessType![_spgController
                                              .activityNumber.value
                                              .toInt()]
                                          .subTitle
                                          .toString(),
                                      style: AppTextStyle.normalBlackText
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .color,
                                              fontSize: 14 *
                                                  SizeConfig.textMultiplier!)),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20 * SizeConfig.heightMultiplier!,
                ),
                SizedBox(
                  height: 20 * SizeConfig.heightMultiplier!,
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                      thumbColor: kGreenColor,
                      activeTrackColor: kGreenColor,
                      trackHeight: 12 * SizeConfig.heightMultiplier!,
                      inactiveTickMarkColor: kGreenColor,
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 12)),
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
                      left: 60 * SizeConfig.widthMultiplier!,
                      right: 60 * SizeConfig.widthMultiplier!),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'low'.tr,
                        style: AppTextStyle.normalBlackText.copyWith(
                            fontSize: 14 * SizeConfig.textMultiplier!,
                            color:
                                Theme.of(context).textTheme.bodyText1!.color),
                      ),
                      Text(
                        'high'.tr,
                        style: AppTextStyle.normalBlackText.copyWith(
                            fontSize: 14 * SizeConfig.textMultiplier!,
                            color:
                                Theme.of(context).textTheme.bodyText1!.color),
                      )
                    ],
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(
                      left: 16 * SizeConfig.widthMultiplier!,
                      right: 16 * SizeConfig.widthMultiplier!),
                  child: Obx(() => _spgController.isLoading.value
                      ? Center(
                          child: CustomizedCircularProgress(),
                        )
                      : ProceedButton(
                          title: 'proceed'.tr,
                          onPressed: () async {
                            _spgController.isLoading.value = true;
                            await SPGService.updateSPGData(
                                _spgController.selectedGoalIndex.value.serialId,
                                _spgController
                                    .selectedGenderIndex.value.serialId,
                                _spgController.selectedDate.value,
                                _spgController.currentHeight.value,
                                _spgController.weightType == "kg"
                                    ? _spgController.targetWeight.value
                                    : _spgController.targetWeight.value ~/
                                        2.205,
                                _spgController.weightType == "kg"
                                    ? _spgController.currentWeight.value
                                    : _spgController.currentHeight.value ~/
                                        2.205,
                                _spgController.activityNumber.value.toInt(),
                                _spgController.selectedBodyFat.value.serialId,
                                _spgController
                                    .selectedFoodIndex.value.serialId);
                            homeController.userProfileData.value =
                                await CreatePostService.getUserProfile();
                            homeController.spgStatus.value = true;
                            _spgController.isLoading.value = false;
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => HomeAndTrainerPage()),
                                (route) => false);
                          })),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
