import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RightTick extends StatelessWidget {
  final VoidCallback onTap;
  RightTick({required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
            top: 8*SizeConfig.heightMultiplier!, bottom: 8*SizeConfig.heightMultiplier!,
            right: 16*SizeConfig.widthMultiplier!),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0), color: kgreen4F),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 12 * SizeConfig.widthMultiplier!,
                vertical: 11 * SizeConfig.heightMultiplier!),
            child: SvgPicture.asset(
              ImagePath.rightTickIcon,
              color: kPureWhite,
              fit: BoxFit.contain,
              height: 13.4 * SizeConfig.heightMultiplier!,
              width: 17.6 * SizeConfig.widthMultiplier!,
            ),
          ),
        ),
      ),
    );
  }
}
