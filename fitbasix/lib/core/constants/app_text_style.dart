import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  static TextStyle italicWelcomeText = GoogleFonts.openSans(
    fontSize: (16) * SizeConfig.textMultiplier!,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    color: dustyWhite,
  );
  static TextStyle normalWhiteText = GoogleFonts.openSans(
    fontSize: (16) * SizeConfig.textMultiplier!,
    fontWeight: FontWeight.w600,
    color: kPureWhite,
  );
  static TextStyle NormalText = GoogleFonts.openSans(
    fontSize: (16) * SizeConfig.textMultiplier!,
    fontWeight: FontWeight.w400,
    color: kPureBlack,
  );
  static TextStyle titleText = GoogleFonts.openSans(
      fontSize: (24) * SizeConfig.textMultiplier!,
      fontWeight: FontWeight.w600,
      color: kPureBlack);
  static TextStyle hintText = GoogleFonts.openSans(
    fontSize: (16) * SizeConfig.textMultiplier!,
    fontWeight: FontWeight.w400,
    color: kGreyColor,
  );
  static TextStyle normalBlackText = GoogleFonts.openSans(
    fontSize: (16) * SizeConfig.textMultiplier!,
    fontWeight: FontWeight.w400,
    color: lightBlack,
  );
  static TextStyle smallGreyText = GoogleFonts.openSans(
    fontSize: (12) * SizeConfig.textMultiplier!,
    fontWeight: FontWeight.w400,
    color: darkGreyColor,
  );
  static TextStyle smallBlackText = GoogleFonts.openSans(
    fontSize: (10) * SizeConfig.textMultiplier!,
    fontWeight: FontWeight.w400,
    color: lightBlack,
  );
  static TextStyle boldBlackText = GoogleFonts.openSans(
    fontSize: (18) * SizeConfig.textMultiplier!,
    fontWeight: FontWeight.w600,
    color: lightBlack,
  );
  static TextStyle greenSemiBoldText = GoogleFonts.openSans(
    fontSize: (14) * SizeConfig.textMultiplier!,
    fontWeight: FontWeight.w600,
    color: kGreenColor,
  );
  static TextStyle lightMediumBlackText = GoogleFonts.openSans(
    fontSize: (12) * SizeConfig.textMultiplier!,
    fontWeight: FontWeight.w400,
    color: lightBlack,
  );
  static TextStyle normalPureBlackText = GoogleFonts.openSans(
    fontSize: (14) * SizeConfig.textMultiplier!,
    fontWeight: FontWeight.w500,
    color: kPureBlack,
  );
  static TextStyle normalGreenText = GoogleFonts.openSans(
    fontSize: (14) * SizeConfig.textMultiplier!,
    fontWeight: FontWeight.w400,
    color: kGreenColor,
  );
}
