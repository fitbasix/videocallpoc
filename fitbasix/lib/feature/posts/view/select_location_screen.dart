import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/core/universal_widgets/right_tick.dart';
import 'package:fitbasix/feature/posts/services/createPost_Services.dart';
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

import '../model/suggestion_model.dart';

class SelectLocationScreen extends StatelessWidget {
  SelectLocationScreen({Key? key}) : super(key: key);

  final PostController _postController = Get.find();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _postController.locationSearchController.clear();
        _postController.searchSuggestion.value.predictions!.clear();
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                _postController.locationSearchController.clear();
                _postController.searchSuggestion.value.predictions!.clear();
                Navigator.pop(context);
                _postController.isLoading.value = false;
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
              'select_location'.tr,
              style: AppTextStyle.titleText.copyWith(
                  color: Theme.of(context).appBarTheme.titleTextStyle?.color,
                  fontSize: 16 * SizeConfig.textMultiplier!),
            ),
          ),
          actions: [
            Obx(() => _postController.selectedLocation.value == ''
                ? Container()
                : _postController.isLoading.value == false
                    ? RightTick(onTap: () async {
                        _postController.isLoading.value = true;
                        _postController.postData.value =
                            await CreatePostService.createPost(
                                postId: _postController.postId.value,
                                placeName: [
                                  _postController
                                      .selectedLocationData.value.placeName!
                                ],
                                placeId: _postController
                                    .selectedLocationData.value.placeId);
                        Navigator.pop(context);
                        _postController.isLoading.value = false;
                      })
                    : Padding(
                        padding: EdgeInsets.only(
                            right: 16 * SizeConfig.widthMultiplier!),
                        child: CustomizedCircularProgress()))
          ],
        ),
        body: Stack(
          children: [
            SafeArea(
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
                          color: Theme.of(context).textTheme.headline4?.color,
                          borderRadius: BorderRadius.circular(
                              8 * SizeConfig.widthMultiplier!),
                        ),
                        child: TextField(
                          controller: _postController.locationSearchController,
                          style: AppTextStyle.normalGreenText.copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyText1?.color),
                          onChanged: (value) async {
                            _postController.searchLoading.value = true;
                            if (value.isEmpty) {
                              printInfo(info: "Emptyyyyyyyy");
                              _postController
                                  .searchSuggestion.value.predictions!
                                  .clear();
                              _postController.searchLoading.value = false;
                            }
                            if (value.length > 0) {
                              _postController.searchSuggestion.value =
                                  (await PlaceApiProvider.fetchSuggestions(
                                      value,
                                      'en',
                                      _postController.sessionToken))!;
                              print("lll" +
                                  _postController.searchSuggestion.value
                                      .predictions![0].placeId
                                      .toString());
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
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.color,
                                        fontSize:
                                            14 * SizeConfig.textMultiplier!),
                                  ),
                                  Spacer(),
                                  IconButton(
                                      onPressed: () {
                                        _postController.selectedLocation.value =
                                            '';
                                        _postController.selectedLocationData
                                            .value.placeName = '';
                                        _postController.selectedLocationData
                                            .value.placeId = '';
                                      },
                                      icon: Icon(
                                        Icons.clear,
                                        color: Theme.of(context).primaryColor,
                                      ))
                                ],
                              ),
                            )),
                      Obx(() => _postController.searchLoading.value ||
                              _postController
                                      .searchSuggestion.value.predictions ==
                                  null
                          ? Container()
                          : TitleText(title: 'suggestions'.tr)),
                      SizedBox(
                        height: 28 * SizeConfig.heightMultiplier!,
                      ),
                      Obx(() => _postController.searchLoading.value ||
                              _postController
                                      .searchSuggestion.value.predictions ==
                                  null
                          ? Container()
                          : Container(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _postController.searchSuggestion
                                      .value.predictions!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
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
                                              .secondaryText
                                              .toString(),
                                          onTap: () {
                                            FocusScope.of(context).unfocus();
                                            print(_postController
                                                .searchSuggestion
                                                .value
                                                .predictions![index]
                                                .placeId);
                                            _postController
                                                    .selectedLocation.value =
                                                _postController
                                                    .searchSuggestion
                                                    .value
                                                    .predictions![index]
                                                    .structuredFormatting!
                                                    .mainText
                                                    .toString();

                                            _postController.selectedLocationData
                                                    .value.placeId =
                                                _postController
                                                    .searchSuggestion
                                                    .value
                                                    .predictions![index]
                                                    .placeId;

                                            _postController.selectedLocationData
                                                    .value.placeName =
                                                _postController
                                                    .searchSuggestion
                                                    .value
                                                    .predictions![index]
                                                    .structuredFormatting!
                                                    .mainText;
                                          },
                                        ));
                                  }),
                            ))
                    ],
                  ),
                ),
              ),
            ),
            Obx(
              () => _postController.isLoading.value
                  ? Container(
                      height: Get.height,
                      width: Get.width,
                      color: Colors.black.withOpacity(0.015),
                    )
                  : Container(),
            )
          ],
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
      child: Container(
        color: Colors.transparent,
        width: Get.width,
        child: Padding(
          padding: EdgeInsets.only(
              left: 4 * SizeConfig.widthMultiplier!,
              bottom: 32 * SizeConfig.heightMultiplier!),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mainText,
                style: AppTextStyle.boldBlackText.copyWith(
                    color: Theme.of(context).textTheme.bodyText1?.color,
                    fontSize: 14 * SizeConfig.textMultiplier!),
              ),
              Text(
                secondaryText,
                style: AppTextStyle.NormalText.copyWith(
                  color: Theme.of(context).textTheme.bodyText1?.color,
                  fontSize: 12 * SizeConfig.textMultiplier!,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
