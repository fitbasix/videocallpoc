import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/feature/Home/model/waterReminderModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fitbasix/feature/log_in/model/countries_model.dart';
import 'package:get/get.dart';

Widget ReminderDropDown(
    {required List<WaterReminder> listofItems,
    required Function onChanged,
    WaterReminder? hint}) {
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
                                            16 * SizeConfig.widthMultiplier!,
                                        right:
                                            10 * SizeConfig.widthMultiplier!),
            child: hint!.serialId == null
              ? Row(
                children: [
                  // Text("3",
                  // style: AppTextStyle.normalBlackText),
                  // SizedBox(width: 4,),
                   Text('select a duration'.tr,style: AppTextStyle.normalBlackText.copyWith(
                     color: grey183
                   ),),
                ],
              )
              : Row(
                children: [
                  Text(hint.optionString.toString().split(" ")[0],style: AppTextStyle.normalBlackText),
              SizedBox(width: 4,),
                   Text('hr'.tr,style: AppTextStyle.normalBlackText.copyWith(
                     color: grey183
                   ),),
                ],
              )),
          underline: Container(),
          items: listofItems.map((WaterReminder value) {
            return DropdownMenuItem<WaterReminder>(
                value: value,
                child: Container(
                  width: 160*SizeConfig.widthMultiplier!,
                
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal:16.0*SizeConfig.widthMultiplier!,vertical: 16*SizeConfig.widthMultiplier!),
                    child: Padding(
                      padding:  EdgeInsets.only(right: 10*SizeConfig.widthMultiplier!),
                      child: Text(
                        value.optionString!+" hr",
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
