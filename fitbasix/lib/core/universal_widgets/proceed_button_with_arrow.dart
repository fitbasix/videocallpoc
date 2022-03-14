import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProceedButtonWithArrow extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  ProceedButtonWithArrow(
      {Key? key, required this.title, required this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size.width,
        height: 48 * SizeConfig.heightMultiplier!,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8 * SizeConfig.heightMultiplier!),
          color: kgreen49,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: AppTextStyle.normalWhiteText,
              ),
              SizedBox(width: 8 * SizeConfig.widthMultiplier!),
              SvgPicture.asset(ImagePath.arrowRightIcon)
            ],
          ),
        ),
      ),
    );
    ;
  }
}
