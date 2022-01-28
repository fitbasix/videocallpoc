import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/feature/Home/view/widgets/comments_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class PostTile extends StatelessWidget {
  const PostTile({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.date,
    required this.place,
    required this.caption,
    required this.likes,
    required this.hitLike,
    required this.comments,
    required this.profilePhoto,
  }) : super(key: key);
  final String name;
  final String profilePhoto;
  final String imageUrl;
  final String category;
  final String date;
  final String place;
  final String caption;
  final String likes;
  final VoidCallback hitLike;
  final String comments;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: 16 * SizeConfig.widthMultiplier!,
                bottom: 16 * SizeConfig.heightMultiplier!,
                top: 16 * SizeConfig.heightMultiplier!),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20 * SizeConfig.widthMultiplier!,
                  backgroundImage: CachedNetworkImageProvider(profilePhoto),
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
                    Row(
                      children: [
                        Text(category,
                            style: AppTextStyle.normalBlackText.copyWith(
                                fontSize: 12 * SizeConfig.textMultiplier!,
                                color: kGreyColor)),
                        SizedBox(
                          width: 13 * SizeConfig.widthMultiplier!,
                        ),
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: kGreyColor,
                        ),
                        SizedBox(
                          width: 5 * SizeConfig.widthMultiplier!,
                        ),
                        Text(date,
                            style: AppTextStyle.normalBlackText.copyWith(
                                fontSize: 12 * SizeConfig.textMultiplier!,
                                color: kGreyColor)),
                        SizedBox(
                          width: 14 * SizeConfig.widthMultiplier!,
                        ),
                        Icon(
                          Icons.place,
                          size: 16,
                          color: kGreyColor,
                        ),
                        SizedBox(
                          width: 6.5 * SizeConfig.widthMultiplier!,
                        ),
                        Text(place,
                            style: AppTextStyle.normalBlackText.copyWith(
                                fontSize: 12 * SizeConfig.textMultiplier!,
                                color: kGreyColor))
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 16 * SizeConfig.widthMultiplier!,
                bottom: 16 * SizeConfig.heightMultiplier!,
                right: 16 * SizeConfig.widthMultiplier!),
            child: Text(
              caption,
              style: AppTextStyle.NormalText.copyWith(
                  fontSize: 14 * SizeConfig.textMultiplier!),
            ),
          ),
          CachedNetworkImage(
            imageUrl: imageUrl,
            height: 198 * SizeConfig.heightMultiplier!,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 16 * SizeConfig.widthMultiplier!,
                bottom: 16 * SizeConfig.heightMultiplier!,
                right: 16 * SizeConfig.widthMultiplier!,
                top: 16 * SizeConfig.heightMultiplier!),
            child: Row(
              children: [
                InkWell(
                  onTap: hitLike,
                  child: Icon(
                    Icons.favorite,
                    color: kRedColor,
                  ),
                ),
                SizedBox(
                  width: 5 * SizeConfig.widthMultiplier!,
                ),
                Text(
                  'likes'.trParams({'no_likes': likes}),
                  style: AppTextStyle.boldBlackText
                      .copyWith(fontSize: 12 * SizeConfig.textMultiplier!),
                ),
                SizedBox(
                  width: 18 * SizeConfig.widthMultiplier!,
                ),
                Text(
                  'comments'.trParams({'no_comments': comments}),
                  style: AppTextStyle.boldBlackText
                      .copyWith(fontSize: 12 * SizeConfig.textMultiplier!),
                )
              ],
            ),
          ),
          CommentsTile(
            name: 'Percy Bysshe Shelley',
            comment: 'Thank you for the motivational thoughts!',
            time: '26',
            likes: 214,
            onReply: () {},
          ),
          SizedBox(
            height: 16 * SizeConfig.heightMultiplier!,
          )
        ],
      ),
    );
  }
}
