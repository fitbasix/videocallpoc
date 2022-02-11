
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/image_path.dart';
import '../../../core/reponsive/SizeConfig.dart';


class EnrollTrainer extends StatelessWidget {
  const EnrollTrainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPureWhite,
      appBar: AppBar(
        backgroundColor: kPureWhite,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              ImagePath.backIcon,
              width: 7.41 * SizeConfig.widthMultiplier!,
              height: 12 * SizeConfig.heightMultiplier!,
            )),
      ),
      body: Center(
        child: Container(
          width: 296 * SizeConfig.widthMultiplier!,
          height: 426 * SizeConfig.heightMultiplier!,
          color: kPureWhite,
          padding: EdgeInsets.only(left: 32,right: 32,top: 31,
          bottom: 31),
          child: Column(
            children: [
               SvgPicture.asset(
                 ImagePath.enrolltrainerFrame,
                 width: 220 * SizeConfig.widthMultiplier!,
                 height: 168 * SizeConfig.heightMultiplier!),
              Padding(
                padding: const EdgeInsets.only(top: 24,bottom:16 ),
                child: Text('uh_oh'.tr,style: GoogleFonts.openSans(
                    fontSize: (16) * SizeConfig.textMultiplier!,
                    fontWeight: FontWeight.w600,
                    color: kPureBlack,
                ))),
              //enroll summary
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Text('enroll_summary'.tr,
                    style: GoogleFonts.openSans(
                  fontSize: (14) * SizeConfig.textMultiplier!,
                  fontWeight: FontWeight.w400,
                  color: kPureBlack,
                )
                ),
              ),
              //enroll now text button
              Padding(
                padding: const EdgeInsets.fromLTRB(39, 0, 39, 0),
                child: Container(
                  decoration:  BoxDecoration(color: kGreenColor,
                      borderRadius: BorderRadius.circular(8)),
                    width: 156 * SizeConfig.widthMultiplier!,
                    height: 48 * SizeConfig.heightMultiplier!,
                  child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'enroll_now'.tr,
                        style: GoogleFonts.openSans(
                          fontSize: (18) * SizeConfig.textMultiplier!,
                          fontWeight: FontWeight.w600,
                          color: kPureWhite,
                        )
                      ),
                    ),
                  ),
                ),
            ]
          ),
        ),
      ),
    );
  }
}
