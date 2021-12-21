import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/feature/log_in/model/countries_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget CountryDropDown({
  required List<Datum> listofItems,
}) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Container(
      width: 150,
      child: DropdownButton(
          isDense: true,
          isExpanded: true,
          elevation: 0,
          underline: Container(),
          items: listofItems.map((Datum value) {
            return DropdownMenuItem<Datum>(
                value: value,
                child: Container(
                  child: Row(
                    children: [
                      SvgPicture.network(
                        value.flag!,
                        width: 20,
                        height: 20,
                      ),
                      SizedBox(
                        width: 16 * SizeConfig.widthMultiplier!,
                      ),
                      Text(value.nameEn!),
                    ],
                  ),
                ));
          }).toList(),
          onChanged: (value) {}),
    ),
  );
}
