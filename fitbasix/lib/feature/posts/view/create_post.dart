import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitbasix/feature/posts/services/createPost_Services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/feature/posts/controller/post_controller.dart';

class CreatePostScreen extends StatelessWidget {
  CreatePostScreen({Key? key}) : super(key: key);
  final PostController _postController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        if (_postController.postText.value.length > 0) {
          CreatePostService.createPost(
              postId: _postController.postId.value,
              caption: _postController.postText.value);
        }
      },
      child: Scaffold(
        backgroundColor: kPureWhite,
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
          title: Transform(
            transform: Matrix4.translationValues(-20, 0, 0),
            child: Text(
              'create_post'.tr,
              style: AppTextStyle.titleText
                  .copyWith(fontSize: 16 * SizeConfig.textMultiplier!),
            ),
          ),
          actions: [
            Obx(() => _postController.postText.value.length > 0
                ? Container(
                    height: 32,
                    width: 78,
                    margin: EdgeInsets.only(top: 8, bottom: 8, right: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        CreatePostService.createPost(
                            postId: _postController.postId.value,
                            isPublish: true);
                      },
                      child: Text(
                        'post'.tr,
                        style: AppTextStyle.boldBlackText.copyWith(
                            fontSize: 14 * SizeConfig.textMultiplier!,
                            color: kPureWhite),
                      ),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                          primary: kGreenColor),
                    ))
                : Container(
                    height: 32,
                    width: 78,
                    margin: EdgeInsets.only(top: 8, bottom: 8, right: 16),
                    child: ElevatedButton(
                      onPressed: null,
                      child: Text(
                        'post'.tr,
                        style: AppTextStyle.boldBlackText.copyWith(
                            fontSize: 14 * SizeConfig.textMultiplier!,
                            color: kGreyColor),
                      ),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                          primary: lightGrey),
                    )))
          ],
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                top: 8 * SizeConfig.heightMultiplier!,
                left: 16 * SizeConfig.widthMultiplier!,
                right: 16 * SizeConfig.widthMultiplier!),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                          20 * SizeConfig.widthMultiplier!),
                      child: CachedNetworkImage(
                          imageUrl: _postController.userProfileData.value
                              .response!.data!.profilePhoto!,
                          fit: BoxFit.cover,
                          height: 40 * SizeConfig.widthMultiplier!,
                          width: 40 * SizeConfig.widthMultiplier!),
                    ),
                    SizedBox(
                      width: 12 * SizeConfig.widthMultiplier!,
                    ),
                    Text(
                      _postController
                          .userProfileData.value.response!.data!.name!,
                      style: AppTextStyle.boldBlackText
                          .copyWith(fontSize: 14 * SizeConfig.textMultiplier!),
                    )
                  ],
                ),
                Container(
                  height: 180 * SizeConfig.heightMultiplier!,
                  child: TextField(
                    controller: _postController.postTextController,
                    onChanged: (value) {
                      _postController.postText.value = value;
                    },
                    onSubmitted: (value) {},
                    onEditingComplete: () {},
                    style: AppTextStyle.normalPureBlackText,
                    // keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'post_hint'.tr,
                        hintStyle: AppTextStyle.NormalText.copyWith(
                            fontSize: 18 * SizeConfig.textMultiplier!,
                            color: hintGrey)),
                  ),
                ),
                SizedBox(
                  height: 16 * SizeConfig.heightMultiplier!,
                ),
                Divider(),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        context, RouteName.selectLocationScreen);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(ImagePath.locationIcon,
                          width: 17 * SizeConfig.widthMultiplier!),
                      SizedBox(
                        width: 16 * SizeConfig.widthMultiplier!,
                      ),
                      Text(
                        'location'.tr,
                        style: AppTextStyle.titleText.copyWith(
                            fontSize: 14 * SizeConfig.textMultiplier!),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 34 * SizeConfig.heightMultiplier!,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RouteName.customGallery);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(ImagePath.galleryIcon,
                          width: 17 * SizeConfig.widthMultiplier!),
                      SizedBox(
                        width: 16 * SizeConfig.widthMultiplier!,
                      ),
                      Text(
                        'photo_video'.tr,
                        style: AppTextStyle.titleText.copyWith(
                            fontSize: 14 * SizeConfig.textMultiplier!),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 17 * SizeConfig.heightMultiplier!,
                ),
                Divider(
                  height: 0,
                ),
                SizedBox(
                  height: 17 * SizeConfig.heightMultiplier!,
                ),
                GestureDetector(
                  onTap: () async {
                    print("vartika");
                    // var users = await CreatePostService.getUsers();
                    // _postController.users.value = users.response!.data!;
                    // print(_postController.users.value);
                    Navigator.pushNamed(context, RouteName.tagPeopleScreen);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        ImagePath.tagPeopleIcon,
                        width: 17 * SizeConfig.widthMultiplier!,
                      ),
                      SizedBox(
                        width: 16 * SizeConfig.widthMultiplier!,
                      ),
                      Text(
                        'tag_people'.tr,
                        style: AppTextStyle.titleText.copyWith(
                            fontSize: 14 * SizeConfig.textMultiplier!),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 17 * SizeConfig.heightMultiplier!,
                ),
                Divider()
              ],
            ),
          ),
        )),
      ),
    );
  }
}
