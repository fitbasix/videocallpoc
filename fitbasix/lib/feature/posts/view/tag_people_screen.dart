import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/core/universal_widgets/right_tick.dart';
import 'package:fitbasix/feature/posts/services/createPost_Services.dart';
import 'package:fitbasix/feature/posts/view/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/feature/posts/controller/post_controller.dart';

class CheckboxState {
  final String title;
  bool value;
  CheckboxState({
    required this.title,
    this.value = false,
  });
}

class TagPeopleScreen extends StatelessWidget {
  TagPeopleScreen({Key? key}) : super(key: key);

  final PostController _postController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: kPureWhite,
        appBar: AppBar(
            backgroundColor: kPureWhite,
            elevation: 0,
            leading: IconButton(
                onPressed: () async {
                  Navigator.pop(context);
                  _postController.isLoading.value == false;
                },
                icon: SvgPicture.asset(
                  ImagePath.backIcon,
                  width: 7 * SizeConfig.widthMultiplier!,
                  height: 12 * SizeConfig.heightMultiplier!,
                )),
            title: Transform(
              transform: Matrix4.translationValues(-20, 0, 0),
              child: Text(
                'tag_people'.tr,
                style: AppTextStyle.titleText
                    .copyWith(fontSize: 16 * SizeConfig.textMultiplier!),
              ),
            ),
            actions: [
              Obx(() => _postController.selectedUserData.length > 0
                  ? _postController.isLoading.value == false
                      ? RightTick(
                          onTap: () async {
                            _postController.isLoading.value = true;
                            final List<String> taggedPeople = [];
                            if (_postController.selectedUserData.length == 0) {
                              Navigator.pop(context);
                            } else {
                              for (var i in _postController.selectedUserData) {
                                taggedPeople.add(i.id!);
                              }
                              _postController.postData.value =
                                  await CreatePostService.createPost(
                                      postId: _postController.postId.value,
                                      taggedPeople: taggedPeople);

                              Navigator.pushNamed(
                                  context, RouteName.createPost);
                              _postController.isLoading.value = false;
                            }
                          },
                        )
                      : Padding(
                          padding: EdgeInsets.only(
                              right: 16 * SizeConfig.widthMultiplier!),
                          child: CustomizedCircularProgress(),
                        )
                  : Container())
            ]),
        body: Stack(
          children: [
            SafeArea(
                child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 16 * SizeConfig.widthMultiplier!,
                    right: 16 * SizeConfig.widthMultiplier!,
                    top: 16 * SizeConfig.heightMultiplier!),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: lightGrey,
                        borderRadius: BorderRadius.circular(
                            8 * SizeConfig.widthMultiplier!),
                      ),
                      child: Center(
                        child: TextField(
                          onChanged: (value) async {
                            print(value);
                            var users = await CreatePostService.getUsers(value);
                            _postController.users.value = users.response!.data!;
                            print(_postController.users.value);
                          },
                          onSubmitted: (value) {
                            print(value);
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
                    ),
                    Obx(() => _postController.selectedPeopleIndex.length > 0
                        ? Padding(
                            padding: EdgeInsets.only(
                                top: 24 * SizeConfig.heightMultiplier!,
                                bottom: 24 * SizeConfig.heightMultiplier!),
                            child: TitleText(title: 'selected'.tr),
                          )
                        : Container()),
                    Obx(() => _postController.selectedPeopleIndex.length > 0
                        ? Container(
                            height: 115 * SizeConfig.heightMultiplier!,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    _postController.selectedUserData.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        right:
                                            16 * SizeConfig.widthMultiplier!),
                                    child: Stack(
                                      children: [
                                        Container(
                                          width:
                                              64 * SizeConfig.widthMultiplier!,
                                          child: Column(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(32 *
                                                        SizeConfig
                                                            .widthMultiplier!),
                                                child: CachedNetworkImage(
                                                    imageUrl: _postController
                                                        .selectedUserData[index]
                                                        .profilePhoto!,
                                                    fit: BoxFit.cover,
                                                    height: 64 *
                                                        SizeConfig
                                                            .widthMultiplier!,
                                                    width: 64 *
                                                        SizeConfig
                                                            .widthMultiplier!),
                                              ),
                                              SizedBox(
                                                height: 8 *
                                                    SizeConfig
                                                        .heightMultiplier!,
                                              ),
                                              Text(
                                                _postController
                                                    .selectedUserData[index]
                                                    .name!,
                                                style: AppTextStyle
                                                    .boldBlackText
                                                    .copyWith(
                                                        fontSize: 14 *
                                                            SizeConfig
                                                                .textMultiplier!),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                              )
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                            right: 3,
                                            child: GestureDetector(
                                              onTap: () {
                                                _postController.selectedUserData
                                                    .removeAt(index);
                                                _postController
                                                    .selectedPeopleIndex
                                                    .removeAt(index);
                                              },
                                              child: SvgPicture.asset(
                                                ImagePath.cancelIcon,
                                                height: 16 *
                                                    SizeConfig.widthMultiplier!,
                                                width: 16 *
                                                    SizeConfig.widthMultiplier!,
                                                fit: BoxFit.contain,
                                              ),
                                            ))
                                      ],
                                    ),
                                  );
                                }),
                          )
                        : Container()),
                    _postController.selectedPeopleIndex.length > 0
                        ? Padding(
                            padding: EdgeInsets.only(
                                top: 24 * SizeConfig.heightMultiplier!),
                            child: TitleText(title: 'suggestions'.tr),
                          )
                        : Container(),
                    Obx(
                      () => _postController.users.length == 0
                          ? Container()
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: _postController.users.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Obx(() => PeopleTile(
                                      name: _postController.users[index].name!,
                                      subtitle:
                                          _postController.users[index].name!,
                                      image: _postController
                                          .users[index].profilePhoto!,
                                      onTap: (value) {
                                        if (_postController
                                                .selectedPeopleIndex.length ==
                                            0) {
                                          _postController.selectedPeopleIndex
                                              .add(_postController
                                                  .users[index].id!);
                                          _postController.selectedUserData.add(
                                              _postController.users[index]);
                                        } else {
                                          if (_postController
                                                  .selectedPeopleIndex
                                                  .indexOf(_postController
                                                      .users[index].id!) ==
                                              -1) {
                                            _postController.selectedPeopleIndex
                                                .add(_postController
                                                    .users[index].id!);
                                            _postController.selectedUserData
                                                .add(_postController
                                                    .users[index]);
                                          } else {
                                            _postController.selectedPeopleIndex
                                                .remove(_postController
                                                    .users[index].id!);
                                            _postController.selectedUserData
                                                .remove(_postController
                                                    .users[index]);
                                          }
                                        }
                                      },
                                      value: _postController.selectedPeopleIndex
                                                  .indexOf(_postController
                                                      .users[index].id!) ==
                                              -1
                                          ? false
                                          : true,
                                    ));
                              }),
                    )
                  ],
                ),
              ),
            )),
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

class PeopleTile extends StatelessWidget {
  const PeopleTile({
    Key? key,
    required this.name,
    required this.subtitle,
    required this.image,
    required this.value,
    required this.onTap,
  }) : super(key: key);

  final String name;
  final String subtitle;
  final String image;
  final bool value;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(top: 12 * SizeConfig.heightMultiplier!),
      child: Row(
        children: [
          ClipRRect(
            borderRadius:
                BorderRadius.circular(16 * SizeConfig.widthMultiplier!),
            child: CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.cover,
                height: 32 * SizeConfig.widthMultiplier!,
                width: 32 * SizeConfig.widthMultiplier!),
          ),
          SizedBox(
            width: 12 * SizeConfig.widthMultiplier!,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTextStyle.boldBlackText
                    .copyWith(fontSize: 14 * SizeConfig.textMultiplier!),
              ),
              SizedBox(
                height: 4 * SizeConfig.heightMultiplier!,
              ),
              Text(
                subtitle,
                style: AppTextStyle.normalBlackText
                    .copyWith(fontSize: 12 * SizeConfig.textMultiplier!),
              )
            ],
          ),
          Spacer(),
          Checkbox(
            value: value,
            onChanged: (value) {
              onTap(value);
            },
            activeColor: kGreenColor,
          ),
          SizedBox(
            width: 7 * SizeConfig.widthMultiplier!,
          )
        ],
      ),
    );
  }
}
