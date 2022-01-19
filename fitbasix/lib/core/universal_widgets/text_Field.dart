import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:flutter/material.dart';

class CutomizedTextField extends StatelessWidget {
  final Color color;
  final Widget child;
  CutomizedTextField({required this.color, required this.child});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 56,
      width: size.width,
      decoration: BoxDecoration(
        border: Border.all(color: color),
        color: lightGrey,
        borderRadius: BorderRadius.circular(8 * SizeConfig.widthMultiplier!),
      ),
      child: Center(child: child),
    );
  }
}

Widget TextFieldContainer(
    {required TextEditingController textEditingController,
    required Function onChanged,
    required bool isNumber,
    bool? isObsecure,
    bool? readOnly,
    bool? isNotCapital,
    bool? isTextFieldActive,
    String? hint,
    Widget? preFixWidget,
    Widget? suffixWidget}) {
  return Container(
    child: TextField(
      controller: textEditingController,
      onChanged: (value) {
        onChanged(value);
      },
      readOnly: readOnly == null ? false : true,
      keyboardType:
          isNumber ? TextInputType.number : TextInputType.streetAddress,
      style: AppTextStyle.hintText.copyWith(color: lightBlack),
      textAlignVertical: TextAlignVertical.bottom,
      obscureText: isObsecure == null ? false : isObsecure,
      decoration: InputDecoration(
          isDense: true,
          counter: Container(
            height: 0,
          ),
          contentPadding: EdgeInsets.only(
              bottom: 10, left: 39 * SizeConfig.widthMultiplier!),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: InputBorder.none,
          hintText: hint,
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.all(
          //       Radius.circular(8 * SizeConfig.heightMultiplier!)),
          //   borderSide: BorderSide(
          //       color:
          //           isTextFieldActive == null ? kGreenColor : kGreyLightShade,
          //       width: 1.0),
          // ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(
                left: 18.0 * SizeConfig.widthMultiplier!,
                right: 15.2 * SizeConfig.widthMultiplier!),
            child: preFixWidget,
          ),
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: 18.0 * SizeConfig.widthMultiplier!),
            child: suffixWidget,
          ),
          hintStyle: AppTextStyle.hintText),
    ),
  );
}
