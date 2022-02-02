import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/universal_widgets/back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              ImagePath.backIcon,
              width: 7 * SizeConfig.widthMultiplier!,
              height: 12 * SizeConfig.heightMultiplier!,
            )),
        title: Transform(
          transform: Matrix4.translationValues(
              -20 * SizeConfig.widthMultiplier!, 0, 0),
          child: Text(titleOfModule,
              style: AppTextStyle.titleText
                  .copyWith(fontSize: 16 * SizeConfig.textMultiplier!)),
        ),
      ),
    );
  }
}
