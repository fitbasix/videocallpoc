import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_palette.dart';
import '../../../core/constants/image_path.dart';
import '../../../core/reponsive/SizeConfig.dart';
import '../../../core/universal_widgets/customized_circular_indicator.dart';

void deActiveAccount(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Container(
        color: kBlack.withOpacity(0.6),
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: AlertDialog(
                insetPadding: EdgeInsets.zero,
                titlePadding: EdgeInsets.zero,
                actionsPadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.symmetric(
                    vertical: 0 * SizeConfig.heightMultiplier!),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8 * SizeConfig.imageSizeMultiplier!)),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Container(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 5 * SizeConfig.widthMultiplier!),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.close,
                                  size: 26 * SizeConfig.heightMultiplier!,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15 * SizeConfig.widthMultiplier!),
                          child: Text(
                            "deactive_account_heading".tr,
                            style: AppTextStyle.black600Text.copyWith(
                                color: kRed,
                                fontSize: 18 * SizeConfig.textMultiplier!),
                          ),
                        ),
                        SizedBox(
                          height: 24 * SizeConfig.heightMultiplier!,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15 * SizeConfig.widthMultiplier!),
                          child: Text(
                            "deactive_account_subheading".tr,
                            style: AppTextStyle.black400Text.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color),
                          ),
                        ),
                        SizedBox(
                          height: 32 * SizeConfig.heightMultiplier!,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      );
    },
  );
}
