import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/universal_widgets/capitalizeText.dart';
import 'package:flutter/material.dart';

class CallBackField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final TextInputType inputType;
  final int minLines;
  const CallBackField(
      {Key? key,
      required this.hintText,
      required this.controller,
      required this.validator,
      required this.inputType,
      required this.minLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: 16 * SizeConfig.widthMultiplier!,
          vertical: 12 * SizeConfig.heightMultiplier!),
      // decoration: BoxDecoration(
      //   color: Theme.of(context).textTheme.headline4?.color,
      //   borderRadius:
      //       BorderRadius.circular(8 * SizeConfig.widthMultiplier!),
      // ),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        controller: controller,
        onChanged: (value) async {
          if (value.isNotEmpty) {
            WidgetsBinding.instance!.addPostFrameCallback((_) async {});
          } else {
            WidgetsBinding.instance!.addPostFrameCallback((_) {});
          }
          //_homeController.searchUsersData.value = users.response!.data!;
        },
        validator: validator,
        style: AppTextStyle.normalGreenText
            .copyWith(color: Theme.of(context).textTheme.bodyText1?.color),
        decoration: InputDecoration(
          fillColor: Theme.of(context).textTheme.headline4?.color,
          filled: true,
          isDense: true,
          contentPadding: EdgeInsets.fromLTRB(
            10 * SizeConfig.heightMultiplier!,
            10 * SizeConfig.heightMultiplier!,
            10 * SizeConfig.heightMultiplier!,
            10 * SizeConfig.heightMultiplier!,
          ),
          // prefixIcon: Transform(
          //   transform: Matrix4.translationValues(
          //       0, 2, 0),
          //   child: Icon(
          //     Icons.search,
          //     color: hintGrey,
          //   ),
          // ),
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(8 * SizeConfig.widthMultiplier!),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(8 * SizeConfig.widthMultiplier!),
          ),
          hintText: hintText,
          hintStyle: AppTextStyle.smallGreyText.copyWith(
              fontSize: 14 * SizeConfig.textMultiplier!, color: hintGrey),
        ),
        minLines: minLines,
        maxLines: minLines,
      ),
    );
  }
}
