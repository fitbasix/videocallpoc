import 'dart:io';
import 'dart:typed_data';

import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/feature/posts/controller/post_controller.dart';
import 'package:fitbasix/feature/posts/services/post_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:image_picker/image_picker.dart';

class CameraViewScreen extends StatefulWidget {
  CameraViewScreen({this.imageFile, this.isVideo});
  File? imageFile;
  final bool? isVideo;

  @override
  State<CameraViewScreen> createState() => _CameraViewScreenState();
}

class _CameraViewScreenState extends State<CameraViewScreen> {
  final PostController _postController = Get.put(PostController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: kPureWhite,
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
              'camera'.tr,
              style: AppTextStyle.titleText
                  .copyWith(fontSize: 16 * SizeConfig.textMultiplier!),
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
                  : Container()
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
          color: Colors.white,
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
                            final fileName = await _postController
                                .genThumbnailFile(file.path);
                            setState(() {
                              widget.imageFile = fileName;
                            });
                          }
                        } else {
                          XFile? file = await picker.pickImage(
                              source: ImageSource.camera);
                          if (file != null) {
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
                      onTap: () {
                        PostService.uploadMedia(
                          [widget.imageFile!],
                        );
                      },
                      child: Container(
                        height: 48 * SizeConfig.heightMultiplier!,
                        decoration: BoxDecoration(
                            color: kGreenColor,
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Center(
                          child: Text('camera'.tr,
                              style: AppTextStyle.greenSemiBoldText.copyWith(
                                  fontSize: 18 * SizeConfig.textMultiplier!,
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
    ));
  }
}
