
import 'dart:convert';

import 'dart:ui';

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitbasix/feature/Home/model/RecentCommentModel.dart';
import 'package:fitbasix/feature/Home/model/comment_model.dart';
import 'package:fitbasix/feature/get_trained/controller/trainer_controller.dart';
import 'package:fitbasix/feature/posts/controller/post_controller.dart';
import 'package:fitbasix/feature/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/Home/services/home_service.dart';
import 'package:fitbasix/feature/Home/view/my_trainers_screen.dart';
import 'package:fitbasix/feature/Home/view/post_screen.dart';
import 'package:fitbasix/feature/Home/view/tools_screen.dart';
import 'package:fitbasix/feature/Home/view/widgets/caloriesDetails.dart';
import 'package:fitbasix/feature/Home/view/widgets/custom_bottom_nav_bar.dart';
import 'package:fitbasix/feature/Home/view/widgets/green_circle_arrow_button.dart';
import 'package:fitbasix/feature/Home/view/widgets/healthData.dart';
import 'package:fitbasix/feature/Home/view/widgets/home_tile.dart';
import 'package:fitbasix/feature/Home/view/widgets/menu_screen.dart';
import 'package:fitbasix/feature/Home/view/widgets/post_tile.dart';
import 'package:fitbasix/feature/log_in/controller/login_controller.dart';
import 'package:fitbasix/feature/posts/view/create_post.dart';
import 'package:fitbasix/feature/spg/view/set_goal_intro_screen.dart';
import 'package:shimmer/shimmer.dart';

import '../../get_trained/view/get_trained_screen.dart';
import '../../profile/services/profile_services.dart';
import '../../spg/view/set_goal_screen.dart';

class HomeAndTrainerPage extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    var dependencyupdate =
        homeController.remoteConfig.getString('UiDependency');
    var jsonOb = json.decode(dependencyupdate);

    final List<Widget> screens = [
      if (jsonOb['home'] == 1) HomePage(),
      if (jsonOb['get_trained'] == 1) GetTrainedScreen(),
      if (jsonOb['post'] == 1) CreatePostScreen(),
      if (jsonOb['tools'] == 1) ToolsScreen(),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      key: homeController.drawerKey,
      body: Obx(() => screens[homeController.selectedIndex.value]),
      // bottomNavigationBar: CustomizedBottomAppBar(),

      bottomNavigationBar: CustomBottomNavigationBar(
        length: screens.length,
      ),
      endDrawer: Drawer(
        child: Obx(
          () => MenuScreen(
              imageCoverPic:
                  homeController.userProfileData.value.response == null
                      ? ""
                      : homeController.coverPhoto.value == ""
                          ? homeController.userProfileData.value.response!.data!
                              .profile!.coverPhoto
                              .toString()
                          : homeController.coverPhoto.value,
              name: homeController.userProfileData.value.response == null
                  ? ""
                  : homeController
                      .userProfileData.value.response!.data!.profile!.name.toString(),
              imageUrl: homeController.userProfileData.value.response == null
                  ? ""
                  : homeController.profilePhoto.value==""?homeController.userProfileData.value.response!.data!
                      .profile!.profilePhoto
                      .toString():homeController.profilePhoto.value),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _homeController = Get.find();
  final PostController postController = Get.put(PostController());
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    _homeController.currentPage.value = 1;

    _scrollController.addListener(() async {
      print(_homeController.isNeedToLoadData.value);
      if (_homeController.isNeedToLoadData.value == true) {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.position.pixels) {
          _homeController.showLoader.value = true;
          final postQuery = await HomeService.getPosts(
              skip: _homeController.currentPage.value);

          if (postQuery.response!.data!.length < 5) {
            _homeController.isNeedToLoadData.value = false;
            _homeController.trendingPostList.addAll(postQuery.response!.data!);
            _homeController.showLoader.value = false;

            return;
          } else {
            log(_homeController.trendingPostList.toString());
            if (_homeController.trendingPostList.last.id ==
                postQuery.response!.data!.last.id) {
              _homeController.showLoader.value = false;
              return;
            }

            _homeController.trendingPostList.addAll(postQuery.response!.data!);
            _homeController.showLoader.value = false;
          }

          _homeController.currentPage.value++;
          _homeController.showLoader.value = false;
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final now = DateTime.now();
    String formatter = DateFormat('MMMd').format(now);
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: kPureWhite,
      //   centerTitle: false,
      //   elevation: 0,
      //   automaticallyImplyLeading: false,
      //   actions: [
      //     IconButton(
      //         onPressed: () {}, icon: SvgPicture.asset(ImagePath.bellIcon))
      //   ],
      // ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
          child: Obx(() => _homeController.isLoading.value
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(child: CustomizedCircularProgress()),
                )
              : SingleChildScrollView(
                  controller: _scrollController,
                  child: Stack(
                    children: [
                      Container(
                        height: 178 * SizeConfig.heightMultiplier!,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 16 * SizeConfig.widthMultiplier!,
                                right: 16 * SizeConfig.widthMultiplier!),

                            child: Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.only(
                                  top: 8 * SizeConfig.heightMultiplier!,
                                  bottom: 8 * SizeConfig.heightMultiplier!),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async{
                                      final ProfileController _profileController=Get.put(ProfileController());
                                      _profileController.directFromHome.value=true;
                                      Navigator.pushNamed(context, RouteName.userprofileinfo);
                                      _profileController.initialPostData.value =
                                      await ProfileServices.getUserPosts();

                                      if (_profileController
                                          .initialPostData.value.response!.data!.length !=
                                          0) {
                                        _profileController.userPostList.value =
                                        _profileController.initialPostData.value.response!.data!;
                                      } else {
                                        _profileController.userPostList.clear();
                                      }
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                    constraints: BoxConstraints(
                                      minWidth: Get.width-120*SizeConfig.widthMultiplier!,
                                      // maxWidth: Get.width-100*SizeConfig.widthMultiplier!
                                    ),

                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                30 * SizeConfig.widthMultiplier!),
                                            child: Obx(() => CachedNetworkImage(
                                                imageUrl:_homeController.profilePhoto.value==""? _homeController
                                                    .userProfileData
                                                    .value
                                                    .response!
                                                    .data!
                                                    .profile!
                                                    .profilePhoto
                                                    .toString():_homeController.profilePhoto.value,
                                                placeholder: (context, url) => ShimmerEffect(),
                                                errorWidget: (context, url, error) => ShimmerEffect(),
                                                fit: BoxFit.cover,
                                                height:
                                                    60 * SizeConfig.widthMultiplier!,
                                                width:
                                                    60 * SizeConfig.widthMultiplier!)),
                                          ),
                                          SizedBox(
                                            width: 15*SizeConfig.widthMultiplier!,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                // mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  _homeController.userProfileData.value
                                                              .response ==
                                                          null
                                                      ? Container()
                                                      : Text(
                                                          'hi_name'.trParams({
                                                            'name': _homeController
                                                                .userProfileData
                                                                .value
                                                                .response!
                                                                .data!
                                                                .profile!
                                                                .name.toString()
                                                          }),
                                                          style: AppTextStyle
                                                              .boldBlackText.copyWith(
                                                            color: Theme.of(context).textTheme.bodyText1?.color
                                                          ),
                                                        ),
                                                  // SizedBox(
                                                  //   width: 31 *
                                                  //       SizeConfig.widthMultiplier!,
                                                  // ),
                                                ],
                                              ),
                                              Obx(
                                                ()=> Container(
                                                 width:  Get.width-130*SizeConfig.widthMultiplier!,
                                                  child: Text(
                                                    _homeController
                                                        .userProfileData
                                                        .value
                                                        .response!
                                                        .data!
                                                        .profile!.bio == null?'home_page_subtitle'.tr:_homeController
                                                        .userProfileData
                                                        .value
                                                        .response!
                                                        .data!
                                                        .profile!.bio.toString(),

                                                    style: AppTextStyle.normalBlackText
                                                        .copyWith(
                                                        color: Theme.of(context).textTheme.bodyText1?.color,
                                                            fontSize: 12 *
                                                                SizeConfig.textMultiplier!),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        
                                        ],
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  SvgPicture.asset(ImagePath.bellIcon,
                                    color: Theme.of(context).primaryIconTheme.color,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16 * SizeConfig.heightMultiplier!,
                          ),

                        _homeController.userProfileData.value.response!.data!.profile!.isPreviousEnrolled==true
                              ?Container()
                              :Container(
                               padding: EdgeInsets.symmetric(
                               horizontal: 16 * SizeConfig.widthMultiplier!,
                               vertical: 11 * SizeConfig.heightMultiplier!,
                               ),
                               color: kBlack,
                               child: Row(
                               crossAxisAlignment: CrossAxisAlignment.center,
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 Container(
                                  width: 216 * SizeConfig.widthMultiplier!,
                                  child: Text(
                                    'You can get a lot more out of it Start with our demo plan'.tr,
                                    style: AppTextStyle.black600Text.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.color),
                                  ),
                                ),
                                 Spacer(),
                                //join button
                                 GestureDetector(
                                  onTap: () {
                                      Navigator.pushNamed(context, RouteName.getTrainedScreen);
                                  },
                                  child: Container(
                                    height: 36 * SizeConfig.heightMultiplier!,
                                    width: 96 * SizeConfig.widthMultiplier!,
                                    decoration: BoxDecoration(
                                      color: kgreen49,
                                      borderRadius: BorderRadius.circular(
                                          8 * SizeConfig.heightMultiplier!),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Take Demo'.tr,
                                        style: AppTextStyle.black600Text.copyWith(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                ?.color),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),

                          //live stream
                          // Container(
                          //   padding: EdgeInsets.symmetric(
                          //     horizontal: 16 * SizeConfig.widthMultiplier!,
                          //     vertical: 8 * SizeConfig.heightMultiplier!,
                          //   ),
                          //   color: kBlack,
                          //   child: Row(
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     children: [
                          //       Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         mainAxisAlignment: MainAxisAlignment.start,
                          //         children: [
                          //           Text(
                          //             'Jonathan is streaming live now',
                          //             style: AppTextStyle.black600Text.copyWith(
                          //                 color: Theme.of(context)
                          //                     .textTheme
                          //                     .bodyText1
                          //                     ?.color),
                          //           ),
                          //           SizedBox(
                          //               height:
                          //                   8 * SizeConfig.heightMultiplier!),
                          //           Container(
                          //             padding: EdgeInsets.only(
                          //                 top: 4 * SizeConfig.heightMultiplier!,
                          //                 bottom:
                          //                     4 * SizeConfig.heightMultiplier!,
                          //                 right:
                          //                     8 * SizeConfig.widthMultiplier!,
                          //                 left: 8.67 *
                          //                     SizeConfig.widthMultiplier!),
                          //             height: 24 * SizeConfig.heightMultiplier!,
                          //             //  width:98*SizeConfig.widthMultiplier!,
                          //             decoration: BoxDecoration(
                          //               color: Theme.of(context)
                          //                   .textTheme
                          //                   .headline4
                          //                   ?.color,
                          //               borderRadius: BorderRadius.circular(
                          //                   8 * SizeConfig.heightMultiplier!),
                          //             ),
                          //             child: Row(
                          //               crossAxisAlignment:
                          //                   CrossAxisAlignment.center,
                          //               mainAxisAlignment:
                          //                   MainAxisAlignment.center,
                          //               children: [
                          //                 Icon(
                          //                   Icons.visibility,
                          //                   color:
                          //                       Theme.of(context).primaryColor,
                          //                   size: 20,
                          //                 ),
                          //                 SizedBox(
                          //                   width: 4.67 *
                          //                       SizeConfig.widthMultiplier!,
                          //                 ),
                          //                 Text('28 viewers',
                          //                     style: AppTextStyle.black600Text
                          //                         .copyWith(
                          //                             fontSize: (12) *
                          //                                 SizeConfig
                          //                                     .textMultiplier!,
                          //                             color: Theme.of(context)
                          //                                 .textTheme
                          //                                 .bodyText1
                          //                                 ?.color)),
                          //               ],
                          //             ),
                          //           )
                          //         ],
                          //       ),
                          //       Spacer(),
                          //       //join button
                          //       GestureDetector(
                          //         onTap: () {},
                          //         child: Container(
                          //           height: 36 * SizeConfig.heightMultiplier!,
                          //           width: 96 * SizeConfig.widthMultiplier!,
                          //           decoration: BoxDecoration(
                          //             color: Color(0xFFFF5A5A),
                          //             borderRadius: BorderRadius.circular(
                          //                 8 * SizeConfig.heightMultiplier!),
                          //           ),
                          //           padding: EdgeInsets.symmetric(
                          //               horizontal:
                          //                   35 * SizeConfig.widthMultiplier!,
                          //               vertical:
                          //                   8 * SizeConfig.heightMultiplier!),
                          //           child: Text(
                          //             'Join'.tr,
                          //             style: AppTextStyle.black600Text.copyWith(
                          //                 color: Theme.of(context)
                          //                     .textTheme
                          //                     .bodyText1
                          //                     ?.color),
                          //           ),
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),

                          Padding(
                            padding: EdgeInsets.only(
                                left: 16 * SizeConfig.widthMultiplier!,
                                right: 16 * SizeConfig.widthMultiplier!),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'today'.tr,
                                  style: AppTextStyle.boldBlackText.copyWith(
                                      fontSize: 16 * SizeConfig.textMultiplier!,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          ?.color),
                                ),
                                Text(
                                  formatter,
                                  style: AppTextStyle.boldBlackText.copyWith(
                                      fontSize: 14 * SizeConfig.textMultiplier!,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          ?.color),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 24 * SizeConfig.heightMultiplier!,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 16 * SizeConfig.widthMultiplier!,
                                right: 16 * SizeConfig.widthMultiplier!),
                            child: _homeController.spgStatus.value == true
                                ? Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Obx(() => _homeController
                                                  .waterConsumedDataLoading
                                                  .value
                                              ? Shimmer.fromColors(
                                                  child: Container(
                                                    height: 220 *
                                                        SizeConfig
                                                            .heightMultiplier!,
                                                    width: (Get.width / 2) -
                                                        20 *
                                                            SizeConfig
                                                                .widthMultiplier!,
                                                    color: Colors.white,
                                                  ),
                                                  baseColor:
                                                      const Color.fromRGBO(
                                                          240, 240, 240, 1),
                                                  highlightColor:
                                                      const Color.fromRGBO(
                                                          245, 245, 245, 1),
                                                )
                                              : Expanded(
                                                  child: WaterConsumed(
                                                      _homeController
                                                          .userProfileData
                                                          .value
                                                          .response!
                                                          .data!
                                                          .profile!
                                                          .nutrition!
                                                          .totalWaterConsumed!
                                                          .toDouble(),
                                                      _homeController
                                                          .userProfileData
                                                          .value
                                                          .response!
                                                          .data!
                                                          .profile!
                                                          .nutrition!
                                                          .totalWaterRequired!
                                                          .toDouble(),
                                                      () async {
                                                  print(
                                                      "homeController.waterLevel.value" +
                                                          _homeController
                                                              .waterLevel.value
                                                              .toString());
                                                  _homeController
                                                      .isConsumptionLoading
                                                      .value = true;
                                                  Navigator.pushNamed(context,
                                                      RouteName.waterConsumed);
                                                  _homeController
                                                          .waterSource.value =
                                                      await HomeService
                                                          .fetchReminderData();
                                                  _homeController
                                                          .waterDetails.value =
                                                      await HomeService
                                                          .getWaterDetails();
                                                  _homeController
                                                          .goalWater.value =
                                                      _homeController
                                                          .waterDetails
                                                          .value
                                                          .response!
                                                          .data![0]
                                                          .totalWaterRequired!;
                                                  _homeController
                                                          .waterStatus.value =
                                                      _homeController
                                                          .waterDetails
                                                          .value
                                                          .response!
                                                          .data![0]
                                                          .status!;
                                                  _homeController
                                                          .waterTimingTo.value =
                                                      TimeOfDay(
                                                          hour: int.parse(
                                                              _homeController
                                                                  .waterDetails
                                                                  .value
                                                                  .response!
                                                                  .data![0]
                                                                  .sleepTime!
                                                                  .split(
                                                                      ":")[0]),
                                                          minute: int.parse(
                                                              _homeController
                                                                  .waterDetails
                                                                  .value
                                                                  .response!
                                                                  .data![0]
                                                                  .sleepTime!
                                                                  .split(":")[1]));
                                                  _homeController
                                                          .waterTimingFrom
                                                          .value =
                                                      TimeOfDay(
                                                          hour: int.parse(_homeController
                                                              .waterDetails
                                                              .value
                                                              .response!
                                                              .data![0]
                                                              .wakeupTime!
                                                              .split(":")[0]),
                                                          minute: int.parse(
                                                              _homeController
                                                                  .waterDetails
                                                                  .value
                                                                  .response!
                                                                  .data![0]
                                                                  .wakeupTime!
                                                                  .split(
                                                                      ":")[1]));
                                                  _homeController
                                                          .waterReminder.value =
                                                      _homeController
                                                          .getWaterReminder(
                                                              _homeController
                                                                  .waterDetails
                                                                  .value
                                                                  .response!
                                                                  .data![0]
                                                                  .waterReminder!);
                                                  _homeController.waterLevel
                                                      .value = _homeController
                                                              .waterDetails
                                                              .value
                                                              .response!
                                                              .data![0]
                                                              .totalWaterConsumed ==
                                                          0.0
                                                      ? 0.0
                                                      : (_homeController
                                                              .userProfileData
                                                              .value
                                                              .response!
                                                              .data!
                                                              .profile!
                                                              .nutrition!
                                                              .totalWaterConsumed! /
                                                          (_homeController
                                                              .userProfileData
                                                              .value
                                                              .response!
                                                              .data!
                                                              .profile!
                                                              .nutrition!
                                                              .totalWaterRequired!));
                                                  _homeController
                                                      .isConsumptionLoading
                                                      .value = false;
                                                },
                                                      //homecontroller
                                                      _homeController,
                                                      //Passing context for theme
                                                      context))),
                                          SizedBox(
                                            width: 8.0 *
                                                SizeConfig.widthMultiplier!,
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 0.0 *
                                                      SizeConfig
                                                          .widthMultiplier!),
                                              child: CaloriesBurnt(
                                                  _homeController
                                                      .caloriesBurnt.value
                                                      .toInt()
                                                      .toDouble(), () {
                                                showDialog(
                                                    context: context,
                                                    builder: (_) =>
                                                        HealthApp());
                                              },
                                                  //is connected
                                                  true,
                                                  //Passing context for theme
                                                  context),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                          height: 20 *
                                              SizeConfig.heightMultiplier!),
                                      CaloryConsumption(
                                          _homeController
                                                  .userProfileData
                                                  .value
                                                  .response!
                                                  .data!
                                                  .profile!
                                                  .nutrition!
                                                  .totalRequiredCalories!
                                                  .toInt()
                                                  .toString() +
                                              " kcal",
                                          _homeController
                                                  .userProfileData
                                                  .value
                                                  .response!
                                                  .data!
                                                  .profile!
                                                  .nutrition!
                                                  .carbs!
                                                  .carbsGrams!
                                                  .toInt()
                                                  .toString() +
                                              " g",
                                          _homeController
                                                  .userProfileData
                                                  .value
                                                  .response!
                                                  .data!
                                                  .profile!
                                                  .nutrition!
                                                  .carbs!
                                                  .carbsKiloCals!
                                                  .toInt()
                                                  .toString() +
                                              " kcal",
                                          _homeController
                                                  .userProfileData
                                                  .value
                                                  .response!
                                                  .data!
                                                  .profile!
                                                  .nutrition!
                                                  .protein!
                                                  .proteinGrams!
                                                  .toInt()
                                                  .toString() +
                                              " g",
                                          _homeController
                                                  .userProfileData
                                                  .value
                                                  .response!
                                                  .data!
                                                  .profile!
                                                  .nutrition!
                                                  .protein!
                                                  .proteinKiloCals!
                                                  .toInt()
                                                  .toString() +
                                              " kcal",
                                          _homeController
                                                  .userProfileData
                                                  .value
                                                  .response!
                                                  .data!
                                                  .profile!
                                                  .nutrition!
                                                  .fats!
                                                  .fatsGrams!
                                                  .toInt()
                                                  .toString() +
                                              " g",
                                          _homeController
                                                  .userProfileData
                                                  .value
                                                  .response!
                                                  .data!
                                                  .profile!
                                                  .nutrition!
                                                  .fats!
                                                  .fatsKiloCals!
                                                  .toInt()
                                                  .toString() +
                                              " kcal",
                                          //passing context for theme
                                          context),
                                      SizedBox(
                                          height: 20 *
                                              SizeConfig.heightMultiplier!),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, RouteName.setGoal);
                                        },
                                        child: Container(
                                            color: Colors.transparent,
                                            child: Row(
                                              children: [
                                                Text('updateSpg'.tr,
                                                    style: AppTextStyle
                                                        .normalBlackText
                                                        .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1
                                                                ?.color,
                                                            fontSize: 14 *
                                                                SizeConfig
                                                                    .textMultiplier!)),
                                                Spacer(),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: kgreen4F),
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        vertical: 8.0 *
                                                            SizeConfig
                                                                .heightMultiplier!,
                                                        horizontal: 23 *
                                                            SizeConfig
                                                                .widthMultiplier!),
                                                    child: Text(
                                                      'update'.tr,
                                                      style: AppTextStyle
                                                          .normalWhiteText
                                                          .copyWith(
                                                              fontSize: 14 *
                                                                  SizeConfig
                                                                      .textMultiplier!),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )),
                                      ),
                                    ],
                                  )
                                : Container(
                                    // padding:
                                    //     EdgeInsets.only(left: 16, bottom: 16),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.10),
                                              blurRadius: 10,
                                              spreadRadius: -2,
                                              offset: Offset(0, 5))
                                        ]),
                                    child: Column(
                                      children: [
                                        // Row(
                                        //   crossAxisAlignment:
                                        //       CrossAxisAlignment.start,
                                        //   children: [
                                        //     Container(
                                        //       padding: EdgeInsets.only(
                                        //           top: 16 *
                                        //               SizeConfig
                                        //                   .heightMultiplier!),
                                        //       width: 126 *
                                        //           SizeConfig.widthMultiplier!,
                                        //       child: Text(
                                        //         'set_goal_heading'.tr,
                                        //         style: AppTextStyle
                                        //             .boldBlackText
                                        //             .copyWith(
                                        //                 fontSize: 14 *
                                        //                     SizeConfig
                                        //                         .textMultiplier!),
                                        //         maxLines: 4,
                                        //       ),
                                        //     ),
                                        //     CachedNetworkImage(
                                        //         imageUrl:
                                        //             "https://fitbasix-dev.s3.me-south-1.amazonaws.com/HealthGoalImage.png",
                                        //         fit: BoxFit.cover,
                                        //         height: 120 *
                                        //             SizeConfig.widthMultiplier!,
                                        //         width: 186 *
                                        //             SizeConfig
                                        //                 .widthMultiplier!),
                                        //   ],
                                        // ),
                                        Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  topRight: Radius.circular(8)),
                                              child: Image.asset(
                                                ImagePath.setgoalfeedImage,
                                                height: 125 *
                                                    SizeConfig
                                                        .heightMultiplier!,
                                                width: Get.width,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Container(
                                              height: 125 *
                                                  SizeConfig.heightMultiplier!,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(8),
                                                    topRight:
                                                        Radius.circular(8)),
                                                gradient: RadialGradient(
                                                    colors: [
                                                      Color(0xff000000)
                                                          .withOpacity(0),
                                                      Color(0xff000000)
                                                          .withOpacity(0.22),
                                                      Color(0xff000000)
                                                          .withOpacity(1.0),
                                                    ],
                                                    focal: Alignment.center,
                                                    radius: 8.0),
                                              ),
                                            ),
                                            Positioned(
                                                top: 63,
                                                left: 16,
                                                right: 178,
                                                child: Text(
                                                  'set_goal_heading'.tr,
                                                  style: AppTextStyle
                                                      .boldBlackText
                                                      .copyWith(
                                                          fontSize: 14 *
                                                              SizeConfig
                                                                  .textMultiplier!,
                                                          color: kPureWhite),
                                                  maxLines: 3,
                                                ))
                                          ],
                                        ),
                                        SizedBox(
                                            height: 13 *
                                                SizeConfig.widthMultiplier!),
                                        // above
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 16, bottom: 16),
                                          child: Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Image.asset(
                                                        ImagePath.dropIcon,
                                                        width: 11 *
                                                            SizeConfig
                                                                .widthMultiplier!,
                                                        height: 15 *
                                                            SizeConfig
                                                                .heightMultiplier!,
                                                        fit: BoxFit.contain,
                                                      ),
                                                      SizedBox(
                                                        width: 10 *
                                                            SizeConfig
                                                                .widthMultiplier!,
                                                      ),
                                                      Text(
                                                        'add_water_intake'.tr,
                                                        style: AppTextStyle
                                                            .smallBlackText
                                                            .copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyText1
                                                                    ?.color,
                                                                fontSize: 14 *
                                                                    SizeConfig
                                                                        .textMultiplier!),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 8 *
                                                        SizeConfig
                                                            .heightMultiplier!,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Image.asset(
                                                        ImagePath.fireIcon,
                                                        width: 11 *
                                                            SizeConfig
                                                                .widthMultiplier!,
                                                        height: 15 *
                                                            SizeConfig
                                                                .heightMultiplier!,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      SizedBox(
                                                        width: 10 *
                                                            SizeConfig
                                                                .widthMultiplier!,
                                                      ),
                                                      Text(
                                                        'track_calories'.tr,
                                                        style: AppTextStyle
                                                            .smallBlackText
                                                            .copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyText1
                                                                    ?.color,
                                                                fontSize: 14 *
                                                                    SizeConfig
                                                                        .textMultiplier!),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Spacer(),
                                              GreenCircleArrowButton(
                                                onTap: () {
                                                  Navigator.pushNamed(context,
                                                      RouteName.setGoalIntro);
                                                },
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                          ),
                          SizedBox(
                            height: 16 * SizeConfig.heightMultiplier!,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 16 * SizeConfig.widthMultiplier!,
                                right: 16 * SizeConfig.widthMultiplier!),
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 16 * SizeConfig.heightMultiplier!,
                                  bottom: 16 * SizeConfig.heightMultiplier!,
                                  left: 16 * SizeConfig.widthMultiplier!),
                              height: 72 * SizeConfig.heightMultiplier!,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Theme.of(context).cardColor,
                                  // gradient: LinearGradient(
                                  //   begin: Alignment.centerLeft,
                                  //     end: Alignment.centerRight,
                                  //     colors: [kBlack.withOpacity(1), Color(0xFF948F8F).withOpacity(0)]),
                                  boxShadow: [
                                    BoxShadow(
                                        color: kBlack.withOpacity(0.10),
                                        blurRadius: 10,
                                        spreadRadius: 0,
                                        offset: Offset(0, 5))
                                  ]),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    ImagePath.searchFavoriteIcon,
                                  ),
                                  SizedBox(
                                    width: 16 * SizeConfig.widthMultiplier!,
                                  ),
                                  Container(
                                    width: 200 * SizeConfig.widthMultiplier!,
                                    child: Text(
                                      'explore_fitbasix'.tr,
                                      style:
                                          AppTextStyle.boldBlackText.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.color,
                                        fontSize:
                                            14 * SizeConfig.textMultiplier!,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  GreenCircleArrowButton(
                                    onTap: () async {
                                      _homeController.explorePageCount.value =
                                          0;
                                      Navigator.pushNamed(
                                          context, RouteName.exploreSearch);
                                      postController.getCategory();
                                      _homeController
                                          .isExploreDataLoading.value = true;
                                      _homeController.explorePostModel.value =
                                          await HomeService.getExplorePosts(
                                        skip: 0,
                                      );
                                      _homeController.explorePostList.value =
                                          _homeController.explorePostModel.value
                                              .response!.data!;
                                      _homeController
                                          .isExploreDataLoading.value = false;
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 24 * SizeConfig.heightMultiplier!,
                          ),
                          Container(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 16 * SizeConfig.heightMultiplier!,
                                      top: 16 * SizeConfig.heightMultiplier!),
                                  child: Text(
                                    'trending_posts'.tr,
                                    style: AppTextStyle.boldBlackText.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.color,
                                        fontSize:
                                            16 * SizeConfig.textMultiplier!),
                                  ),
                                ),
                                SizedBox(
                                  height: 16 * SizeConfig.heightMultiplier!,
                                ),
                                Container(
                                  // height: 5000,
                                  child: Obx(
                                    () => _homeController.isPostUpdate.value
                                        ? Center(child: Container())
                                        : ListView.builder(
                                            itemCount: _homeController
                                                        .trendingPostList
                                                        .length ==
                                                    0
                                                ? 0
                                                : _homeController
                                                    .trendingPostList.length,
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (_, index) {
                                              log("can not");
                                              _homeController
                                                  .alreadyRenderedPostId
                                                  .add(_homeController
                                                      .trendingPostList[index]
                                                      .id!);
                                              _homeController
                                                  .alreadyRenderedPostId
                                                  .toSet();
                                              // if(_homeController.alreadyRenderedPostId.indexOf(_homeController
                                              //     .trendingPostList[
                                              // index]
                                              //     .id!)==-1){
                                              //   log("add");
                                              //   _homeController.commentsMap.addIf(false==false,
                                              //       _homeController
                                              //           .trendingPostList[
                                              //       index]
                                              //           .id!, _homeController
                                              //           .trendingPostList[
                                              //       index]
                                              //           .commentgiven);
                                              //   _homeController.updateCount.addIf(false==false,
                                              //       _homeController
                                              //           .trendingPostList[
                                              //       index]
                                              //           .id!, UpdateCount(id: _homeController
                                              //           .trendingPostList[
                                              //       index]
                                              //           .id!,
                                              //           comments: _homeController
                                              //               .trendingPostList[
                                              //           index]
                                              //               .comments,
                                              //           likes: _homeController
                                              //               .trendingPostList[
                                              //           index]
                                              //               .likes
                                              //       ));
                                              // }

// log(_homeController
//     .commentsMap[_homeController
//     .trendingPostList[
// index]
//     .id!]!.comment.toString());

                                              if (_homeController
                                                      .trendingPostList.length <
                                                  5) {
                                                _homeController.isNeedToLoadData
                                                    .value = false;
                                              }
                                              return Obx(() => Column(
                                                    children: [
                                                      PostTile(
                                                        comment: _homeController
                                                                        .commentsMap[
                                                                    _homeController
                                                                        .trendingPostList[
                                                                            index]
                                                                        .id!] ==
                                                                null
                                                            ? _homeController
                                                                .trendingPostList[
                                                                    index]
                                                                .commentgiven
                                                            : _homeController
                                                                    .commentsMap[
                                                                _homeController
                                                                    .trendingPostList[
                                                                        index]
                                                                    .id!],
                                                        name: _homeController
                                                            .trendingPostList[
                                                                index]
                                                            .userId!
                                                            .name.toString(),
                                                        profilePhoto:
                                                            _homeController
                                                                .trendingPostList[
                                                                    index]
                                                                .userId!
                                                                .profilePhoto!,
                                                        category: _homeController
                                                            .trendingPostList[
                                                                index]
                                                            .postCategory![0]
                                                            .name!,
                                                        date: DateFormat.d()
                                                            .add_MMM()
                                                            .format(_homeController
                                                                .trendingPostList[
                                                                    index]
                                                                .updatedAt!),
                                                        place: _homeController
                                                                    .trendingPostList[
                                                                        index]
                                                                    .location!
                                                                    .placeName!
                                                                    .length ==
                                                                0
                                                            ? ''
                                                            : _homeController
                                                                .trendingPostList[
                                                                    index]
                                                                .location!
                                                                .placeName![1]
                                                                .toString(),
                                                        imageUrl: _homeController
                                                                    .trendingPostList[
                                                                        index]
                                                                    .files!
                                                                    .length ==
                                                                0
                                                            ? []
                                                            : _homeController
                                                                .trendingPostList[
                                                                    index]
                                                                .files!,
                                                        caption: _homeController
                                                                .trendingPostList[
                                                                    index]
                                                                .caption ??
                                                            '',
                                                        likes: _homeController
                                                                        .updateCount[
                                                                    _homeController
                                                                        .trendingPostList[
                                                                            index]
                                                                        .id!] ==
                                                                null
                                                            ? _homeController
                                                                .trendingPostList[
                                                                    index]
                                                                .likes!
                                                                .toString()
                                                            : _homeController
                                                                .updateCount[
                                                                    _homeController
                                                                        .trendingPostList[
                                                                            index]
                                                                        .id!]!
                                                                .likes!
                                                                .toString(),
                                                        comments: _homeController
                                                                        .updateCount[
                                                                    _homeController
                                                                        .trendingPostList[
                                                                            index]
                                                                        .id!] ==
                                                                null
                                                            ? _homeController
                                                                .trendingPostList[
                                                                    index]
                                                                .comments!
                                                                .toString()
                                                            : _homeController
                                                                .updateCount[
                                                                    _homeController
                                                                        .trendingPostList[
                                                                            index]
                                                                        .id!]!
                                                                .comments!
                                                                .toString(),
                                                        hitLike: () async {
                                                          _homeController
                                                                  .LikedPostMap[
                                                              _homeController
                                                                  .trendingPostList[
                                                                      index]
                                                                  .id!] = _homeController
                                                                          .LikedPostMap[
                                                                      _homeController
                                                                          .trendingPostList[
                                                                              index]
                                                                          .id!] ==
                                                                  null
                                                              ? !(_homeController
                                                                  .trendingPostList[
                                                                      index]
                                                                  .isLiked!)
                                                              : !(_homeController
                                                                      .LikedPostMap[
                                                                  _homeController
                                                                      .trendingPostList[
                                                                          index]
                                                                      .id!]!);
                                                          if (_homeController
                                                                      .LikedPostMap[
                                                                  _homeController
                                                                      .trendingPostList[
                                                                          index]
                                                                      .id!]! ==
                                                              false) {
                                                            _homeController
                                                                .trendingPostList[
                                                                    index]
                                                                .isLiked = false;

                                                            await HomeService.unlikePost(
                                                                postId: _homeController
                                                                    .trendingPostList[
                                                                        index]
                                                                    .id!);
                                                          } else {
                                                            _homeController
                                                                .trendingPostList[
                                                                    index]
                                                                .isLiked = true;

                                                            _homeController
                                                                .likedPost
                                                                .toSet()
                                                                .toList();

                                                            await HomeService.likePost(
                                                                postId: _homeController
                                                                    .trendingPostList[
                                                                        index]
                                                                    .id!);
                                                          }

                                                          log("hit Like");
                                                          RecentCommentModel
                                                              recentComment =
                                                              RecentCommentModel();
                                                          recentComment = await HomeService
                                                              .recentComment(
                                                                  postId: _homeController
                                                                      .trendingPostList[
                                                                          index]
                                                                      .id!);
                                                          // _homeController.commentsMap[_homeController.post.value.id.toString()] =
                                                          //     recentComment.response!.data!.comment;
                                                          _homeController
                                                                  .updateCount[
                                                              _homeController
                                                                  .trendingPostList[
                                                                      index]
                                                                  .id!] = recentComment
                                                              .response!
                                                              .data!
                                                              .data;

                                                          setState(() {});
                                                        },
                                                        addComment: () {
                                                          // HomeService.addComment(
                                                          //     _homeController
                                                          //         .trendingPostList[
                                                          //             index]
                                                          //         .id!,
                                                          //     _homeController
                                                          //         .comment.value);
                                                          //
                                                          // setState(() {});
                                                          //
                                                          // _homeController
                                                          //     .commentController
                                                          //     .clear();

                                                        },
                                                        postId: _homeController
                                                            .trendingPostList[
                                                                index]
                                                            .id!,
                                                        isLiked: _homeController
                                                                        .LikedPostMap[
                                                                    _homeController
                                                                        .trendingPostList[
                                                                            index]
                                                                        .id!] ==
                                                                null
                                                            ? _homeController
                                                                .trendingPostList[
                                                                    index]
                                                                .isLiked!
                                                            : _homeController
                                                                    .LikedPostMap[
                                                                _homeController
                                                                    .trendingPostList[
                                                                        index]
                                                                    .id!]!,
                                                        onTap: () async {
                                                          _homeController
                                                              .commentsList
                                                              .clear();
                                                          _homeController
                                                              .viewReplies!
                                                              .clear();
                                                          // _homeController.replyList.clear();
                                                          Navigator.pushNamed(
                                                              context,
                                                              RouteName
                                                                  .postScreen);
                                                          _homeController
                                                              .postLoading
                                                              .value = true;
                                                          var postData = await HomeService
                                                              .getPostById(
                                                                  _homeController
                                                                      .trendingPostList[
                                                                          index]
                                                                      .id!);

                                                          _homeController
                                                                  .post.value =
                                                              postData.response!
                                                                  .data!;

                                                          _homeController
                                                              .postLoading
                                                              .value = false;
                                                          _homeController
                                                              .commentsLoading
                                                              .value = true;
                                                          // print("post id  "+_homeController._homeController
                                                          //     .trendingPostList[
                                                          // index]
                                                          //     .id!);
                                                          _homeController
                                                                  .postComments
                                                                  .value =
                                                              await HomeService
                                                                  .fetchComment(
                                                                      postId: _homeController
                                                                          .trendingPostList[
                                                                              index]
                                                                          .id!);

                                                          if (_homeController
                                                                  .postComments
                                                                  .value
                                                                  .response!
                                                                  .data!
                                                                  .length !=
                                                              0) {
                                                            _homeController
                                                                    .commentsList
                                                                    .value =
                                                                _homeController
                                                                    .postComments
                                                                    .value
                                                                    .response!
                                                                    .data!;
                                                          }
                                                          _homeController
                                                              .commentsLoading
                                                              .value = false;
                                                        },
                                                        people: _homeController
                                                            .trendingPostList[
                                                                index]
                                                            .people!,
                                                      ),
                                                      Container(
                                                        height: 16 *
                                                            SizeConfig
                                                                .heightMultiplier!,
                                                        color: Theme.of(context)
                                                            .scaffoldBackgroundColor
                                                            .withOpacity(0.1),
                                                      )
                                                    ],
                                                  ));
                                            }),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Obx(() => _homeController.showLoader.value
                          ? Positioned(
                              bottom: 20,
                              left: Get.width / 2 - 10,
                              child:
                                  Center(child: CustomizedCircularProgress()))
                          : SizedBox()),
                    ],
                  ),
                ))),
    );
  }

  void showDialogForLiveLimitExceeded(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: kBlack.withOpacity(0.6),
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: AlertDialog(
                insetPadding: EdgeInsets.zero,
                titlePadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 20 * SizeConfig.widthMultiplier!),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8 * SizeConfig.imageSizeMultiplier!)),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 8 * SizeConfig.heightMultiplier!,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Transform.translate(
                        offset: Offset(10 * SizeConfig.widthMultiplier!, 0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).cardColor,
                            radius: 20 * SizeConfig.imageSizeMultiplier!,
                            child: Icon(
                              Icons.close,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 150 * SizeConfig.heightMultiplier!,
                      width: 150 * SizeConfig.widthMultiplier!,
                      child: Image.asset(
                        ImagePath.animatedLiveLimitErrorIcon,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: 16 * SizeConfig.heightMultiplier!,
                    ),
                    SizedBox(
                      width: 250 * SizeConfig.widthMultiplier!,
                    ),
                    Text(
                      "Something went wrong!".tr,
                      style: AppTextStyle.black400Text.copyWith(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                          fontSize: 16 * SizeConfig.textMultiplier!,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 16 * SizeConfig.heightMultiplier!,
                    ),
                    Text(
                      "There is already 200 people in\nthis please join later."
                          .tr,
                      style: AppTextStyle.black400Text.copyWith(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 40 * SizeConfig.heightMultiplier!,
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }
}