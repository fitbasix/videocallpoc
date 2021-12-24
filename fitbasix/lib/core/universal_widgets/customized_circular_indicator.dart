import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:flutter/material.dart';

class CustomizedCircularProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20 * SizeConfig.heightMultiplier!,
      width: 20 * SizeConfig.heightMultiplier!,
      child: FittedBox(
        fit: BoxFit.contain,
        child: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            kGreenColor,
          ),
          strokeWidth: 2,
        ),
      ),
    );
  }
}
