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
    required this.rating,
  }) : super(key: key);

  final String name;
  final String certificateCount;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250 * SizeConfig.heightMultiplier!,
      width: 164 * SizeConfig.widthMultiplier!,
      margin: EdgeInsets.only(
        right: 8 * SizeConfig.widthMultiplier!,
      ),
      padding: EdgeInsets.symmetric(
          vertical: 24 * SizeConfig.heightMultiplier!,
          horizontal: 12 * SizeConfig.widthMultiplier!),
      decoration: BoxDecoration(
          color: kPureWhite,
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
        children: [
          CircleAvatar(
            radius: 40 * SizeConfig.heightMultiplier!,
            backgroundImage: NetworkImage(
                'https://upload.wikimedia.org/wikipedia/commons/9/94/Robert_Downey_Jr_2014_Comic_Con_%28cropped%29.jpg'),
          ),
          SizedBox(
            height: 8 * SizeConfig.heightMultiplier!,
          ),
          Text(
            name,
            style: AppTextStyle.titleText
                .copyWith(fontSize: 14 * SizeConfig.textMultiplier!),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Sports Nutrition +3',
                style: AppTextStyle.NormalText.copyWith(
                    fontSize: 10 * SizeConfig.textMultiplier!),
              ),
              SizedBox(
                width: 8 * SizeConfig.widthMultiplier!,
              ),
              Text(
                '|',
                style: TextStyle(color: kLightGrey),
              ),
              SizedBox(
                width: 8 * SizeConfig.widthMultiplier!,
              ),
              SvgPicture.asset(ImagePath.certificateIcon),
              SizedBox(
                width: 2 * SizeConfig.widthMultiplier!,
              ),
              Text(
                certificateCount,
                style: AppTextStyle.titleText
                    .copyWith(fontSize: 10 * SizeConfig.textMultiplier!),
              ),
            ],
          ),
          SizedBox(
            height: 8 * SizeConfig.heightMultiplier!,
          ),
          Text(
            'Hi, This is Coach Name. I am certified by Institute ...',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.NormalText.copyWith(
                fontSize: 10 * SizeConfig.textMultiplier!, color: kGreyText),
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
            '(234)',
            style: AppTextStyle.NormalText.copyWith(
                fontSize: 10, color: kGreyText),
          ),
        ],
      ),
    );
  }
}
