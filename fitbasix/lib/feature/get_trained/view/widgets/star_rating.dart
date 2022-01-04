import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:flutter/material.dart';

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
    Icon icon;
    if (index >= rating) {
      icon = new Icon(
        Icons.star_border,
        size: 16,
        color: Theme.of(context).buttonColor,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = new Icon(
        Icons.star_half,
        size: 16,
        color: color ?? kGreenColor,
      );
    } else {
      icon = new Icon(
        Icons.star,
        size: 16,
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