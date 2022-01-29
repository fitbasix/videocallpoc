import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentsTile extends StatelessWidget {
  const CommentsTile({
    Key? key,
    required this.name,
    required this.comment,
    required this.time,
    required this.likes,
    required this.onReply,
  }) : super(key: key);

  final String name;
  final String comment;
  final String time;
  final int likes;
  final VoidCallback onReply;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 16 * SizeConfig.widthMultiplier!,
          right: 16 * SizeConfig.widthMultiplier!),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
          ),
          SizedBox(
            width: 8 * SizeConfig.widthMultiplier!,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 84 * SizeConfig.heightMultiplier!,
                width: Get.width - 80 * SizeConfig.widthMultiplier!,
                padding: EdgeInsets.only(
                    top: 12 * SizeConfig.heightMultiplier!,
                    left: 12 * SizeConfig.widthMultiplier!,
                    right: 12 * SizeConfig.widthMultiplier!),
                decoration: BoxDecoration(
                    color: kLightGrey,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextStyle.boldBlackText
                          .copyWith(fontSize: 12 * SizeConfig.textMultiplier!),
                    ),
                    SizedBox(
                      height: 8 * SizeConfig.heightMultiplier!,
                    ),
                    Text(
                      comment,
                      style: AppTextStyle.normalBlackText
                          .copyWith(fontSize: 14 * SizeConfig.textMultiplier!),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 8 * SizeConfig.heightMultiplier!,
              ),
              Padding(
                padding: EdgeInsets.only(left: 4 * SizeConfig.widthMultiplier!),
                child: Row(
                  children: [
                    Text('post_time'.trParams({'duration': time}),
                        style: AppTextStyle.normalBlackText.copyWith(
                            fontSize: 12 * SizeConfig.textMultiplier!,
                            color: kGreyColor)),
                    SizedBox(
                      width: 13 * SizeConfig.widthMultiplier!,
                    ),
                    Icon(
                      Icons.favorite,
                      color: kGreyColor,
                      size: 14,
                    ),
                    SizedBox(
                      width: 5 * SizeConfig.widthMultiplier!,
                    ),
                    Text('likes'.trParams({'no_likes': likes.toString()}),
                        style: AppTextStyle.normalBlackText.copyWith(
                            fontSize: 12 * SizeConfig.textMultiplier!,
                            color: kGreyColor)),
                    SizedBox(
                      width: 13 * SizeConfig.widthMultiplier!,
                    ),
                    Icon(
                      Icons.reply,
                      color: kGreyColor,
                      size: 18,
                    ),
                    SizedBox(
                      width: 4 * SizeConfig.widthMultiplier!,
                    ),
                    GestureDetector(
                      onTap: onReply,
                      child: Text('reply'.tr,
                          style: AppTextStyle.normalBlackText.copyWith(
                              fontSize: 12 * SizeConfig.textMultiplier!,
                              color: kGreyColor)),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
