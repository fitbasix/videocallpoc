import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/get_trained/view/all_trainer_screen.dart';
import 'package:fitbasix/feature/posts/controller/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ExploreFeed extends StatelessWidget {
  final HomeController homeController = Get.find();
  final PostController postController = Get.find();
  @override
  Widget build(BuildContext context) {
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
                        onChanged: (value) async {},
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
                            onTap: () {
                              homeController.searchController.text.length == 0
                                  ? homeController.isExploreSearch.value = false
                                  : homeController.searchController.clear();
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
        body: Column(
          children: [
            SizedBox(
              height: 12 * SizeConfig.heightMultiplier!,
            ),
            Obx(
              () => Container(
                height: 28 * SizeConfig.heightMultiplier!,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: postController.categories.length == 0
                        ? 5
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
                      return Obx(() => postController.categories.length == 0
                          ? Shimmer.fromColors(
                              child: ItemCategory(
                                  interest: "Category",
                                  onTap: () {},
                                  isSelected: false),
                              baseColor: const Color.fromRGBO(230, 230, 230, 1),
                              highlightColor:
                                  const Color.fromRGBO(242, 245, 245, 1),
                            )
                          : Padding(
                              padding: index == 0
                                  ? EdgeInsets.only(
                                      left: 16 * SizeConfig.widthMultiplier!)
                                  : EdgeInsets.all(0),
                              child: ItemCategory(
                                onTap: () async {
                                  homeController
                                          .selectedPostCategoryIndex.value =
                                      postController
                                          .categories[index].serialId!;
                                },
                                isSelected: homeController
                                            .selectedPostCategoryIndex.value ==
                                        postController
                                            .categories[index].serialId!
                                    ? true
                                    : false,
                                interest: postController.categories[index].name
                                    .toString(),
                              ),
                            ));
                    }),
              ),
            )
          ],
        ));
  }
}
