import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/core/universal_widgets/right_tick.dart';
import 'package:fitbasix/feature/posts/model/media_response_model.dart';
import 'package:fitbasix/feature/posts/view/cached_network_image.dart';
import 'package:fitbasix/feature/posts/view/camera_screen.dart';
import 'package:fitbasix/feature/profile/services/profile_services.dart';
import 'package:fitbasix/feature/profile/view/profile_camera_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import '../../Home/controller/Home_Controller.dart';
import '../../posts/services/post_service.dart';
import '../controller/profile_controller.dart';

class SelectProfilePicScreen extends StatefulWidget {
  SelectProfilePicScreen({Key? key}) : super(key: key);

  @override
  State<SelectProfilePicScreen> createState() => _SelectProfilePicScreenState();
}

class _SelectProfilePicScreenState extends State<SelectProfilePicScreen> {
  // final PostController _postController = Get.put(PostController());
  final ScrollController _scrollController = ScrollController();
  final ProfileController profileController = Get.find();
  final HomeController homeController = Get.find();
  File? selectedMediaFile;
  AssetEntity? selectedAssestEntity;
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
        if (profileController.lastPage.value !=
            profileController.currentPage.value) {
          final imageAsset = await profileController.fetchAssets(
              presentPage: profileController.currentPage.value);

          if (imageAsset.isNotEmpty) {
            profileController.assets.addAll(imageAsset);
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
    print(profileController.assets.length);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              profileController.isLoading.value = false;
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              ImagePath.backIcon,
              color: Theme.of(context).primaryColor,
              width: 7 * SizeConfig.widthMultiplier!,
              height: 12 * SizeConfig.heightMultiplier!,
            )),
        title: Transform(
          transform: Matrix4.translationValues(-20, 0, 0),
          child: Text(
            'gallery'.tr,
            style: AppTextStyle.titleText.copyWith(
                color: Theme.of(context).appBarTheme.titleTextStyle?.color,
                fontSize: 16 * SizeConfig.textMultiplier!),
          ),
        ),
        actions: [
          Obx(() => profileController.isLoading.value
              ? CustomizedCircularProgress()
              : (selectedMediaFile != null
                  ? RightTick(
                      onTap: () async {
                        profileController.isLoading.value = true;
                        if (profileController.isCoverPhoto.value == false) {
                          profileController.profilePhoto.value =
                              await ProfileServices.UpdateProfilePhoto(
                                  profilePhoto: [
                                File(selectedMediaFile!.path)
                              ]);
                          homeController.profilePhoto.value =
                              profileController.profilePhoto.value;
                        } else {
                          // MediaUrl mediaUrl = await PostService.uploadMedia(
                          //     [File(selectedMediaFile!.path)]);
                          // profileController.coverPhoto.value =
                          //     mediaUrl.response!.data![0];
                          homeController.coverPhoto.value =
                              await ProfileServices.UpdateCoverPhoto(
                                  coverPhoto: [File(selectedMediaFile!.path)]);
                          // homeController.coverPhoto.value =
                          //     mediaUrl.response!.data![0];
                        }
                        profileController.isLoading.value = false;
                        Navigator.pop(context);
                      },
                    )
                  : Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              final ImagePicker picker = ImagePicker();
                              XFile? file = await picker.pickImage(
                                  source: ImageSource.camera, imageQuality: 20);
                              if (file != null) {
                                profileController.imageFile = File(file.path);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CameraProfileViewScreen(
                                            imageFile: File(file.path),
                                          )),
                                );
                              }
                            },
                            icon: Icon(
                              Icons.camera_alt,
                              color: Theme.of(context).primaryColor,
                            )),
                        // GestureDetector(
                        //   onTap: () async {
                        //     final ImagePicker picker = ImagePicker();
                        //     XFile? file =
                        //         await picker.pickVideo(source: ImageSource.camera);
                        //     if (file != null) {
                        //       profileController.imageFile = File(file.path);
                        //       final fileName = await profileController
                        //           .genThumbnailFile(file.path);
                        //       print(fileName);
                        //       Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => CameraViewScreen(
                        //                   imageFile: fileName,
                        //                   isVideo: true,
                        //                 )),
                        //       );
                        //     }
                        //   },
                        //   child: SvgPicture.asset(
                        //     ImagePath.videoIcon,
                        //     color: Theme.of(context).primaryColor,
                        //   ),
                        // ),
                        SizedBox(
                          width: 17.66 * SizeConfig.widthMultiplier!,
                        )
                      ],
                    )))
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 16 * SizeConfig.heightMultiplier!,
                    horizontal: 16 * SizeConfig.widthMultiplier!),
                child: Obx(
                  () => Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 58.0 * SizeConfig.heightMultiplier!),
                        child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 6,
                                    mainAxisSpacing: 6),
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: profileController.assets.length,
                            itemBuilder: (BuildContext context, int index) {
                              // _postController.getSelectedMedia(
                              //     _postController.assets[0]);
                              return Obx(() => profileController
                                          .assets[index].type ==
                                      AssetType.video
                                  ? Container()
                                  : AssetThumbnail(
                                      asset: profileController.assets[index],
                                      tag: profileController
                                          .assets[index].modifiedDateSecond!,
                                      onTap: () async {
                                        if (selectedAssestEntity ==
                                            profileController.assets[index]) {
                                          selectedAssestEntity = null;
                                          selectedMediaFile = null;
                                        } else {
                                          selectedAssestEntity =
                                              profileController.assets[index];
                                          selectedMediaFile =
                                              await profileController
                                                  .assets[index].file;
                                        }

                                        setState(() {});
                                        print(selectedMediaFile);
                                      },
                                      isSelected: selectedAssestEntity ==
                                              profileController.assets[index]
                                          ? true
                                          : false,
                                      selectionNumber: (profileController
                                                  .selectedMediaAsset
                                                  .indexOf(profileController
                                                      .assets[index]) +
                                              1)
                                          .toString(),
                                    ));
                            }),
                      ),

                      // customDropDownBtn(
                      //     options: _postController.foldersAvailable,
                      //     controller: _postController,
                      //     context: context,
                      //     isExpanded: _postController.isDropDownExpanded.value,
                      //     label: 'gallery'.tr,
                      //     onPressed: () {
                      //       _postController.toggleDropDownExpansion();
                      //     }),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Obx(
            () => profileController.isLoading.value
                ? Container(
                    height: Get.height,
                    width: Get.width,
                    color: Colors.black.withOpacity(0.015),
                  )
                : Container(),
          )
        ],
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
                color: isSelected ? kGreenColor : Colors.transparent,
                width: 2)),
        child: FutureBuilder<Uint8List?>(
          future: asset.thumbData,
          builder: (_, snapshot) {
            // print("lll" + tag.toString());
            final image = snapshot.data;
            if (image != null)
              return Stack(
                children: [
                  asset.type == AssetType.video
                      ? Container()
                      : Positioned.fill(
                          child: Image(
                          image: CacheImageProvider(
                              img: snapshot.data!, tag: tag.toString()),
                          fit: BoxFit.cover,
                          //  loadingBuilder: CircularProgressIndicator(),
                          key: ValueKey(tag),
                        )),
                  isSelected
                      ? Positioned(
                          top: 7 * SizeConfig.heightMultiplier!,
                          right: 8 * SizeConfig.widthMultiplier!,
                          child: CircleAvatar(
                            backgroundColor: kGreenColor,
                            radius: 12 * SizeConfig.widthMultiplier!,
                            child: Text(
                              "1",
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
