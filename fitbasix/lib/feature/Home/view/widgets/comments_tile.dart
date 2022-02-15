import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:readmore/readmore.dart';

class CommentsTile extends StatelessWidget {
  CommentsTile({
    Key? key,
    required this.name,
    required this.comment,
    required this.time,
    required this.likes,
    required this.profilePhoto,
    required this.onReply,
    required this.onLikeComment,
    this.replyCount,
    required this.minWidth,
  }) : super(key: key);

  final String name;
  final String comment;
  final String time;
  int likes;
  final String profilePhoto;
  final VoidCallback onReply;
  final VoidCallback onLikeComment;
  final int? replyCount;
  final double minWidth;

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
            backgroundImage: CachedNetworkImageProvider(profilePhoto),
          ),
          SizedBox(
            width: 8 * SizeConfig.widthMultiplier!,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // height: 84 * SizeConfig.heightMultiplier!,
                // width: Get.width - 80 * SizeConfig.widthMultiplier!,
                constraints:
                    BoxConstraints(minWidth: minWidth, maxWidth: Get.width),

                padding: EdgeInsets.only(
                    top: 12 * SizeConfig.heightMultiplier!,
                    left: 12 * SizeConfig.widthMultiplier!,
                    right: 12 * SizeConfig.widthMultiplier!,
                    bottom: 16 * SizeConfig.heightMultiplier!),
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
                    ReadMoreText(
                      comment,
                      trimLines: 2,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'see_more'.tr,
                      trimExpandedText: 'see_less'.tr,
                      colorClickableText: hintGrey,
                      style: AppTextStyle.normalBlackText
                          .copyWith(fontSize: 14 * SizeConfig.textMultiplier!),
                    )
                    // Text(
                    //   comment,
                    //   style: AppTextStyle.normalBlackText
                    //       .copyWith(fontSize: 14 * SizeConfig.textMultiplier!),
                    // )
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
                    Text(time,
                        style: AppTextStyle.normalBlackText.copyWith(
                            fontSize: 12 * SizeConfig.textMultiplier!,
                            color: kGreyColor)),
                    SizedBox(
                      width: 13 * SizeConfig.widthMultiplier!,
                    ),
                    InkWell(
                      onTap: onLikeComment,
                      child: Icon(
                        Icons.favorite,
                        color: kGreyColor,
                        size: 14,
                      ),
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
