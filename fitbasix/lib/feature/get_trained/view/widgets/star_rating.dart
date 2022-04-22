import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:flutter/material.dart';

import '../../../../core/reponsive/SizeConfig.dart';

typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback? onRatingChanged;
  final Color? color;
  final bool? axisAlignmentFromStart;

  StarRating(
      {this.starCount = 5, this.rating = .0, this.onRatingChanged, this.color,this.axisAlignmentFromStart});

  Widget buildStar(BuildContext context, int index) {
    Image icon;
    if (index >= rating) {
      icon = new Image.asset(
        ImagePath.starrating_no,
        width: 16 * SizeConfig.widthMultiplier!,
        height: 16 * SizeConfig.heightMultiplier!,
        // Icons.star_border,
        // size: 16,
        color: Theme.of(context).buttonColor,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = new Image.asset(
      ImagePath.starrating_half,
        width: 16 * SizeConfig.widthMultiplier!,
        height: 16 * SizeConfig.heightMultiplier!,
     //   size: 16,
        color: color ?? kGreenColor,
      );
    } else {
      icon = new Image.asset(
        ImagePath.starrating_full,
        width: 16 * SizeConfig.widthMultiplier!,
        height: 16 * SizeConfig.heightMultiplier!,
        //size: 16,
        color: color ?? kGreenColor,
      );
    }
    return new InkResponse(
      onTap:
          onRatingChanged == null ? null : () => onRatingChanged!(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
       mainAxisAlignment: axisAlignmentFromStart==null? MainAxisAlignment.center:MainAxisAlignment.start,
        children:
            new List.generate(starCount, (index) => buildStar(context, index)));
  }
}
