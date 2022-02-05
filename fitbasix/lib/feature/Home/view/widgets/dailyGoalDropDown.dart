import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fitbasix/feature/log_in/model/countries_model.dart';
import 'package:get/get.dart';

Widget DailyGoalDropDown(
    {required List<double> listofItems,
    required Function onChanged,
    double? hint}) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Container(
      child: DropdownButton(
          isDense: true,
          isExpanded: true,
          elevation: 0,
          icon: Padding(
            padding:  EdgeInsets.only(right:16 * SizeConfig.widthMultiplier!),
            child: Icon(
              Icons.arrow_drop_down
            ),
          ),
          hint:Padding(
            padding: EdgeInsets.only(
                                        left:
                                            10 * SizeConfig.widthMultiplier!),
            child: hint == null
              ? Row(
                children: [
                  Text("3",
                  style: AppTextStyle.normalBlackText),
                  SizedBox(width: 4,),
                   Text('ltr'.tr,style: AppTextStyle.normalBlackText.copyWith(
                     color: grey183
                   ),),
                ],
              )
              : Row(
                children: [
                  Text(hint.toString(),style: AppTextStyle.normalBlackText),
              SizedBox(width: 4,),
                   Text('ltr'.tr,style: AppTextStyle.normalBlackText.copyWith(
                     color: grey183
                   )),
                ],
              )),
          underline: Container(),
          items: listofItems.map((double value) {
            return DropdownMenuItem<double>(
                value: value,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal:16.0*SizeConfig.widthMultiplier!,vertical: 16*SizeConfig.widthMultiplier!),
                    child: Padding(
                      padding:  EdgeInsets.only(right: 10*SizeConfig.widthMultiplier!),
                      child: Text(
                        value.toString()+"ltr",
                        style: AppTextStyle.boldBlackText.copyWith(
                          fontSize: 14*SizeConfig.textMultiplier!
                        ),
                      ),
                    ),
                  ),
                ));
          }).toList(),
          onChanged: (value) {
            onChanged(value);
          }),
    ),
  );
}
