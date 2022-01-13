import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/feature/posts/controller/post_controller.dart';

class SelectMediaScreen extends StatefulWidget {
  SelectMediaScreen({Key? key}) : super(key: key);

  @override
  State<SelectMediaScreen> createState() => _SelectMediaScreenState();
}

class _SelectMediaScreenState extends State<SelectMediaScreen> {
  final PostController _postController = Get.put(PostController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_postController.lastPage.value !=
            _postController.currentPage.value) {
          final imageAsset = await _postController.fetchAssets(
              presentPage: _postController.currentPage.value);

          if (imageAsset.isNotEmpty) {
            _postController.assets.addAll(imageAsset);
          }
        }
        // final imageAsset = await _postController.fetchAssets(
        //     start: _postController.currentPage.value * 100 + 1,
        //     end: _postController.currentPage.value * 200);

        // _postController.currentPage.value++;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.camera_alt,
                color: kPureBlack,
              ))
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: 16 * SizeConfig.heightMultiplier!,
                horizontal: 16 * SizeConfig.widthMultiplier!),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'gallery'.tr,
                      style: AppTextStyle.titleText
                          .copyWith(fontSize: 16 * SizeConfig.textMultiplier!),
                    ),
                    Transform.rotate(
                      angle: -90 * math.pi / 180,
                      child: IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            ImagePath.backIcon,
                            width: 12 * SizeConfig.widthMultiplier!,
                            height: 10 * SizeConfig.heightMultiplier!,
                          )),
                    )
                  ],
                ),
                Obx(
                  () => _postController.assets.length == 0
                      ? Container()
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 6,
                                  mainAxisSpacing: 6),
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _postController.assets.length,
                          itemBuilder: (BuildContext context, int index) {
                            _postController.getSelectedMedia(100);
                            return Obx(() => AssetThumbnail(
                                  asset: _postController.assets[index],
                                  onTap: () {
                                    _postController
                                            .lastSelectedMediaIndex.value =
                                        int.tryParse(
                                            _postController.assets[index].id)!;

                                    _postController.getSelectedMedia(
                                        _postController
                                            .lastSelectedMediaIndex.value);
                                    print(_postController.assets[index].id);

                                    _postController.selectedMediaCount.add(
                                        _postController
                                            .selectedMediaIndex.length);
                                  },
                                  isSelected: _postController.selectedMediaIndex
                                              .indexOf(int.tryParse(
                                                  _postController
                                                      .assets[index].id)!) ==
                                          -1
                                      ? false
                                      : true,
                                  selectionNumber:
                                      _postController.selectedMediaIndex.length,
                                ));
                          }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AssetThumbnail extends StatelessWidget {
  AssetThumbnail({
    Key? key,
    required this.asset,
    required this.onTap,
    required this.isSelected,
    required this.selectionNumber,
  }) : super(key: key);

  final AssetEntity asset;
  final VoidCallback onTap;
  final bool isSelected;
  final int selectionNumber;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: isSelected ? kGreenColor : kPureWhite, width: 2)),
        child: FutureBuilder<File?>(
          future: asset.file,
          builder: (_, snapshot) {
            final image = snapshot.data;
            if (image != null)
              return Stack(
                children: [
                  Positioned.fill(
                      child: asset.type == AssetType.video
                          ? Container()
                          : Image.file(
                              snapshot.data!,
                              fit: BoxFit.cover,
                            )),
                  if (asset.type == AssetType.video)
                    Center(
                      child: Container(
                        color: Colors.blue,
                        child: Icon(
                          Icons.play_arrow,
                          color: kPureWhite,
                        ),
                      ),
                    ),
                  isSelected
                      ? Positioned(
                          top: 7 * SizeConfig.heightMultiplier!,
                          right: 8 * SizeConfig.widthMultiplier!,
                          child: CircleAvatar(
                            backgroundColor: kGreenColor,
                            radius: 12 * SizeConfig.widthMultiplier!,
                            child: Text(
                              selectionNumber.toString(),
                              style: AppTextStyle.titleText.copyWith(
                                  fontSize: 16 * SizeConfig.textMultiplier!,
                                  color: kPureWhite),
                            ),
                          ),
                        )
                      : Container()
                ],
              );
            return Container();
          },
        ),
      ),
    );
  }
}
