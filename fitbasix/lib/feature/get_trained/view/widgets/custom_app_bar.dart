import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/universal_widgets/back_button.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String titleOfModule;
  CustomAppBar({
    required this.titleOfModule,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPureWhite,
        centerTitle: false,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(titleOfModule,
            style: AppTextStyle.titleText
                .copyWith(fontSize: 16 * SizeConfig.textMultiplier!)),
      ),
    );
  }
}
