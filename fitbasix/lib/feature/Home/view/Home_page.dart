import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  final List<Widget> screens = [HomePage(), GetTrainedScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => screens[homeController.selectedIndex.value]),
      bottomNavigationBar: CustomizedBottomAppBar(),
    );
  }
}

class HomePage extends StatelessWidget {
  final LoginController _controller = Get.put(LoginController());
  final PostController _postController = Get.put(PostController());
  final HomeController _homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final now = DateTime.now();
    String formatter = DateFormat('MMMd').format(now);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPureWhite,
        centerTitle: false,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {}, icon: SvgPicture.asset(ImagePath.bellIcon))
        ],
      ),
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
                                      Text(
                                        'home_page_subtitle'.tr,
                                        style: AppTextStyle.normalBlackText
                                            .copyWith(
                                                fontSize: 12 *
                                                    SizeConfig.textMultiplier!),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                HomeTile(
                                  color: kPurple,
                                  title: 'live_stream'.tr,
                                  icon: Icons.videocam,
                                  onTap: () async {
                                    final PostController _postController =
                                        Get.put(PostController());
                                    _postController.postId.value =
                                        await CreatePostService.getPostId();

                                    await _postController.getPostData();
                                    Navigator.pushNamed(
                                        context, RouteName.createPost);
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
                            child: Container(
                              height: 182 * SizeConfig.heightMultiplier!,
                              padding: EdgeInsets.only(left: 16, bottom: 16),
                              decoration: BoxDecoration(
                                  color: kPureWhite,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.10),
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
                                                SizeConfig.heightMultiplier!),
                                        width:
                                            126 * SizeConfig.widthMultiplier!,
                                        child: Text(
                                          'set_goal_heading'.tr,
                                          style: AppTextStyle.boldBlackText
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
                                          height:
                                              120 * SizeConfig.widthMultiplier!,
                                          width: 186 *
                                              SizeConfig.widthMultiplier!),
                                    ],
                                  ),
                                  Spacer(),
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
                                                    SizeConfig.widthMultiplier!,
                                                height: 15 *
                                                    SizeConfig
                                                        .heightMultiplier!,
                                                fit: BoxFit.contain,
                                              ),
                                              SizedBox(
                                                width: 10 *
                                                    SizeConfig.widthMultiplier!,
                                              ),
                                              Text('add_water_intake'.tr)
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8 *
                                                SizeConfig.heightMultiplier!,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                ImagePath.fireIcon,
                                                width: 11 *
                                                    SizeConfig.widthMultiplier!,
                                                height: 15 *
                                                    SizeConfig
                                                        .heightMultiplier!,
                                                fit: BoxFit.cover,
                                              ),
                                              SizedBox(
                                                width: 10 *
                                                    SizeConfig.widthMultiplier!,
                                              ),
                                              Text('track_calories'.tr)
                                            ],
                                          )
                                        ],
                                      ),
                                      Spacer(),
                                      Column(
                                        children: [
                                          GreenCircleArrowButton(
                                            onTap: () {},
                                          )
                                        ],
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
                                Obx(() => _homeController.isLoading.value
                                    ? Center(
                                        child: CustomizedCircularProgress(),
                                      )
                                    : Container(
                                        child: ListView.builder(
                                            itemCount: _homeController.posts
                                                .value.response!.data!.length,
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (_, index) {
                                              return Column(
                                                children: [
                                                  PostTile(
                                                    name: _homeController
                                                        .posts
                                                        .value
                                                        .response!
                                                        .data![index]
                                                        .userId!
                                                        .name!,
                                                    category: _homeController
                                                        .posts
                                                        .value
                                                        .response!
                                                        .data![index]
                                                        .postCategory![0]
                                                        .name!,
                                                    date: DateFormat.d()
                                                        .add_MMM()
                                                        .format(_homeController
                                                            .posts
                                                            .value
                                                            .response!
                                                            .data![index]
                                                            .updatedAt!),
                                                    place: _homeController
                                                        .posts
                                                        .value
                                                        .response!
                                                        .data![index]
                                                        .location!
                                                        .placeName![1]
                                                        .toString(),
                                                    imageUrl: _homeController
                                                        .posts
                                                        .value
                                                        .response!
                                                        .data![index]
                                                        .files![0],
                                                    caption: _homeController
                                                        .posts
                                                        .value
                                                        .response!
                                                        .data![index]
                                                        .caption!,
                                                    likes: _homeController
                                                        .posts
                                                        .value
                                                        .response!
                                                        .data![index]
                                                        .likes
                                                        .toString(),
                                                    comments: _homeController
                                                        .posts
                                                        .value
                                                        .response!
                                                        .data![index]
                                                        .comments
                                                        .toString(),
                                                  ),
                                                  Container(
                                                    height: 16 *
                                                        SizeConfig
                                                            .heightMultiplier!,
                                                    color: kBackgroundColor,
                                                  )
                                                ],
                                              );
                                            }),
                                      )),
                                PostTile(
                                  name: 'Jonathan Swift',
                                  category: 'Transformation',
                                  date: '29 May',
                                  place: 'Chicago',
                                  imageUrl:
                                      'https://fitbasix-dev.s3.me-south-1.amazonaws.com/HealthGoalImage.png',
                                  caption:
                                      'Without the right habits, you can surely get fit but can’t stay fit.',
                                  likes: '1234',
                                  comments: '60',
                                )
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

class PostTile extends StatelessWidget {
  const PostTile({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.date,
    required this.place,
    required this.caption,
    required this.likes,
    required this.comments,
  }) : super(key: key);
  final String name;
  final String imageUrl;
  final String category;
  final String date;
  final String place;
  final String caption;
  final String likes;
  final String comments;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: 16 * SizeConfig.widthMultiplier!,
                bottom: 16 * SizeConfig.heightMultiplier!,
                top: 16 * SizeConfig.heightMultiplier!),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20 * SizeConfig.widthMultiplier!,
                ),
                SizedBox(
                  width: 12 * SizeConfig.widthMultiplier!,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextStyle.boldBlackText
                          .copyWith(fontSize: 14 * SizeConfig.textMultiplier!),
                    ),
                    Row(
                      children: [
                        Text(category,
                            style: AppTextStyle.normalBlackText.copyWith(
                                fontSize: 12 * SizeConfig.textMultiplier!,
                                color: kGreyColor)),
                        SizedBox(
                          width: 13 * SizeConfig.widthMultiplier!,
                        ),
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: kGreyColor,
                        ),
                        SizedBox(
                          width: 5 * SizeConfig.widthMultiplier!,
                        ),
                        Text(date,
                            style: AppTextStyle.normalBlackText.copyWith(
                                fontSize: 12 * SizeConfig.textMultiplier!,
                                color: kGreyColor)),
                        SizedBox(
                          width: 14 * SizeConfig.widthMultiplier!,
                        ),
                        Icon(
                          Icons.place,
                          size: 16,
                          color: kGreyColor,
                        ),
                        SizedBox(
                          width: 6.5 * SizeConfig.widthMultiplier!,
                        ),
                        Text(place,
                            style: AppTextStyle.normalBlackText.copyWith(
                                fontSize: 12 * SizeConfig.textMultiplier!,
                                color: kGreyColor))
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 16 * SizeConfig.widthMultiplier!,
                bottom: 16 * SizeConfig.heightMultiplier!,
                right: 16 * SizeConfig.widthMultiplier!),
            child: Text(
              caption,
              style: AppTextStyle.NormalText.copyWith(
                  fontSize: 14 * SizeConfig.textMultiplier!),
            ),
          ),
          CachedNetworkImage(
            imageUrl: imageUrl,
            height: 198 * SizeConfig.heightMultiplier!,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 16 * SizeConfig.widthMultiplier!,
                bottom: 16 * SizeConfig.heightMultiplier!,
                right: 16 * SizeConfig.widthMultiplier!,
                top: 16 * SizeConfig.heightMultiplier!),
            child: Row(
              children: [
                Icon(
                  Icons.favorite,
                  color: kRedColor,
                ),
                SizedBox(
                  width: 5 * SizeConfig.widthMultiplier!,
                ),
                Text(
                  'likes'.trParams({'no_likes': likes}),
                  style: AppTextStyle.boldBlackText
                      .copyWith(fontSize: 12 * SizeConfig.textMultiplier!),
                ),
                SizedBox(
                  width: 18 * SizeConfig.widthMultiplier!,
                ),
                Text(
                  'comments'.trParams({'no_comments': comments}),
                  style: AppTextStyle.boldBlackText
                      .copyWith(fontSize: 12 * SizeConfig.textMultiplier!),
                )
              ],
            ),
          ),
          CommentsTile(
            name: 'Percy Bysshe Shelley',
            comment: 'Thank you for the motivational thoughts!',
            time: '26',
            likes: 214,
            onReply: () {},
          ),
          SizedBox(
            height: 16 * SizeConfig.heightMultiplier!,
          )
        ],
      ),
    );
  }
}

class CommentsTile extends StatelessWidget {
  const CommentsTile({
    Key? key,
    required this.name,
    required this.comment,
    required this.time,
    required this.likes,
    required this.onReply,
  }) : super(key: key);

  final String name;
  final String comment;
  final String time;
  final int likes;
  final VoidCallback onReply;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 16 * SizeConfig.widthMultiplier!,
          right: 16 * SizeConfig.widthMultiplier!),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
          ),
          SizedBox(
            width: 8 * SizeConfig.widthMultiplier!,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 84 * SizeConfig.heightMultiplier!,
                width: Get.width - 80 * SizeConfig.widthMultiplier!,
                padding: EdgeInsets.only(
                    top: 12 * SizeConfig.heightMultiplier!,
                    left: 12 * SizeConfig.widthMultiplier!,
                    right: 12 * SizeConfig.widthMultiplier!),
                decoration: BoxDecoration(
                    color: kLightGrey,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextStyle.boldBlackText
                          .copyWith(fontSize: 12 * SizeConfig.textMultiplier!),
                    ),
                    SizedBox(
                      height: 8 * SizeConfig.heightMultiplier!,
                    ),
                    Text(
                      comment,
                      style: AppTextStyle.normalBlackText
                          .copyWith(fontSize: 14 * SizeConfig.textMultiplier!),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 8 * SizeConfig.heightMultiplier!,
              ),
              Padding(
                padding: EdgeInsets.only(left: 4 * SizeConfig.widthMultiplier!),
                child: Row(
                  children: [
                    Text('post_time'.trParams({'duration': time}),
                        style: AppTextStyle.normalBlackText.copyWith(
                            fontSize: 12 * SizeConfig.textMultiplier!,
                            color: kGreyColor)),
                    SizedBox(
                      width: 13 * SizeConfig.widthMultiplier!,
                    ),
                    Icon(
                      Icons.favorite,
                      color: kGreyColor,
                      size: 14,
                    ),
                    SizedBox(
                      width: 5 * SizeConfig.widthMultiplier!,
                    ),
                    Text('likes'.trParams({'no_likes': likes.toString()}),
                        style: AppTextStyle.normalBlackText.copyWith(
                            fontSize: 12 * SizeConfig.textMultiplier!,
                            color: kGreyColor)),
                    SizedBox(
                      width: 13 * SizeConfig.widthMultiplier!,
                    ),
                    Icon(
                      Icons.reply,
                      color: kGreyColor,
                      size: 18,
                    ),
                    SizedBox(
                      width: 4 * SizeConfig.widthMultiplier!,
                    ),
                    GestureDetector(
                      onTap: onReply,
                      child: Text('reply'.tr,
                          style: AppTextStyle.normalBlackText.copyWith(
                              fontSize: 12 * SizeConfig.textMultiplier!,
                              color: kGreyColor)),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
