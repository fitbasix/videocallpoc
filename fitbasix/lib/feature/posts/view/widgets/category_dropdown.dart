import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/feature/posts/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

Widget CategoryDropDown(
    {required List<Category> listofItems,
    required Function onChanged,
    Category? hint}) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Container(
      // width: 140 * SizeConfig.widthMultiplier!,
      decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: hint!.name == null ? hintGrey : lightBlack,
          ),
          borderRadius:
              BorderRadius.circular(8 * SizeConfig.heightMultiplier!)),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 12 * SizeConfig.widthMultiplier!,
            vertical: 8 * SizeConfig.heightMultiplier!),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            hint.name == null
                ? Icon(
                    Icons.add,
                    size: 15 * SizeConfig.textMultiplier!,
                    color: hintGrey,
                  )
                : Container(),
            hint.name == null
                ? SizedBox(
                    width: 10.5 * SizeConfig.widthMultiplier!,
                  )
                : Container(),
            Container(
              width: 100 * SizeConfig.widthMultiplier!,
              child: DropdownButton2(
                  dropdownWidth: 140 * SizeConfig.widthMultiplier!,
                  iconSize: 0.0,
                  isDense: true,
                  isExpanded: true,
                  // dropdownPadding: EdgeInsets.only(top: 10),
                  dropdownDecoration: BoxDecoration(
                      color: kPureWhite,
                      borderRadius: BorderRadius.circular(8)),
                  offset:
                      hint.name == null ? Offset(-42, -12) : Offset(-16, -12),
                  // elevation: 0,

                  hint: hint.name == null
                      ? Text(
                          'add_category'.tr,
                          style: AppTextStyle.smallGreyText
                              .copyWith(color: hintGrey),
                        )
                      : Text(
                          hint.name.toString(),
                          style: AppTextStyle.smallGreyText
                              .copyWith(color: lightBlack),
                        ),
                  underline: Container(),
                  items: listofItems.map((Category value) {
                    return DropdownMenuItem<Category>(
                        value: value,
                        child: Container(
                          // width: 30,
                          // height: 20,
                          child: Text(value.name!),
                        ));
                  }).toList(),
                  onChanged: (value) {
                    onChanged(value);
                  }),
            ),
          ],
        ),
      ),
    ),
  );
}
