import 'dart:ffi';

import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/feature/get_trained/controller/trainer_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/feature/get_trained/view/widgets/custom_app_bar.dart';
import 'package:fitbasix/feature/get_trained/view/widgets/trainer_card.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class GetTrainedScreen extends StatelessWidget {
  GetTrainedScreen({Key? key}) : super(key: key);
  final TrainerController _trainerController = Get.put(TrainerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: CustomAppBar(titleOfModule: 'getTrainedTitle'.tr),
          preferredSize: const Size(double.infinity, kToolbarHeight)),
      backgroundColor: kGreyBackground,
      body: SafeArea(
          child: Obx(() => _trainerController.isLoading.value
              ? Center(child: CustomizedCircularProgress())
              : SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 27 * SizeConfig.heightMultiplier!,
                        bottom: 69 * SizeConfig.heightMultiplier!),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12 * SizeConfig.widthMultiplier!),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(ImagePath.getTrainerIcon),
                              SizedBox(
                                width: 7 * SizeConfig.widthMultiplier!,
                              ),
                              GetTrainedTitle(
                                title: 'getTrainer'.tr,
                              ),
                              Spacer(),
                              SeeAllButton(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RouteName.allTrainerScreen);
                                },
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 19 * SizeConfig.heightMultiplier!,
                        ),
                        Container(
                          height: 250,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _trainerController.allTrainer.value
                                  .response!.data!.trainers!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: index == 0
                                      ? EdgeInsets.only(
                                          left:
                                              12 * SizeConfig.widthMultiplier!)
                                      : EdgeInsets.all(0),
                                  child: TrainerCard(
                                    name: _trainerController
                                        .allTrainer
                                        .value
                                        .response!
                                        .data!
                                        .trainers![index]
                                        .user!
                                        .name!,
                                    certificateCount: _trainerController
                                        .allTrainer
                                        .value
                                        .response!
                                        .data!
                                        .trainers![index]
                                        .numOfCertificates!,
                                    rating: double.tryParse(_trainerController
                                        .allTrainer
                                        .value
                                        .response!
                                        .data!
                                        .trainers![index]
                                        .rating!)!,
                                    profilePhoto: _trainerController
                                        .allTrainer
                                        .value
                                        .response!
                                        .data!
                                        .trainers![index]
                                        .user!
                                        .profilePhoto!,
                                    about: _trainerController
                                        .allTrainer
                                        .value
                                        .response!
                                        .data!
                                        .trainers![index]
                                        .about!,
                                    raters: _trainerController
                                        .allTrainer
                                        .value
                                        .response!
                                        .data!
                                        .trainers![index]
                                        .totalRating!,
                                    strength: _trainerController
                                        .allTrainer
                                        .value
                                        .response!
                                        .data!
                                        .trainers![index]
                                        .strength![0],
                                    strengthLength: _trainerController
                                        .allTrainer
                                        .value
                                        .response!
                                        .data!
                                        .trainers![index]
                                        .strength!
                                        .length,
                                  ),
                                );
                              }),
                        ),
                        SizedBox(
                          height: 39,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12 * SizeConfig.widthMultiplier!),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                  ImagePath.getFitnessConsultationIcon),
                              SizedBox(
                                width: 7 * SizeConfig.widthMultiplier!,
                              ),
                              GetTrainedTitle(
                                title: 'getFitnessConsult'.tr,
                              ),
                              Spacer(),
                              SeeAllButton(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RouteName.allTrainerScreen);
                                },
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 19 * SizeConfig.heightMultiplier!,
                        ),
                        Container(
                          height: 250,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: index == 0
                                      ? EdgeInsets.only(
                                          left:
                                              12 * SizeConfig.widthMultiplier!)
                                      : EdgeInsets.all(0),
                                  child: TrainerCard(
                                    name: 'Jonathan Swift',
                                    certificateCount: 3,
                                    rating: 5,
                                    profilePhoto: '',
                                    about: '',
                                    raters: '',
                                    strength: '',
                                    strengthLength: 0,
                                  ),
                                );
                              }),
                        ),
                        SizedBox(
                          height: 39,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12 * SizeConfig.widthMultiplier!),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                  ImagePath.getNutritionConsultationIcon),
                              SizedBox(
                                width: 7 * SizeConfig.widthMultiplier!,
                              ),
                              GetTrainedTitle(
                                title: 'getNutritionConsult'.tr,
                              ),
                              Spacer(),
                              SeeAllButton(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RouteName.allTrainerScreen);
                                },
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 19 * SizeConfig.heightMultiplier!,
                        ),
                        Container(
                          height: 250,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _trainerController.nutritionConsultant
                                  .value.response!.data!.trainers!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: index == 0
                                      ? EdgeInsets.only(
                                          left:
                                              12 * SizeConfig.widthMultiplier!)
                                      : EdgeInsets.all(0),
                                  child: TrainerCard(
                                    name: _trainerController
                                        .nutritionConsultant
                                        .value
                                        .response!
                                        .data!
                                        .trainers![index]
                                        .user!
                                        .name!,
                                    certificateCount: _trainerController
                                        .nutritionConsultant
                                        .value
                                        .response!
                                        .data!
                                        .trainers![index]
                                        .numOfCertificates!,
                                    rating: double.tryParse(_trainerController
                                        .nutritionConsultant
                                        .value
                                        .response!
                                        .data!
                                        .trainers![index]
                                        .rating!)!,
                                    profilePhoto: _trainerController
                                        .nutritionConsultant
                                        .value
                                        .response!
                                        .data!
                                        .trainers![index]
                                        .user!
                                        .profilePhoto!,
                                    about: _trainerController
                                        .nutritionConsultant
                                        .value
                                        .response!
                                        .data!
                                        .trainers![index]
                                        .about!,
                                    raters: _trainerController
                                        .nutritionConsultant
                                        .value
                                        .response!
                                        .data!
                                        .trainers![index]
                                        .totalRating!,
                                    strength: _trainerController
                                        .nutritionConsultant
                                        .value
                                        .response!
                                        .data!
                                        .trainers![index]
                                        .strength![0],
                                    strengthLength: _trainerController
                                        .nutritionConsultant
                                        .value
                                        .response!
                                        .data!
                                        .trainers![index]
                                        .strength!
                                        .length,
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ))),
    );
  }
}

class GetTrainedTitle extends StatelessWidget {
  const GetTrainedTitle({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyle.titleText
          .copyWith(fontSize: 16 * SizeConfig.textMultiplier!),
    );
  }
}

class SeeAllButton extends StatelessWidget {
  const SeeAllButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Text(
          'seeAll'.tr,
          style: AppTextStyle.NormalText.copyWith(
              fontSize: 14 * SizeConfig.textMultiplier!,
              decoration: TextDecoration.underline,
              color: kGreyText),
        ));
  }
}
