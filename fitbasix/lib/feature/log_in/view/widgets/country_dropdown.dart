import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/feature/log_in/model/countries_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget CountryDropDown(
    {required List<Datum> listofItems,
    required Function onChanged,
    Datum? hint}) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Container(
      width: 70,
      child: DropdownButton(
          isDense: true,
          isExpanded: true,
          elevation: 0,
          hint: hint!.flag == null
              ? SvgPicture.network(
                  'https://purecatamphetamine.github.io/country-flag-icons/3x2/DZ.svg')
              : SvgPicture.network(hint.flag!),
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
                      // SizedBox(
                      //   width: 16 * SizeConfig.widthMultiplier!,
                      // ),
                      // Text(value.phoneCode!),
                    ],
                  ),
                ));
          }).toList(),
          onChanged: (value) {
            onChanged(value);
          }),
    ),
  );
}
