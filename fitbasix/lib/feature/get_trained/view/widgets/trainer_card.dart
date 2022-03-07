import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/feature/get_trained/view/widgets/star_rating.dart';

class TrainerCard extends StatelessWidget {
  const TrainerCard({
    Key? key,
    required this.name,
    required this.certificateCount,
    required this.profilePhoto,
    required this.strength,
    required this.strengthLength,
    required this.about,
    required this.raters,
    required this.rating,
    required this.onTap,
  }) : super(key: key);

  final String name;
  final int certificateCount;
  final String profilePhoto;
  final String strength;
  final int strengthLength;
  final String about;
  final String raters;
  final double rating;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // height: 242 * SizeConfig.heightMultiplier!,
        width: 164 * SizeConfig.widthMultiplier!,
        margin: EdgeInsets.only(
          right: 8 * SizeConfig.widthMultiplier!,
        ),
        padding: EdgeInsets.symmetric(
            vertical: 24 * SizeConfig.heightMultiplier!,
            horizontal: 12 * SizeConfig.widthMultiplier!),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: -5,
                  offset: Offset(0, 2))
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40 * SizeConfig.heightMultiplier!,
              backgroundImage: NetworkImage(profilePhoto),
            ),
            SizedBox(
              height: 8 * SizeConfig.heightMultiplier!,
            ),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.titleText
                  .copyWith(
                  color: Theme.of(context).textTheme.bodyText1?.color,
                  fontSize: 14 * SizeConfig.textMultiplier!),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  strengthLength == 1
                      ? '$strength'
                      : '$strength + ${strengthLength - 1}',
                  style: AppTextStyle.NormalText.copyWith(
                    color: Theme.of(context).textTheme.bodyText1?.color,
                      fontSize: 10 * SizeConfig.textMultiplier!),
                ),
                SizedBox(
                  width: 8 * SizeConfig.widthMultiplier!,
                ),
                Text(
                  '|',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.headline1?.color
                  ),
                ),
                SizedBox(
                  width: 8 * SizeConfig.widthMultiplier!,
                ),
                SvgPicture.asset(ImagePath.certificateIcon),
                SizedBox(
                  width: 2 * SizeConfig.widthMultiplier!,
                ),
                Text(
                  '$certificateCount',
                  style: AppTextStyle.titleText
                      .copyWith(
                      color: Theme.of(context).textTheme.bodyText1?.color,
                      fontSize: 10 * SizeConfig.textMultiplier!),
                ),
              ],
            ),
            SizedBox(
              height: 8 * SizeConfig.heightMultiplier!,
            ),
            Text(
              about,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.NormalText.copyWith(
                  fontSize: 10 * SizeConfig.textMultiplier!,
                  color: Theme.of(context).textTheme.headline1?.color
              ),
            ),
            SizedBox(
              height: 8 * SizeConfig.heightMultiplier!,
            ),
            StarRating(
              rating: rating,
            ),
            SizedBox(
              height: 4 * SizeConfig.heightMultiplier!,
            ),
            Text(
              '($raters)',
              style: AppTextStyle.NormalText.copyWith(
                  fontSize: 10 * SizeConfig.textMultiplier!,
                  color: Theme.of(context).textTheme.headline1?.color
              ),
            ),
            SizedBox(
              height: 0 * SizeConfig.heightMultiplier!,
            ),
          ],
        ),
      ),
    );
  }
}
