import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button.dart';
import 'package:fitbasix/feature/spg/controller/spg_controller.dart';
import 'package:fitbasix/feature/spg/view/set_goal_screen.dart';
import 'package:fitbasix/feature/spg/view/widgets/spg_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class SetFoodType extends StatelessWidget {
  SetFoodType({Key? key}) : super(key: key);

  final SPGController _spgController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: SPGAppBar(
              title:
                  'page_count'.trParams({'pageNumber': "7", 'total_page': "8"}),
              onBack: () {
                Navigator.pop(context);
              },
              onSkip: () {}),
          preferredSize: const Size(double.infinity, kToolbarHeight)),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(children: [
            Container(
              color: Theme.of(context).primaryColor,
              height: 2 * SizeConfig.heightMultiplier!,
              width: Get.width,
            ),
            Container(
              color: kGreenColor,
              height: 2 * SizeConfig.heightMultiplier!,
              width: Get.width * (7 / 8),
            ),
          ]),
          Padding(
            padding: EdgeInsets.only(
                left: 16 * SizeConfig.widthMultiplier!,
                right: 16 * SizeConfig.widthMultiplier!,
                top: 40 * SizeConfig.heightMultiplier!,
                bottom: 16 * SizeConfig.widthMultiplier!),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'set_food_type'.tr,
                  style: AppTextStyle.boldBlackText.copyWith(
                      color: Theme.of(context).textTheme.bodyText1!.color),
                ),
                SizedBox(
                  height: 40 * SizeConfig.heightMultiplier!,
                ),
                GridView.builder(
                    itemCount: _spgController
                        .spgData.value.response!.data!.foodType!.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16 * SizeConfig.widthMultiplier!,
                      mainAxisSpacing: 16 * SizeConfig.widthMultiplier!,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      // if (_spgController.selectedFoodIndex.value.serialId ==
                      //     null) {
                      //   _spgController.selectedFoodIndex.value = _spgController
                      //       .spgData.value.response!.data!.foodType![0];
                      // }
                      return Obx(() => GoalCard(
                            title: _spgController.spgData.value.response!.data!
                                .foodType![index].name!,
                            imageUrl: _spgController.spgData.value.response!
                                .data!.foodType![index].image!,
                            onTap: () {
                              _spgController.selectedFoodIndex.value =
                                  _spgController.spgData.value.response!.data!
                                      .foodType![index];
                            },
                            isSelected: _spgController.spgData.value.response!
                                        .data!.foodType![index] ==
                                    _spgController.selectedFoodIndex.value
                                ? true
                                : false,
                          ));
                    })
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(
              () => GestureDetector(
                onTap: _spgController.selectedFoodIndex.value.id != null
                    ? () {
                  Navigator.pushNamed(context, RouteName.setActivity);
                      }
                    : null,
                child: Container(
                  width: Get.width,
                  height: 48 * SizeConfig.heightMultiplier!,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(8 * SizeConfig.heightMultiplier!),
                    color: _spgController.selectedFoodIndex.value.id != null
                        ? kgreen49
                        : hintGrey,
                  ),
                  child: Center(
                    child: Text(
                      'proceed'.tr,
                      style: AppTextStyle.normalWhiteText.copyWith(
                          color: _spgController.selectedFoodIndex.value.id != null
                              ? kPureWhite
                              : greyBorder),
                    ),
                  ),
                ),
              ),
            ),
          )

          //   ProceedButton(
          //       title: 'proceed'.tr,
          //       onPressed: () {
          //         Navigator.pushNamed(context, RouteName.setActivity);
          //       }),
          // )
        ],
      )),
    );
  }
}

class FoodTile extends StatelessWidget {
  const FoodTile(
      {Key? key,
      required this.title,
      required this.imageUrl,
      required this.onTap,
      this.isSelected = false})
      : super(key: key);

  final String title;
  final String imageUrl;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: EdgeInsets.only(top: 8 * SizeConfig.heightMultiplier!),
          padding: EdgeInsets.only(left: 24 * SizeConfig.widthMultiplier!),
          height: 70 * SizeConfig.heightMultiplier!,
          decoration: BoxDecoration(
              color: isSelected ? kSelectedGreen : kPureWhite,
              border: Border.all(color: isSelected ? kGreenColor : kLightGrey),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: -2,
                    offset: Offset(0, 4))
              ]),
          child: Row(
            children: [
              Container(
                  height: 60 * SizeConfig.heightMultiplier!,
                  width: 60 * SizeConfig.heightMultiplier!,
                  child: CachedNetworkImage(
                    height: 60 * SizeConfig.heightMultiplier!,
                    width: 60 * SizeConfig.heightMultiplier!,
                    imageUrl: imageUrl,
                  )),
              SizedBox(
                width: 15 * SizeConfig.widthMultiplier!,
              ),
              Text(
                title,
                style: AppTextStyle.boldBlackText
                    .copyWith(fontSize: 16 * SizeConfig.textMultiplier!),
              ),
            ],
          )),
    );
  }
}
