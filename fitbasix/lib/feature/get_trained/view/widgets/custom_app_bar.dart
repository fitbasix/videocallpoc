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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: false,
        elevation: 0,
        automaticallyImplyLeading: false,
       // iconTheme: Theme.of(context).appBarTheme.iconTheme,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              ImagePath.backIcon,
              color: Theme.of(context).primaryColor,
              width: 7 * SizeConfig.widthMultiplier!,
              height: 12 * SizeConfig.heightMultiplier!,
             // theme: SvgTheme(currentColor: Theme.of(context).primaryIconTheme.color),
            )),
        title: Transform(
          transform: Matrix4.translationValues(
              -20 * SizeConfig.widthMultiplier!, 0, 0),
          child: Text(titleOfModule,
              style: AppTextStyle.titleText
                  .copyWith(
                  color: Theme.of(context).appBarTheme.titleTextStyle?.color,
                  fontSize: 16 * SizeConfig.textMultiplier!)),
        ),
      ),
    );
  }
}
