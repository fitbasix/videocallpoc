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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SelectGenderScreen extends StatelessWidget {
  SelectGenderScreen({Key? key}) : super(key: key);

  final SPGController _spgController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
          child: SPGAppBar(
              title:
                  'page_count'.trParams({'pageNumber': "2", 'total_page': "8"}),
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
              width: Get.width / 8 * 2,
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
              children: [
                Text(
                  'gender_select_heading'.tr,
                  style: AppTextStyle.boldBlackText.copyWith(
                      color: Theme.of(context).textTheme.bodyText1!.color),
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
                        // if (_spgController.selectedGenderIndex.value.serialId ==
                        //     null) {
                        //   _spgController.selectedGenderIndex.value =
                        //       _spgController.spgData.value.response!.data!
                        //           .genderType![index];
                        // }
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
                                      _spgController.spgData.value.response!
                                          .data!.genderType![index];
                                },
                                isSelected:
                                    _spgController.selectedGenderIndex.value ==
                                            _spgController
                                                .spgData
                                                .value
                                                .response!
                                                .data!
                                                .genderType![index]
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
            child: Obx(
                  ()=> GestureDetector(
                onTap:_spgController.selectedGenderIndex.value.id!=null?() {
                  Navigator.pushNamed(context, RouteName.setDob);
                }:null,
                child: Container(
                  width: Get.width,
                  height: 48 * SizeConfig.heightMultiplier!,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8 * SizeConfig.heightMultiplier!),
                    color: _spgController.selectedGenderIndex.value.id!=null?kgreen49:hintGrey,
                  ),
                  child: Center(
                    child: Text(
                      'proceed'.tr,
                      style: AppTextStyle.normalWhiteText.copyWith(
                          color: _spgController.selectedGenderIndex.value.id!=null?kPureWhite:greyBorder
                      ),
                    ),
                  ),
                ),
              ),
            )

            // ProceedButton(
            //     title: 'proceed'.tr,
            //     onPressed: () {
            //       print(_spgController.selectedGenderIndex.value.serialId);
            //       Navigator.pushNamed(context, RouteName.setDob);
            //     }),
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
            decoration: BoxDecoration(
                color: isSelected ? kSelectedBlue : kPureWhite,
                borderRadius:
                    BorderRadius.circular(8 * SizeConfig.widthMultiplier!),
                border:
                    Border.all(color: isSelected ? kGreenColor : Colors.black)),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(7 * SizeConfig.widthMultiplier!),
                  child: CachedNetworkImage(
                    height: 204 * SizeConfig.heightMultiplier!,
                    width: (Get.width - 54 * SizeConfig.widthMultiplier!) / 2,
                    imageUrl: imageUrl,
                    placeholder: (context, url) => ShimmerEffect(),
                    errorWidget: (context, url, error) => ShimmerEffect(),
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: 16 * SizeConfig.heightMultiplier!),
                    child: Text(
                      title,
                      style: AppTextStyle.normalBlackText.copyWith(
                          color: Theme.of(context).textTheme.bodyText1!.color),
                    ),
                  ),
                ),
                isSelected
                    ? Container(
                        height: 202 * SizeConfig.heightMultiplier!,
                        width:
                            (Get.width - 54 * SizeConfig.widthMultiplier!) / 2,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 10 * SizeConfig.heightMultiplier!,
                                right: 10 * SizeConfig.widthMultiplier!),
                            child: Icon(
                              Icons.check_circle,
                              color: Theme.of(context).primaryColor,
                              size: 24 * SizeConfig.imageSizeMultiplier!,
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
