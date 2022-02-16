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
  AppbarforBMRScreen({this.title, this.parentContext, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: kPureWhite,
      elevation: 0,
      title: Row(
        children: [
          SizedBox(
            width: 7 * SizeConfig.widthMultiplier!,
          ),
          GestureDetector(
              onTap: () {
             //   Navigator.pop(parentContext!);
              },
              child: Container(
                  color: Colors.transparent,
                  child: SvgPicture.asset(
                    ImagePath.backIcon,
                    width: 7.41 * SizeConfig.widthMultiplier!,
                    height: 12 * SizeConfig.heightMultiplier!,
                    fit: BoxFit.contain,
                  ))),
          SizedBox(
            width: 20.59 * SizeConfig.widthMultiplier!,
          ),
          Text(
            title!,
            style: AppTextStyle.NormalBlackTitleText,
          ),
        ],
      ),
      actions: [
        IconButton(
            onPressed: (){},
            icon: SvgPicture.asset(
              ImagePath.circlequestionmarkIcon,
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
