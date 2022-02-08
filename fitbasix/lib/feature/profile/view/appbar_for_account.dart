import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_palette.dart';
import '../../../core/constants/image_path.dart';
import '../../../core/reponsive/SizeConfig.dart';

class AppBarForAccount extends StatelessWidget with PreferredSizeWidget{
  String? title;
  BuildContext? parentContext;
  AppBarForAccount({Key? key,this.title,this.parentContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: kPureWhite,
      elevation: 0,
      title: Row(
        children: [
          SizedBox(width: 7*SizeConfig.widthMultiplier!,),
          GestureDetector(
              onTap: (){
                Navigator.pop(parentContext!);
              },
              child: SvgPicture.asset(ImagePath.backIcon,width: 7.41*SizeConfig.widthMultiplier!,height: 12*SizeConfig.heightMultiplier!,fit: BoxFit.contain,)),
          SizedBox(width: 16.59*SizeConfig.widthMultiplier!,),
          Text(title!,style: AppTextStyle.NormalBlackTitleText,),
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

}
