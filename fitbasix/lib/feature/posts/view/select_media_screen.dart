import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:fitbasix/core/universal_widgets/right_tick.dart';
import 'package:fitbasix/feature/posts/services/post_service.dart';
import 'package:fitbasix/feature/posts/view/cached_network_image.dart';
import 'package:fitbasix/feature/posts/view/camera_screen.dart';
import 'package:fitbasix/feature/posts/view/widgets/custom_dropDown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/feature/posts/controller/post_controller.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class SelectMediaScreen extends StatefulWidget {
  SelectMediaScreen({Key? key}) : super(key: key);

  @override
  State<SelectMediaScreen> createState() => _SelectMediaScreenState();
}

class _SelectMediaScreenState extends State<SelectMediaScreen> {
  final PostController _postController = Get.put(PostController());
  final ScrollController _scrollController = ScrollController();
  List<DropdownMenuItem<AssetPathEntity>> buildDropdownMenuItems(
      List companies) {
    List<DropdownMenuItem<AssetPathEntity>> items = [];
    for (AssetPathEntity company in companies) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.name),
        ),
      );
    }
    return items;
  }

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
          Obx(() => _postController.selectedMediaAsset.length > 0
              ? RightTick(
                  onTap: () async {
                    await _postController
                        .getFile(_postController.selectedMediaAsset);
                    PostService.uploadMedia(
                      _postController.selectedMediaFiles,
                    );
                  },
                )
              : Row(
                  children: [
                    IconButton(
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          XFile? file = await picker.pickImage(
                              source: ImageSource.camera);
                          if (file != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CameraViewScreen(
                                        imageFile: File(file.path),
                                      )),
                            );
                          }
                        },
                        icon: Icon(
                          Icons.camera_alt,
                          color: kPureBlack,
                        )),
                    GestureDetector(
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        XFile? file =
                            await picker.pickVideo(source: ImageSource.camera);
                        if (file != null) {
                          final fileName =
                              await _postController.genThumbnailFile(file.path);
                          print(fileName);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CameraViewScreen(
                                      imageFile: fileName,
                                      isVideo: true,
                                    )),
                          );
                        }
                      },
                      child: SvgPicture.asset(
                        ImagePath.videoIcon,
                      ),
                    ),
                    SizedBox(
                      width: 17.66 * SizeConfig.widthMultiplier!,
                    )
                  ],
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
            child: Obx(
              () => Stack(
                children: [
                  Obx(
                    () => _postController.assets.length == 0
                        ? Container()
                        : Padding(
                            padding: EdgeInsets.only(top: 58.0),
                            child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 6,
                                        mainAxisSpacing: 6),
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _postController.assets.length,
                                itemBuilder: (BuildContext context, int index) {
                                  // _postController.getSelectedMedia(
                                  //     _postController.assets[0]);
                                  return Obx(() => AssetThumbnail(
                                        asset: _postController.assets[index],
                                        tag: _postController
                                            .assets[index].modifiedDateSecond!,
                                        onTap: () async {
                                          _postController.lastSelectedMediaIndex
                                                  .value =
                                              int.tryParse(_postController
                                                  .assets[index].id)!;
                                          _postController.getSelectedMedia(
                                              _postController.assets[index]);
                                        },
                                        isSelected: _postController
                                                    .selectedMediaAsset
                                                    .indexOf(_postController
                                                        .assets[index]) ==
                                                -1
                                            ? false
                                            : true,
                                        selectionNumber: (_postController
                                                    .selectedMediaAsset
                                                    .indexOf(_postController
                                                        .assets[index]) +
                                                1)
                                            .toString(),
                                      ));
                                }),
                          ),
                  ),
                  customDropDownBtn(
                    options: _postController.foldersAvailable,
                    controller: _postController,
                    isExpanded: _postController.isDropDownExpanded.value,
                    label: 'gallery'.tr,
                    /* onPressed: () {
                        _postController.toggleDropDownExpansion();
                      }*/
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AssetThumbnail extends StatelessWidget {
  AssetThumbnail(
      {Key? key,
      required this.asset,
      required this.onTap,
      required this.isSelected,
      required this.selectionNumber,
      required this.tag})
      : super(key: key);

  final AssetEntity asset;
  final VoidCallback onTap;
  final bool isSelected;
  final String selectionNumber;
  final int tag;
  @override
  Widget build(BuildContext context) {
    print(ImageCache().liveImageCount);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: isSelected ? kGreenColor : kPureWhite, width: 2)),
        child: FutureBuilder<Uint8List?>(
          future: asset.thumbData,
          builder: (_, snapshot) {
            // print("lll" + tag.toString());
            final image = snapshot.data;
            if (image != null)
              return Stack(
                children: [
                  Positioned.fill(
                      child: Image(
                    image: CacheImageProvider(
                        img: snapshot.data!, tag: tag.toString()),
                    fit: BoxFit.cover,
                    //  loadingBuilder: CircularProgressIndicator(),
                    key: ValueKey(tag),
                  )),
                  if (asset.type == AssetType.video)
                    Center(
                      child: Icon(
                        Icons.play_arrow,
                        color: kPureWhite,
                        size: 32 * SizeConfig.heightMultiplier!,
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
                      : Positioned(
                          top: 7 * SizeConfig.heightMultiplier!,
                          right: 8 * SizeConfig.widthMultiplier!,
                          child: Container(
                              height: 24 * SizeConfig.widthMultiplier!,
                              width: 24 * SizeConfig.widthMultiplier!,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      12 * SizeConfig.widthMultiplier!),
                                  border: Border.all(
                                      color: Colors.white, width: 1.0))),
                        )
                ],
              );
            return Container();
          },
        ),
      ),
    );
  }
}
