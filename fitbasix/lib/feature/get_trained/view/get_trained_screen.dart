import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/credentials.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/feature/Home/model/active_plans_model.dart';
import 'package:fitbasix/feature/Home/view/widgets/review_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/feature/get_trained/controller/trainer_controller.dart';
import 'package:fitbasix/feature/get_trained/services/trainer_services.dart';
import 'package:fitbasix/feature/get_trained/view/widgets/custom_app_bar.dart';
import 'package:fitbasix/feature/get_trained/view/widgets/trainer_card.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../Home/controller/Home_Controller.dart';
import '../model/all_trainer_model.dart' as TrainerModel;

class GetTrainedScreen extends StatelessWidget {
  GetTrainedScreen({Key? key}) : super(key: key);
  final TrainerController _trainerController = Get.put(TrainerController());
  final HomeController _homeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: false,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              _homeController.selectedIndex.value = 0;
            },
            icon: SvgPicture.asset(
              ImagePath.backIcon,
              color: Theme.of(context).primaryColor,
              width: 7.41 * SizeConfig.widthMultiplier!,
              height: 12 * SizeConfig.heightMultiplier!,
              fit: BoxFit.contain,
            ),
          ),
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
                    return _trainerController
                            .trainers.value.response!.data!.myTrainers!.isEmpty
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
                                            onTap: () async {
                                              // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                              // String? userIdForCometChat = await sharedPreferences.getString("userIdForCometChat");
                                              // if(userIdForCometChat!=null) {
                                              //   bool userIsLoggedIn = await CometChatService().logInUser(userIdForCometChat);
                                              //   if(userIsLoggedIn){
                                              //     ///go to chat screen
                                              //   }
                                              //
                                              // }
                                              _trainerController
                                                  .searchMyTrainerController
                                                  .clear();
                                              _trainerController
                                                  .currentMyTrainerPage
                                                  .value = 1;
                                              Navigator.pushNamed(context,
                                                  RouteName.myTrainersScreen);
                                            },
                                          ))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20 * SizeConfig.heightMultiplier!,
                              ),
                              CarouselSlider(
                                options: CarouselOptions(
                                  height: _trainerController
                                          .showChangeTiming.value
                                      ? 310
                                      : _trainerController
                                              .isCarouselExpanded.value
                                          ? 260 * SizeConfig.heightMultiplier!
                                          : 130 * SizeConfig.heightMultiplier!,
                                  viewportFraction: 0.9,
                                  autoPlay: false,
                                  enableInfiniteScroll: false,
                                  initialPage: 0,
                                  reverse: false,
                                  enlargeCenterPage: true,
                                  disableCenter: true,
                                  onPageChanged: (index, _) {
                                    _trainerController.collapseTiles();
                                    _trainerController
                                        .isCarouselExpanded.value = false;
                                    _trainerController.showChangeTiming.value =
                                        false;
                                  },
                                ),
                                items: List<Widget>.generate(
                                    _homeController.activePlans.length,
                                    (index) => MyTrainersTile(
                                          index: index,
                                          planDetail: _homeController
                                              .activePlans[index],
                                          name: _homeController
                                              .activePlans[index].trainer!.name
                                              .toString(),
                                          imageUrl: _homeController
                                              .activePlans[index]
                                              .trainer!
                                              .profilePhoto
                                              .toString(),
                                          isCurrentlyEnrolled: true,
                                          onMyTrainerTileTapped: () async {
                                            String trainerId = _homeController
                                                .activePlans[index]
                                                .trainer!
                                                .id!;
                                            _trainerController.atrainerDetail
                                                .value = TrainerModel.Trainer();
                                            _trainerController
                                                .isMyTrainerProfileLoading
                                                .value = true;
                                            _trainerController
                                                .isProfileLoading.value = true;
                                            Navigator.pushNamed(context,
                                                RouteName.trainerProfileScreen);
                                            var result = await TrainerServices
                                                .getATrainerDetail(trainerId);
                                            _trainerController.atrainerDetail
                                                .value = result.response!.data!;
                                            _trainerController
                                                .isMyTrainerProfileLoading
                                                .value = false;

                                            _trainerController
                                                .isPlanLoading.value = true;
                                            _trainerController.planModel.value =
                                                await TrainerServices
                                                    .getPlanByTrainerId(
                                                        trainerId,
                                                        _trainerController
                                                            .currentPlanType);
                                            _trainerController
                                                .isPlanLoading.value = false;
                                            _trainerController
                                                    .initialPostData.value =
                                                await TrainerServices
                                                    .getTrainerPosts(
                                                        trainerId, 0);
                                            _trainerController
                                                .isProfileLoading.value = false;

                                            if (_trainerController
                                                .initialPostData
                                                .value
                                                .response!
                                                .data!
                                                .isNotEmpty) {
                                              _trainerController
                                                      .trainerPostList.value =
                                                  _trainerController
                                                      .initialPostData
                                                      .value
                                                      .response!
                                                      .data!;
                                            } else {
                                              _trainerController.trainerPostList
                                                  .clear();
                                            }
                                          },
                                        )),
                              ),
                              // Container(
                              //   height: 250 * SizeConfig.heightMultiplier!,
                              //   child: ListView.separated(
                              //     padding: EdgeInsets.only(left: 12*SizeConfig.widthMultiplier!),
                              //     shrinkWrap: true,
                              //     physics: const BouncingScrollPhysics(),
                              //     scrollDirection: Axis.horizontal,
                              //     itemCount: _homeController.activePlans.length,
                              //     itemBuilder: (context, index) {
                              // SingleChildScrollView(
                              //   padding: EdgeInsets.only(
                              //       right: 10 * SizeConfig.widthMultiplier!),
                              //   scrollDirection: Axis.horizontal,
                              //   child: Row(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: List<Widget>.generate(
                              //         _homeController.activePlans.length,
                              //         (index) => MyTrainersTile(
                              //               planDetail: _homeController
                              //                   .activePlans[index],
                              //               name: _homeController
                              //                   .activePlans[index]
                              //                   .trainer!
                              //                   .name
                              //                   .toString(),
                              //               imageUrl: _homeController
                              //                   .activePlans[index]
                              //                   .trainer!
                              //                   .profilePhoto
                              //                   .toString(),
                              //               isCurrentlyEnrolled: true,
                              //               onMyTrainerTileTapped: () async {
                              //                 String trainerId = _homeController
                              //                     .activePlans[index]
                              //                     .trainer!
                              //                     .id!;
                              //                 _trainerController
                              //                         .atrainerDetail.value =
                              //                     TrainerModel.Trainer();
                              //                 _trainerController
                              //                     .isMyTrainerProfileLoading
                              //                     .value = true;
                              //                 _trainerController
                              //                     .isProfileLoading
                              //                     .value = true;
                              //                 Navigator.pushNamed(
                              //                     context,
                              //                     RouteName
                              //                         .trainerProfileScreen);
                              //                 var result = await TrainerServices
                              //                     .getATrainerDetail(trainerId);
                              //                 _trainerController
                              //                         .atrainerDetail.value =
                              //                     result.response!.data!;
                              //                 _trainerController
                              //                     .isMyTrainerProfileLoading
                              //                     .value = false;
                              //
                              //                 _trainerController
                              //                     .isPlanLoading.value = true;
                              //                 _trainerController
                              //                         .planModel.value =
                              //                     await TrainerServices
                              //                         .getPlanByTrainerId(
                              //                             trainerId,
                              //                             _trainerController
                              //                                 .currentPlanType);
                              //                 _trainerController
                              //                     .isPlanLoading.value = false;
                              //                 _trainerController
                              //                         .initialPostData.value =
                              //                     await TrainerServices
                              //                         .getTrainerPosts(
                              //                             trainerId, 0);
                              //                 _trainerController
                              //                     .isProfileLoading
                              //                     .value = false;
                              //
                              //                 if (_trainerController
                              //                     .initialPostData
                              //                     .value
                              //                     .response!
                              //                     .data!
                              //                     .isNotEmpty) {
                              //                   _trainerController
                              //                           .trainerPostList.value =
                              //                       _trainerController
                              //                           .initialPostData
                              //                           .value
                              //                           .response!
                              //                           .data!;
                              //                 } else {
                              //                   _trainerController
                              //                       .trainerPostList
                              //                       .clear();
                              //                 }
                              //               },
                              //             )),
                              //   ),
                              // ),
                              // },
                              // separatorBuilder:
                              //     (BuildContext context, int index) {
                              //   return SizedBox(
                              //     width: 10 * SizeConfig.widthMultiplier!,
                              //   );
                              // },
                              //   ),
                              // ),
                              SizedBox(
                                height: 16 * SizeConfig.heightMultiplier!,
                              ),
                              Container(
                                width: double.infinity,
                                height: 4 * SizeConfig.heightMultiplier!,
                                color: Theme.of(context).cardColor,
                              ),
                              SizedBox(
                                height: 15 * SizeConfig.heightMultiplier!,
                              ),
                            ],
                          );
                  } else {
                    return Container();
                  }
                }),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(ImagePath.bg2),
                              fit: BoxFit.cover)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15 * SizeConfig.heightMultiplier!,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12 * SizeConfig.widthMultiplier!),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(ImagePath.biceps),
                                SizedBox(
                                  width: 7 * SizeConfig.widthMultiplier!,
                                ),
                                GetTrainedTitle(
                                  title: 'getTrainer'.tr,
                                ),
                                Spacer(),
                                Obx(() => _trainerController
                                        .getTrainedIsLoading.value
                                    ? Container()
                                    : SeeAllButton(
                                        onTap: () async {
                                          _trainerController.currentPlanType ==
                                              0;

                                          Navigator.pushNamed(context,
                                              RouteName.allTrainerScreen);
                                          _trainerController
                                              .availability.value = [];
                                          _trainerController.isLoading.value =
                                              true;
                                          _trainerController.pageTitle.value =
                                              'trainers'.tr;
                                          _trainerController
                                              .SelectedSortMethod.value = -1;
                                          _trainerController
                                              .SelectedInterestIndex.value = 0;
                                          _trainerController.trainerType.value =
                                              0;
                                          _trainerController
                                              .searchedName.value = "";
                                          _trainerController
                                              .searchController.text = "";
                                          _trainerController.allTrainer.value =
                                              await TrainerServices
                                                  .getAllTrainer();
                                          _trainerController.isLoading.value =
                                              false;
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
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 13 * SizeConfig.widthMultiplier!,
                                  ),
                                  VisibilityDetector(
                                    key: const Key('T0'),
                                    onVisibilityChanged: (visibility) {
                                      if (visibility.visibleFraction > 0.5) {
                                        _trainerController
                                            .trainerListIndex.value = 0;
                                      }
                                    },
                                    child: SizedBox(
                                      height:
                                          245 * SizeConfig.heightMultiplier!,
                                      child: Image.asset(
                                        ImagePath.getTrained1,
                                        scale: 4,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 13 * SizeConfig.widthMultiplier!,
                                  ),
                                  VisibilityDetector(
                                    key: const Key('T1'),
                                    onVisibilityChanged: (visibility) {
                                      if (visibility.visibleFraction > 0.5) {
                                        _trainerController
                                            .trainerListIndex.value = 1;
                                      }
                                    },
                                    child: Container(
                                      height:
                                          245 * SizeConfig.heightMultiplier!,
                                      width: 330 * SizeConfig.widthMultiplier!,
                                      decoration: BoxDecoration(
                                          color: kPureBlack,
                                          borderRadius: BorderRadius.circular(
                                              8 *
                                                  SizeConfig
                                                      .heightMultiplier!)),
                                      child: Stack(
                                        children: [
                                          Image.asset(ImagePath.trainerBg),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.0 *
                                                    SizeConfig
                                                        .heightMultiplier!,
                                                vertical: 10 *
                                                    SizeConfig
                                                        .heightMultiplier!),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '12 Sessions Monthly'
                                                      .toUpperCase(),
                                                  style: AppTextStyle
                                                      .boldWhiteText
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 16 *
                                                              SizeConfig
                                                                  .textMultiplier!),
                                                ),
                                                SizedBox(
                                                  height: 8 *
                                                      SizeConfig
                                                          .widthMultiplier!,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(10 *
                                                      SizeConfig
                                                          .heightMultiplier!),
                                                  decoration: BoxDecoration(
                                                      color: kPureWhite
                                                          .withOpacity(0.1),
                                                      borderRadius: BorderRadius
                                                          .circular(8 *
                                                              SizeConfig
                                                                  .heightMultiplier!)),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '45 min Class'
                                                            .toUpperCase(),
                                                        style: AppTextStyle
                                                            .boldWhiteText
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 12 *
                                                                    SizeConfig
                                                                        .textMultiplier!),
                                                      ),
                                                      SizedBox(
                                                        height: 10 *
                                                            SizeConfig
                                                                .widthMultiplier!,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            '05 MINS \nWarm up',
                                                            style: AppTextStyle
                                                                .white400Text
                                                                .copyWith(
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                          Text(
                                                            '35 MINS \nWorkout',
                                                            style: AppTextStyle
                                                                .white400Text
                                                                .copyWith(
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                          Text(
                                                            '05 MINS \nStretching/Cool down',
                                                            style: AppTextStyle
                                                                .white400Text
                                                                .copyWith(
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 8 *
                                                      SizeConfig
                                                          .widthMultiplier!,
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.all(10 *
                                                      SizeConfig
                                                          .heightMultiplier!),
                                                  decoration: BoxDecoration(
                                                      color: kPureWhite
                                                          .withOpacity(0.1),
                                                      borderRadius: BorderRadius
                                                          .circular(8 *
                                                              SizeConfig
                                                                  .heightMultiplier!)),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '●  1 Expert Personal Trainer',
                                                        style: AppTextStyle
                                                            .white400Text
                                                            .copyWith(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 1 *
                                                            SizeConfig
                                                                .heightMultiplier!,
                                                      ),
                                                      Text(
                                                        '●  Unlimited Chat with coach',
                                                        style: AppTextStyle
                                                            .white400Text
                                                            .copyWith(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 1 *
                                                            SizeConfig
                                                                .heightMultiplier!,
                                                      ),
                                                      Text(
                                                        '●  3 Free trial sessions',
                                                        style: AppTextStyle
                                                            .white400Text
                                                            .copyWith(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 8 *
                                                      SizeConfig
                                                          .widthMultiplier!,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    const Icon(
                                                      Icons.arrow_back,
                                                      color: Colors.white,
                                                    ),
                                                    Text(
                                                      ' Swipe to see trainers',
                                                      style: AppTextStyle
                                                          .white400Text
                                                          .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  for (int index = 0;
                                      index <
                                          (_trainerController
                                                  .getTrainedIsLoading.value
                                              ? 5
                                              : _trainerController
                                                  .trainers
                                                  .value
                                                  .response!
                                                  .data!
                                                  .trainers!
                                                  .length);
                                      index++)
                                    _trainerController.getTrainedIsLoading.value
                                        ? Shimmer.fromColors(
                                            child: Padding(
                                              padding: index == 0
                                                  ? EdgeInsets.only(
                                                      left: 12 *
                                                          SizeConfig
                                                              .widthMultiplier!)
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
                                                Color.fromARGB(0, 255, 255, 255)
                                                    .withOpacity(0),
                                            highlightColor:
                                                Color.fromARGB(1, 255, 255, 255)
                                                    .withOpacity(0.46),
                                          )
                                        : VisibilityDetector(
                                            key: Key('T${index + 2}'),
                                            onVisibilityChanged: (visibility) {
                                              if (visibility.visibleFraction >
                                                  0.5) {
                                                _trainerController
                                                    .trainerListIndex.value = 2;
                                              }
                                            },
                                            child: Padding(
                                              padding: index == 0
                                                  ? EdgeInsets.only(
                                                      left: 12 *
                                                          SizeConfig
                                                              .widthMultiplier!)
                                                  : const EdgeInsets.all(0),
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
                                                certificateCount:
                                                    _trainerController
                                                        .trainers
                                                        .value
                                                        .response!
                                                        .data!
                                                        .trainers![index]
                                                        .certificates!
                                                        .length,
                                                rating: double.tryParse(
                                                    _trainerController
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
                                                strengthLength:
                                                    _trainerController
                                                        .trainers
                                                        .value
                                                        .response!
                                                        .data!
                                                        .trainers![index]
                                                        .strength!
                                                        .length,
                                                onTap: () async {
                                                  _trainerController
                                                      .currentPlanType = 0;
                                                  Navigator.pushNamed(
                                                      context,
                                                      RouteName
                                                          .trainerProfileScreen);
                                                  _trainerController
                                                      .isProfileLoading
                                                      .value = true;
                                                  _trainerController
                                                          .atrainerDetail
                                                          .value =
                                                      _trainerController
                                                          .trainers
                                                          .value
                                                          .response!
                                                          .data!
                                                          .trainers![index];
                                                  _trainerController
                                                      .loadingIndicator
                                                      .value = false;
                                                  // _trainerController.isPlanLoading.value =
                                                  //     true;
                                                  // _trainerController.planModel.value =
                                                  //     await TrainerServices
                                                  //         .getPlanByTrainerId(
                                                  //             _trainerController
                                                  //                 .trainers
                                                  //                 .value
                                                  //                 .response!
                                                  //                 .data!
                                                  //                 .trainers![index]
                                                  //                 .user!
                                                  //                 .id!);
                                                  // _trainerController.isPlanLoading.value =
                                                  //     false;
                                                  _trainerController
                                                          .initialPostData
                                                          .value =
                                                      await TrainerServices
                                                          .getTrainerPosts(
                                                              _trainerController
                                                                  .trainers
                                                                  .value
                                                                  .response!
                                                                  .data!
                                                                  .trainers![
                                                                      index]
                                                                  .user!
                                                                  .id!,
                                                              0);
                                                  if (_trainerController
                                                      .initialPostData
                                                      .value
                                                      .response!
                                                      .data!
                                                      .isNotEmpty) {
                                                    _trainerController
                                                            .trainerPostList
                                                            .value =
                                                        _trainerController
                                                            .initialPostData
                                                            .value
                                                            .response!
                                                            .data!;
                                                  } else {
                                                    _trainerController
                                                        .trainerPostList
                                                        .clear();
                                                  }
                                                  _trainerController
                                                      .isProfileLoading
                                                      .value = false;
                                                },
                                              ),
                                            ),
                                          )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 18 * SizeConfig.heightMultiplier!,
                          ),
                        ],
                      ),
                    ),
                    Obx(() => Indicator(
                        index: _trainerController.trainerListIndex.value)),
                  ],
                ),
                SizedBox(
                  height: 5 * SizeConfig.heightMultiplier!,
                ),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(ImagePath.bg3),
                            fit: BoxFit.cover),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15 * SizeConfig.heightMultiplier!,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12 * SizeConfig.widthMultiplier!),
                            child: Row(
                              children: [
                                SvgPicture.asset(ImagePath.videocam),
                                SizedBox(
                                  width: 7 * SizeConfig.widthMultiplier!,
                                ),
                                GetTrainedTitle(
                                  title: 'getFitnessConsult'.tr,
                                ),
                                Spacer(),
                                Obx(() => _trainerController
                                        .getTrainedIsLoading.value
                                    ? Container()
                                    : SeeAllButton(
                                        onTap: () async {
                                          _trainerController.currentPlanType ==
                                              1;

                                          Navigator.pushNamed(context,
                                              RouteName.allTrainerScreen);
                                          _trainerController.isLoading.value =
                                              true;
                                          _trainerController.pageTitle.value =
                                              'fitnessConsult'.tr;
                                          _trainerController
                                              .availability.value = [];
                                          _trainerController
                                              .SelectedInterestIndex.value = 0;
                                          _trainerController
                                              .searchedName.value = "";
                                          _trainerController.trainerType.value =
                                              1;
                                          _trainerController
                                              .searchController.text = "";
                                          _trainerController.allTrainer.value =
                                              await TrainerServices
                                                  .getAllTrainer();

                                          _trainerController.isLoading.value =
                                              false;
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
                                  SizedBox(
                                    width: 13 * SizeConfig.widthMultiplier!,
                                  ),
                                  VisibilityDetector(
                                    key: const Key('F1'),
                                    onVisibilityChanged: (visibility) {
                                      if (visibility.visibleFraction > 0.5) {
                                        _trainerController
                                            .fitnessListIndex.value = 0;
                                      }
                                    },
                                    child: SizedBox(
                                      height:
                                          245 * SizeConfig.heightMultiplier!,
                                      child: Image.asset(
                                        ImagePath.getTrained2,
                                        scale: 4,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 13 * SizeConfig.widthMultiplier!,
                                  ),
                                  VisibilityDetector(
                                    key: const Key('F2'),
                                    onVisibilityChanged: (visibility) {
                                      if (visibility.visibleFraction > 0.5) {
                                        _trainerController
                                            .fitnessListIndex.value = 1;
                                      }
                                    },
                                    child: Container(
                                      height:
                                          245 * SizeConfig.heightMultiplier!,
                                      width: 330 * SizeConfig.widthMultiplier!,
                                      decoration: BoxDecoration(
                                          color: kPureBlack,
                                          borderRadius: BorderRadius.circular(
                                              8 *
                                                  SizeConfig
                                                      .heightMultiplier!)),
                                      child: Stack(
                                        children: [
                                          Image.asset(ImagePath.trainerBg),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.0 *
                                                    SizeConfig
                                                        .heightMultiplier!,
                                                vertical: 10 *
                                                    SizeConfig
                                                        .heightMultiplier!),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '4 consultation Classes Monthly'
                                                      .toUpperCase(),
                                                  style: AppTextStyle
                                                      .boldWhiteText
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 16 *
                                                              SizeConfig
                                                                  .textMultiplier!),
                                                ),
                                                SizedBox(
                                                  height: 8 *
                                                      SizeConfig
                                                          .widthMultiplier!,
                                                ),
                                                Text(
                                                  '45 min consultation'
                                                      .toUpperCase(),
                                                  style: AppTextStyle
                                                      .boldWhiteText
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 12 *
                                                              SizeConfig
                                                                  .textMultiplier!),
                                                ),
                                                SizedBox(
                                                  height: 8 *
                                                      SizeConfig
                                                          .widthMultiplier!,
                                                ),
                                                SizedBox(
                                                  height: 8 *
                                                      SizeConfig
                                                          .widthMultiplier!,
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.all(10 *
                                                      SizeConfig
                                                          .heightMultiplier!),
                                                  decoration: BoxDecoration(
                                                      color: kPureWhite
                                                          .withOpacity(0.1),
                                                      borderRadius: BorderRadius
                                                          .circular(8 *
                                                              SizeConfig
                                                                  .heightMultiplier!)),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '●  1 Expert Personal Trainer',
                                                        style: AppTextStyle
                                                            .white400Text
                                                            .copyWith(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 1 *
                                                            SizeConfig
                                                                .heightMultiplier!,
                                                      ),
                                                      Text(
                                                        '●  Unlimited Chat with coach',
                                                        style: AppTextStyle
                                                            .white400Text
                                                            .copyWith(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 1 *
                                                            SizeConfig
                                                                .heightMultiplier!,
                                                      ),
                                                      Text(
                                                        '●  3 Free trial sessions',
                                                        style: AppTextStyle
                                                            .white400Text
                                                            .copyWith(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 1 *
                                                            SizeConfig
                                                                .heightMultiplier!,
                                                      ),
                                                      Text(
                                                        '●  1 Expert Personal Trainer',
                                                        style: AppTextStyle
                                                            .white400Text
                                                            .copyWith(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 1 *
                                                            SizeConfig
                                                                .heightMultiplier!,
                                                      ),
                                                      Text(
                                                        '●  Unlimited Chat with coach',
                                                        style: AppTextStyle
                                                            .white400Text
                                                            .copyWith(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 1 *
                                                            SizeConfig
                                                                .heightMultiplier!,
                                                      ),
                                                      Text(
                                                        '●  3 Free trial sessions',
                                                        style: AppTextStyle
                                                            .white400Text
                                                            .copyWith(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 8 *
                                                      SizeConfig
                                                          .widthMultiplier!,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    const Icon(
                                                      Icons.arrow_back,
                                                      color: Colors.white,
                                                    ),
                                                    Text(
                                                      ' Swipe to see consultations',
                                                      style: AppTextStyle
                                                          .white400Text
                                                          .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  for (int index = 0; index < 5; index++)
                                    _trainerController.getTrainedIsLoading.value
                                        ? Shimmer.fromColors(
                                            child: Padding(
                                              padding: index == 0
                                                  ? EdgeInsets.only(
                                                      left: 12 *
                                                          SizeConfig
                                                              .widthMultiplier!)
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
                                                Color.fromARGB(0, 255, 255, 255)
                                                    .withOpacity(0),
                                            highlightColor:
                                                Color.fromARGB(1, 255, 255, 255)
                                                    .withOpacity(0.46),
                                          )
                                        : VisibilityDetector(
                                            key: Key('F${index + 3}'),
                                            onVisibilityChanged: (visibility) {
                                              if (visibility.visibleFraction >
                                                  0.5) {
                                                _trainerController
                                                    .fitnessListIndex.value = 2;
                                              }
                                            },
                                            child: Padding(
                                              padding: index == 0
                                                  ? EdgeInsets.only(
                                                      left: 12 *
                                                          SizeConfig
                                                              .widthMultiplier!)
                                                  : EdgeInsets.all(0),
                                              child: TrainerCard(
                                                name: _trainerController
                                                            .trainers
                                                            .value
                                                            .response!
                                                            .data!
                                                            .fitnessConsultant![
                                                                index]
                                                            .user !=
                                                        null
                                                    ? _trainerController
                                                            .trainers
                                                            .value
                                                            .response!
                                                            .data!
                                                            .fitnessConsultant![
                                                                index]
                                                            .user!
                                                            .name ??
                                                        ''
                                                    : '',
                                                certificateCount:
                                                    _trainerController
                                                        .trainers
                                                        .value
                                                        .response!
                                                        .data!
                                                        .fitnessConsultant![
                                                            index]
                                                        .certificates!
                                                        .length,
                                                rating: double.tryParse(
                                                    _trainerController
                                                        .trainers
                                                        .value
                                                        .response!
                                                        .data!
                                                        .fitnessConsultant![
                                                            index]
                                                        .rating!)!,
                                                profilePhoto: _trainerController
                                                            .trainers
                                                            .value
                                                            .response!
                                                            .data!
                                                            .fitnessConsultant![
                                                                index]
                                                            .user !=
                                                        null
                                                    ? _trainerController
                                                            .trainers
                                                            .value
                                                            .response!
                                                            .data!
                                                            .fitnessConsultant![
                                                                index]
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
                                                strengthLength:
                                                    _trainerController
                                                        .trainers
                                                        .value
                                                        .response!
                                                        .data!
                                                        .fitnessConsultant![
                                                            index]
                                                        .strength!
                                                        .length,
                                                onTap: () async {
                                                  _trainerController
                                                      .currentPlanType = 1;
                                                  Navigator.pushNamed(
                                                      context,
                                                      RouteName
                                                          .trainerProfileScreen);
                                                  _trainerController
                                                      .isProfileLoading
                                                      .value = true;
                                                  _trainerController
                                                      .atrainerDetail
                                                      .value = _trainerController
                                                          .trainers
                                                          .value
                                                          .response!
                                                          .data!
                                                          .fitnessConsultant![
                                                      index];
                                                  // _trainerController.isPlanLoading.value =
                                                  //     true;
                                                  // _trainerController.planModel.value =
                                                  //     await TrainerServices
                                                  //         .getPlanByTrainerId(
                                                  //             _trainerController
                                                  //                 .trainers
                                                  //                 .value
                                                  //                 .response!
                                                  //                 .data!
                                                  //                 .fitnessConsultant![index]
                                                  //                 .user!
                                                  //                 .id!);
                                                  // _trainerController.isPlanLoading.value =
                                                  //     false;
                                                  _trainerController
                                                      .loadingIndicator
                                                      .value = false;
                                                  _trainerController
                                                          .initialPostData
                                                          .value =
                                                      await TrainerServices
                                                          .getTrainerPosts(
                                                              _trainerController
                                                                  .trainers
                                                                  .value
                                                                  .response!
                                                                  .data!
                                                                  .fitnessConsultant![
                                                                      index]
                                                                  .user!
                                                                  .id!,
                                                              0);
                                                  if (_trainerController
                                                          .initialPostData
                                                          .value
                                                          .response!
                                                          .data!
                                                          .length !=
                                                      0) {
                                                    _trainerController
                                                            .trainerPostList
                                                            .value =
                                                        _trainerController
                                                            .initialPostData
                                                            .value
                                                            .response!
                                                            .data!;
                                                  } else {
                                                    _trainerController
                                                        .trainerPostList
                                                        .clear();
                                                  }
                                                  _trainerController
                                                      .isProfileLoading
                                                      .value = false;
                                                },
                                              ),
                                            ),
                                          )
                                ],
                              )),
                            ),
                          ),
                          SizedBox(
                            height: 18 * SizeConfig.heightMultiplier!,
                          ),
                        ],
                      ),
                    ),
                    Obx(() => Indicator(
                        index: _trainerController.fitnessListIndex.value)),
                  ],
                ),
                SizedBox(
                  height: 5 * SizeConfig.heightMultiplier!,
                ),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(ImagePath.bg1),
                              fit: BoxFit.cover)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15 * SizeConfig.heightMultiplier!,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12 * SizeConfig.widthMultiplier!),
                            child: Row(
                              children: [
                                SvgPicture.asset(ImagePath.apple),
                                SizedBox(
                                  width: 7 * SizeConfig.widthMultiplier!,
                                ),
                                GetTrainedTitle(
                                  title: 'getNutritionConsult'.tr,
                                ),
                                Spacer(),
                                Obx(() => _trainerController
                                        .getTrainedIsLoading.value
                                    ? Container()
                                    : SeeAllButton(
                                        onTap: () async {
                                          _trainerController.currentPlanType ==
                                              2;

                                          _trainerController
                                              .SelectedInterestIndex.value = 0;
                                          _trainerController
                                              .searchedName.value = "";
                                          _trainerController.trainerType.value =
                                              2;
                                          _trainerController
                                              .searchController.text = "";
                                          _trainerController
                                              .availability.value = [];
                                          Navigator.pushNamed(context,
                                              RouteName.allTrainerScreen);
                                          _trainerController.isLoading.value =
                                              true;
                                          _trainerController.pageTitle.value =
                                              'nutritionConsult'.tr;
                                          _trainerController.allTrainer.value =
                                              await TrainerServices
                                                  .getAllTrainer();
                                          _trainerController.isLoading.value =
                                              false;
                                        },
                                      ))
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 18 * SizeConfig.heightMultiplier!,
                          ),
                          Obx(
                            () => SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 13 * SizeConfig.widthMultiplier!,
                                  ),
                                  VisibilityDetector(
                                    key: const Key('N1'),
                                    onVisibilityChanged: (visibility) {
                                      if (visibility.visibleFraction > 0.5) {
                                        _trainerController
                                            .nutritionListIndex.value = 0;
                                      }
                                    },
                                    child: SizedBox(
                                      height:
                                          245 * SizeConfig.heightMultiplier!,
                                      child: Image.asset(
                                        ImagePath.getTrained3,
                                        scale: 4,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 13 * SizeConfig.widthMultiplier!,
                                  ),
                                  VisibilityDetector(
                                    key: const Key('N2'),
                                    onVisibilityChanged: (visibility) {
                                      if (visibility.visibleFraction > 0.5) {
                                        _trainerController
                                            .nutritionListIndex.value = 1;
                                      }
                                    },
                                    child: Container(
                                      height:
                                          245 * SizeConfig.heightMultiplier!,
                                      width: 330 * SizeConfig.widthMultiplier!,
                                      decoration: BoxDecoration(
                                          color: kPureBlack,
                                          borderRadius: BorderRadius.circular(
                                              8 *
                                                  SizeConfig
                                                      .heightMultiplier!)),
                                      child: Stack(
                                        children: [
                                          Image.asset(ImagePath.trainerBg),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.0 *
                                                    SizeConfig
                                                        .heightMultiplier!,
                                                vertical: 10 *
                                                    SizeConfig
                                                        .heightMultiplier!),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '4 consultation Classes Monthly'
                                                      .toUpperCase(),
                                                  style: AppTextStyle
                                                      .boldWhiteText
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 16 *
                                                              SizeConfig
                                                                  .textMultiplier!),
                                                ),
                                                SizedBox(
                                                  height: 8 *
                                                      SizeConfig
                                                          .widthMultiplier!,
                                                ),
                                                Text(
                                                  '45 min consultation'
                                                      .toUpperCase(),
                                                  style: AppTextStyle
                                                      .boldWhiteText
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 12 *
                                                              SizeConfig
                                                                  .textMultiplier!),
                                                ),
                                                SizedBox(
                                                  height: 8 *
                                                      SizeConfig
                                                          .widthMultiplier!,
                                                ),
                                                SizedBox(
                                                  height: 8 *
                                                      SizeConfig
                                                          .widthMultiplier!,
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.all(10 *
                                                      SizeConfig
                                                          .heightMultiplier!),
                                                  decoration: BoxDecoration(
                                                      color: kPureWhite
                                                          .withOpacity(0.1),
                                                      borderRadius: BorderRadius
                                                          .circular(8 *
                                                              SizeConfig
                                                                  .heightMultiplier!)),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '●  1 Expert Personal Trainer',
                                                        style: AppTextStyle
                                                            .white400Text
                                                            .copyWith(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 1 *
                                                            SizeConfig
                                                                .heightMultiplier!,
                                                      ),
                                                      Text(
                                                        '●  Unlimited Chat with coach',
                                                        style: AppTextStyle
                                                            .white400Text
                                                            .copyWith(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 1 *
                                                            SizeConfig
                                                                .heightMultiplier!,
                                                      ),
                                                      Text(
                                                        '●  3 Free trial sessions',
                                                        style: AppTextStyle
                                                            .white400Text
                                                            .copyWith(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 1 *
                                                            SizeConfig
                                                                .heightMultiplier!,
                                                      ),
                                                      Text(
                                                        '●  1 Expert Personal Trainer',
                                                        style: AppTextStyle
                                                            .white400Text
                                                            .copyWith(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 1 *
                                                            SizeConfig
                                                                .heightMultiplier!,
                                                      ),
                                                      Text(
                                                        '●  Unlimited Chat with coach',
                                                        style: AppTextStyle
                                                            .white400Text
                                                            .copyWith(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 1 *
                                                            SizeConfig
                                                                .heightMultiplier!,
                                                      ),
                                                      Text(
                                                        '●  3 Free trial sessions',
                                                        style: AppTextStyle
                                                            .white400Text
                                                            .copyWith(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 8 *
                                                      SizeConfig
                                                          .widthMultiplier!,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Icon(
                                                      Icons.arrow_back,
                                                      color: Colors.white,
                                                    ),
                                                    Text(
                                                      ' Swipe to see consultations',
                                                      style: AppTextStyle
                                                          .white400Text
                                                          .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  for (int index = 0; index < 5; index++)
                                    _trainerController.getTrainedIsLoading.value
                                        ? Shimmer.fromColors(
                                            child: Padding(
                                              padding: index == 0
                                                  ? EdgeInsets.only(
                                                      left: 12 *
                                                          SizeConfig
                                                              .widthMultiplier!)
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
                                                Color.fromARGB(0, 255, 255, 255)
                                                    .withOpacity(0),
                                            highlightColor:
                                                Color.fromARGB(1, 255, 255, 255)
                                                    .withOpacity(0.46),
                                          )
                                        : VisibilityDetector(
                                            key: Key('N${index + 3}'),
                                            onVisibilityChanged: (visibility) {
                                              if (visibility.visibleFraction >
                                                  0.5) {
                                                _trainerController
                                                    .nutritionListIndex
                                                    .value = 2;
                                              }
                                            },
                                            child: Padding(
                                              padding: index == 0
                                                  ? EdgeInsets.only(
                                                      left: 12 *
                                                          SizeConfig
                                                              .widthMultiplier!)
                                                  : EdgeInsets.all(0),
                                              child: TrainerCard(
                                                name: _trainerController
                                                            .trainers
                                                            .value
                                                            .response!
                                                            .data!
                                                            .nutritionConsultant![
                                                                index]
                                                            .user !=
                                                        null
                                                    ? _trainerController
                                                            .trainers
                                                            .value
                                                            .response!
                                                            .data!
                                                            .nutritionConsultant![
                                                                index]
                                                            .user!
                                                            .name ??
                                                        ''
                                                    : '',
                                                certificateCount:
                                                    _trainerController
                                                        .trainers
                                                        .value
                                                        .response!
                                                        .data!
                                                        .nutritionConsultant![
                                                            index]
                                                        .certificates!
                                                        .length,
                                                rating: double.tryParse(
                                                    _trainerController
                                                        .trainers
                                                        .value
                                                        .response!
                                                        .data!
                                                        .nutritionConsultant![
                                                            index]
                                                        .rating!)!,
                                                profilePhoto: _trainerController
                                                            .trainers
                                                            .value
                                                            .response!
                                                            .data!
                                                            .nutritionConsultant![
                                                                index]
                                                            .user !=
                                                        null
                                                    ? _trainerController
                                                            .trainers
                                                            .value
                                                            .response!
                                                            .data!
                                                            .nutritionConsultant![
                                                                index]
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
                                                strengthLength:
                                                    _trainerController
                                                        .trainers
                                                        .value
                                                        .response!
                                                        .data!
                                                        .nutritionConsultant![
                                                            index]
                                                        .strength!
                                                        .length,
                                                onTap: () async {
                                                  _trainerController
                                                      .currentPlanType = 2;
                                                  Navigator.pushNamed(
                                                      context,
                                                      RouteName
                                                          .trainerProfileScreen);
                                                  _trainerController
                                                      .isProfileLoading
                                                      .value = true;
                                                  _trainerController
                                                      .atrainerDetail
                                                      .value = _trainerController
                                                          .trainers
                                                          .value
                                                          .response!
                                                          .data!
                                                          .nutritionConsultant![
                                                      index];
                                                  // _trainerController.isPlanLoading.value =
                                                  //     true;
                                                  // _trainerController.planModel.value =
                                                  //     await TrainerServices
                                                  //         .getPlanByTrainerId(
                                                  //             _trainerController
                                                  //                 .trainers
                                                  //                 .value
                                                  //                 .response!
                                                  //                 .data!
                                                  //                 .nutritionConsultant![
                                                  //                     index]
                                                  //                 .user!
                                                  //                 .id!);
                                                  // _trainerController.isPlanLoading.value =
                                                  //     false;
                                                  _trainerController
                                                      .loadingIndicator
                                                      .value = false;
                                                  _trainerController
                                                          .initialPostData
                                                          .value =
                                                      await TrainerServices
                                                          .getTrainerPosts(
                                                              _trainerController
                                                                  .trainers
                                                                  .value
                                                                  .response!
                                                                  .data!
                                                                  .nutritionConsultant![
                                                                      index]
                                                                  .user!
                                                                  .id!,
                                                              0);
                                                  if (_trainerController
                                                          .initialPostData
                                                          .value
                                                          .response!
                                                          .data!
                                                          .length !=
                                                      0) {
                                                    _trainerController
                                                            .trainerPostList
                                                            .value =
                                                        _trainerController
                                                            .initialPostData
                                                            .value
                                                            .response!
                                                            .data!;
                                                  } else {
                                                    _trainerController
                                                        .trainerPostList
                                                        .clear();
                                                  }
                                                  _trainerController
                                                      .isProfileLoading
                                                      .value = false;
                                                },
                                              ),
                                            ),
                                          ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 18 * SizeConfig.heightMultiplier!,
                          ),
                        ],
                      ),
                    ),
                    Obx(() => Indicator(
                        index: _trainerController.nutritionListIndex.value)),
                  ],
                ),
                SizedBox(
                  height: 20 * SizeConfig.heightMultiplier!,
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: 12 * SizeConfig.widthMultiplier!),
                  width: Get.width - 24 * SizeConfig.widthMultiplier!,
                  padding: EdgeInsets.symmetric(
                      vertical: 13 * SizeConfig.heightMultiplier!,
                      horizontal: 16 * SizeConfig.widthMultiplier!),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(8 * SizeConfig.heightMultiplier!),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Did you know?'.toUpperCase(),
                        style: AppTextStyle.boldWhiteText.copyWith(
                            fontSize: 18 * SizeConfig.textMultiplier!,
                            fontWeight: FontWeight.w900),
                      ),
                      SizedBox(
                        height: 15 * SizeConfig.heightMultiplier!,
                      ),
                      Text.rich(
                        TextSpan(
                          text:
                              'Working out under a Coach helps you achieve your Goals  ',
                          style: AppTextStyle.grey400Text.copyWith(
                            fontSize: 16 * SizeConfig.textMultiplier!,
                          ),
                          children: [
                            TextSpan(
                              text: '3x',
                              style: AppTextStyle.greenSemiBoldText.copyWith(
                                fontSize: 32 * SizeConfig.textMultiplier!,
                              ),
                            ),
                            TextSpan(
                              text: ' Faster!',
                              style: AppTextStyle.greenSemiBoldText.copyWith(
                                fontSize: 16 * SizeConfig.textMultiplier!,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20 * SizeConfig.heightMultiplier!,
                ),
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: 12 * SizeConfig.widthMultiplier!),
                      width: Get.width - 24 * SizeConfig.widthMultiplier!,
                      padding: EdgeInsets.symmetric(
                          vertical: 13 * SizeConfig.heightMultiplier!,
                          horizontal: 16 * SizeConfig.widthMultiplier!),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            8 * SizeConfig.heightMultiplier!),
                        color: Theme.of(context).cardColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'How to choose',
                            style: AppTextStyle.boldWhiteText.copyWith(
                                fontSize: 18 * SizeConfig.textMultiplier!,
                                fontWeight: FontWeight.w900),
                          ),
                          Text(
                            '"Your Perfect Cocach"'.toUpperCase(),
                            style: AppTextStyle.boldWhiteText.copyWith(
                                fontSize: 18 * SizeConfig.textMultiplier!,
                                fontWeight: FontWeight.w900),
                          ),
                          SizedBox(
                            height: 15 * SizeConfig.heightMultiplier!,
                          ),
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            minLeadingWidth: 5,
                            leading: Text(
                              '•',
                            ),
                            title: Text(
                              'Know your Goals.',
                              style: AppTextStyle.grey400Text.copyWith(
                                fontSize: 16 * SizeConfig.textMultiplier!,
                              ),
                            ),
                          ),
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            minLeadingWidth: 5,
                            leading: Text(
                              '•',
                            ),
                            title: Text(
                              'Look for the Coach with similar interests as yours.',
                              style: AppTextStyle.grey400Text.copyWith(
                                fontSize: 16 * SizeConfig.textMultiplier!,
                              ),
                            ),
                          ),
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            minLeadingWidth: 5,
                            leading: Text(
                              '•',
                            ),
                            title: Text(
                              'Use Free 3 trial sessions to better understand your Coach.',
                              style: AppTextStyle.grey400Text.copyWith(
                                fontSize: 16 * SizeConfig.textMultiplier!,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.all(10 * SizeConfig.heightMultiplier!),
                      child: SvgPicture.asset(ImagePath.dumbbell),
                    )
                  ],
                ),
                SizedBox(
                  height: 40 * SizeConfig.heightMultiplier!,
                ),
                Center(
                  child: SvgPicture.asset(
                    ImagePath.logo,
                    width: 80 * SizeConfig.heightMultiplier!,
                  ),
                )
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
        child: Container(
          color: Colors.transparent,
          margin: EdgeInsets.only(left: 20),
          child: Text(
            title != null ? title!.tr : 'seeAll'.tr,
            style: AppTextStyle.NormalText.copyWith(
                fontSize: 14 * SizeConfig.textMultiplier!,
                decoration: TextDecoration.underline,
                color: kPureWhite),
          ),
        ));
  }
}

class MyTrainersTile extends StatefulWidget {
  MyTrainersTile({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.isCurrentlyEnrolled,
    this.onMyTrainerTileTapped,
    required this.planDetail,
    this.isSubscriptionPage = false,
    required this.index,
  }) : super(key: key);

  String imageUrl;
  String name;
  bool isCurrentlyEnrolled;
  GestureTapCallback? onMyTrainerTileTapped;
  PlanDetail planDetail;
  bool isSubscriptionPage;
  int index;

  @override
  State<MyTrainersTile> createState() => _MyTrainersTileState();
}

class _MyTrainersTileState extends State<MyTrainersTile> {
  final HomeController _homeController = Get.find();

  final TrainerController _trainerController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onMyTrainerTileTapped,
      child: Container(
        margin: widget.isSubscriptionPage
            ? EdgeInsets.symmetric(horizontal: 10 * SizeConfig.widthMultiplier!)
            : EdgeInsets.zero,
        width: widget.isSubscriptionPage
            ? Get.width
            : Get.width - 65 * SizeConfig.widthMultiplier!,
        padding: EdgeInsets.symmetric(
            vertical: 13 * SizeConfig.heightMultiplier!,
            horizontal: 16 * SizeConfig.widthMultiplier!),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8 * SizeConfig.heightMultiplier!),
          color: Theme.of(context).cardColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25 * SizeConfig.imageSizeMultiplier!,
                  backgroundImage: NetworkImage(widget.imageUrl),
                ),
                SizedBox(
                  width: 12 * SizeConfig.widthMultiplier!,
                ),
                SizedBox(
                  width: 120 * SizeConfig.textMultiplier!,
                  child: Text(
                    widget.name.capitalize!,
                    style: AppTextStyle.white400Text,
                    textAlign: TextAlign.left,
                    maxLines: 2,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.planDetail.isExpanded =
                          !widget.planDetail.isExpanded;
                      _trainerController.isCarouselExpanded.value =
                          widget.planDetail.isExpanded;
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        widget.planDetail.isExpanded
                            ? 'Hide details'
                            : 'Show details',
                        style: AppTextStyle.NormalText.copyWith(
                            fontSize: 14 * SizeConfig.textMultiplier!,
                            color:
                                Theme.of(context).textTheme.headline1?.color),
                      ),
                      SizedBox(
                        width: 5 * SizeConfig.widthMultiplier!,
                      ),
                      Icon(
                        widget.planDetail.isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 25 * SizeConfig.heightMultiplier!,
                        color: Theme.of(context).textTheme.headline1?.color,
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15 * SizeConfig.heightMultiplier!,
            ),
            widget.planDetail.isExpanded
                ? Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            color: kGreyColor,
                            size: 20 * SizeConfig.heightMultiplier!,
                          ),
                          SizedBox(
                            width: 10 * SizeConfig.heightMultiplier!,
                          ),
                          Text(
                            'Timings',
                            style: AppTextStyle.white400Text.copyWith(
                              color: kGreyColor,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            Get.find<TrainerController>()
                                .getTime(widget.planDetail.sessionTime!.name!),
                            style: AppTextStyle.white400Text,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10 * SizeConfig.heightMultiplier!,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            color: kGreyColor,
                            size: 20 * SizeConfig.heightMultiplier!,
                          ),
                          SizedBox(
                            width: 10 * SizeConfig.heightMultiplier!,
                          ),
                          Text(
                            'Days',
                            style: AppTextStyle.white400Text.copyWith(
                              color: kGreyColor,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _homeController
                                .getDaysFromIndex(widget.planDetail.weekDays!),
                            style: AppTextStyle.white400Text,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10 * SizeConfig.heightMultiplier!,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.note_alt_outlined,
                            color: kGreyColor,
                            size: 20 * SizeConfig.heightMultiplier!,
                          ),
                          SizedBox(
                            width: 10 * SizeConfig.heightMultiplier!,
                          ),
                          Text(
                            'Plan',
                            style: AppTextStyle.white400Text.copyWith(
                              color: kGreyColor,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            widget.planDetail.planDetails!.planName!,
                            style: AppTextStyle.white400Text,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10 * SizeConfig.heightMultiplier!,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.alarm,
                            color: kGreyColor,
                            size: 20 * SizeConfig.heightMultiplier!,
                          ),
                          SizedBox(
                            width: 10 * SizeConfig.heightMultiplier!,
                          ),
                          Text(
                            'Plan Expiry',
                            style: AppTextStyle.white400Text.copyWith(
                              color: kGreyColor,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            DateFormat('d MMMM yyyy')
                                .format(widget.planDetail.expiryDate!),
                            style: AppTextStyle.white400Text,
                          ),
                        ],
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Get.find<TrainerController>()
                            .getTime(widget.planDetail.sessionTime!.name!),
                        style: AppTextStyle.white400Text,
                      ),
                      Text(
                        _homeController
                            .getDaysFromIndex(widget.planDetail.weekDays!),
                        style: AppTextStyle.white400Text,
                      ),
                    ],
                  ),
            if (widget.planDetail.isExpanded)
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 5 * SizeConfig.heightMultiplier!),
                child: Divider(
                  color: Colors.white.withOpacity(0.16),
                ),
              ),
            if (widget.planDetail.isExpanded && !widget.isSubscriptionPage)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _homeController.activePlans[widget.index].isChangeExpanded =
                        !_homeController
                            .activePlans[widget.index].isChangeExpanded;
                    _trainerController.showChangeTiming.value =
                        _homeController.activePlans[widget.index].isChangeExpanded;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Request a change in timings',
                      style: AppTextStyle.NormalText.copyWith(
                          fontSize: 14 * SizeConfig.textMultiplier!,
                          color: kPureWhite,
                          decoration: TextDecoration.underline),
                    ),
                    SizedBox(
                      width: 5 * SizeConfig.widthMultiplier!,
                    ),
                    Icon(
                      _homeController.activePlans[widget.index].isChangeExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 25 * SizeConfig.heightMultiplier!,
                      color: Theme.of(context).textTheme.headline1?.color,
                    )
                  ],
                ),
              ),
            if (_homeController.activePlans[widget.index].isChangeExpanded &&
                widget.planDetail.isExpanded &&
                widget.planDetail.postponeSessionLeft! > 0)
              GestureDetector(
                onTap: () {
                  Get.dialog(
                    PostponeSessionWidget(
                      trainerId: widget.planDetail.trainer!.id!,
                      planId: widget.planDetail.id!,
                      expiryDate: widget.planDetail.expiryDate!,
                      days: widget.planDetail.weekDays!,
                      time: widget.planDetail.sessionTime!.name!,
                    ),
                  );
                },
                child: Container(
                  margin:
                      EdgeInsets.only(top: 10 * SizeConfig.heightMultiplier!),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20 * SizeConfig.widthMultiplier!,
                    vertical: 15 * SizeConfig.heightMultiplier!,
                  ),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(4 * SizeConfig.heightMultiplier!),
                    color: grey2B,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.history,
                        color: kPureWhite,
                      ),
                      SizedBox(
                        width: 15 * SizeConfig.heightMultiplier!,
                      ),
                      Text(
                        'Postpone next session',
                        style: AppTextStyle.NormalText.copyWith(
                          fontSize: 14 * SizeConfig.textMultiplier!,
                          color: kPureWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (_homeController.activePlans[widget.index].isChangeExpanded &&
                widget.planDetail.isExpanded &&
                widget.planDetail.postponeSessionLeft! < 1)
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 10 * SizeConfig.heightMultiplier!),
                child: Text(
                    'You have already postponed your sessions three times',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.grey400Text),
              ),
            if (widget.planDetail.isExpanded && widget.isSubscriptionPage)
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(
                        () => ReviewPage(
                          image: widget.planDetail.trainer!.profilePhoto!,
                          name: widget.planDetail.trainer!.name!,
                          trainerId: widget.planDetail.trainer!.id!,
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 8 * SizeConfig.heightMultiplier!),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20 * SizeConfig.widthMultiplier!,
                        vertical: 15 * SizeConfig.heightMultiplier!,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            4 * SizeConfig.heightMultiplier!),
                        color: kgreen49,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.star_border,
                            color: kPureWhite,
                          ),
                          SizedBox(
                            width: 15 * SizeConfig.heightMultiplier!,
                          ),
                          Text(
                            'Rate and review',
                            style: AppTextStyle.NormalText.copyWith(
                              fontSize: 14 * SizeConfig.textMultiplier!,
                              color: kPureWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.dialog(
                        CancelSubscriptionWidget(
                          trainerName: widget.planDetail.trainer!.name!,
                          planId: widget.planDetail.id!,
                          planName: widget.planDetail.planDetails!.planName!,
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 8 * SizeConfig.heightMultiplier!),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20 * SizeConfig.widthMultiplier!,
                        vertical: 15 * SizeConfig.heightMultiplier!,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            4 * SizeConfig.heightMultiplier!),
                        color: grey2B,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.close,
                            color: kPureWhite,
                          ),
                          SizedBox(
                            width: 15 * SizeConfig.heightMultiplier!,
                          ),
                          Text(
                            'Cancel Subcription',
                            style: AppTextStyle.NormalText.copyWith(
                              fontSize: 14 * SizeConfig.textMultiplier!,
                              color: kPureWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}

class PostponeSessionWidget extends StatelessWidget {
  PostponeSessionWidget({
    Key? key,
    required this.trainerId,
    required this.planId,
    required this.time,
    // required this.date,
    required this.days,
    required this.expiryDate,
  }) : super(key: key);

  final String trainerId;
  final String planId;
  final String time;
  // final DateTime date;
  final List<int> days;
  final DateTime expiryDate;

  final _trainerController = Get.find<TrainerController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 30 * SizeConfig.heightMultiplier!,
          horizontal: 30 * SizeConfig.widthMultiplier!,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8 * SizeConfig.heightMultiplier!),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              child: Icon(
                Icons.question_mark,
                color: kBlack,
              ),
              backgroundColor: kGreenColor,
            ),
            SizedBox(
              height: 15 * SizeConfig.heightMultiplier!,
            ),
            Text(
              'Are you sure',
              style: AppTextStyle.boldWhiteText.copyWith(
                fontSize: 24 * SizeConfig.textMultiplier!,
              ),
            ),
            SizedBox(
              height: 8 * SizeConfig.heightMultiplier!,
            ),
            Text(
              'Your sessions will be postponed to end of your subscription',
              textAlign: TextAlign.center,
              style: AppTextStyle.boldWhiteText.copyWith(
                fontSize: 14 * SizeConfig.textMultiplier!,
              ),
            ),
            SizedBox(
              height: 40 * SizeConfig.heightMultiplier!,
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: Get.back,
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 10 * SizeConfig.heightMultiplier!),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20 * SizeConfig.widthMultiplier!,
                        vertical: 15 * SizeConfig.heightMultiplier!,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            4 * SizeConfig.heightMultiplier!),
                        color: grey2B,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Cancel',
                            style: AppTextStyle.NormalText.copyWith(
                              fontSize: 14 * SizeConfig.textMultiplier!,
                              color: kPureWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 8 * SizeConfig.widthMultiplier!,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      Get.back();
                      Get.dialog(
                        Center(child: CustomizedCircularProgress()),
                        barrierDismissible: false,
                      );
                      var response = await _trainerController.postponeSession(
                        trainerId: trainerId,
                        expiryDate: expiryDate,
                        planId: planId,
                        time: time,
                        days: days,
                      );
                      if (response != null) {
                        Get.back();
                        Get.dialog(
                          PostponeSessionSuccess(
                              expiryDate: response.expiryDate.toString(),
                              postponeSessionLeft:
                                  response.postponeSessionLeft.toString()),
                          barrierDismissible: false,
                        );
                      } else {
                        Get.back();
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 10 * SizeConfig.heightMultiplier!),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20 * SizeConfig.widthMultiplier!,
                        vertical: 15 * SizeConfig.heightMultiplier!,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            4 * SizeConfig.heightMultiplier!),
                        color: grey2B,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Confirm',
                            style: AppTextStyle.NormalText.copyWith(
                              fontSize: 14 * SizeConfig.textMultiplier!,
                              color: kPureWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30 * SizeConfig.heightMultiplier!,
            ),
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: hintGrey,
                  size: 15 * SizeConfig.heightMultiplier!,
                ),
                SizedBox(
                  width: 10 * SizeConfig.widthMultiplier!,
                ),
                Expanded(
                  child: Text(
                    'You can only postpone three times',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.grey400Text,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PostponeSessionSuccess extends StatelessWidget {
  const PostponeSessionSuccess(
      {Key? key, required this.expiryDate, required this.postponeSessionLeft})
      : super(key: key);

  final String postponeSessionLeft;
  final String expiryDate;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: GestureDetector(
        onTap: () async {
          var data = await Get.find<HomeController>().getActivePlans();
          Get.find<HomeController>().update();
          Get.find<TrainerController>().update();
          Get.back();
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 30 * SizeConfig.heightMultiplier!,
            horizontal: 30 * SizeConfig.widthMultiplier!,
          ),
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(8 * SizeConfig.heightMultiplier!),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                child: Icon(
                  Icons.check,
                  color: kBlack,
                ),
                backgroundColor: kGreenColor,
              ),
              SizedBox(
                height: 15 * SizeConfig.heightMultiplier!,
              ),
              Text(
                'Thank you',
                style: AppTextStyle.boldWhiteText.copyWith(
                  fontSize: 24 * SizeConfig.textMultiplier!,
                ),
              ),
              SizedBox(
                height: 23 * SizeConfig.heightMultiplier!,
              ),
              Text.rich(
                TextSpan(
                  text: 'Your session has been \npostponed to ',
                  children: [
                    TextSpan(
                      text: DateFormat('d MMMM yyyy')
                          .format(DateTime.parse(expiryDate)),
                      style: AppTextStyle.boldWhiteText.copyWith(
                          fontSize: 14 * SizeConfig.textMultiplier!,
                          color: kGreenColor),
                    )
                  ],
                ),
                textAlign: TextAlign.center,
                style: AppTextStyle.boldWhiteText.copyWith(
                  fontSize: 14 * SizeConfig.textMultiplier!,
                ),
              ),
              SizedBox(
                height: 30 * SizeConfig.heightMultiplier!,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: hintGrey,
                    size: 15 * SizeConfig.heightMultiplier!,
                  ),
                  SizedBox(
                    width: 10 * SizeConfig.widthMultiplier!,
                  ),
                  Text(
                    'You have only $postponeSessionLeft postpone left',
                    style: AppTextStyle.grey400Text,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CancelSubscriptionWidget extends StatelessWidget {
  CancelSubscriptionWidget({
    Key? key,
    required this.trainerName,
    required this.planId,
    required this.planName,
  }) : super(key: key);

  final String trainerName;
  final String planId;
  final String planName;

  final _trainerController = Get.find<TrainerController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 30 * SizeConfig.heightMultiplier!,
          horizontal: 30 * SizeConfig.widthMultiplier!,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8 * SizeConfig.heightMultiplier!),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              child: Icon(
                Icons.question_mark,
                color: kBlack,
              ),
              backgroundColor: kGreenColor,
            ),
            SizedBox(
              height: 15 * SizeConfig.heightMultiplier!,
            ),
            Text(
              'Are you sure',
              style: AppTextStyle.boldWhiteText.copyWith(
                fontSize: 24 * SizeConfig.textMultiplier!,
              ),
            ),
            SizedBox(
              height: 8 * SizeConfig.heightMultiplier!,
            ),
            Text(
              'Your subscription will be \ncancelled upon confirmation',
              textAlign: TextAlign.center,
              style: AppTextStyle.boldWhiteText.copyWith(
                fontSize: 14 * SizeConfig.textMultiplier!,
              ),
            ),
            SizedBox(
              height: 40 * SizeConfig.heightMultiplier!,
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: Get.back,
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 10 * SizeConfig.heightMultiplier!),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20 * SizeConfig.widthMultiplier!,
                        vertical: 15 * SizeConfig.heightMultiplier!,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            4 * SizeConfig.heightMultiplier!),
                        color: grey2B,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Go back',
                            style: AppTextStyle.NormalText.copyWith(
                              fontSize: 14 * SizeConfig.textMultiplier!,
                              color: kPureWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 8 * SizeConfig.widthMultiplier!,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      Get.back();
                      Get.dialog(Center(child: CustomizedCircularProgress()),
                          barrierDismissible: false);
                      var response =
                          await _trainerController.cancelSubscription(
                        planId: planId,
                        planName: planName,
                        trainerName: trainerName,
                      );
                      if (response) {
                        Get.back();
                        Get.dialog(const CancelSubscriptionConfirmWidget());
                      } else {
                        Get.back();
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 10 * SizeConfig.heightMultiplier!),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20 * SizeConfig.widthMultiplier!,
                        vertical: 15 * SizeConfig.heightMultiplier!,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            4 * SizeConfig.heightMultiplier!),
                        color: grey2B,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'I\'m sure',
                            style: AppTextStyle.NormalText.copyWith(
                              fontSize: 14 * SizeConfig.textMultiplier!,
                              color: kPureWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CancelSubscriptionConfirmWidget extends StatelessWidget {
  const CancelSubscriptionConfirmWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 30 * SizeConfig.heightMultiplier!,
          horizontal: 30 * SizeConfig.widthMultiplier!,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8 * SizeConfig.heightMultiplier!),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              ImagePath.sadFace,
              scale: 3.5,
            ),
            SizedBox(
              height: 15 * SizeConfig.heightMultiplier!,
            ),
            Text(
              'Sorry to see \nyou go.',
              textAlign: TextAlign.center,
              style: AppTextStyle.boldWhiteText.copyWith(
                fontSize: 18 * SizeConfig.textMultiplier!,
              ),
            ),
            SizedBox(
              height: 8 * SizeConfig.heightMultiplier!,
            ),
            Text(
              'Your request has been \nupdated.You’ll hear from \nour team soon',
              textAlign: TextAlign.center,
              style: AppTextStyle.boldWhiteText.copyWith(
                fontSize: 14 * SizeConfig.textMultiplier!,
              ),
            ),
            SizedBox(
              height: 24 * SizeConfig.heightMultiplier!,
            ),
            GestureDetector(
              onTap: () async {
                Get.back();
                Get.back();
                Get.find<HomeController>()
                  ..selectedIndex.value = 0
                  ..update();
                Get.back();
              },
              child: Container(
                margin: EdgeInsets.only(top: 10 * SizeConfig.heightMultiplier!),
                padding: EdgeInsets.symmetric(
                  horizontal: 20 * SizeConfig.widthMultiplier!,
                  vertical: 15 * SizeConfig.heightMultiplier!,
                ),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(4 * SizeConfig.heightMultiplier!),
                  color: kgreen49,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Back to Home',
                      style: AppTextStyle.NormalText.copyWith(
                        fontSize: 14 * SizeConfig.textMultiplier!,
                        color: kPureWhite,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 40 * SizeConfig.heightMultiplier!,
            ),
          ],
        ),
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  const Indicator({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0 * SizeConfig.heightMultiplier!),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.circle,
            size: 8,
            color: index == 0 ? kPureWhite : kGreyColor,
          ),
          SizedBox(
            width: 3 * SizeConfig.widthMultiplier!,
          ),
          Icon(
            Icons.circle,
            size: 8,
            color: index == 1 ? kPureWhite : kGreyColor,
          ),
          SizedBox(
            width: 3 * SizeConfig.widthMultiplier!,
          ),
          Icon(
            Icons.circle,
            size: 8,
            color: index == 2 ? kPureWhite : kGreyColor,
          ),
        ],
      ),
    );
  }
}
