import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CutomizedTextField extends StatelessWidget {
  final Color color;
  final Widget child;
  bool? wantWhiteBG;

  CutomizedTextField(
      {required this.color, required this.child, this.wantWhiteBG});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 56,
      width: size.width,
      decoration: BoxDecoration(
        border: Border.all(color: color),
        color: wantWhiteBG != null ? Colors.white : lightGrey,
        borderRadius: BorderRadius.circular(8 * SizeConfig.widthMultiplier!),
      ),
      child: Center(child: child),
    );
  }
}

Widget TextFieldContainer(
    {required TextEditingController textEditingController,
    required Function onChanged,
    List<TextInputFormatter>? inputFormatters,
    required bool isNumber,
    bool? isObsecure,
    bool? readOnly,
    bool? isNotCapital,
    bool? isTextFieldActive,
    String? hint,
    int? maxLength,
    Widget? preFixWidget,
    Widget? suffixWidget}) {
  return Container(
    child: TextField(
      inputFormatters: inputFormatters != null ? inputFormatters : null,
      controller: textEditingController,
      onChanged: (value) {
        onChanged(value);
      },
      readOnly: readOnly == null ? false : true,
      keyboardType:
          isNumber ? TextInputType.number : TextInputType.streetAddress,
      style: AppTextStyle.hintText.copyWith(color: lightBlack),
      textAlignVertical: TextAlignVertical.bottom,
      maxLength: maxLength == null ? 300 : maxLength,
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
