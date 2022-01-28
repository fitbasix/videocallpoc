import 'package:flutter/material.dart';

import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';

class HomeTile extends StatelessWidget {
  const HomeTile({
    Key? key,
    required this.color,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  final Color color;
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70 * SizeConfig.heightMultiplier!,
        width: 104 * SizeConfig.widthMultiplier!,
        padding: EdgeInsets.only(left: 12 * SizeConfig.widthMultiplier!),
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20 * SizeConfig.heightMultiplier!,
            ),
            Icon(
              icon,
              size: 20,
              color: kPureWhite,
            ),
            Text(
              title,
              style: AppTextStyle.boldBlackText.copyWith(
                  color: kPureWhite, fontSize: 14 * SizeConfig.textMultiplier!),
            )
          ],
        ),
      ),
    );
  }
}
