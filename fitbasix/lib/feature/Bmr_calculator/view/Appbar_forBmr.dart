import 'package:fitbasix/feature/Bmr_calculator/view/dialogboxforbmr.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_palette.dart';
import '../../../core/constants/image_path.dart';
import '../../../core/reponsive/SizeConfig.dart';

class AppbarforBMRScreen extends StatelessWidget with PreferredSizeWidget {
  String? title;
  BuildContext? parentContext;
  VoidCallback? onRoute;
  AppbarforBMRScreen({this.onRoute, this.title, this.parentContext, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      leading: IconButton(
        onPressed: onRoute,
        icon: SvgPicture.asset(
          ImagePath.backIcon,
          color: Theme.of(context).primaryColor,
          width: 7.41 * SizeConfig.widthMultiplier!,
          height: 12 * SizeConfig.heightMultiplier!,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(
        title!,
        style: AppTextStyle.NormalBlackTitleText.copyWith(
          color: Theme.of(context).textTheme.bodyText1?.color
        ),
      ),
      actions: [
        IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => BMRDialog());
            },
            icon: SvgPicture.asset(
              ImagePath.circlequestionmarkIcon,
              color: Theme.of(context).primaryColor,
              width: 20 * SizeConfig.widthMultiplier!,
              height: 20 * SizeConfig.heightMultiplier!,
            )),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
