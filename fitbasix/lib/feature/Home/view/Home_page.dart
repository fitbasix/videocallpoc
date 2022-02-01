import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitbasix/feature/Home/model/post_feed_model.dart';
import 'package:fitbasix/feature/Home/services/home_service.dart';
import 'package:fitbasix/feature/Home/view/tools_screen.dart';
import 'package:fitbasix/feature/Home/view/widgets/caloriesDetails.dart';
import 'package:fitbasix/feature/Home/view/widgets/custom_bottom_nav_bar.dart';
import 'package:fitbasix/feature/Home/view/widgets/menu_screen.dart';
import 'package:fitbasix/feature/Home/view/widgets/post_tile.dart';
import 'package:fitbasix/feature/posts/view/create_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/Home/view/widgets/bottom_app_bar.dart';
import 'package:fitbasix/feature/Home/view/widgets/green_circle_arrow_button.dart';
import 'package:fitbasix/feature/Home/view/widgets/home_tile.dart';
import 'package:fitbasix/feature/get_trained/view/get_trained_screen.dart';
import 'package:fitbasix/feature/log_in/controller/login_controller.dart';
import 'package:fitbasix/feature/posts/controller/post_controller.dart';
import 'package:fitbasix/feature/posts/services/createPost_Services.dart';
import 'package:fitbasix/feature/spg/view/set_goal_intro_screen.dart';

class HomeAndTrainerPage extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());

  final List<Widget> screens = [
    HomePage(),
    GetTrainedScreen(),
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
        child: MenuScreen(
            imageCoverPic: homeController.userProfileData.value.response == null
                ? ""
                : homeController
                    .userProfileData.value.response!.data!.profile!.coverPhoto!,
            name: homeController.userProfileData.value.response == null
                ? ""
                : homeController
                    .userProfileData.value.response!.data!.profile!.name!,
            imageUrl: homeController.userProfileData.value.response == null
                ? ""
                : homeController.userProfileData.value.response!.data!.profile!
                    .profilePhoto!),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LoginController _controller = Get.put(LoginController());

  final PostController _postController = Get.put(PostController());

  final HomeController _homeController = Get.find();

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
                                    child: CachedNetworkImage(
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
                                            60 * SizeConfig.widthMultiplier!),
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
                                          Text(
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
                                    Navigator.pushNamed(
                                        context, RouteName.getTrainedScreen);
                                  },
                                ),
                                HomeTile(
                                  color: kBlue,
                                  title: 'trainers'.tr,
                                  icon: Icons.person,
                                  onTap: () async {
                                    final SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.clear();
                                    await _controller.googleSignout();
                                    Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        RouteName.loginScreen,
                                        (route) => false);
                                  },
                                ),
                                HomeTile(
                                  color: kLightGreen,
                                  title: 'my_plan'.tr,
                                  icon: Icons.list_alt,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                SetGoalIntroScreen()));
                                  },
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
                                          Expanded(
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
                                                    .toDouble()),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 8.0 *
                                                      SizeConfig
                                                          .widthMultiplier!),
                                              child: CaloriesBurnt(20.0),
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
                                    onTap: () {},
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

                                StreamBuilder<PostsModel>(
                                    stream: HomeService.getPosts(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData)
                                        return ListView.builder(
                                            itemCount: snapshot
                                                .data!.response!.data!.length,
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (_, index) {
                                              return Column(
                                                children: [
                                                  PostTile(
                                                    name: snapshot
                                                        .data!
                                                        .response!
                                                        .data![index]
                                                        .userId!
                                                        .name!,
                                                    profilePhoto: snapshot
                                                        .data!
                                                        .response!
                                                        .data![index]
                                                        .userId!
                                                        .profilePhoto!,
                                                    category: snapshot
                                                        .data!
                                                        .response!
                                                        .data![index]
                                                        .postCategory![0]
                                                        .name!,
                                                    date: DateFormat.d()
                                                        .add_MMM()
                                                        .format(snapshot
                                                            .data!
                                                            .response!
                                                            .data![index]
                                                            .updatedAt!),
                                                    place: snapshot
                                                        .data!
                                                        .response!
                                                        .data![index]
                                                        .location!
                                                        .placeName![1]
                                                        .toString(),
                                                    imageUrl: snapshot
                                                        .data!
                                                        .response!
                                                        .data![index]
                                                        .files![0],
                                                    caption: snapshot
                                                            .data!
                                                            .response!
                                                            .data![index]
                                                            .caption ??
                                                        '',
                                                    likes: snapshot
                                                        .data!
                                                        .response!
                                                        .data![index]
                                                        .likes
                                                        .toString(),
                                                    comments: snapshot
                                                        .data!
                                                        .response!
                                                        .data![index]
                                                        .comments
                                                        .toString(),
                                                    hitLike: () {
                                                      HomeService.likePost(
                                                          postId: snapshot
                                                              .data!
                                                              .response!
                                                              .data![index]
                                                              .id!);
                                                      setState(() {});
                                                    },
                                                    addComment: () {
                                                      HomeService.addComment(
                                                          snapshot
                                                              .data!
                                                              .response!
                                                              .data![index]
                                                              .id!,
                                                          _homeController
                                                              .comment.value);

                                                      setState(() {});
                                                      _homeController
                                                          .commentController
                                                          .clear();
                                                    },
                                                    postId: snapshot
                                                        .data!
                                                        .response!
                                                        .data![index]
                                                        .id!,
                                                  ),
                                                  Container(
                                                    height: 16 *
                                                        SizeConfig
                                                            .heightMultiplier!,
                                                    color: kBackgroundColor,
                                                  )
                                                ],
                                              );
                                            });
                                      return Container();
                                    }),
                                // PostTile(
                                //   name: 'Jonathan Swift',
                                //   category: 'Transformation',
                                //   date: '29 May',
                                //   place: 'Chicago',
                                //   imageUrl:
                                //       'https://fitbasix-dev.s3.me-south-1.amazonaws.com/HealthGoalImage.png',
                                //   caption:
                                //       'Without the right habits, you can surely get fit but can’t stay fit.',
                                //   likes: '1234',
                                //   comments: '60',
                                // )
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ))),
    );
  }
}
