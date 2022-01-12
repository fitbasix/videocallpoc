import 'package:fitbasix/feature/posts/view/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

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

  final notification = [
    CheckboxState(title: '1'),
    CheckboxState(title: '2'),
    CheckboxState(title: '3'),
    CheckboxState(title: '4'),
    CheckboxState(title: '5')
  ];

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
              'tag_people'.tr,
              style: AppTextStyle.titleText
                  .copyWith(fontSize: 16 * SizeConfig.textMultiplier!),
            ),
          ),
        ),
        body: SafeArea(
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
                    borderRadius:
                        BorderRadius.circular(8 * SizeConfig.widthMultiplier!),
                  ),
                  child: TextField(
                    onChanged: (value) {},
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
                        height: 106 * SizeConfig.heightMultiplier!,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                _postController.selectedPeopleIndex.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    right: 16 * SizeConfig.widthMultiplier!),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 64 * SizeConfig.widthMultiplier!,
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 32,
                                          ),
                                          SizedBox(
                                            height: 8 *
                                                SizeConfig.heightMultiplier!,
                                          ),
                                          Text(
                                            'Jonathan Swift',
                                            style: AppTextStyle.boldBlackText
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
                                            _postController.selectedPeopleIndex
                                                .removeAt(index);
                                          },
                                          child: Icon(
                                            Icons.cancel_sharp,
                                            size: 20,
                                            color: hintGrey,
                                          ),
                                        ))
                                  ],
                                ),
                              );
                            }),
                      )
                    : Container()),
                Padding(
                  padding:
                      EdgeInsets.only(top: 24 * SizeConfig.heightMultiplier!),
                  child: TitleText(title: 'suggestions'.tr),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Obx(() => PeopleTile(
                            name: 'Jonathan Swift',
                            subtitle: 'Nutrition Consultant',
                            onTap: (value) {
                              _postController.lastSelectedPersonIndex.value =
                                  int.tryParse(notification[index].title)!;

                              _postController.getSelectedPeople(_postController
                                  .lastSelectedPersonIndex.value);
                            },
                            value: _postController.selectedPeopleIndex.indexOf(
                                        int.tryParse(
                                            notification[index].title)!) ==
                                    -1
                                ? false
                                : true,
                          ));
                    })
              ],
            ),
          ),
        )),
      ),
    );
  }
}

class PeopleTile extends StatelessWidget {
  const PeopleTile({
    Key? key,
    required this.name,
    required this.subtitle,
    required this.value,
    required this.onTap,
  }) : super(key: key);

  final String name;
  final String subtitle;
  final bool value;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12 * SizeConfig.heightMultiplier!),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16 * SizeConfig.widthMultiplier!,
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
