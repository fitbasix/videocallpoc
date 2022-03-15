import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:flutter/material.dart';
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
  final SPGController _spgController = Get.put(SPGController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
          child: SPGAppBar(
              title:
                  'page_count'.trParams({'pageNumber': "1", 'total_page': "8"}),
              onBack: () {
                Navigator.pop(context);
              },
              onSkip: () {}),
          preferredSize: const Size(double.infinity, kToolbarHeight)),
      body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
        child: Obx(
              ()=>_spgController.isLoading.value ?
              Center(child: CustomizedCircularProgress())
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        color: Theme.of(context).primaryColor,
                        height: 2 * SizeConfig.heightMultiplier!,
                        width: Get.width,
                      ),
                      Container(
                        color: kGreenColor,
                        height: 2 * SizeConfig.heightMultiplier!,
                        width: Get.width * (1 / 8),
                      ),
                    ],
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
                          style: AppTextStyle.boldBlackText.copyWith(color: Theme.of(context).textTheme.bodyText1!.color),
                        ),
                        SizedBox(
                          height: 40 * SizeConfig.heightMultiplier!,
                        ),
                        _spgController
                                .spgData.value.response==null?
                                Container()
                                :GridView.builder(
                            itemCount: _spgController
                                .spgData.value.response!.data!.goalType!.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
                              crossAxisSpacing: 16*SizeConfig.widthMultiplier!,
                              mainAxisSpacing: 16*SizeConfig.widthMultiplier!,
                            ),
                            itemBuilder: (BuildContext context, int index){
                              if (_spgController.selectedGoalIndex.value.serialId ==
                                  null) {
                                _spgController.selectedGoalIndex.value =
                                    _spgController
                                        .spgData.value.response!.data!.goalType![0];
                              }
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
                      ],
                    ),
                  )
                ],
              ),
        ),
      ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16*SizeConfig.widthMultiplier!,vertical: 16*SizeConfig.heightMultiplier!),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ProceedButton(
                      title: 'proceed'.tr,
                      onPressed: () {
                        print(_spgController.selectedGoalIndex.value.serialId);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => SelectGenderScreen()));
                      }),
                ),
              ),
            ],
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
          // margin: EdgeInsets.only(top: 8 * SizeConfig.heightMultiplier!),
          // padding: EdgeInsets.only(left: 24 * SizeConfig.widthMultiplier!),
          height: 156 *SizeConfig.widthMultiplier!,
          width: 156*SizeConfig.widthMultiplier!,
          decoration: BoxDecoration(
              color: isSelected ? kSelectedGreen : kPureWhite,
              border: Border.all(color: isSelected ? kGreenColor : Colors.black),
              borderRadius: BorderRadius.circular(8*SizeConfig.imageSizeMultiplier!),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: -2,
                    offset: Offset(0, 4))
              ]),
          child: Stack(
            children: [
              Container(
                  // height: 60 * SizeConfig.heightMultiplier!,
                  // width: 60 * SizeConfig.heightMultiplier!,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7*SizeConfig.imageSizeMultiplier!),
                    child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        // height: 60 * SizeConfig.heightMultiplier!,
                        // width: 60 * SizeConfig.heightMultiplier!,
                        fit: BoxFit.cover),
                  )),
              Container(
                margin: EdgeInsets.only(left: 12*SizeConfig.widthMultiplier!,top: 12*SizeConfig.heightMultiplier!,right: 15*SizeConfig.widthMultiplier!),
                child: Text(
                  title,
                  style: AppTextStyle.boldBlackText
                      .copyWith(fontSize: 14 * SizeConfig.textMultiplier!,color: Theme.of(context).textTheme.bodyText1!.color,),
                ),
              ),
              (isSelected)?Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.only(right: 11*SizeConfig.widthMultiplier!,top: 8*SizeConfig.heightMultiplier!),
                  child: Icon(Icons.check,color: Theme.of(context).primaryColor,size: 24*SizeConfig.widthMultiplier!,),
                ),
              ):Container()

            ],
          )),
    );
  }
}
