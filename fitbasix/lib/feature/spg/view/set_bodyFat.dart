import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button.dart';
import 'package:fitbasix/feature/spg/controller/spg_controller.dart';
import 'package:fitbasix/feature/spg/view/widgets/spg_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SetBodyFat extends StatelessWidget {
  final SPGController _spgController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPureWhite,
      appBar: PreferredSize(
          child: SPGAppBar(
              title:
                  'page_count'.trParams({'pageNumber': "6", 'total_page': "8"}),
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
            width: Get.width * 0.75,
          ),
          SizedBox(
            height: 40 * SizeConfig.heightMultiplier!,
          ),
          Center(
            child: Text(
              'set_body_fat'.tr,
              style: AppTextStyle.boldBlackText,
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
                  crossAxisSpacing: 10 * SizeConfig.heightMultiplier!),
              itemBuilder: (_, index) {
                if (_spgController.selectedBodyFat.value.serialId == null) {
                  _spgController.selectedBodyFat.value =
                      _spgController.bodyFatData![0];
                }
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
                      print(_spgController.selectedBodyFat.value.serialId);
                      print(_spgController.bodyFatData![index].serialId);
                    },
                    isSelected: _spgController.selectedBodyFat.value.serialId ==
                            _spgController.bodyFatData![index].serialId
                        ? true
                        : false,
                  ),
                );
              }),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 16 * SizeConfig.widthMultiplier!),
            child: ProceedButton(
                title: 'proceed'.tr,
                onPressed: () {
                  print(_spgController.selectedBodyFat.value.serialId);
                  Navigator.pushNamed(context, RouteName.setFoodType);
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
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: imageUrl.toString(),
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
                style: AppTextStyle.normalWhiteText
                    .copyWith(height: 0, color: lightBlack)),
            SizedBox(height: 6 * SizeConfig.heightMultiplier!)
          ],
        ),
      ),
    );
  }
}
