import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitbasix/feature/posts/controller/post_controller.dart';
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

class HomeAndTrainerPage extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());

  final List<Widget> screens = [
    HomePage(),
    MyTrainersScreen(),
    CreatePostScreen(),
    ToolsScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeController.drawerKey,
      body: Obx(() => screens[homeController.selectedIndex.value]),
      // bottomNavigationBar: CustomizedBottomAppBar(),

      bottomNavigationBar: CustomBottomNavigationBar(),
      endDrawer: Drawer(
        child: Obx(
          () => MenuScreen(
              imageCoverPic:
                  homeController.userProfileData.value.response == null
                      ? ""
                      : homeController.userProfileData.value.response!.data!
                          .profile!.coverPhoto
                          .toString(),
              name: homeController.userProfileData.value.response == null
                  ? ""
                  : homeController
                      .userProfileData.value.response!.data!.profile!.name!,
              imageUrl: homeController.userProfileData.value.response == null
                  ? ""
                  : homeController.userProfileData.value.response!.data!
                      .profile!.profilePhoto
                      .toString()),
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
      backgroundColor: kBackgroundColor,
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
                        color: kPureWhite,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 16 * SizeConfig.widthMultiplier!,
                                right: 16 * SizeConfig.widthMultiplier!),
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 8 * SizeConfig.heightMultiplier!,
                                  bottom: 8 * SizeConfig.heightMultiplier!),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        30 * SizeConfig.widthMultiplier!),
                                    child: Obx(() => CachedNetworkImage(
                                        imageUrl: _homeController
                                            .userProfileData
                                            .value
                                            .response!
                                            .data!
                                            .profile!
                                            .profilePhoto
                                            .toString(),
                                        fit: BoxFit.cover,
                                        height:
                                            60 * SizeConfig.widthMultiplier!,
                                        width:
                                            60 * SizeConfig.widthMultiplier!)),
                                  ),
                                  SizedBox(
                                    width: 15,
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
                                          _homeController
                                              .userProfileData
                                              .value
                                              .response ==null?
                                              Container()
                                              :Text(
                                            'hi_name'.trParams({
                                              'name': _homeController
                                                  .userProfileData
                                                  .value
                                                  .response!
                                                  .data!
                                                  .profile!
                                                  .name!
                                            }),
                                            style: AppTextStyle.boldBlackText,
                                          ),
                                          // SizedBox(
                                          //   width: 31 *
                                          //       SizeConfig.widthMultiplier!,
                                          // ),
                                        ],
                                      ),
                                      Text(
                                        'home_page_subtitle'.tr,
                                        style: AppTextStyle.normalBlackText
                                            .copyWith(
                                                fontSize: 12 *
                                                    SizeConfig.textMultiplier!),
                                      )
                                    ],
                                  ),
                                  Spacer(),
                                  SvgPicture.asset(ImagePath.bellIcon),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                HomeTile(
                                  color: kPurple,
                                  title: 'live_stream'.tr,
                                  icon: Icons.videocam,
                                  onTap: () {
                                    Navigator.pushNamed(context, RouteName.liveStream);
                                  },
                                ),
                                HomeTile(
                                  color: kBlue,
                                  title: 'trainers'.tr,
                                  icon: Icons.person,
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, RouteName.getTrainedScreen);
                                  },
                                ),
                                HomeTile(
                                  color: kLightGreen,
                                  title: 'my_plan'.tr,
                                  icon: Icons.list_alt,
                                  onTap: () {},
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 38 * SizeConfig.heightMultiplier!,
                          ),
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
                                      fontSize:
                                          16 * SizeConfig.textMultiplier!),
                                ),
                                Text(
                                  formatter,
                                  style: AppTextStyle.boldBlackText.copyWith(
                                      fontSize:
                                          14 * SizeConfig.textMultiplier!),
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
                                                }))),
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
                                              }),
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
                                              " kcal"),
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
                                                            fontSize: 14 *
                                                                SizeConfig
                                                                    .textMultiplier!)),
                                                Spacer(),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: kGreenColor),
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        vertical: 8.0 *
                                                            SizeConfig
                                                                .heightMultiplier!,
                                                        horizontal: 23 *
                                                            SizeConfig
                                                                .widthMultiplier!),
                                                    child: Text('update'.tr,
                                                        style: AppTextStyle
                                                            .normalWhiteText
                                                            .copyWith(
                                                                fontSize: 14 *
                                                                    SizeConfig
                                                                        .textMultiplier!)),
                                                  ),
                                                )
                                              ],
                                            )),
                                      ),
                                    ],
                                  )
                                : Container(
                                    padding:
                                        EdgeInsets.only(left: 16, bottom: 16),
                                    decoration: BoxDecoration(
                                        color: kPureWhite,
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
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 16 *
                                                      SizeConfig
                                                          .heightMultiplier!),
                                              width: 126 *
                                                  SizeConfig.widthMultiplier!,
                                              child: Text(
                                                'set_goal_heading'.tr,
                                                style: AppTextStyle
                                                    .boldBlackText
                                                    .copyWith(
                                                        fontSize: 14 *
                                                            SizeConfig
                                                                .textMultiplier!),
                                                maxLines: 4,
                                              ),
                                            ),
                                            CachedNetworkImage(
                                                imageUrl:
                                                    "https://fitbasix-dev.s3.me-south-1.amazonaws.com/HealthGoalImage.png",
                                                fit: BoxFit.cover,
                                                height: 120 *
                                                    SizeConfig.widthMultiplier!,
                                                width: 186 *
                                                    SizeConfig
                                                        .widthMultiplier!),
                                          ],
                                        ),
                                        SizedBox(
                                            height: 0 *
                                                SizeConfig.widthMultiplier!),
                                        Row(
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
                                  gradient: LinearGradient(
                                      colors: [kLightBlue, kPureWhite]),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.10),
                                        blurRadius: 10,
                                        spreadRadius: 0,
                                        offset: Offset(0, 5))
                                  ]),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                      ImagePath.searchFavoriteIcon),
                                  SizedBox(
                                    width: 16 * SizeConfig.widthMultiplier!,
                                  ),
                                  Container(
                                    width: 200 * SizeConfig.widthMultiplier!,
                                    child: Text(
                                      'explore_fitbasix'.tr,
                                      style:
                                          AppTextStyle.boldBlackText.copyWith(
                                        fontSize:
                                            14 * SizeConfig.textMultiplier!,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  GreenCircleArrowButton(
                                    onTap: () async{
                                      _homeController.explorePageCount.value = 0;
                                      Navigator.pushNamed(context, RouteName.exploreSearch);
                                      postController.getCategory();
                                      _homeController.isExploreDataLoading.value=true;
                                     _homeController.explorePostModel.value= await HomeService.getExplorePosts(
                                       skip: 0,
                                     );
                                     _homeController.explorePostList.value=_homeController.explorePostModel.value.response!.data!;
                                      _homeController.isExploreDataLoading.value=false;

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
                            color: kPureWhite,
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
                                        fontSize:
                                            16 * SizeConfig.textMultiplier!),
                                  ),
                                ),
                                SizedBox(
                                  height: 16 * SizeConfig.heightMultiplier!,
                                ),
                                Obx(
                                  () => _homeController.isLoading.value
                                      ? CustomizedCircularProgress()
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
                                                          .trendingPostList[
                                                              index]
                                                          .commentgiven,
                                                      name: _homeController
                                                          .trendingPostList[
                                                              index]
                                                          .userId!
                                                          .name!,
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
                                                          .trendingPostList[
                                                              index]
                                                          .likes
                                                          .toString(),
                                                      comments: _homeController
                                                          .trendingPostList[
                                                              index]
                                                          .comments
                                                          .toString(),
                                                      hitLike: () async {
                                                        if (_homeController
                                                            .trendingPostList[
                                                                index]
                                                            .isLiked!) {
                                                          _homeController
                                                              .trendingPostList[
                                                                  index]
                                                              .isLiked = false;
                                                          _homeController
                                                              .trendingPostList[
                                                                  index]
                                                              .likes = (_homeController
                                                                  .trendingPostList[
                                                                      index]
                                                                  .likes! -
                                                              1);
                                                          HomeService.unlikePost(
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
                                                              .trendingPostList[
                                                                  index]
                                                              .likes = (_homeController
                                                                  .trendingPostList[
                                                                      index]
                                                                  .likes! +
                                                              1);
                                                          HomeService.likePost(
                                                              postId: _homeController
                                                                  .trendingPostList[
                                                                      index]
                                                                  .id!);
                                                        }
                                                        setState(() {});
                                                      },
                                                      addComment: () {
                                                        HomeService.addComment(
                                                            _homeController
                                                                .trendingPostList[
                                                                    index]
                                                                .id!,
                                                            _homeController
                                                                .comment.value);

                                                        setState(() {});

                                                        _homeController
                                                            .commentController
                                                            .clear();
                                                      },
                                                      postId: _homeController
                                                          .trendingPostList[
                                                              index]
                                                          .id!,
                                                      isLiked: _homeController
                                                          .trendingPostList[
                                                              index]
                                                          .isLiked!,
                                                      onTap: () async {
                                                        _homeController
                                                            .commentsList
                                                            .clear();
                                                        Navigator.pushNamed(
                                                            context,
                                                            RouteName
                                                                .postScreen);
                                                        _homeController.post
                                                            .value = _homeController
                                                                .trendingPostList[
                                                            index];
                                                        _homeController
                                                            .commentsLoading
                                                            .value = true;
                                                        _homeController
                                                                .postComments
                                                                .value =
                                                            await HomeService
                                                                .fetchComment(
                                                                    _homeController
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
                                                      color: kBackgroundColor,
                                                    )
                                                  ],
                                                ));
                                          }),
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
}
