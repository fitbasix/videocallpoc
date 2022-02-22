import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/feature/get_trained/controller/trainer_controller.dart';
import 'package:fitbasix/feature/get_trained/services/trainer_services.dart';
import 'package:fitbasix/feature/get_trained/view/widgets/custom_app_bar.dart';
import 'package:fitbasix/feature/get_trained/view/widgets/trainer_card.dart';

class GetTrainedScreen extends StatelessWidget {
  GetTrainedScreen({Key? key}) : super(key: key);
  final TrainerController _trainerController = Get.put(TrainerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            child: CustomAppBar(titleOfModule: 'getTrainedTitle'.tr),
            preferredSize: const Size(double.infinity, kToolbarHeight)),
        // backgroundColor: kGreyBackground,
        body: SafeArea(
            child: SingleChildScrollView(
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
                        onTap: () async {
                          Navigator.pushNamed(
                              context, RouteName.allTrainerScreen);

                          _trainerController.isLoading.value = true;
                          _trainerController.pageTitle.value = 'trainers'.tr;
                          _trainerController.SelectedInterestIndex.value = 0;
                          _trainerController.trainerType.value = 0;
                          _trainerController.searchedName.value = "";
                          _trainerController.searchController.text = "";
                          _trainerController.allTrainer.value =
                              await TrainerServices.getAllTrainer();
                          _trainerController.isLoading.value = false;
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(
                  //19
                  height: 21 * SizeConfig.heightMultiplier!,
                ),
                Container(
                  height: 242 * SizeConfig.heightMultiplier!,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _trainerController.getTrainedIsLoading.value
                          ? 5
                          : _trainerController
                              .trainers.value.response!.data!.trainers!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Obx(() => _trainerController
                                .getTrainedIsLoading.value
                            ? Shimmer.fromColors(
                                child: Padding(
                                  padding: index == 0
                                      ? EdgeInsets.only(
                                          left:
                                              12 * SizeConfig.widthMultiplier!)
                                      : EdgeInsets.all(0),
                                  child: TrainerCard(
                                      name: '',
                                      certificateCount: 0,
                                      profilePhoto:
                                          'https://randomuser.me/api/portraits/men/1.jpg',
                                      strength: '',
                                      strengthLength: 0,
                                      about: '',
                                      raters: '',
                                      rating: 0,
                                      onTap: () {}),
                                ),
                                baseColor:
                                    const Color.fromRGBO(230, 230, 230, 1),
                                highlightColor:
                                    const Color.fromRGBO(242, 245, 245, 1),
                              )
                            : Padding(
                                padding: index == 0
                                    ? EdgeInsets.only(
                                        left: 12 * SizeConfig.widthMultiplier!)
                                    : EdgeInsets.all(0),
                                child: TrainerCard(
                                  name: _trainerController
                                              .trainers
                                              .value
                                              .response!
                                              .data!
                                              .trainers![index]
                                              .user !=
                                          null
                                      ? _trainerController
                                              .trainers
                                              .value
                                              .response!
                                              .data!
                                              .trainers![index]
                                              .user!
                                              .name ??
                                          ''
                                      : '',
                                  certificateCount: _trainerController
                                      .trainers
                                      .value
                                      .response!
                                      .data!
                                      .trainers![index]
                                      .certificates!
                                      .length,
                                  rating: double.tryParse(_trainerController
                                      .trainers
                                      .value
                                      .response!
                                      .data!
                                      .trainers![index]
                                      .rating!)!,
                                  profilePhoto: _trainerController
                                              .trainers
                                              .value
                                              .response!
                                              .data!
                                              .trainers![index]
                                              .user !=
                                          null
                                      ? _trainerController
                                              .trainers
                                              .value
                                              .response!
                                              .data!
                                              .trainers![index]
                                              .user!
                                              .profilePhoto ??
                                          ''
                                      : '',
                                  about: _trainerController.trainers.value
                                      .response!.data!.trainers![index].about!,
                                  raters: _trainerController
                                      .trainers
                                      .value
                                      .response!
                                      .data!
                                      .trainers![index]
                                      .totalRating!,
                                  strength: _trainerController
                                      .trainers
                                      .value
                                      .response!
                                      .data!
                                      .trainers![index]
                                      .strength![0]
                                      .name
                                      .toString(),
                                  strengthLength: _trainerController
                                      .trainers
                                      .value
                                      .response!
                                      .data!
                                      .trainers![index]
                                      .strength!
                                      .length,
                                  onTap: () async {
                                    Navigator.pushNamed(context,
                                        RouteName.trainerProfileScreen);
                                    _trainerController.isProfileLoading.value =
                                        true;
                                    _trainerController.atrainerDetail.value =
                                        _trainerController.trainers.value
                                            .response!.data!.trainers![index];
                                    _trainerController.planModel.value =
                                        await TrainerServices
                                            .getPlanByTrainerId(
                                                _trainerController
                                                    .trainers
                                                    .value
                                                    .response!
                                                    .data!
                                                    .trainers![index]
                                                    .user!
                                                    .id!);
                                    _trainerController.loadingIndicator.value =
                                        false;
                                    _trainerController.initialPostData.value =
                                        await TrainerServices.getTrainerPosts(
                                            _trainerController
                                                .trainers
                                                .value
                                                .response!
                                                .data!
                                                .trainers![index]
                                                .user!
                                                .id!,
                                            0);
                                    if (_trainerController.initialPostData.value
                                            .response!.data!.length !=
                                        0) {
                                      _trainerController.trainerPostList.value =
                                          _trainerController.initialPostData
                                              .value.response!.data!;
                                    } else {
                                      _trainerController.trainerPostList
                                          .clear();
                                    }
                                    _trainerController.isProfileLoading.value =
                                        false;
                                  },
                                ),
                              ));
                      }),
                ),
                SizedBox(
                  //39
                  height: 37 * SizeConfig.heightMultiplier!,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 12 * SizeConfig.widthMultiplier!),
                  child: Row(
                    children: [
                      SvgPicture.asset(ImagePath.getFitnessConsultationIcon),
                      SizedBox(
                        width: 7 * SizeConfig.widthMultiplier!,
                      ),
                      GetTrainedTitle(
                        title: 'getFitnessConsult'.tr,
                      ),
                      Spacer(),
                      SeeAllButton(
                        onTap: () async {
                          Navigator.pushNamed(
                              context, RouteName.allTrainerScreen);
                          _trainerController.isLoading.value = true;
                          _trainerController.pageTitle.value =
                              'fitnessConsult'.tr;
                          _trainerController.SelectedInterestIndex.value = 0;
                          _trainerController.searchedName.value = "";
                          _trainerController.trainerType.value = 1;
                          _trainerController.searchController.text = "";
                          _trainerController.allTrainer.value =
                              await TrainerServices.getAllTrainer();

                          _trainerController.isLoading.value = false;
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(
                  //19
                  height: 18 * SizeConfig.heightMultiplier!,
                ),
                Container(
                  //252
                  height: 242 * SizeConfig.heightMultiplier!,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (BuildContext context, int index) {
                        return Obx(() => _trainerController
                                .getTrainedIsLoading.value
                            ? Shimmer.fromColors(
                                child: Padding(
                                  padding: index == 0
                                      ? EdgeInsets.only(
                                          left:
                                              12 * SizeConfig.widthMultiplier!)
                                      : EdgeInsets.all(0),
                                  child: TrainerCard(
                                      name: '',
                                      certificateCount: 0,
                                      profilePhoto:
                                          'https://randomuser.me/api/portraits/men/1.jpg',
                                      strength: '',
                                      strengthLength: 0,
                                      about: '',
                                      raters: '',
                                      rating: 0,
                                      onTap: () {}),
                                ),
                                baseColor:
                                    const Color.fromRGBO(230, 230, 230, 1),
                                highlightColor:
                                    const Color.fromRGBO(242, 245, 245, 1),
                              )
                            : Padding(
                                padding: index == 0
                                    ? EdgeInsets.only(
                                        left: 12 * SizeConfig.widthMultiplier!)
                                    : EdgeInsets.all(0),
                                child: TrainerCard(
                                  name: _trainerController
                                              .trainers
                                              .value
                                              .response!
                                              .data!
                                              .fitnessConsultant![index]
                                              .user !=
                                          null
                                      ? _trainerController
                                              .trainers
                                              .value
                                              .response!
                                              .data!
                                              .fitnessConsultant![index]
                                              .user!
                                              .name ??
                                          ''
                                      : '',
                                  certificateCount: _trainerController
                                      .trainers
                                      .value
                                      .response!
                                      .data!
                                      .fitnessConsultant![index]
                                      .certificates!
                                      .length,
                                  rating: double.tryParse(_trainerController
                                      .trainers
                                      .value
                                      .response!
                                      .data!
                                      .fitnessConsultant![index]
                                      .rating!)!,
                                  profilePhoto: _trainerController
                                              .trainers
                                              .value
                                              .response!
                                              .data!
                                              .fitnessConsultant![index]
                                              .user !=
                                          null
                                      ? _trainerController
                                              .trainers
                                              .value
                                              .response!
                                              .data!
                                              .fitnessConsultant![index]
                                              .user!
                                              .profilePhoto ??
                                          ''
                                      : '',
                                  about: _trainerController
                                      .trainers
                                      .value
                                      .response!
                                      .data!
                                      .fitnessConsultant![index]
                                      .about!,
                                  raters: _trainerController
                                      .trainers
                                      .value
                                      .response!
                                      .data!
                                      .fitnessConsultant![index]
                                      .totalRating!,
                                  strength: _trainerController
                                      .trainers
                                      .value
                                      .response!
                                      .data!
                                      .fitnessConsultant![index]
                                      .strength![0]
                                      .name
                                      .toString(),
                                  strengthLength: _trainerController
                                      .trainers
                                      .value
                                      .response!
                                      .data!
                                      .fitnessConsultant![index]
                                      .strength!
                                      .length,
                                  onTap: () async {
                                    Navigator.pushNamed(context,
                                        RouteName.trainerProfileScreen);
                                    _trainerController.isProfileLoading.value =
                                        true;
                                    _trainerController.atrainerDetail.value =
                                        _trainerController
                                            .trainers
                                            .value
                                            .response!
                                            .data!
                                            .fitnessConsultant![index];
                                    _trainerController.planModel.value =
                                        await TrainerServices
                                            .getPlanByTrainerId(
                                                _trainerController
                                                    .trainers
                                                    .value
                                                    .response!
                                                    .data!
                                                    .fitnessConsultant![index]
                                                    .user!
                                                    .id!);
                                    _trainerController.loadingIndicator.value =
                                        false;
                                    _trainerController.initialPostData.value =
                                        await TrainerServices.getTrainerPosts(
                                            _trainerController
                                                .trainers
                                                .value
                                                .response!
                                                .data!
                                                .fitnessConsultant![index]
                                                .user!
                                                .id!,
                                            0);
                                    if (_trainerController.initialPostData.value
                                            .response!.data!.length !=
                                        0) {
                                      _trainerController.trainerPostList.value =
                                          _trainerController.initialPostData
                                              .value.response!.data!;
                                    } else {
                                      _trainerController.trainerPostList
                                          .clear();
                                    }
                                    _trainerController.isProfileLoading.value =
                                        false;
                                  },
                                ),
                              ));
                      }),
                ),
                SizedBox(
                  //39
                  height: 37 * SizeConfig.heightMultiplier!,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 12 * SizeConfig.widthMultiplier!),
                  child: Row(
                    children: [
                      SvgPicture.asset(ImagePath.getNutritionConsultationIcon),
                      SizedBox(
                        width: 7 * SizeConfig.widthMultiplier!,
                      ),
                      GetTrainedTitle(
                        title: 'getNutritionConsult'.tr,
                      ),
                      Spacer(),
                      SeeAllButton(
                        onTap: () async {
                          _trainerController.SelectedInterestIndex.value = 0;
                          _trainerController.searchedName.value = "";
                          _trainerController.trainerType.value = 2;
                          _trainerController.searchController.text = "";
                          Navigator.pushNamed(
                              context, RouteName.allTrainerScreen);
                          _trainerController.isLoading.value = true;
                          _trainerController.pageTitle.value =
                              'nutritionConsult'.tr;
                          _trainerController.allTrainer.value =
                              await TrainerServices.getAllTrainer();
                          _trainerController.isLoading.value = false;
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(
                  //19
                  height: 18 * SizeConfig.heightMultiplier!,
                ),
                Container(
                  //252
                  height: 242 * SizeConfig.heightMultiplier!,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (BuildContext context, int index) {
                        return Obx(() => _trainerController
                                .getTrainedIsLoading.value
                            ? Shimmer.fromColors(
                                child: Padding(
                                  padding: index == 0
                                      ? EdgeInsets.only(
                                          left:
                                              12 * SizeConfig.widthMultiplier!)
                                      : EdgeInsets.all(0),
                                  child: TrainerCard(
                                      name: '',
                                      certificateCount: 0,
                                      profilePhoto:
                                          'https://randomuser.me/api/portraits/men/1.jpg',
                                      strength: '',
                                      strengthLength: 0,
                                      about: '',
                                      raters: '',
                                      rating: 0,
                                      onTap: () {}),
                                ),
                                baseColor:
                                    const Color.fromRGBO(230, 230, 230, 1),
                                highlightColor:
                                    const Color.fromRGBO(242, 245, 245, 1),
                              )
                            : Padding(
                                padding: index == 0
                                    ? EdgeInsets.only(
                                        left: 12 * SizeConfig.widthMultiplier!)
                                    : EdgeInsets.all(0),
                                child: TrainerCard(
                                  name: _trainerController
                                              .trainers
                                              .value
                                              .response!
                                              .data!
                                              .nutritionConsultant![index]
                                              .user !=
                                          null
                                      ? _trainerController
                                              .trainers
                                              .value
                                              .response!
                                              .data!
                                              .nutritionConsultant![index]
                                              .user!
                                              .name ??
                                          ''
                                      : '',
                                  certificateCount: _trainerController
                                      .trainers
                                      .value
                                      .response!
                                      .data!
                                      .nutritionConsultant![index]
                                      .certificates!
                                      .length,
                                  rating: double.tryParse(_trainerController
                                      .trainers
                                      .value
                                      .response!
                                      .data!
                                      .nutritionConsultant![index]
                                      .rating!)!,
                                  profilePhoto: _trainerController
                                              .trainers
                                              .value
                                              .response!
                                              .data!
                                              .nutritionConsultant![index]
                                              .user !=
                                          null
                                      ? _trainerController
                                              .trainers
                                              .value
                                              .response!
                                              .data!
                                              .nutritionConsultant![index]
                                              .user!
                                              .profilePhoto ??
                                          ''
                                      : '',
                                  about: _trainerController
                                      .trainers
                                      .value
                                      .response!
                                      .data!
                                      .nutritionConsultant![index]
                                      .about!,
                                  raters: _trainerController
                                      .trainers
                                      .value
                                      .response!
                                      .data!
                                      .nutritionConsultant![index]
                                      .totalRating!,
                                  strength: _trainerController
                                      .trainers
                                      .value
                                      .response!
                                      .data!
                                      .nutritionConsultant![index]
                                      .strength![0]
                                      .name
                                      .toString(),
                                  strengthLength: _trainerController
                                      .trainers
                                      .value
                                      .response!
                                      .data!
                                      .nutritionConsultant![index]
                                      .strength!
                                      .length,
                                  onTap: () async {
                                    Navigator.pushNamed(context,
                                        RouteName.trainerProfileScreen);
                                    _trainerController.isProfileLoading.value =
                                        true;
                                    _trainerController.atrainerDetail.value =
                                        _trainerController
                                            .trainers
                                            .value
                                            .response!
                                            .data!
                                            .nutritionConsultant![index];
                                    _trainerController.planModel.value =
                                        await TrainerServices
                                            .getPlanByTrainerId(
                                                _trainerController
                                                    .trainers
                                                    .value
                                                    .response!
                                                    .data!
                                                    .nutritionConsultant![index]
                                                    .user!
                                                    .id!);
                                    _trainerController.loadingIndicator.value =
                                        false;
                                    _trainerController.initialPostData.value =
                                        await TrainerServices.getTrainerPosts(
                                            _trainerController
                                                .trainers
                                                .value
                                                .response!
                                                .data!
                                                .nutritionConsultant![index]
                                                .user!
                                                .id!,
                                            0);
                                    if (_trainerController.initialPostData.value
                                            .response!.data!.length !=
                                        0) {
                                      _trainerController.trainerPostList.value =
                                          _trainerController.initialPostData
                                              .value.response!.data!;
                                    } else {
                                      _trainerController.trainerPostList
                                          .clear();
                                    }
                                    _trainerController.isProfileLoading.value =
                                        false;
                                  },
                                ),
                              ));
                      }),
                ),
              ],
            ),
          ),
        )));
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
