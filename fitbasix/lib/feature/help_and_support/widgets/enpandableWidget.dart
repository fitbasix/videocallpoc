import 'package:flutter/material.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';

import '../../../core/constants/color_palette.dart';
import '../../../core/reponsive/SizeConfig.dart';

class ExpandableWidget extends StatelessWidget {
  String? title;
  String? content;
  ExpandableWidget({Key? key,this.title,this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16*SizeConfig.widthMultiplier!),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GFAccordion(
            margin: EdgeInsets.zero,
            expandedTitleBackgroundColor: Colors.transparent,
            titlePadding: EdgeInsets.symmetric(vertical: 16*SizeConfig.heightMultiplier!),
            contentPadding: EdgeInsets.only(right: 16*SizeConfig.widthMultiplier!,bottom: 10*SizeConfig.heightMultiplier!),
            collapsedIcon: Icon(Icons.access_alarms_sharp,color: kPureWhite,size: 0.0000001),
            expandedIcon: Icon(Icons.access_alarms_sharp,color: kPureWhite,size: 0.0000001,),
            titleChild: Text(title!,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: kBlack),),
            contentChild: Text(content!,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: kBlack,height: 1.3),),
          ),

          Divider(endIndent: 16*SizeConfig.widthMultiplier!,thickness: 1.2,color: kLightGrey,height: 0.0,),
        ],
      ),
    );
  }
}