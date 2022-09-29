import 'dart:developer';

import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/Home/model/RecentCommentModel.dart';
import 'package:fitbasix/feature/Home/services/home_service.dart';
import 'package:fitbasix/feature/Home/view/post_screen.dart';
import 'package:fitbasix/feature/Home/view/widgets/explore_feed.dart';
import 'package:fitbasix/feature/Home/view/widgets/post_tile.dart';
import 'package:fitbasix/feature/get_trained/view/all_trainer_screen.dart';
import 'package:fitbasix/feature/posts/controller/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/universal_widgets/capitalizeText.dart';

class ExploreFeed extends StatefulWidget {
  @override
  State<ExploreFeed> createState() => _ExploreFeedState();
}

class _ExploreFeedState extends State<ExploreFeed> {
  final HomeController homeController = Get.find();

  final PostController postController = Get.find();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    homeController.explorePageCount.value = 1;
    _scrollController.addListener(() async {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        homeController.nextDataLoad.value = true;
        final postQuery = await HomeService.getExplorePosts(
            skip: homeController.explorePageCount.value * 5);

        if (postQuery.response!.data!.length < 5) {
          homeController.explorePostList.addAll(postQuery.response!.data!);
          // homeController.explorePageCount.value++;

          //   return;
        } else {
          // if (_homeController.trendingPostList.last.id ==
          //     postQuery.response!.data!.last.id) {
          //   _homeController.showLoader.value = false;
          //   return;
          // }

          if (homeController.explorePostList.last.id ==
              postQuery.response!.data!.last.id) {
            // homeController.explorePageCount.value++;
            //  return;
          }

          // homeController.explorePageCount.value++;
          homeController.explorePostList.addAll(postQuery.response!.data!);
        }
        homeController.explorePageCount.value++;
        homeController.nextDataLoad.value = false;
        setState(() {});
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset(
                ImagePath.backIcon,
                color: Theme.of(context).primaryColor,
                width: 7 * SizeConfig.widthMultiplier!,
                height: 12 * SizeConfig.heightMultiplier!,
              )),
          title: Obx(() => homeController.isExploreSearch.value
              ? Transform(
                  transform: Matrix4.translationValues(
                      -20 * SizeConfig.widthMultiplier!, 0, 0),
                  child: Container(
                    height: 32 * SizeConfig.heightMultiplier!,
                    decoration: BoxDecoration(
                      color: lightGrey,
                      borderRadius: BorderRadius.circular(
                          8 * SizeConfig.widthMultiplier!),
                    ),
                    child: Center(
                      child: TextField(
                        inputFormatters: [
                                        UpperCaseTextFormatter()
                                      ],
                                      textCapitalization: TextCapitalization.sentences,
                        controller: homeController.searchController,
                        style: AppTextStyle.smallGreyText.copyWith(
                            fontSize: 14 * SizeConfig.textMultiplier!,
                            color: kBlack),
                        onChanged: (value) async {
                          if (homeController.exploreSearchText.value != value) {
                            if (value.length > 2) {
                              homeController.exploreSearchText.value = value;
                              homeController.isExploreDataLoading.value = true;
                              homeController.explorePageCount.value = 1;
                              homeController.explorePostModel.value =
                                  await HomeService.getExplorePosts();
                              homeController.explorePostList.value =
                                  homeController
                                      .explorePostModel.value.response!.data!;
                              homeController.isExploreDataLoading.value = false;
                            }
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(
                                left: 10.5 * SizeConfig.widthMultiplier!,
                                right: 5),
                            child: Icon(
                              Icons.search,
                              color: hintGrey,
                              size: 22 * SizeConfig.heightMultiplier!,
                            ),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () async {
                              if (homeController.searchController.text.length ==
                                  0) {
                                homeController.isExploreSearch.value = false;
                              } else {
                                homeController.exploreSearchText.value = "";
                                homeController.searchController.clear();
                                homeController.isExploreDataLoading.value =
                                    true;
                                homeController.explorePageCount.value = 1;
                                homeController.explorePostModel.value =
                                    await HomeService.getExplorePosts();
                                homeController.explorePostList.value =
                                    homeController
                                        .explorePostModel.value.response!.data!;
                                homeController.isExploreDataLoading.value =
                                    false;
                              }
                            },
                            child: Icon(
                              Icons.clear,
                              color: hintGrey,
                              size: 18 * SizeConfig.heightMultiplier!,
                            ),
                          ),
                          border: InputBorder.none,
                          hintText: 'explore_search'.tr,
                          hintStyle: AppTextStyle.smallGreyText.copyWith(
                              fontSize: 14 * SizeConfig.textMultiplier!,
                              color: hintGrey),
                          /*contentPadding: EdgeInsets.only(
                                top: -2,
                              )*/
                        ),
                      ),
                    ),
                  ),
                )
              : Transform(
                  transform: Matrix4.translationValues(-20, 0, 0),
                  child: Text(
                    'explore'.tr,
                    style: AppTextStyle.titleText.copyWith(
                        color: Theme.of(context).textTheme.bodyText1?.color,
                        fontSize: 16 * SizeConfig.textMultiplier!),
                  ),
                )),
          actions: [
            Obx(() => homeController.isExploreSearch.value
                ? SizedBox()
                : IconButton(
                    onPressed: () {
                      homeController.isExploreSearch.value = true;
                    },
                    icon: Icon(
                      Icons.search,
                      color: Theme.of(context).primaryColor,
                      size: 25 * SizeConfig.heightMultiplier!,
                    )))
          ],
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 12 * SizeConfig.heightMultiplier!,
                  ),
                  Obx(
                    () => Container(
                      height: 30 * SizeConfig.heightMultiplier!,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 16 * SizeConfig.widthMultiplier!),
                            child: ExploreItemCategory(
                              onTap: () async {
                                homeController.explorePageCount.value = 1;
                                _scrollController.jumpTo(0);
                                homeController.selectedPostCategoryIndex.value =
                                    -1;
                                homeController.isExploreDataLoading.value =
                                    true;
                                homeController.explorePostModel.value =
                                    await HomeService.getExplorePosts();
                                homeController.explorePostList.value =
                                    homeController
                                        .explorePostModel.value.response!.data!;
                                homeController.isExploreDataLoading.value =
                                    false;
                              },
                              isSelected: homeController
                                          .selectedPostCategoryIndex.value ==
                                      -1
                                  ? true
                                  : false,
                              interest: 'All'.tr,
                            ),
                          ),
                          ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: postController.categories.length == 0
                                  ? 3
                                  : postController.categories.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                // for (int i = 0;
                                // i <
                                //     _trainerController.interests.value.response!
                                //         .response!.data!.length;
                                // i++) {
                                //   _trainerController.interestSelection.add(false);
                                // }
                                return Obx(
                                    () => postController.categories.length == 0
                                        ? Shimmer.fromColors(
                                            child: ExploreItemCategory(
                                                interest: "Category",
                                                onTap: () {},
                                                isSelected: false),
                                            baseColor: const Color.fromRGBO(
                                                230, 230, 230, 1),
                                            highlightColor:
                                                const Color.fromRGBO(
                                                    242, 245, 245, 1),
                                          )
                                        : Padding(
                                            padding: index == 0
                                                ? EdgeInsets.only(
                                                    left: 0 *
                                                        SizeConfig
                                                            .widthMultiplier!)
                                                : EdgeInsets.all(0),
                                            child: ExploreItemCategory(
                                              onTap: () async {
                                                homeController
                                                    .explorePageCount.value = 1;
                                                homeController
                                                        .selectedPostCategoryIndex
                                                        .value =
                                                    postController
                                                        .categories[index]
                                                        .serialId!;
                                                homeController
                                                    .isExploreDataLoading
                                                    .value = true;
                                                homeController.explorePostModel
                                                        .value =
                                                    await HomeService
                                                        .getExplorePosts();
                                                homeController
                                                        .explorePostList.value =
                                                    homeController
                                                        .explorePostModel
                                                        .value
                                                        .response!
                                                        .data!;
                                                homeController
                                                    .isExploreDataLoading
                                                    .value = false;
                                              },
                                              isSelected: homeController
                                                          .selectedPostCategoryIndex
                                                          .value ==
                                                      postController
                                                          .categories[index]
                                                          .serialId!
                                                  ? true
                                                  : false,
                                              interest: postController
                                                  .categories[index].name
                                                  .toString(),
                                            ),
                                          ));
                              }),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20 * SizeConfig.heightMultiplier!),
                  Obx(
                    () => homeController.isExploreDataLoading.value
                        ? Center(child: CustomizedCircularProgress())
                        : ListView.builder(
                            itemCount:
                                homeController.explorePostList.length == 0
                                    ? 0
                                    : homeController.explorePostList.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (_, index) {
                              if (homeController.explorePostModel.value
                                      .response!.data!.length <
                                  5) {
                                // _homeController.isNeedToLoadData
                                //     .value = false;
                              }
                              return Obx(() {
                                print(homeController
                                    .explorePostList[index]
                                    .isMe.toString()+ homeController
                                    .explorePostList[index].id!);
                                return Column(
                                    children: [

                                      ExplorePostTile(
                                        isMe:homeController
                                            .explorePostList[index]
                                            .isMe!,
                                        userID: homeController.explorePostList[index].userId!.id,
                                        name: homeController
                                            .explorePostList[index]
                                            .userId!
                                            .name!,
                                        profilePhoto: homeController
                                            .explorePostList[index]
                                            .userId!
                                            .profilePhoto!,
                                        category: homeController
                                            .explorePostList[index]
                                            .postCategory![0]
                                            .name!,
                                        isFollowing: homeController
                                            .explorePostList[index]
                                            .isFollowing!,
                                        date: DateFormat.d().add_MMM().format(
                                            homeController
                                                .explorePostList[index]
                                                .updatedAt!),
                                        place: homeController
                                                    .explorePostList[index]
                                                    .location!
                                                    .placeName!
                                                    .length ==
                                                0
                                            ? ''
                                            : homeController
                                                .explorePostList[index]
                                                .location!
                                                .placeName![1]
                                                .toString(),
                                        imageUrl: homeController
                                                    .explorePostList[index]
                                                    .files!
                                                    .length ==
                                                0
                                            ? []
                                            : homeController
                                                .explorePostList[index].files!,
                                        caption: homeController
                                            .explorePostList[index].caption
                                            .toString(),
                                        likes: homeController.updateCount[
                                                    homeController
                                                        .explorePostList[index]
                                                        .id] ==
                                                null
                                            ? homeController
                                                .explorePostList[index].likes
                                                .toString()
                                            : homeController
                                                .updateCount[homeController
                                                    .explorePostList[index].id]!
                                                .likes!
                                                .toString(),
                                        comments: homeController.updateCount[
                                                    homeController
                                                        .explorePostList[index]
                                                        .id] ==
                                                null
                                            ? homeController
                                                .explorePostList[index].comments
                                                .toString()
                                            : homeController
                                                .updateCount[homeController
                                                    .explorePostList[index].id]!
                                                .comments!
                                                .toString(),
                                        hitLike: () async {
                                          bool val = homeController
                                                          .LikedPostMap[
                                                      homeController
                                                          .explorePostList[
                                                              index]
                                                          .id!] ==
                                                  null
                                              ? homeController
                                                  .explorePostList[index]
                                                  .isLiked!
                                              : homeController.LikedPostMap[
                                                  homeController
                                                      .explorePostList[index]
                                                      .id!]!;
                                          // if()
                                          if (val) {
                                            homeController
                                                .explorePostList[index]
                                                .isLiked = false;
                                            homeController.LikedPostMap[
                                                homeController
                                                    .explorePostList[index]
                                                    .id!] = false;
                                            homeController
                                                .explorePostList[index]
                                                .likes = (homeController
                                                    .explorePostList[index]
                                                    .likes! -
                                                1);
                                            await HomeService.unlikePost(
                                                postId: homeController
                                                    .explorePostList[index]
                                                    .id!);
                                          } else {
                                            homeController
                                                .explorePostList[index]
                                                .isLiked = true;
                                            homeController
                                                .explorePostList[index]
                                                .likes = (homeController
                                                    .explorePostList[index]
                                                    .likes! +
                                                1);
                                            homeController.LikedPostMap[
                                                homeController
                                                    .explorePostList[index]
                                                    .id!] = true;
                                            await HomeService.likePost(
                                                postId: homeController
                                                    .explorePostList[index]
                                                    .id!);
                                          }
                                          RecentCommentModel recentComment =
                                              RecentCommentModel();
                                          recentComment =
                                              await HomeService.recentComment(
                                                  postId: homeController
                                                      .explorePostList[index]
                                                      .id!);
                                          // _homeController.commentsMap[_homeController.post.value.id.toString()] =
                                          //     recentComment.response!.data!.comment;
                                          homeController.updateCount[
                                              homeController
                                                  .explorePostList[index]
                                                  .id!] = recentComment
                                              .response!.data!.data;
                                          setState(() {});
                                        },
                                        addComment: () {
                                          // HomeService.addComment(
                                          //     _homeController
                                          //         .trendingPostList[
                                          //     index]
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
                                        postId: homeController
                                            .explorePostList[index].id!,
                                        isLiked: homeController.LikedPostMap[
                                                    homeController
                                                        .explorePostList[index]
                                                        .id!] ==
                                                null
                                            ? homeController
                                                .explorePostList[index].isLiked!
                                            : homeController.LikedPostMap[
                                                homeController
                                                    .explorePostList[index]
                                                    .id]!,
                                        onTap: () async {
                                          homeController.commentsList.clear();
                                          homeController.viewReplies!.clear();
                                          Navigator.pushNamed(
                                              context, RouteName.postScreen);
                                          homeController.postLoading.value =
                                              true;
                                          var postData =
                                              await HomeService.getPostById(
                                                  homeController
                                                      .explorePostList[index]
                                                      .id!);
                                          homeController.post.value =
                                              postData.response!.data!;

                                          homeController.postLoading.value =
                                              false;
                                          homeController.commentsLoading.value =
                                              true;

                                          homeController.postComments.value =
                                              await HomeService.fetchComment(
                                                  postId: homeController
                                                      .explorePostList[index]
                                                      .id!);

                                          if (homeController.postComments.value
                                                  .response!.data!.length !=
                                              0) {
                                            homeController.commentsList.value =
                                                homeController.postComments
                                                    .value.response!.data!;
                                          }
                                          homeController.commentsLoading.value =
                                              false;
                                        },
                                        people: homeController
                                            .explorePostList[index].people!,
                                      ),
                                      Container(
                                        height:
                                            16 * SizeConfig.heightMultiplier!,
                                        color: kBackgroundColor,
                                      )
                                    ],
                                  );});
                            }),
                  )
                ],
              ),
              Obx(
                () => homeController.nextDataLoad.value
                    ? Positioned(
                        bottom: 20,
                        left: (Get.width / 2) - 10,
                        child: Center(child: CustomizedCircularProgress()),
                      )
                    : Container(),
              )
            ],
          ),
        ));
  }
}

class ExploreItemCategory extends StatelessWidget {
  const ExploreItemCategory({
    Key? key,
    required this.interest,
    required this.onTap,
    required this.isSelected,
  }) : super(key: key);
  final String interest;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0 * SizeConfig.widthMultiplier!),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 30 * SizeConfig.heightMultiplier!,
          decoration: BoxDecoration(
            color: isSelected
                ? kgreen49
                : Theme.of(context).textTheme.headline4?.color,
            borderRadius:
                BorderRadius.circular(14 * SizeConfig.heightMultiplier!),
            // border: Border.all(
            //   color: kBlack,
            // )
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 12 * SizeConfig.widthMultiplier!),
            child: Center(
              child: Text(
                interest,
                style: AppTextStyle.lightMediumBlackText.copyWith(
                    color: Theme.of(context).textTheme.bodyText1?.color),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
