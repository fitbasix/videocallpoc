import 'dart:io';
import 'dart:typed_data';

import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/posts/controller/post_controller.dart';
import 'package:fitbasix/feature/posts/services/createPost_Services.dart';
import 'package:fitbasix/feature/posts/services/post_service.dart';
import 'package:fitbasix/feature/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:image_picker/image_picker.dart';

import '../../posts/model/media_response_model.dart';
import '../services/profile_services.dart';

class CameraProfileViewScreen extends StatefulWidget {
  CameraProfileViewScreen({this.imageFile, this.isVideo});
  File? imageFile;
  final bool? isVideo;

  @override
  State<CameraProfileViewScreen> createState() =>
      _CameraProfileViewScreenState();
}

class _CameraProfileViewScreenState extends State<CameraProfileViewScreen> {
  final ProfileController profileController = Get.find();
  final HomeController homeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  'camera'.tr,
                  style: AppTextStyle.titleText.copyWith(
                      color:
                          Theme.of(context).appBarTheme.titleTextStyle?.color,
                      fontSize: 16 * SizeConfig.textMultiplier!),
                ),
              )),
          body: Column(
            children: [
              SizedBox(
                height: 16 * SizeConfig.heightMultiplier!,
              ),
              Stack(
                children: [
                  Image.file(
                    widget.imageFile!,
                    height: 400 * SizeConfig.heightMultiplier!,
                    width: Get.width,
                    fit: BoxFit.cover,
                  ),
                  widget.isVideo == true
                      ? Padding(
                          padding: EdgeInsets.only(
                              top: 170 * SizeConfig.heightMultiplier!),
                          child: Center(
                            child: Icon(
                              Icons.play_arrow,
                              color: kPureWhite,
                              size: 56 * SizeConfig.heightMultiplier!,
                            ),
                          ),
                        )
                      : Container(),
                  Obx(() => profileController.isLoading.value
                      ? Padding(
                          padding: EdgeInsets.only(
                              top: 170 * SizeConfig.heightMultiplier!),
                          child: Center(child: CustomizedCircularProgress()),
                        )
                      : Container())
                ],
              ),
            ],
          ),
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomAppBar(
              elevation: 15,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 24 * SizeConfig.widthMultiplier!),
                child: Container(
                  height: 65 * SizeConfig.heightMultiplier!,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final ImagePicker picker = ImagePicker();
                            if (widget.isVideo == true) {
                              XFile? file = await picker.pickVideo(
                                  source: ImageSource.camera);
                              if (file != null) {
                                profileController.imageFile = File(file.path);
                                final fileName = await profileController
                                    .genThumbnailFile(file.path);
                                setState(() {
                                  widget.imageFile = fileName;
                                });
                              }
                            } else {
                              XFile? file = await picker.pickImage(
                                  source: ImageSource.camera, imageQuality: 20);
                              if (file != null) {
                                profileController.imageFile = File(file.path);
                                setState(() {
                                  widget.imageFile = File(file.path);
                                });
                              }
                            }
                          },
                          child: Container(
                            height: 48 * SizeConfig.heightMultiplier!,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                    color: kGreenColor,
                                    width: 2 * SizeConfig.heightMultiplier!),
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Center(
                              child: Text(
                                'ratake'.tr,
                                style: AppTextStyle.greenSemiBoldText.copyWith(
                                    fontSize: 18 * SizeConfig.textMultiplier!),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 30 * SizeConfig.widthMultiplier!),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            profileController.isLoading.value = true;
                            if (profileController.isCoverPhoto.value == false) {
                              homeController.profilePhoto.value =
                                  await ProfileServices.UpdateProfilePhoto(
                                      profilePhoto: [
                                    File(profileController.imageFile!.path)
                                  ]);
                              profileController.profilePhoto.value =
                                  homeController.profilePhoto.value;
                            } else {
                              // MediaUrl mediaUrl = await PostService.uploadMedia(
                              //     [File(profileController.imageFile!.path)]);
                              // profileController.coverPhoto.value =
                              //     mediaUrl.response!.data![0];
                              homeController.coverPhoto.value =
                                  await ProfileServices.UpdateCoverPhoto(
                                      coverPhoto: [
                                    File(profileController.imageFile!.path)
                                  ]);
                              // homeController.coverPhoto.value =
                              //     mediaUrl.response!.data![0];
                            }

                            profileController.isLoading.value = false;
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 48 * SizeConfig.heightMultiplier!,
                            decoration: BoxDecoration(
                                color: kGreenColor,
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Center(
                              child: Text('next'.tr,
                                  style: AppTextStyle.greenSemiBoldText
                                      .copyWith(
                                          fontSize:
                                              18 * SizeConfig.textMultiplier!,
                                          color: kPureWhite)),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
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
    ));
  }
}
