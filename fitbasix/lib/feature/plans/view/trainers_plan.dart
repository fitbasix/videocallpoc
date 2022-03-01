import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_palette.dart';
import '../../../core/constants/image_path.dart';
import '../../../core/reponsive/SizeConfig.dart';
import '../../get_trained/view/widgets/star_rating.dart';

class TrainerPlansScreen extends StatelessWidget {
   TrainerPlansScreen({Key? key}) : super(key: key);
  @override
  // constant values for designing purpose
  static const imageurl=
      "https://t4.ftcdn.net/jpg/04/41/05/23/360_F_441052304_xqszd9uBMcbW8dS3WD1JolMbztuF2KNx.jpg";
  var planPrize = '\$120';
  var peopleEnrolled = '234 people enrolled';
  var planDuration = '12 weeks plan';
String ratingcount = '131';

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGreyBackground,
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
           )
       ),
       title: Text('select_plans_proceed'.tr, style: AppTextStyle.hblack600Text),
     ),
      body: ListView(
        padding: EdgeInsets.only(
          left: 16*SizeConfig.widthMultiplier!,
          right: 16*SizeConfig.widthMultiplier!,
          top: 24*SizeConfig.heightMultiplier!
        ),
        children: [
              Text('plans_by '.tr+'Victor Lai'.tr,style: AppTextStyle.hblack600Text,),
              BuildPlancard()
        ],
      ),
    );
  }

  Widget BuildPlancard() => Container(
    padding: EdgeInsets.only(
      top: 24 * SizeConfig.heightMultiplier!,
      bottom: 24*SizeConfig.heightMultiplier!,
    ),
    child: Container(
      decoration: BoxDecoration(
          color: kPureWhite,
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
            child: Container(
                child: Image.network(imageurl,
                height: 120* SizeConfig.heightMultiplier!,
                width: 328*SizeConfig.widthMultiplier!,
                fit: BoxFit.cover,)),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 12*SizeConfig.widthMultiplier!,
              top: 12*SizeConfig.widthMultiplier!,
              bottom: 12*SizeConfig.widthMultiplier!,
              right: 12*SizeConfig.widthMultiplier!,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('sports_nutrition'.tr,
                    style: AppTextStyle.hblackSemiBoldText,),
                    SizedBox(
                      height: 8*SizeConfig.heightMultiplier!,
                    ),
                    //rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StarRating(
                          color: Color(0xffFFB548),
                          rating: 3.0,
                        ),
                        SizedBox(
                          width: 4*SizeConfig.widthMultiplier!,
                        ),
                        Text('('+ratingcount+')',style: AppTextStyle.lightMediumBlackText.copyWith(
                          color: Color(0xff929292)
                        ),)
                      ],
                    ),
                    SizedBox(
                      height: 8*SizeConfig.heightMultiplier!,
                    ),
                    //Plan detail
                    Row(
                      children: [
                        SvgPicture.asset(
                          ImagePath.plantimerIcon,
                          width: 12 * SizeConfig.widthMultiplier!,
                          height: 14 * SizeConfig.heightMultiplier!,
                        ),
                        SizedBox(width: 6*SizeConfig.widthMultiplier!,),
                        Text(planDuration,
                          style: AppTextStyle.hsmallhintText,),
                      ],
                    ),
                    SizedBox(
                      height: 4* SizeConfig.heightMultiplier!,
                    ),
                    //enrolledpersonDetail
                    Row(
                      children: [
                        SvgPicture.asset(
                          ImagePath.planpersonenrolledIcon,
                          width: 10.67 * SizeConfig.widthMultiplier!,
                          height: 10.67 * SizeConfig.heightMultiplier!,
                        ),
                        SizedBox(width: 6*SizeConfig.widthMultiplier!,),
                        Text(peopleEnrolled,
                          style: AppTextStyle.hsmallhintText,),
                      ],
                    ),
                  ],
                ),

                Spacer(),
                Text(planPrize,
                style: AppTextStyle.hblackSemiBoldText.copyWith(
                  fontSize: (24) * SizeConfig.textMultiplier!,
                  letterSpacing: 1
                ),)
              ],
            ),
          )
        ],
      ),
    ),
  );
}
