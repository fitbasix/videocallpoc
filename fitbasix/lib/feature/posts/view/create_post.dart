import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/feature/posts/model/category_model.dart';
import 'package:fitbasix/feature/posts/model/post_model.dart';
import 'package:fitbasix/feature/posts/services/createPost_Services.dart';
import 'package:fitbasix/feature/posts/services/post_service.dart';
import 'package:fitbasix/feature/posts/view/widgets/discard_post_bottom_sheet.dart';
import 'package:fitbasix/feature/posts/view/widgets/select_category_dialog.dart';
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
      onTap: () async {
        FocusScope.of(context).unfocus();
        if (_postController.postText.value.length > 0) {
          _postController.postData.value = await CreatePostService.createPost(
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
                showModalBottomSheet(
                    context: context, builder: (_) => DiscardPostBottomSheet());
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
                ? _postController.isLoading.value == false
                    ? Container(
                        height: 32,
                        width: 78,
                        margin: EdgeInsets.only(top: 8, bottom: 8, right: 16),
                        child: ElevatedButton(
                          onPressed: () async {
                            _postController.isLoading.value = true;
                            _postController.postData.value =
                                await CreatePostService.createPost(
                                    postId: _postController.postId.value,
                                    isPublish: true);
                            _postController.isLoading.value = false;
                            if (_postController.postData.value.code == 0) {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  RouteName.homePage, (route) => false);
                              Get.showSnackbar(GetSnackBar(
                                message: 'Post posted successfully',
                                duration: Duration(seconds: 3),
                              ));

                              _postController.postTextController.clear();
                              _postController.postText.value = '';
                              _postController.selectedMediaFiles.clear();
                              _postController.selectedMediaAsset.clear();
                              _postController.selectedCategory.value =
                                  Category();
                            }
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
                    : Padding(
                        padding: EdgeInsets.only(
                            right: 16 * SizeConfig.widthMultiplier!),
                        child: CustomizedCircularProgress(),
                      )
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
        body: WillPopScope(
          onWillPop: () async {
            showModalBottomSheet(
                context: context, builder: (_) => DiscardPostBottomSheet());
            return false;
          },
          child: SafeArea(
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
                                .response!.data!.profilePhoto
                                .toString(),
                            fit: BoxFit.cover,
                            height: 40 * SizeConfig.widthMultiplier!,
                            width: 40 * SizeConfig.widthMultiplier!),
                      ),
                      SizedBox(
                        width: 12 * SizeConfig.widthMultiplier!,
                      ),
                      Obx(() => _postController.postData.value.response!.data!
                                  .people!.length ==
                              0
                          ? Text(
                              _postController
                                  .userProfileData.value.response!.data!.name!,
                              style: AppTextStyle.boldBlackText.copyWith(
                                  fontSize: 14 * SizeConfig.textMultiplier!),
                            )
                          : _postController.postData.value.response!.data!
                                      .people!.length ==
                                  1
                              ? Container(
                                  width: 276 * SizeConfig.widthMultiplier!,
                                  child: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Text(
                                        _postController.userProfileData.value
                                            .response!.data!.name!,
                                        style: AppTextStyle.boldBlackText
                                            .copyWith(
                                                fontSize: 14 *
                                                    SizeConfig.textMultiplier!),
                                      ),
                                      SizedBox(
                                        width: 4 * SizeConfig.widthMultiplier!,
                                      ),
                                      Container(
                                        height: 1,
                                        width: 15,
                                        color: kPureBlack,
                                      ),
                                      SizedBox(
                                        width: 4 * SizeConfig.widthMultiplier!,
                                      ),
                                      Text('with'.tr),
                                      SizedBox(
                                        width: 4 * SizeConfig.widthMultiplier!,
                                      ),
                                      Text(
                                        _postController.postData.value.response!
                                            .data!.people![0].name!,
                                        style: AppTextStyle.boldBlackText
                                            .copyWith(
                                                fontSize: 14 *
                                                    SizeConfig.textMultiplier!),
                                      )
                                    ],
                                  ),
                                )
                              : Container(
                                  width: 276 * SizeConfig.widthMultiplier!,
                                  child: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Text(
                                        _postController.userProfileData.value
                                            .response!.data!.name!,
                                        style: AppTextStyle.boldBlackText
                                            .copyWith(
                                                fontSize: 14 *
                                                    SizeConfig.textMultiplier!),
                                      ),
                                      SizedBox(
                                        width: 4 * SizeConfig.widthMultiplier!,
                                      ),
                                      Container(
                                        height: 1,
                                        width: 15,
                                        color: kPureBlack,
                                      ),
                                      SizedBox(
                                        width: 4 * SizeConfig.widthMultiplier!,
                                      ),
                                      Text(
                                        'with'.tr,
                                        style: AppTextStyle.normalBlackText
                                            .copyWith(
                                                fontSize: 14 *
                                                    SizeConfig.textMultiplier!),
                                      ),
                                      SizedBox(
                                        width: 4 * SizeConfig.widthMultiplier!,
                                      ),
                                      Text(
                                        _postController.postData.value.response!
                                            .data!.people![0].name!,
                                        style: AppTextStyle.boldBlackText
                                            .copyWith(
                                                fontSize: 14 *
                                                    SizeConfig.textMultiplier!),
                                      ),
                                      Text(
                                        'and'.tr,
                                        style: AppTextStyle.normalBlackText
                                            .copyWith(
                                                fontSize: 14 *
                                                    SizeConfig.textMultiplier!),
                                      ),
                                      Text(
                                        'others'.trParams({
                                          "no_people": (_postController
                                                      .postData
                                                      .value
                                                      .response!
                                                      .data!
                                                      .people!
                                                      .length -
                                                  1)
                                              .toString()
                                        }),
                                        style: AppTextStyle.boldBlackText
                                            .copyWith(
                                                fontSize: 14 *
                                                    SizeConfig.textMultiplier!),
                                      )
                                    ],
                                  ),
                                ))
                    ],
                  ),
                  SizedBox(
                    height: 10 * SizeConfig.heightMultiplier!,
                  ),
                  Obx(
                    () => GestureDetector(
                        onTap: () async {
                          print(_postController.selectedCategory.value);
                          _postController.getCategory();
                          await showDialog(
                              context: context,
                              builder: (_) => SelectCategoryDialog(
                                    category: _postController.categories,
                                  ));
                        },
                        child: _postController.selectedCategory.value.name ==
                                null
                            ? Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: hintGrey,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        8 * SizeConfig.heightMultiplier!)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          12 * SizeConfig.widthMultiplier!,
                                      vertical:
                                          8 * SizeConfig.heightMultiplier!),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        size: 15 * SizeConfig.textMultiplier!,
                                        color: hintGrey,
                                      ),
                                      SizedBox(
                                        width:
                                            10.5 * SizeConfig.widthMultiplier!,
                                      ),
                                      Text(
                                        'add_category'.tr,
                                        style: AppTextStyle.smallGreyText
                                            .copyWith(color: hintGrey),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: lightBlack,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        8 * SizeConfig.heightMultiplier!)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          12 * SizeConfig.widthMultiplier!,
                                      vertical:
                                          8 * SizeConfig.heightMultiplier!),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        _postController
                                            .selectedCategory.value.name
                                            .toString(),
                                        style: AppTextStyle.smallGreyText
                                            .copyWith(color: lightBlack),
                                      )
                                    ],
                                  ),
                                ),
                              )),
                  ),
                  SizedBox(
                    height: 10 * SizeConfig.heightMultiplier!,
                  ),
                  Obx(
                      () =>
                          _postController.postData.value.response!.data!.files!
                                      .length ==
                                  0
                              ? Container(
                                  height: 180 * SizeConfig.heightMultiplier!,
                                  child: TextField(
                                    controller:
                                        _postController.postTextController,
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
                                        hintStyle:
                                            AppTextStyle.NormalText.copyWith(
                                                fontSize: 18 *
                                                    SizeConfig.textMultiplier!,
                                                color: hintGrey)),
                                  ),
                                )
                              : _postController.postData.value.response!.data!
                                              .files!.length ==
                                          1 &&
                                      _postController.postData.value.response!
                                              .data!.caption ==
                                          null
                                  ? Container(
                                      child: ListView(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        children: [
                                          Container(
                                            height: 64 *
                                                SizeConfig.heightMultiplier!,
                                            child: TextField(
                                              controller: _postController
                                                  .postTextController,
                                              onChanged: (value) {
                                                _postController.postText.value =
                                                    value;
                                              },
                                              onSubmitted: (value) {},
                                              onEditingComplete: () {},
                                              style: AppTextStyle
                                                  .normalPureBlackText,
                                              // keyboardType: TextInputType.multiline,
                                              maxLines: null,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'post_hint'.tr,
                                                  hintStyle: AppTextStyle
                                                          .NormalText
                                                      .copyWith(
                                                          fontSize: 18 *
                                                              SizeConfig
                                                                  .textMultiplier!,
                                                          color: hintGrey)),
                                            ),
                                          ),
                                          _postController.getUrlType(
                                                      _postController
                                                          .postData
                                                          .value
                                                          .response!
                                                          .data!
                                                          .files![0]) ==
                                                  0
                                              ? Stack(
                                                  children: [
                                                    CachedNetworkImage(
                                                      imageUrl: _postController
                                                          .postData
                                                          .value
                                                          .response!
                                                          .data!
                                                          .files![0],
                                                      height: 336 *
                                                          SizeConfig
                                                              .heightMultiplier!,
                                                      width: double.infinity,
                                                      fit: BoxFit.fitWidth,
                                                    ),
                                                    Positioned(
                                                        top: 10,
                                                        right: 10,
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            if (_postController
                                                                    .selectedMediaFiles
                                                                    .length !=
                                                                0) {
                                                              _postController
                                                                  .selectedMediaAsset
                                                                  .removeAt(0);
                                                              _postController
                                                                  .selectedMediaFiles
                                                                  .removeAt(0);
                                                              _postController
                                                                      .uploadedFiles
                                                                      .value =
                                                                  await PostService
                                                                      .uploadMedia(
                                                                _postController
                                                                    .selectedMediaFiles,
                                                              );
                                                            } else {
                                                              _postController
                                                                      .uploadedFiles
                                                                      .value =
                                                                  await PostService
                                                                      .uploadMedia(
                                                                [],
                                                              );
                                                            }
                                                            if (_postController
                                                                    .uploadedFiles
                                                                    .value
                                                                    .code ==
                                                                0) {
                                                              _postController
                                                                      .postData
                                                                      .value =
                                                                  await CreatePostService.createPost(
                                                                      postId: _postController
                                                                          .postId
                                                                          .value,
                                                                      files: _postController
                                                                          .uploadedFiles
                                                                          .value
                                                                          .response!
                                                                          .data);
                                                            }
                                                          },
                                                          child:
                                                              SvgPicture.asset(
                                                            ImagePath
                                                                .cancelIcon,
                                                            height: 24 *
                                                                SizeConfig
                                                                    .widthMultiplier!,
                                                            width: 24 *
                                                                SizeConfig
                                                                    .widthMultiplier!,
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ))
                                                  ],
                                                )
                                              : FutureBuilder<File?>(
                                                  future: _postController
                                                      .genThumbnailFile(
                                                          _postController
                                                              .postData
                                                              .value
                                                              .response!
                                                              .data!
                                                              .files![0]),
                                                  builder: (_, snapshot) {
                                                    final image = snapshot.data;
                                                    if (image != null)
                                                      return Stack(
                                                        children: [
                                                          Image.file(
                                                            image,
                                                            height: 336 *
                                                                SizeConfig
                                                                    .heightMultiplier!,
                                                            width:
                                                                double.infinity,
                                                            fit:
                                                                BoxFit.fitWidth,
                                                          ),
                                                          Positioned(
                                                              top: 10,
                                                              right: 10,
                                                              child:
                                                                  GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  if (_postController
                                                                          .selectedMediaFiles
                                                                          .length !=
                                                                      0) {
                                                                    _postController
                                                                        .selectedMediaAsset
                                                                        .removeAt(
                                                                            0);
                                                                    _postController
                                                                        .selectedMediaFiles
                                                                        .removeAt(
                                                                            0);
                                                                    _postController
                                                                            .uploadedFiles
                                                                            .value =
                                                                        await PostService
                                                                            .uploadMedia(
                                                                      _postController
                                                                          .selectedMediaFiles,
                                                                    );
                                                                  } else {
                                                                    _postController
                                                                            .uploadedFiles
                                                                            .value =
                                                                        await PostService
                                                                            .uploadMedia(
                                                                      [],
                                                                    );
                                                                  }
                                                                  if (_postController
                                                                          .uploadedFiles
                                                                          .value
                                                                          .code ==
                                                                      0) {
                                                                    _postController.postData.value = await CreatePostService.createPost(
                                                                        postId: _postController
                                                                            .postId
                                                                            .value,
                                                                        files: _postController
                                                                            .uploadedFiles
                                                                            .value
                                                                            .response!
                                                                            .data);
                                                                  }
                                                                },
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  ImagePath
                                                                      .cancelIcon,
                                                                  height: 24 *
                                                                      SizeConfig
                                                                          .widthMultiplier!,
                                                                  width: 24 *
                                                                      SizeConfig
                                                                          .widthMultiplier!,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                ),
                                                              )),
                                                          Positioned(
                                                            top: 336 /
                                                                    2 *
                                                                    SizeConfig
                                                                        .heightMultiplier! -
                                                                28 *
                                                                    SizeConfig
                                                                        .heightMultiplier!,
                                                            left: Get.width /
                                                                    2 *
                                                                    SizeConfig
                                                                        .widthMultiplier! -
                                                                60 *
                                                                    SizeConfig
                                                                        .widthMultiplier!,
                                                            child: Center(
                                                              child: Icon(
                                                                Icons
                                                                    .play_arrow,
                                                                color:
                                                                    kPureWhite,
                                                                size: 56 *
                                                                    SizeConfig
                                                                        .heightMultiplier!,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      );
                                                    return Container();
                                                  })
                                        ],
                                      ),
                                    )
                                  : Container(
                                      child: ListView(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        children: [
                                          Container(
                                            height: 64 *
                                                SizeConfig.heightMultiplier!,
                                            child: TextField(
                                              controller: _postController
                                                  .postTextController,
                                              onChanged: (value) {
                                                _postController.postText.value =
                                                    value;
                                              },
                                              onSubmitted: (value) {},
                                              onEditingComplete: () {},
                                              style: AppTextStyle
                                                  .normalPureBlackText,
                                              // keyboardType: TextInputType.multiline,
                                              maxLines: null,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'post_hint'.tr,
                                                  hintStyle: AppTextStyle
                                                          .NormalText
                                                      .copyWith(
                                                          fontSize: 18 *
                                                              SizeConfig
                                                                  .textMultiplier!,
                                                          color: hintGrey)),
                                            ),
                                          ),
                                          Container(
                                            height: 120,
                                            child: ListView.builder(
                                                itemCount: _postController
                                                    .postData
                                                    .value
                                                    .response!
                                                    .data!
                                                    .files!
                                                    .length,
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 12 *
                                                              SizeConfig
                                                                  .widthMultiplier!),
                                                      child:
                                                          _postController.getUrlType(_postController
                                                                          .postData
                                                                          .value
                                                                          .response!
                                                                          .data!
                                                                          .files![
                                                                      index]) ==
                                                                  0
                                                              ? Stack(
                                                                  children: [
                                                                    CachedNetworkImage(
                                                                      imageUrl: _postController
                                                                          .postData
                                                                          .value
                                                                          .response!
                                                                          .data!
                                                                          .files![index],
                                                                      height: 120 *
                                                                          SizeConfig
                                                                              .heightMultiplier!,
                                                                      width: 120 *
                                                                          SizeConfig
                                                                              .widthMultiplier!,
                                                                      fit: BoxFit
                                                                          .fitWidth,
                                                                    ),
                                                                    Positioned(
                                                                        top: 4,
                                                                        right:
                                                                            4,
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap:
                                                                              () async {
                                                                            if (_postController.selectedMediaFiles.length !=
                                                                                0) {
                                                                              _postController.selectedMediaAsset.removeAt(index);
                                                                              _postController.selectedMediaFiles.removeAt(index);
                                                                              _postController.uploadedFiles.value = await PostService.uploadMedia(
                                                                                _postController.selectedMediaFiles,
                                                                              );
                                                                            } else {
                                                                              _postController.uploadedFiles.value = await PostService.uploadMedia(
                                                                                [],
                                                                              );
                                                                            }
                                                                            if (_postController.uploadedFiles.value.code ==
                                                                                0) {
                                                                              _postController.postData.value = await CreatePostService.createPost(postId: _postController.postId.value, files: _postController.uploadedFiles.value.response!.data);
                                                                            }
                                                                          },
                                                                          child:
                                                                              SvgPicture.asset(
                                                                            ImagePath.cancelIcon,
                                                                            height:
                                                                                24 * SizeConfig.widthMultiplier!,
                                                                            width:
                                                                                24 * SizeConfig.widthMultiplier!,
                                                                            fit:
                                                                                BoxFit.contain,
                                                                          ),
                                                                        ))
                                                                  ],
                                                                )
                                                              : FutureBuilder<
                                                                      File?>(
                                                                  future: _postController.genThumbnailFile(_postController
                                                                          .postData
                                                                          .value
                                                                          .response!
                                                                          .data!
                                                                          .files![
                                                                      index]),
                                                                  builder: (_,
                                                                      snapshot) {
                                                                    final image =
                                                                        snapshot
                                                                            .data;
                                                                    if (image !=
                                                                        null)
                                                                      return Stack(
                                                                        children: [
                                                                          Image
                                                                              .file(
                                                                            image,
                                                                            fit:
                                                                                BoxFit.fitWidth,
                                                                            height:
                                                                                120 * SizeConfig.widthMultiplier!,
                                                                            width:
                                                                                120 * SizeConfig.widthMultiplier!,
                                                                          ),
                                                                          Positioned(
                                                                            top:
                                                                                40,
                                                                            left:
                                                                                40,
                                                                            child:
                                                                                Icon(
                                                                              Icons.play_arrow,
                                                                              color: kPureWhite,
                                                                              size: 32 * SizeConfig.heightMultiplier!,
                                                                            ),
                                                                          ),
                                                                          Positioned(
                                                                              top: 4,
                                                                              right: 4,
                                                                              child: GestureDetector(
                                                                                onTap: () async {
                                                                                  if (_postController.selectedMediaFiles.length != 0) {
                                                                                    _postController.selectedMediaAsset.removeAt(index);
                                                                                    _postController.selectedMediaFiles.removeAt(index);
                                                                                    _postController.uploadedFiles.value = await PostService.uploadMedia(
                                                                                      _postController.selectedMediaFiles,
                                                                                    );
                                                                                  } else {
                                                                                    _postController.uploadedFiles.value = await PostService.uploadMedia(
                                                                                      [],
                                                                                    );
                                                                                  }
                                                                                  if (_postController.uploadedFiles.value.code == 0) {
                                                                                    _postController.postData.value = await CreatePostService.createPost(postId: _postController.postId.value, files: _postController.uploadedFiles.value.response!.data);
                                                                                  }
                                                                                },
                                                                                child: SvgPicture.asset(
                                                                                  ImagePath.cancelIcon,
                                                                                  height: 24 * SizeConfig.widthMultiplier!,
                                                                                  width: 24 * SizeConfig.widthMultiplier!,
                                                                                  fit: BoxFit.contain,
                                                                                ),
                                                                              ))
                                                                        ],
                                                                      );
                                                                    return Container();
                                                                  })

                                                      // child: CachedNetworkImage(
                                                      //   imageUrl: _postController
                                                      //       .postData
                                                      //       .value
                                                      //       .response!
                                                      //       .data!
                                                      //       .files![index],
                                                      //   height: 120 *
                                                      //       SizeConfig.widthMultiplier!,
                                                      //   width: 120 *
                                                      //       SizeConfig.widthMultiplier!,
                                                      //   fit: BoxFit.fitWidth,
                                                      // ),
                                                      );
                                                }),
                                          )
                                        ],
                                      ),
                                    )),
                  SizedBox(
                    height: 16 * SizeConfig.heightMultiplier!,
                  ),
                  Divider(),
                  Obx(() => _postController.postData.value.response!.data!
                              .location!.placeName!.length ==
                          0
                      ? GestureDetector(
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
                        )
                      : GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, RouteName.selectLocationScreen);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_pin,
                                color: kPink,
                              ),
                              SizedBox(
                                width: 16 * SizeConfig.widthMultiplier!,
                              ),
                              Text(
                                _postController.postData.value.response!.data!
                                    .location!.placeName![1],
                                style: AppTextStyle.titleText.copyWith(
                                    fontSize: 14 * SizeConfig.textMultiplier!),
                              )
                            ],
                          ),
                        )),
                  SizedBox(
                    height: 34 * SizeConfig.heightMultiplier!,
                  ),
                  GestureDetector(
                    onTap: () async {
                      _postController.currentPage.value = 0;
                      _postController.assets.value =
                          await _postController.fetchAssets(
                              presentPage: _postController.currentPage.value);
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
      ),
    );
  }
}
