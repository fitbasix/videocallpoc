import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/color_palette.dart';
import '../../../core/constants/image_path.dart';
import 'Appbar_forBmr.dart';

class BMRResultScreen extends StatefulWidget {
  const BMRResultScreen({Key? key}) : super(key: key);

  @override
  State<BMRResultScreen> createState() => _BMRResultScreenState();
}

class _BMRResultScreenState extends State<BMRResultScreen> {
  var bmrresult = '1346';
  bool isReadmore = false;
  @override

  Widget build(BuildContext context) {
        return Scaffold(
      backgroundColor: greyF6,
      appBar: AppbarforBMRScreen(
        title: 'BMR Calculator',
        parentContext: context,
        onRoute: (){
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: AnimatedContainer(
          height: !isReadmore?191 * SizeConfig.heightMultiplier!
              :515* SizeConfig.heightMultiplier!,
          duration: Duration(milliseconds: 400),
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.all(16 * SizeConfig.widthMultiplier!),
                height: 191 * SizeConfig.heightMultiplier!,
                //  padding: EdgeInsets.all(16*SizeConfig.widthMultiplier!),
               //  height: 300 * SizeConfig.heightMultiplier!,
                decoration: BoxDecoration(
                  color: kPureWhite,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(
                        left: 24*SizeConfig.widthMultiplier!,
                        right: 24*SizeConfig.widthMultiplier!,
                        top: 16*SizeConfig.heightMultiplier!,
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Your BMR'
                                ,style: AppTextStyle.hblackSemiBoldText,),
                              SizedBox(
                                height: 16*SizeConfig.heightMultiplier!,
                              ),
                              // result
                              Text(
                                NumberFormat("#,###").format(double.parse(bmrresult)),
                                style: AppTextStyle.hblackSemiBoldText
                                    .copyWith(
                                  fontSize: 32 *
                                      SizeConfig.textMultiplier!,
                                  fontWeight: FontWeight.w400,
                                ),),
                              SizedBox(
                                height: 6*SizeConfig.heightMultiplier!,
                              ),
                              Text('Calories/Day ',
                                style: AppTextStyle.hblack400Text,)
                            ],
                          ),
                          Spacer(),
                          SvgPicture.asset(
                              ImagePath.bmrinfoImage,
                              height: 100 * SizeConfig.heightMultiplier!),
                        ],
                      ),
                    ),
                    isReadmore?buildText():Container(),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: (){
                            setState((){
                              isReadmore = !isReadmore;
                              print(isReadmore);                      });
                          },
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor: MaterialStateProperty.all(kPureWhite),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          0 * SizeConfig.widthMultiplier!)))),
                          child: Text((isReadmore?'View More':'View Less'),
                            style: AppTextStyle.hmediumBlackText,)),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

  Widget buildText(){
   // final lines = isReadmore? null: 1;
    return Text(
      'Daily calorie needs based on activity',
      style: AppTextStyle.hmediumBlackText,
     // maxLines: lines,
    );
  }
}
