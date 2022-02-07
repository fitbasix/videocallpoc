import 'dart:io';

import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/posts/controller/post_controller.dart';
import 'package:fitbasix/feature/posts/model/category_model.dart';
import 'package:fitbasix/feature/posts/services/createPost_Services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class DiscardPostBottomSheet extends StatelessWidget {
  DiscardPostBottomSheet({
    Key? key,
  }) : super(key: key);

  final PostController _postController = Get.find();
  final HomeController _homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 235 * SizeConfig.heightMultiplier!,
      color: Colors.white,
      padding: EdgeInsets.only(
          top: 32 * SizeConfig.heightMultiplier!,
          left: 16 * SizeConfig.widthMultiplier!,
          right: 16 * SizeConfig.widthMultiplier!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'discard_post_title'.tr,
            style: AppTextStyle.boldBlackText
                .copyWith(fontSize: 14 * SizeConfig.textMultiplier!),
          ),
          SizedBox(
            height: 8 * SizeConfig.heightMultiplier!,
          ),
          Text(
            'discard_post_subtitle'.tr,
            style: AppTextStyle.normalBlackText
                .copyWith(fontSize: 12 * SizeConfig.textMultiplier!),
          ),
          SizedBox(
            height: 31 * SizeConfig.heightMultiplier!,
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.create),
            label: Text(
              'continue_editing'.tr,
              style: AppTextStyle.boldBlackText
                  .copyWith(fontSize: 14 * SizeConfig.textMultiplier!),
            ),
            style: TextButton.styleFrom(
                primary: lightBlack,
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap),
          ),
          SizedBox(
            height: 34 * SizeConfig.heightMultiplier!,
          ),
          TextButton.icon(
            onPressed: () {
              CreatePostService.deletePost(_postController.postId.value);
              Navigator.pop(context);
              // Navigator.pushNamedAndRemoveUntil(
              //     context, RouteName.homePage, (route) => false);
              _postController.postId.value = "";
              _postController.postTextController.clear();
              _postController.postText.value = '';
              _postController.selectedMediaFiles.clear();
              _postController.selectedMediaAsset.clear();
              _postController.selectedCategory.value = Category();
              _postController.selectedUserData.clear();
              _postController.selectedPeopleIndex.clear();
              _postController.users.clear();
              _postController.imageFile = null;
              _postController.isLoading.value = false;
              _postController.selectedFiles.clear();
              _homeController.selectedIndex.value = 0;
            },
            icon: const Icon(Icons.delete_outline),
            label: Text(
              'discard_post'.tr,
              style: AppTextStyle.boldBlackText.copyWith(
                  fontSize: 14 * SizeConfig.textMultiplier!, color: kPink),
            ),
            style: TextButton.styleFrom(
                primary: kPink,
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap),
          ),
        ],
      ),
    );
  }
}
