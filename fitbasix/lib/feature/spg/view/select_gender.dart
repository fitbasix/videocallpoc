import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button.dart';
import 'package:fitbasix/feature/spg/controller/spg_controller.dart';
import 'package:fitbasix/feature/spg/view/widgets/spg_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SelectGenderScreen extends StatelessWidget {
  SelectGenderScreen({Key? key}) : super(key: key);

  final SPGController _spgController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPureWhite,
      appBar: PreferredSize(
          child: SPGAppBar(
              title: '2 of 8',
              onBack: () {
                Navigator.pop(context);
              },
              onSkip: () {}),
          preferredSize: const Size(double.infinity, kToolbarHeight)),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: kGreenColor,
            height: 2 * SizeConfig.heightMultiplier!,
            width: Get.width / 8 * 2,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 16 * SizeConfig.widthMultiplier!,
                right: 16 * SizeConfig.widthMultiplier!,
                top: 40 * SizeConfig.heightMultiplier!,
                bottom: 16 * SizeConfig.widthMultiplier!),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'gender_select_heading'.tr,
                  style: AppTextStyle.boldBlackText,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 40 * SizeConfig.heightMultiplier!,
                ),
                Container(
                  height: 202 * SizeConfig.heightMultiplier!,
                  child: ListView.builder(
                      itemCount: _spgController
                          .spgData.value.response!.data!.genderType!.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      // physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (_, index) {
                        return Obx(() => Padding(
                              padding: index == 0
                                  ? EdgeInsets.only(
                                      right: 16 * SizeConfig.widthMultiplier!)
                                  : EdgeInsets.all(0),
                              child: GenderCard(
                                title: _spgController.spgData.value.response!
                                    .data!.genderType![index].name!,
                                imageUrl: _spgController.spgData.value.response!
                                    .data!.genderType![index].image!,
                                onTap: () {
                                  _spgController.selectedGenderIndex.value =
                                      index;

                                  _spgController.updatedGenderStatus(
                                      _spgController.selectedGenderIndex.value);
                                },
                                isSelected:
                                    _spgController.selectedGenderIndex.value ==
                                            index
                                        ? true
                                        : false,
                              ),
                            ));
                      }),
                )
              ],
            ),
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
      )),
    );
  }
}

class GenderCard extends StatelessWidget {
  const GenderCard(
      {Key? key,
      required this.imageUrl,
      required this.title,
      required this.onTap,
      this.isSelected = false})
      : super(key: key);
  final String imageUrl;
  final String title;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            height: 202 * SizeConfig.heightMultiplier!,
            width: (Get.width - 54 * SizeConfig.widthMultiplier!) / 2,
            padding: EdgeInsets.only(top: 20 * SizeConfig.heightMultiplier!),
            decoration: BoxDecoration(
                color: isSelected ? kSelectedBlue : kPureWhite,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: kLightGrey)),
            child: Column(
              children: [
                SizedBox(
                    height: 129 * SizeConfig.heightMultiplier!,
                    child: SvgPicture.network(imageUrl)),
                SizedBox(
                  height: 14 * SizeConfig.heightMultiplier!,
                ),
                Text(
                  title,
                  style:
                      AppTextStyle.normalBlackText.copyWith(color: kBlueColor),
                ),
                SizedBox(
                  height: 14 * SizeConfig.heightMultiplier!,
                ),
              ],
            ),
          ),
          isSelected
              ? Container(
                  height: 202 * SizeConfig.heightMultiplier!,
                  width: (Get.width - 54 * SizeConfig.widthMultiplier!) / 2,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 15.6 * SizeConfig.heightMultiplier!,
                          right: 12 * SizeConfig.widthMultiplier!),
                      child: SvgPicture.asset(ImagePath.rightTickIcon,
                          color: Blue),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
