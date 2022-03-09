import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_palette.dart';
import '../../../core/constants/image_path.dart';
import '../../../core/reponsive/SizeConfig.dart';

class AppBarForAccount extends StatelessWidget with PreferredSizeWidget {
  String? title;
  VoidCallback onback;
  AppBarForAccount({Key? key, this.title, required this.onback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      elevation: 0,
      leading: IconButton(
        onPressed: onback,
        icon: Container(
            color: Colors.transparent,
            child: SvgPicture.asset(
              ImagePath.backIcon,
              color: Theme.of(context).textTheme.bodyText1?.color,
              width: 7.41 * SizeConfig.widthMultiplier!,
              height: 12 * SizeConfig.heightMultiplier!,
              color: Theme.of(context).primaryColor,
              fit: BoxFit.contain,
            )),
      ),
      title: Text(
        title!,
        style: AppTextStyle.NormalBlackTitleText.copyWith(
          color: Theme.of(context).appBarTheme.titleTextStyle?.color
        ),

    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
