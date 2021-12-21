import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:flutter/material.dart';

class ProceedButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  ProceedButton({Key? key, required this.title, required this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size.width,
        height: 45 * SizeConfig.heightMultiplier!,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8 * SizeConfig.heightMultiplier!),
          color: kGreenColor,
        ),
        child: Center(
          child: Text(
            title,
            style: AppTextStyle.normalWhiteText,
          ),
        ),
      ),
    );
    ;
  }
}
