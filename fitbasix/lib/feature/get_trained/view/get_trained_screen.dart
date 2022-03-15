import 'package:cached_network_image/cached_network_image.dart';
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

import '../model/all_trainer_model.dart';

class GetTrainedScreen extends StatelessWidget {
  GetTrainedScreen({Key? key}) : super(key: key);
  final TrainerController _trainerController = Get.put(TrainerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: false,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text('getTrainedTitle'.tr,
              style: AppTextStyle.titleText.copyWith(
                  color: Theme.of(context).appBarTheme.titleTextStyle?.color,
                  fontSize: 16 * SizeConfig.textMultiplier!)),
        ),
        // PreferredSize(
        //     child: CustomAppBar(titleOfModule: 'getTrainedTitle'.tr),
        //     preferredSize: const Size(double.infinity, kToolbarHeight)),
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
                //My trainers tile
                Obx(() {
                  if (_trainerController.trainers.value.response != null) {
                    return _trainerController.trainers.value.response!.data!
                                .myTrainers!.length ==
                            0
                        ? Container()
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        12 * SizeConfig.widthMultiplier!),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      ImagePath.myTrainersIcon,
                                      height:
                                          24 * SizeConfig.imageSizeMultiplier!,
                                      width:
                                          24 * SizeConfig.imageSizeMultiplier!,
                                    ),
                                    SizedBox(
                                      width: 7 * SizeConfig.widthMultiplier!,
                                    ),
                                    GetTrainedTitle(
                                      title: 'my_trainers'.tr,
                                    ),
                                    Spacer(),
                                    Obx(() => _trainerController
                                            .getTrainedIsLoading.value
                                        ? Container()
                                        : SeeAllButton(
                                            title: "see_all_trainer".tr,
                                            onTap: () async {},
                                          ))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30 * SizeConfig.heightMultiplier!,
                              ),
                              Container(
                                height: 110 * SizeConfig.heightMultiplier!,
                                margin: EdgeInsets.only(
                                    left: 16 * SizeConfig.widthMultiplier!),
                                child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _trainerController.trainers.value
                                        .response!.data!.myTrainers!.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                          margin: EdgeInsets.only(
                                              right: 16 *
                                                  SizeConfig.widthMultiplier!),
                                          child: MyTrainersTile(
                                              name: _trainerController
                                                  .trainers
                                                  .value
                                                  .response!
                                                  .data!
                                                  .myTrainers![index]
                                                  .name!,
                                              imageUrl: _trainerController
                                                  .trainers
                                                  .value
                                                  .response!
                                                  .data!
                                                  .myTrainers![index]
                                                  .profilePhoto!,
                                            isCurrentlyEnrolled: _trainerController
                                                .trainers
                                                .value
                                                .response!
                                                .data!
                                                .myTrainers![index].isCurrentlyEnrolled!,
                                            onMyTrainerTileTapped: () async{
                                                print(_trainerController.trainers.value.response!.data!.myTrainers![index].quickBlox.toString()+ " quickbloxid");
                                              // Trainer selectedTrainer = _trainerController
                                              //     .trainers
                                              //     .value
                                              //     .response!
                                              //     .data!
                                              //     .trainers![_trainerController
                                              //     .trainers
                                              //     .value
                                              //     .response!
                                              //     .data!
                                              //     .trainers!.indexWhere((element) => element.id == _trainerController.trainers.value.response!.data!.myTrainers![index].id)];
                                              //
                                              // Navigator.pushNamed(context,
                                              //     RouteName.trainerProfileScreen);
                                              // _trainerController
                                              //     .isProfileLoading.value = true;
                                              // _trainerController
                                              //     .atrainerDetail.value = selectedTrainer;
                                              //
                                              //   _trainerController.planModel.value =
                                              //     await TrainerServices
                                              //     .getPlanByTrainerId(
                                              //     selectedTrainer.id!);
                                              //
                                              // _trainerController
                                              //     .loadingIndicator.value = false;
                                              // _trainerController
                                              //     .initialPostData.value =
                                              //     await TrainerServices
                                              //     .getTrainerPosts(
                                              //         selectedTrainer.id!,
                                              //     0);
                                              // if (_trainerController.initialPostData
                                              //     .value.response!.data!.length !=
                                              //     0) {
                                              //   _trainerController
                                              //       .trainerPostList.value =
                                              //   _trainerController.initialPostData
                                              //       .value.response!.data!;
                                              // } else {
                                              //   _trainerController.trainerPostList
                                              //       .clear();
                                              // }
                                              // _trainerController
                                              //     .isProfileLoading.value = false;
                                            },
                                          )

                                      );
                                    }),
                              ),
                              SizedBox(
                                height: 16 * SizeConfig.heightMultiplier!,
                              ),
                              Container(
                                width: double.infinity,
                                height: 4 * SizeConfig.heightMultiplier!,
                                color: Theme.of(context).cardColor,
                              ),
                              SizedBox(
                                height: 19 * SizeConfig.heightMultiplier!,
                              ),
                            ],
                          );
                  } else {
                    return Container();
                  }
                }),

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
                      Obx(() => _trainerController.getTrainedIsLoading.value
                          ? Container()
                          : SeeAllButton(
                              onTap: () async {
                                Navigator.pushNamed(
                                    context, RouteName.allTrainerScreen);

                                _trainerController.isLoading.value = true;
                                _trainerController.pageTitle.value =
                                    'trainers'.tr;
                                _trainerController.SelectedSortMethod.value =
                                    -1;
                                _trainerController.SelectedInterestIndex.value =
                                    0;
                                _trainerController.trainerType.value = 0;
                                _trainerController.searchedName.value = "";
                                _trainerController.searchController.text = "";
                                _trainerController.allTrainer.value =
                                    await TrainerServices.getAllTrainer();
                                _trainerController.isLoading.value = false;
                              },
                            ))
                    ],
                  ),
                ),
                SizedBox(
                  //19
                  height: 18 * SizeConfig.heightMultiplier!,
                ),
                Obx(
                  () => Container(
                    // height: 242 * SizeConfig.heightMultiplier!,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (int index = 0;
                              index <
                                  (_trainerController.getTrainedIsLoading.value
                                      ? 5
                                      : _trainerController.trainers.value
                                          .response!.data!.trainers!.length);
                              index++)
                            _trainerController.getTrainedIsLoading.value
                                ? Shimmer.fromColors(
                                    child: Padding(
                                      padding: index == 0
                                          ? EdgeInsets.only(
                                              left: 12 *
                                                  SizeConfig.widthMultiplier!)
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
                                    baseColor: Color.fromARGB(0, 255, 255, 255)
                                        .withOpacity(0),
                                    highlightColor:
                                        Color.fromARGB(1, 255, 255, 255)
                                            .withOpacity(0.46),
                                  )
                                : Padding(
                                    padding: index == 0
                                        ? EdgeInsets.only(
                                            left: 12 *
                                                SizeConfig.widthMultiplier!)
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
                                      about: _trainerController
                                          .trainers
                                          .value
                                          .response!
                                          .data!
                                          .trainers![index]
                                          .about!,
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
                                        _trainerController
                                            .isProfileLoading.value = true;
                                        _trainerController
                                                .atrainerDetail.value =
                                            _trainerController
                                                .trainers
                                                .value
                                                .response!
                                                .data!
                                                .trainers![index];
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
                                        _trainerController
                                            .loadingIndicator.value = false;
                                        _trainerController
                                                .initialPostData.value =
                                            await TrainerServices
                                                .getTrainerPosts(
                                                    _trainerController
                                                        .trainers
                                                        .value
                                                        .response!
                                                        .data!
                                                        .trainers![index]
                                                        .user!
                                                        .id!,
                                                    0);
                                        if (_trainerController.initialPostData
                                                .value.response!.data!.length !=
                                            0) {
                                          _trainerController
                                                  .trainerPostList.value =
                                              _trainerController.initialPostData
                                                  .value.response!.data!;
                                        } else {
                                          _trainerController.trainerPostList
                                              .clear();
                                        }
                                        _trainerController
                                            .isProfileLoading.value = false;
                                      },
                                    ),
                                  )
                        ],
                      ),
                    ),
                  ),
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
                      Obx(() => _trainerController.getTrainedIsLoading.value
                          ? Container()
                          : SeeAllButton(
                              onTap: () async {
                                Navigator.pushNamed(
                                    context, RouteName.allTrainerScreen);
                                _trainerController.isLoading.value = true;
                                _trainerController.pageTitle.value =
                                    'fitnessConsult'.tr;
                                _trainerController.SelectedInterestIndex.value =
                                    0;
                                _trainerController.searchedName.value = "";
                                _trainerController.trainerType.value = 1;
                                _trainerController.searchController.text = "";
                                _trainerController.allTrainer.value =
                                    await TrainerServices.getAllTrainer();

                                _trainerController.isLoading.value = false;
                              },
                            ))
                    ],
                  ),
                ),
                SizedBox(
                  //19
                  height: 18 * SizeConfig.heightMultiplier!,
                ),
                Obx(
                  () => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                        //252
                        child: Row(
                      children: [
                        for (int index = 0; index < 5; index++)
                          _trainerController.getTrainedIsLoading.value
                              ? Shimmer.fromColors(
                                  child: Padding(
                                    padding: index == 0
                                        ? EdgeInsets.only(
                                            left: 12 *
                                                SizeConfig.widthMultiplier!)
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
                                  baseColor: Color.fromARGB(0, 255, 255, 255)
                                      .withOpacity(0),
                                  highlightColor:
                                      Color.fromARGB(1, 255, 255, 255)
                                          .withOpacity(0.46),
                                )
                              : Padding(
                                  padding: index == 0
                                      ? EdgeInsets.only(
                                          left:
                                              12 * SizeConfig.widthMultiplier!)
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
                                      _trainerController
                                          .isProfileLoading.value = true;
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
                                      _trainerController
                                          .loadingIndicator.value = false;
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
                                      if (_trainerController.initialPostData
                                              .value.response!.data!.length !=
                                          0) {
                                        _trainerController
                                                .trainerPostList.value =
                                            _trainerController.initialPostData
                                                .value.response!.data!;
                                      } else {
                                        _trainerController.trainerPostList
                                            .clear();
                                      }
                                      _trainerController
                                          .isProfileLoading.value = false;
                                    },
                                  ),
                                )
                      ],
                    )),
                  ),
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
                      Obx(() => _trainerController.getTrainedIsLoading.value
                          ? Container()
                          : SeeAllButton(
                              onTap: () async {
                                _trainerController.SelectedInterestIndex.value =
                                    0;
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
                            ))
                    ],
                  ),
                ),
                SizedBox(
                  //19
                  height: 18 * SizeConfig.heightMultiplier!,
                ),
                Obx(
                  () => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                        //252
                        child: Row(
                      children: [
                        for (int index = 0; index < 5; index++)
                          _trainerController.getTrainedIsLoading.value
                              ? Shimmer.fromColors(
                                  child: Padding(
                                    padding: index == 0
                                        ? EdgeInsets.only(
                                            left: 12 *
                                                SizeConfig.widthMultiplier!)
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
                                  baseColor: Color.fromARGB(0, 255, 255, 255)
                                      .withOpacity(0),
                                  highlightColor:
                                      Color.fromARGB(1, 255, 255, 255)
                                          .withOpacity(0.46),
                                )
                              : Padding(
                                  padding: index == 0
                                      ? EdgeInsets.only(
                                          left:
                                              12 * SizeConfig.widthMultiplier!)
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
                                      _trainerController
                                          .isProfileLoading.value = true;
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
                                                      .nutritionConsultant![
                                                          index]
                                                      .user!
                                                      .id!);
                                      _trainerController
                                          .loadingIndicator.value = false;
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
                                      if (_trainerController.initialPostData
                                              .value.response!.data!.length !=
                                          0) {
                                        _trainerController
                                                .trainerPostList.value =
                                            _trainerController.initialPostData
                                                .value.response!.data!;
                                      } else {
                                        _trainerController.trainerPostList
                                            .clear();
                                      }
                                      _trainerController
                                          .isProfileLoading.value = false;
                                    },
                                  ),
                                )
                      ],
                    )),
                  ),
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
      style: AppTextStyle.titleText.copyWith(
          color: Theme.of(context).textTheme.bodyText1?.color,
          fontSize: 16 * SizeConfig.textMultiplier!),
    );
  }
}

class SeeAllButton extends StatelessWidget {
  SeeAllButton({Key? key, required this.onTap, this.title}) : super(key: key);
  final VoidCallback onTap;
  String? title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Text(
          title != null ? title!.tr : 'seeAll'.tr,
          style: AppTextStyle.NormalText.copyWith(
              fontSize: 14 * SizeConfig.textMultiplier!,
              decoration: TextDecoration.underline,
              color: Theme.of(context).textTheme.headline1?.color),
        ));
  }
}

class MyTrainersTile extends StatelessWidget {
  MyTrainersTile({Key? key, required this.name, required this.imageUrl,required this.isCurrentlyEnrolled,this.onMyTrainerTileTapped})
      : super(key: key);
  String imageUrl;
  String name;
  bool isCurrentlyEnrolled;
  GestureTapCallback? onMyTrainerTileTapped;
  @override
  Widget build(BuildContext context) {
    print(isCurrentlyEnrolled.toString());
    return GestureDetector(
      onTap: onMyTrainerTileTapped,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 32 * SizeConfig.imageSizeMultiplier!,
            backgroundImage: NetworkImage(imageUrl),
          ),
          SizedBox(
            height: 8 * SizeConfig.heightMultiplier!,
          ),
          Container(
              width: 64 * SizeConfig.widthMultiplier!,
              child: Text(
                name,
                style: AppTextStyle.normalPureBlackTextWithWeight600.copyWith(
                    color: isCurrentlyEnrolled?Theme.of(context).textTheme.bodyText1!.color:Theme.of(context).textTheme.headline1!.color),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ))
        ],
      ),
    );
  }
}
