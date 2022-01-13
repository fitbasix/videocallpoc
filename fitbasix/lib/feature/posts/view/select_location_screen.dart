import 'package:fitbasix/feature/posts/view/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/feature/posts/controller/post_controller.dart';
import 'package:fitbasix/feature/posts/services/location_service.dart';

class SelectLocationScreen extends StatelessWidget {
  SelectLocationScreen({Key? key}) : super(key: key);

  final PostController _postController = Get.find();

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
            'select_location'.tr,
            style: AppTextStyle.titleText
                .copyWith(fontSize: 16 * SizeConfig.textMultiplier!),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                top: 16 * SizeConfig.heightMultiplier!,
                left: 16 * SizeConfig.widthMultiplier!,
                right: 16 * SizeConfig.widthMultiplier!),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: lightGrey,
                    borderRadius:
                        BorderRadius.circular(8 * SizeConfig.widthMultiplier!),
                  ),
                  child: TextField(
                    controller: _postController.locationSearchController,
                    onChanged: (value) async {
                      if (value.length > 0) {
                        _postController.searchLoading.value = true;
                        _postController.searchSuggestion.value =
                            (await PlaceApiProvider.fetchSuggestions(
                                value, 'en', _postController.sessionToken))!;
                        _postController.searchLoading.value = false;
                      }

                      print(_postController
                          .searchSuggestion.value.predictions!.length);
                    },
                    decoration: InputDecoration(
                      prefixIcon: Transform(
                        transform: Matrix4.translationValues(0, 2, 0),
                        child: Icon(
                          Icons.search,
                          color: hintGrey,
                        ),
                      ),
                      border: InputBorder.none,
                      hintText: 'search'.tr,
                      hintStyle: AppTextStyle.smallGreyText.copyWith(
                          fontSize: 14 * SizeConfig.textMultiplier!,
                          color: hintGrey),
                    ),
                  ),
                ),
                SizedBox(
                  height: 24 * SizeConfig.heightMultiplier!,
                ),
                Obx(
                  () => _postController.selectedLocation.value == ''
                      ? Container()
                      : TitleText(
                          title: 'current_location'.tr,
                        ),
                ),
                Obx(() => _postController.selectedLocation.value == ''
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.only(
                            left: 4 * SizeConfig.widthMultiplier!,
                            top: 12 * SizeConfig.heightMultiplier!,
                            bottom: 20 * SizeConfig.heightMultiplier!),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_pin,
                              color: kPink,
                              size: 16,
                            ),
                            SizedBox(
                              width: 16 * SizeConfig.widthMultiplier!,
                            ),
                            Text(
                              _postController.selectedLocation.value,
                              style: AppTextStyle.boldBlackText.copyWith(
                                  fontSize: 14 * SizeConfig.textMultiplier!),
                            ),
                            Spacer(),
                            IconButton(
                                onPressed: () {
                                  _postController.selectedLocation.value = '';
                                },
                                icon: Icon(Icons.clear))
                          ],
                        ),
                      )),
                Obx(() => _postController.searchLoading.value ||
                        _postController.searchSuggestion.value.predictions ==
                            null
                    ? Container()
                    : TitleText(title: 'suggestions'.tr)),
                SizedBox(
                  height: 28 * SizeConfig.heightMultiplier!,
                ),
                Obx(() => _postController.searchLoading.value ||
                        _postController.searchSuggestion.value.predictions ==
                            null
                    ? Container()
                    : Container(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _postController
                                .searchSuggestion.value.predictions!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Obx(() => LocationTile(
                                    mainText: _postController
                                        .searchSuggestion
                                        .value
                                        .predictions![index]
                                        .structuredFormatting!
                                        .mainText!,
                                    secondaryText: _postController
                                        .searchSuggestion
                                        .value
                                        .predictions![index]
                                        .structuredFormatting!
                                        .secondaryText!,
                                    onTap: () {
                                      _postController.selectedLocation.value =
                                          _postController
                                              .searchSuggestion
                                              .value
                                              .predictions![index]
                                              .structuredFormatting!
                                              .mainText!;
                                    },
                                  ));
                            }),
                      ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LocationTile extends StatelessWidget {
  const LocationTile({
    Key? key,
    required this.mainText,
    required this.secondaryText,
    required this.onTap,
  }) : super(key: key);

  final String mainText;
  final String secondaryText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(
            left: 4 * SizeConfig.widthMultiplier!,
            bottom: 32 * SizeConfig.heightMultiplier!),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mainText,
              style: AppTextStyle.boldBlackText
                  .copyWith(fontSize: 14 * SizeConfig.textMultiplier!),
            ),
            Text(
              secondaryText,
              style: AppTextStyle.NormalText.copyWith(
                  fontSize: 12 * SizeConfig.textMultiplier!, color: lightBlack),
            ),
          ],
        ),
      ),
    );
  }
}
