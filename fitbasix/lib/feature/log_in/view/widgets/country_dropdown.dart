import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fitbasix/feature/log_in/model/countries_model.dart';

Widget CountryDropDown(
    {required List<CountryData> listofItems,
    required Function onChanged,
    CountryData? hint}) {
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
                  'https://upload.wikimedia.org/wikipedia/en/4/41/Flag_of_India.svg',
                  height: 20,
                  width: 30,
                  fit: BoxFit.cover,
                )
              : SvgPicture.network(
                  hint.flag!,
                  height: 20,
                  width: 30,
                  fit: BoxFit.fitWidth,
                ),
          underline: Container(),
          items: listofItems.map((CountryData value) {
            return DropdownMenuItem<CountryData>(
                value: value,
                child: Container(
                  width: 30,
                  height: 20,
                  child: SvgPicture.network(
                    value.flag!,
                    fit: BoxFit.cover,
                  ),
                ));
          }).toList(),
          onChanged: (value) {
            onChanged(value);
          }),
    ),
  );
}
