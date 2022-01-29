import 'package:fitbasix/feature/spg/services/spg_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button.dart';
import 'package:fitbasix/feature/spg/controller/spg_controller.dart';
import 'package:fitbasix/feature/spg/view/select_gender.dart';
import 'package:fitbasix/feature/spg/view/widgets/spg_app_bar.dart';

class SetGoalScreen extends StatelessWidget {
  SetGoalScreen({Key? key}) : super(key: key);
  final SPGController _spgController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPureWhite,
      appBar: PreferredSize(
          child: SPGAppBar(
              title:
                  'page_count'.trParams({'pageNumber': "1", 'total_page': "7"}),
              onBack: () {
                Navigator.pop(context);
              },
              onSkip: () {}),
          preferredSize: const Size(double.infinity, kToolbarHeight)),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: kGreenColor,
              height: 2 * SizeConfig.heightMultiplier!,
              width: Get.width * (1 / 7),
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
                    'what_is_your_goal'.tr,
                    style: AppTextStyle.boldBlackText,
                  ),
                  SizedBox(
                    height: 40 * SizeConfig.heightMultiplier!,
                  ),
                  ListView.builder(
                      itemCount: _spgController
                          .spgData.value.response!.data!.goalType!.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (_, index) {
                        return Obx(() => GoalCard(
                              title: _spgController.spgData.value.response!
                                  .data!.goalType![index].name!,
                              imageUrl: _spgController.spgData.value.response!
                                  .data!.goalType![index].image!,
                              onTap: () {
                                _spgController.selectedGoalIndex.value =
                                    _spgController.spgData.value.response!.data!
                                        .goalType![index];

                                // _spgController.updatedGoalStatus(
                                //     _spgController.selectedGoalIndex.value);
                              },
                              isSelected: _spgController.spgData.value.response!
                                          .data!.goalType![index] ==
                                      _spgController.selectedGoalIndex.value
                                  ? true
                                  : false,
                            ));
                      }),
                  SizedBox(
                    height: 32 * SizeConfig.heightMultiplier!,
                  ),
                  ProceedButton(
                      title: 'proceed'.tr,
                      onPressed: () async {
                        if (_spgController.selectedGoalIndex.value.serialId !=
                            null) {
                          await SPGService.updateSPGData(
                              _spgController.selectedGoalIndex.value.serialId,
                              null,
                              null,
                              null,
                              null);
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => SelectGenderScreen()));
                      }),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}

class GoalCard extends StatelessWidget {
  const GoalCard(
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
                  child: SvgPicture.network(imageUrl,
                      height: 60 * SizeConfig.heightMultiplier!,
                      width: 60 * SizeConfig.heightMultiplier!,
                      fit: BoxFit.contain)),
              SizedBox(
                width: 8 * SizeConfig.widthMultiplier!,
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
