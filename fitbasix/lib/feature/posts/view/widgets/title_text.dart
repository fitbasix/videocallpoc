import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  const TitleText({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyle.boldBlackText
          .copyWith(fontSize: 14 * SizeConfig.textMultiplier!),
    );
  }
}
