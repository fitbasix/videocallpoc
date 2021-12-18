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
    color: kPureBlack,
  );
}
