import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/Home/controller/individual_user_controller.dart';
import 'package:fitbasix/feature/Home/view/widgets/post_tile.dart';
import 'package:fitbasix/feature/get_trained/view/followers.dart';
import 'package:fitbasix/feature/profile/controller/profile_controller.dart';
import 'package:fitbasix/feature/profile/services/profile_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_text_style.dart';
import '../../../../core/constants/image_path.dart';
import '../../../../core/reponsive/SizeConfig.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/universal_widgets/customized_circular_indicator.dart';
import '../../../get_trained/services/trainer_services.dart';
import '../../../get_trained/view/trainer_profile_screen.dart';
import '../../../spg/view/set_goal_screen.dart';
import '../../model/RecentCommentModel.dart';
import '../../services/home_service.dart';

class IndividualProfileScreen extends StatefulWidget {
  const IndividualProfileScreen({Key? key}) : super(key: key);

  @override
  State<IndividualProfileScreen> createState() =>
      _IndividualProfileScreenState();
}

String about_user =
    'Hi, This is Jonathan. I am certified by Institute Viverra cras facilisis massa amet,'
    ' hendrerit nunc. Tristique tellus, massa scelerisque tincidunt neque dui metus,'
    ' id pellentesque.'
    'Let’s start your fitness journey!!!';

class _IndividualProfileScreenState extends State<IndividualProfileScreen> {
  final HomeController _homeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => (!_homeController.isIndividualUserProfileLoading.value)
            ? IndividualUserProfileUI(
                onFollow: () {
                  followUser();
                },
                username: _homeController.individualUserProfileData.value
                    .response!.data!.profile!.name,
                userfollowerscount: _homeController.individualUserProfileData
                    .value.response!.data!.profile!.followers
                    .toString(),
                userfollowingscount: _homeController.individualUserProfileData
                    .value.response!.data!.profile!.following
                    .toString(),
                aboutuser: about_user.tr,
                userImage: _homeController.individualUserProfileData.value
                            .response!.data!.profile!.profilePhoto ==
                        ""
                    ? _homeController.individualUserProfileData.value.response!
                        .data!.profile!.profilePhoto
                    : _homeController.individualUserProfileData.value.response!
                        .data!.profile!.profilePhoto,
                userCoverImage:
                    _homeController.individualUserProfileData.value.response ==
                            null
                        ? ""
                        : _homeController.individualUserProfileData.value
                                    .response!.data!.profile!.coverPhoto ==
                                ""
                            ? _homeController.individualUserProfileData.value
                                .response!.data!.profile!.coverPhoto
                                .toString()
                            : _homeController.individualUserProfileData.value
                                .response!.data!.profile!.coverPhoto,
                onFollowButtonTap: () {}, id: _homeController.individualUserProfileData.value.response!.data!.profile!.id!,
              )
            : Center(
                child: CustomizedCircularProgress(),
              ),
      ),
    );
  }

  followUser() {
    if (_homeController.individualUserProfileData.value.response!.data!.profile!
        .isFollowing!) {
      _homeController.individualUserProfileData.value.response!.data!.profile!
          .isFollowing = false;
      _homeController.individualUserProfileData.refresh();
      _homeController.individualUserProfileData.value.response!.data!.profile!
          .followers = (_homeController.individualUserProfileData.value
              .response!.data!.profile!.followers! -
          1);
      print(_homeController
          .individualUserProfileData.value.response!.data!.profile!.id!);
      TrainerServices.unFollowTrainer(_homeController
          .individualUserProfileData.value.response!.data!.profile!.id!);
    } else {
      _homeController.individualUserProfileData.value.response!.data!.profile!
          .isFollowing = true;
      print(_homeController
          .individualUserProfileData.value.response!.data!.profile!.id!);
      _homeController.individualUserProfileData.refresh();
      _homeController.individualUserProfileData.value.response!.data!.profile!
          .followers = (_homeController.individualUserProfileData.value
              .response!.data!.profile!.followers! +
          1);
      TrainerServices.followTrainer(_homeController
          .individualUserProfileData.value.response!.data!.profile!.id!);
    }
  }
}

class IndividualUserProfileUI extends StatefulWidget {
  const IndividualUserProfileUI(
      {this.username,
      this.userImage,
      this.userCoverImage,
      this.userfollowerscount,
      this.userfollowingscount,
      this.aboutuser,
      this.onFollowButtonTap,
      required this.onFollow,
      Key? key, required this.id})
      : super(key: key);

  final String? username;
  final String? userImage;
  final String? userCoverImage;
  final String? userfollowerscount;
  final String? userfollowingscount;
  final String? aboutuser;
  final String id;
  final VoidCallback? onFollowButtonTap;
  final VoidCallback onFollow;
  @override
  _IndividualUserProfileUIState createState() =>
      _IndividualUserProfileUIState();
}

class _IndividualUserProfileUIState extends State<IndividualUserProfileUI> {
  //demo user interest list for design purpose
  final HomeController _homeController = Get.find();
  final ScrollController _scrollController = ScrollController();
  final IndividualUserController _individualUserController = Get.find();

  List<String> userinterestlist = [
    "Sports Nutrition",
    "Fat-loss",
    "General Well being",
    "Muscle-gain",
    "Improve Imunity",
  ];

  @override
  void initState() {
    super.initState();
    _individualUserController.dataNeedToLoad.value = true;
    _scrollController.addListener(() async {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        if (_individualUserController.dataNeedToLoad.value) {
          _individualUserController.showLoading.value = true;
          final postQuery = await HomeService.getIndividualUserPosts(
              _homeController
                  .individualUserProfileData.value.response!.data!.profile!.id!,
              _individualUserController.currentPage.value * 5);

          if (postQuery.response!.data!.length < 5) {
            _individualUserController.dataNeedToLoad.value = false;
            _individualUserController.userPostList
                .addAll(postQuery.response!.data!);
            _individualUserController.showLoading.value = false;

            return;
          } else {
            if (_individualUserController.userPostList.last.id ==
                postQuery.response!.data!.last.id) {
              _individualUserController.showLoading.value = false;
              return;
            }
            _individualUserController.userPostList
                .addAll(postQuery.response!.data!);
            _individualUserController.showLoading.value = false;
          }
          _individualUserController.currentPage.value++;
          _individualUserController.showLoading.value = false;
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
    return Scaffold(
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        },
        child: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: 152 * SizeConfig.widthMultiplier!),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height:
                                          187 * SizeConfig.heightMultiplier!,
                                    ),
                                    Text(
                                      widget.username!.capitalize.toString(),
                                      style: AppTextStyle.titleText.copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              ?.color,
                                          fontSize:
                                              18 * SizeConfig.textMultiplier!),
                                    ),
                                    SizedBox(
                                      height: 14 * SizeConfig.heightMultiplier!,
                                    ),
                                    Obx(
                                      () => _homeController
                                              .individualUserProfileData
                                              .value
                                              .response!
                                              .data!
                                              .profile!
                                              .isFollowing!
                                          ? SizedBox(
                                              width: 90 *
                                                  SizeConfig.widthMultiplier!,
                                              child: CustomButton(
                                                title: 'following'.tr,
                                                onPress: widget.onFollow,
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                                textColor: kgreen49,
                                              ),
                                            )
                                          : SizedBox(
                                              width: 80 *
                                                  SizeConfig.widthMultiplier!,
                                              child: CustomButton(
                                                  title: 'follow'.tr,
                                                  onPress: widget.onFollow,
                                                  color: kGreenColor,
                                                  textColor: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 24 * SizeConfig.heightMultiplier!,
                              ),
                              //Follwers & followimg
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 11 * SizeConfig.heightMultiplier!,
                                    left: 16.0 * SizeConfig.widthMultiplier!,
                                    right: 27 * SizeConfig.widthMultiplier!),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => Get.to(() => FollowersList(
                                              id: widget.id, index: 0,
                                            )),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(widget.userfollowerscount!,
                                              style: AppTextStyle.hmedium13Text
                                                  .copyWith(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    ?.color,
                                                fontSize: (18) *
                                                    SizeConfig.textMultiplier!,
                                              )),
                                          SizedBox(
                                            height:
                                                4 * SizeConfig.heightMultiplier!,
                                          ),
                                          Text('follower'.tr,
                                              style: AppTextStyle.hmediumBlackText
                                                  .copyWith(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    ?.color,
                                                fontSize: (12) *
                                                    SizeConfig.textMultiplier!,
                                              )),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            32 * SizeConfig.widthMultiplier!),
                                    GestureDetector(
                                      onTap: () => Get.to(() => FollowersList(
                                            id: widget.id,
                                            index: 1,
                                          )),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(widget.userfollowingscount!,
                                              style: AppTextStyle.hmedium13Text
                                                  .copyWith(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    ?.color,
                                                fontSize: (18) *
                                                    SizeConfig.textMultiplier!,
                                              )),
                                          SizedBox(
                                            height: 4 *
                                                SizeConfig.heightMultiplier!,
                                          ),
                                          Text('following'.tr,
                                              style: AppTextStyle
                                                  .hmediumBlackText
                                                  .copyWith(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    ?.color,
                                                fontSize: (12) *
                                                    SizeConfig.textMultiplier!,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height: 24 * SizeConfig.heightMultiplier!),
                              //About
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 16.0 * SizeConfig.widthMultiplier!,
                                    right: 32 * SizeConfig.widthMultiplier!),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //   'about'.tr,
                                    //   style: AppTextStyle.hblackSemiBoldText
                                    //       .copyWith(
                                    //     color: Theme.of(context)
                                    //         .textTheme
                                    //         .bodyText1
                                    //         ?.color,
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   height: 12 * SizeConfig.heightMultiplier!,
                                    // ),
                                    // Text(
                                    //   widget.aboutuser!,
                                    //   style: AppTextStyle.hblackSemiBoldText
                                    //       .copyWith(
                                    //     color: Theme.of(context)
                                    //         .textTheme
                                    //         .bodyText1
                                    //         ?.color,
                                    //     fontWeight: FontWeight.w400,
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   height: 24 * SizeConfig.heightMultiplier!,
                                    // ),
                                    Text(
                                      'interested_in'.tr,
                                      style: AppTextStyle.hblackSemiBoldText
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  ?.color),
                                    ),
                                    SizedBox(
                                      height: 12 * SizeConfig.heightMultiplier!,
                                    ),
                                    // common user interest list using a demo list
                                    _userinterestBar(list: userinterestlist),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 24 * SizeConfig.heightMultiplier!,
                              ),
                              Obx(
                                () => _homeController.isLoading.value
                                    ? Center(
                                        child: CustomizedCircularProgress())
                                    : ListView.builder(
                                        itemCount: _individualUserController
                                                    .userPostList.length ==
                                                0
                                            ? 0
                                            : _individualUserController
                                                .userPostList.length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (_, index) {
                                          return Obx(() => Column(
                                                children: [
                                                  Container(
                                                    height: 16 *
                                                        SizeConfig
                                                            .heightMultiplier!,
                                                    color: kBackgroundColor,
                                                  ),
                                                  PostTile(
                                                    isMe:
                                                        _individualUserController
                                                            .userPostList[index]
                                                            .isMe!,
                                                    userID:
                                                        _individualUserController
                                                            .userPostList[index]
                                                            .userId!
                                                            .id,
                                                    isTrainerProfile: true,
                                                    comment: _homeController
                                                                    .commentsMap[
                                                                _individualUserController
                                                                    .userPostList[
                                                                        index]
                                                                    .id!] ==
                                                            null
                                                        ? _individualUserController
                                                            .userPostList[index]
                                                            .commentgiven
                                                        : _homeController
                                                                .commentsMap[
                                                            _individualUserController
                                                                .userPostList[
                                                                    index]
                                                                .id],
                                                    name:
                                                        _individualUserController
                                                            .userPostList[index]
                                                            .userId!
                                                            .name!,
                                                    profilePhoto:
                                                        _individualUserController
                                                            .userPostList[index]
                                                            .userId!
                                                            .profilePhoto!,
                                                    category:
                                                        _individualUserController
                                                            .userPostList[index]
                                                            .postCategory![0]
                                                            .name!,
                                                    date: DateFormat.d()
                                                        .add_MMM()
                                                        .format(
                                                            _individualUserController
                                                                .userPostList[
                                                                    index]
                                                                .updatedAt!),
                                                    place: _individualUserController
                                                                .userPostList[
                                                                    index]
                                                                .location!
                                                                .placeName!
                                                                .length ==
                                                            0
                                                        ? ''
                                                        : _individualUserController
                                                            .userPostList[index]
                                                            .location!
                                                            .placeName![1]
                                                            .toString(),
                                                    imageUrl: _individualUserController
                                                                .userPostList[
                                                                    index]
                                                                .files!
                                                                .length ==
                                                            0
                                                        ? []
                                                        : _individualUserController
                                                            .userPostList[index]
                                                            .files!,
                                                    caption:
                                                        _individualUserController
                                                                .userPostList[
                                                                    index]
                                                                .caption ??
                                                            '',
                                                    likes: _homeController
                                                                    .updateCount[
                                                                _individualUserController
                                                                    .userPostList[
                                                                        index]
                                                                    .id] ==
                                                            null
                                                        ? _individualUserController
                                                            .userPostList[index]
                                                            .likes
                                                            .toString()
                                                        : _homeController
                                                            .updateCount[
                                                                _individualUserController
                                                                    .userPostList[
                                                                        index]
                                                                    .id]!
                                                            .likes!
                                                            .toString(),
                                                    comments: _homeController
                                                                    .updateCount[
                                                                _individualUserController
                                                                    .userPostList[
                                                                        index]
                                                                    .id] ==
                                                            null
                                                        ? _individualUserController
                                                            .userPostList[index]
                                                            .comments
                                                            .toString()
                                                        : _homeController
                                                            .updateCount[
                                                                _individualUserController
                                                                    .userPostList[
                                                                        index]
                                                                    .id]!
                                                            .comments!
                                                            .toString(),
                                                    hitLike: () async {
                                                      bool val = _homeController
                                                                      .LikedPostMap[
                                                                  _individualUserController
                                                                      .userPostList[
                                                                          index]
                                                                      .id!] ==
                                                              null
                                                          ? _individualUserController
                                                              .userPostList[
                                                                  index]
                                                              .isLiked!
                                                          : _homeController
                                                                  .LikedPostMap[
                                                              _individualUserController
                                                                  .userPostList[
                                                                      index]
                                                                  .id!]!;
                                                      if (val) {
                                                        _individualUserController
                                                            .userPostList[index]
                                                            .isLiked = false;
                                                        _individualUserController
                                                                .userPostList[index]
                                                                .likes =
                                                            (_individualUserController
                                                                    .userPostList[
                                                                        index]
                                                                    .likes! -
                                                                1);
                                                        await HomeService.unlikePost(
                                                            postId:
                                                                _individualUserController
                                                                    .userPostList[
                                                                        index]
                                                                    .id!);
                                                      } else {
                                                        _individualUserController
                                                            .userPostList[index]
                                                            .isLiked = true;
                                                        _individualUserController
                                                                .userPostList[index]
                                                                .likes =
                                                            (_individualUserController
                                                                    .userPostList[
                                                                        index]
                                                                    .likes! +
                                                                1);
                                                        await HomeService.likePost(
                                                            postId:
                                                                _individualUserController
                                                                    .userPostList[
                                                                        index]
                                                                    .id!);
                                                      }
                                                      RecentCommentModel
                                                          recentComment =
                                                          RecentCommentModel();
                                                      recentComment = await HomeService
                                                          .recentComment(
                                                              postId: _individualUserController
                                                                  .userPostList[
                                                                      index]
                                                                  .id!);
                                                      // _homeController.commentsMap[_homeController.post.value.id.toString()] =
                                                      //     recentComment.response!.data!.comment;
                                                      _homeController
                                                              .updateCount[
                                                          _individualUserController
                                                              .userPostList[
                                                                  index]
                                                              .id!] = recentComment
                                                          .response!.data!.data;
                                                      setState(() {});
                                                    },
                                                    addComment: () {
                                                      // HomeService.addComment(
                                                      //     _trainerController
                                                      //         .trainerPostList[
                                                      //             index]
                                                      //         .id!,
                                                      //     _homeController
                                                      //         .comment.value);

                                                      setState(() {});

                                                      _homeController
                                                          .commentController
                                                          .clear();
                                                    },
                                                    postId:
                                                        _individualUserController
                                                            .userPostList[index]
                                                            .id!,
                                                    isLiked: _homeController
                                                                    .LikedPostMap[
                                                                _individualUserController
                                                                    .userPostList[
                                                                        index]
                                                                    .id!] ==
                                                            null
                                                        ? _individualUserController
                                                            .userPostList[index]
                                                            .isLiked!
                                                        : _homeController
                                                                .LikedPostMap[
                                                            _individualUserController
                                                                .userPostList[
                                                                    index]
                                                                .id]!,
                                                    onTap: () async {
                                                      _homeController
                                                          .commentsList
                                                          .clear();
                                                      _homeController
                                                          .viewReplies!
                                                          .clear();
                                                      Navigator.pushNamed(
                                                          context,
                                                          RouteName.postScreen);

                                                      _homeController
                                                          .postLoading
                                                          .value = true;
                                                      var postData = await HomeService
                                                          .getPostById(
                                                              _individualUserController
                                                                  .userPostList[
                                                                      index]
                                                                  .id!);

                                                      _homeController
                                                              .post.value =
                                                          postData
                                                              .response!.data!;

                                                      _homeController
                                                          .postLoading
                                                          .value = false;
                                                      _homeController
                                                          .commentsLoading
                                                          .value = true;
                                                      _homeController
                                                              .postComments
                                                              .value =
                                                          await HomeService
                                                              .fetchComment(
                                                                  postId: _individualUserController
                                                                      .userPostList[
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
                                                    people:
                                                        _individualUserController
                                                            .userPostList[index]
                                                            .people!,
                                                  ),
                                                ],
                                              ));
                                        }),
                              ),
                            ],
                          ),
                          Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 177 * SizeConfig.heightMultiplier!,
                                child: CachedNetworkImage(
                                  imageUrl: widget.userCoverImage!,
                                  placeholder: (context, url) =>
                                      ShimmerEffect(),
                                  errorWidget: (context, url, error) =>
                                      ShimmerEffect(),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 177 * SizeConfig.heightMultiplier!,
                                child: ClipRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 7.0, sigmaY: 7.0),
                                    child: CachedNetworkImage(
                                      imageUrl: widget.userCoverImage!,
                                      placeholder: (context, url) =>
                                          ShimmerEffect(),
                                      errorWidget: (context, url, error) =>
                                          ShimmerEffect(),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 127 * SizeConfig.heightMultiplier!,
                            left: 16 * SizeConfig.widthMultiplier!,
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width:
                                              4 * SizeConfig.widthMultiplier!,
                                          color: kPureWhite),
                                      shape: BoxShape.circle),
                                  height: 120 * SizeConfig.widthMultiplier!,
                                  width: 120 * SizeConfig.widthMultiplier!,
                                  child: CircleAvatar(
                                    //  radius: 60 * SizeConfig.heightMultiplier!,
                                    backgroundImage:
                                        NetworkImage(widget.userImage!),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                              top: 16 * SizeConfig.heightMultiplier!,
                              left: 16 * SizeConfig.widthMultiplier!,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 40 * SizeConfig.heightMultiplier!,
                                  width: 40 * SizeConfig.heightMultiplier!,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                  child: SvgPicture.asset(
                                    ImagePath.backIcon,
                                    color: kPureBlack,
                                    height: 12,
                                    width: 7,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                Obx(() => _individualUserController.showLoading.value
                    ? Positioned(
                        bottom: 20 * SizeConfig.heightMultiplier!,
                        left: Get.width / 2 - 10,
                        child: Center(child: CustomizedCircularProgress()))
                    : SizedBox())
              ],
            ),
          ),
        ),
      ),
    );
  }

// user interest listview using demo list
  Widget _userinterestBar({List<String>? list}) {
    return Container(
      height: 28 * SizeConfig.heightMultiplier!,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: list!.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.only(left: 8.0 * SizeConfig.widthMultiplier!),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(
                        14 * SizeConfig.heightMultiplier!)),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 12 * SizeConfig.widthMultiplier!),
                  child: Center(
                    child: Text(
                      list[index],
                      style: AppTextStyle.lightMediumBlackText.copyWith(
                        color: Theme.of(context).textTheme.bodyText1?.color,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
