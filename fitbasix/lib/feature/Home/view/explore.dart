import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
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

class ExploreFeed extends StatelessWidget {
  final HomeController homeController = Get.find();
  final PostController postController = Get.find();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() async {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        homeController.nextDataLoad.value = true;

        final postQuery = await HomeService.getExplorePosts(
            skip: homeController.explorePageCount.value * 5);

        if (postQuery.response!.data!.length < 5) {
          homeController.explorePostList.addAll(postQuery.response!.data!);
          homeController.explorePageCount.value++;
          homeController.nextDataLoad.value = false;
          return;
        } else {
          // if (_homeController.trendingPostList.last.id ==
          //     postQuery.response!.data!.last.id) {
          //   _homeController.showLoader.value = false;
          //   return;
          // }
          homeController.explorePageCount.value++;
          homeController.explorePostList.addAll(postQuery.response!.data!);
          homeController.nextDataLoad.value = false;
        }

        homeController.nextDataLoad.value = false;
      }
    });
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPureWhite,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset(
                ImagePath.backIcon,
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
                        controller: homeController.searchController,
                        style: AppTextStyle.smallGreyText.copyWith(
                            fontSize: 14 * SizeConfig.textMultiplier!,
                            color: kBlack),
                        onChanged: (value) async {
                          if (homeController.exploreSearchText.value != value) {
                            if (value.length > 2) {
                              homeController.exploreSearchText.value = value;
                              homeController.isExploreDataLoading.value = true;
                              homeController.explorePageCount.value = 0;
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
                                homeController.explorePageCount.value = 0;
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
                    style: AppTextStyle.titleText
                        .copyWith(fontSize: 16 * SizeConfig.textMultiplier!),
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
                      color: kPureBlack,
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
                      height: 28 * SizeConfig.heightMultiplier!,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 16 * SizeConfig.widthMultiplier!),
                            child: ItemCategory(
                              onTap: () async {
                                homeController.explorePageCount.value = 0;
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
                                            child: ItemCategory(
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
                                            child: ItemCategory(
                                              onTap: () async {
                                                homeController
                                                    .explorePageCount.value = 0;
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
                              return Obx(() => Column(
                                    children: [
                                      ExplorePostTile(
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
                                                .explorePostList[index]
                                                .caption ??
                                            '',
                                        likes: homeController
                                            .explorePostList[index].likes
                                            .toString(),
                                        comments: homeController
                                            .explorePostList[index].comments
                                            .toString(),
                                        hitLike: () async {
                                          if (homeController
                                              .explorePostList[index]
                                              .isLiked!) {
                                            homeController
                                                .explorePostList[index]
                                                .isLiked = false;
                                            homeController
                                                .explorePostList[index]
                                                .likes = (homeController
                                                    .explorePostList[index]
                                                    .likes! -
                                                1);
                                            // HomeService.unlikePost(
                                            //     postId: _homeController
                                            //         .trendingPostList[
                                            //     index]
                                            //         .id!);
                                          } else {
                                            // _homeController
                                            //     .trendingPostList[
                                            // index]
                                            //     .isLiked = true;
                                            // _homeController
                                            //     .trendingPostList[
                                            // index]
                                            //     .likes = (_homeController
                                            //     .trendingPostList[
                                            // index]
                                            //     .likes! +
                                            //     1);
                                            // HomeService.likePost(
                                            //     postId: _homeController
                                            //         .trendingPostList[
                                            //     index]
                                            //         .id!);
                                          }
                                          // setState(() {});
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
                                        isLiked: homeController
                                            .explorePostList[index].isLiked!,
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      PostScreen()));
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
                                  ));
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
