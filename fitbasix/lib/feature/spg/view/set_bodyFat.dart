import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button.dart';
import 'package:fitbasix/feature/spg/controller/spg_controller.dart';
import 'package:fitbasix/feature/spg/view/set_goal_screen.dart';
import 'package:fitbasix/feature/spg/view/widgets/spg_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SetBodyFat extends StatelessWidget {
  final SPGController _spgController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
          child: SPGAppBar(
              title:
                  'page_count'.trParams({'pageNumber': "6", 'total_page': "8"}),
              onBack: () {
                Navigator.pop(context);
              },
              onSkip: () {}),
          preferredSize: const Size(double.infinity, kToolbarHeight)),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(children: [
                  Container(
                    color: kPureWhite,
                    height: 2 * SizeConfig.heightMultiplier!,
                    width: Get.width * (8 / 8),
                  ),
                  Container(
                    color: kGreenColor,
                    height: 2 * SizeConfig.heightMultiplier!,
                    width: Get.width * 0.75,
                  ),
                ]),
                SizedBox(
                  height: 40 * SizeConfig.heightMultiplier!,
                ),
                Center(
                  child: Text(
                    'set_body_fat'.tr,
                    style: AppTextStyle.boldBlackText.copyWith(
                        color: Theme.of(context).textTheme.bodyText1!.color),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 30 * SizeConfig.heightMultiplier!,
                ),
                GridView.builder(
                    itemCount: _spgController.bodyFatData!.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 5 * SizeConfig.widthMultiplier!),
                    itemBuilder: (_, index) {
                      // if (_spgController.selectedBodyFat.value.serialId == null) {
                      //   _spgController.selectedBodyFat.value =
                      //       _spgController.bodyFatData![0];
                      // }
                      return Obx(
                        () => BodyFatTile(
                          imageUrl: _spgController.bodyFatData![index].image,
                          StartRange:
                              _spgController.bodyFatData![index].start.toString(),
                          EndRange: (_spgController.bodyFatData![index].start! > 39)
                              ? "+"
                              : _spgController.bodyFatData![index].end.toString(),
                          onTap: () {
                            _spgController.selectedBodyFat.value =
                                _spgController.bodyFatData![index];
                          },
                          isSelected: _spgController.selectedBodyFat.value.serialId ==
                                  _spgController.bodyFatData![index].serialId
                              ? true
                              : false,
                        ),
                      );
                    }),

                SizedBox(
                  height: 46 * SizeConfig.heightMultiplier!,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 16 * SizeConfig.heightMultiplier!,horizontal: 16*SizeConfig.widthMultiplier!),
              child: ProceedButton(
                  title: 'proceed'.tr,
                  onPressed: () {
                    print(_spgController.selectedBodyFat.value.serialId);
                    Navigator.pushNamed(context, RouteName.setFoodType);
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

class BodyFatTile extends StatelessWidget {
  final String? imageUrl;
  final String StartRange;
  final VoidCallback onTap;
  final String EndRange;
  final bool? isSelected;
  BodyFatTile(
      {required this.imageUrl,
      required this.StartRange,
      required this.EndRange,
      required this.onTap,
      required this.isSelected});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Container(
                    height: 90 * SizeConfig.widthMultiplier!,
                    width: 90 * SizeConfig.widthMultiplier!,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1.5 * SizeConfig.widthMultiplier!,
                          color:
                              isSelected! ? kGreenColor : Colors.transparent),
                      borderRadius: BorderRadius.circular(
                          8 * SizeConfig.widthMultiplier!),
                    ),
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: imageUrl.toString(),
                          placeholder: (context, url) => ShimmerEffect(),
                          errorWidget: (context, url, error) => ShimmerEffect(),
                          height: 98.67 * SizeConfig.widthMultiplier!,
                          width: 98.67 * SizeConfig.widthMultiplier!,
                          fit: BoxFit.cover,
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: 5 * SizeConfig.widthMultiplier!,
                                top: 5 * SizeConfig.widthMultiplier!),
                            child: Container(
                              height: 15 * SizeConfig.widthMultiplier!,
                              width: 15 * SizeConfig.widthMultiplier!,
                              child: isSelected!
                                  ? SvgPicture.asset(ImagePath.greenRightTick)
                                  : Container(),
                            ),
                          ),
                        )
                      ],
                    )),
              ],
            ),
            SizedBox(height: 17 * SizeConfig.heightMultiplier!),
            Text(StartRange + (EndRange == "+" ? "" : "-") + EndRange + "%",
                style: AppTextStyle.normalWhiteText.copyWith(
                    height: 0,
                    color: Theme.of(context).textTheme.bodyText1!.color)),
            SizedBox(height: 6 * SizeConfig.heightMultiplier!)
          ],
        ),
      ),
    );
  }
}
