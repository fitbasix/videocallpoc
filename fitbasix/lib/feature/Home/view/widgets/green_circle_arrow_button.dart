import 'dart:math';

import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GreenCircleArrowButton extends StatelessWidget {
  const GreenCircleArrowButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40 * SizeConfig.heightMultiplier!,
        width: 40 * SizeConfig.heightMultiplier!,
        margin: EdgeInsets.only(right: 16 * SizeConfig.widthMultiplier!),
        decoration: BoxDecoration(shape: BoxShape.circle, color: kGreenColor),
        child: Transform.rotate(
          angle: -pi,
          child: SvgPicture.asset(
            ImagePath.backIcon,
            color: kPureWhite,
            height: 15,
            width: 7,
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
    );
  }
}
