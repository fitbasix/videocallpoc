import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/feature/profile/view/appbar_for_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';

import '../../../core/constants/color_palette.dart';
import '../widgets/enpandableWidget.dart';

class HelpAndSupportScreen extends StatelessWidget {
  const HelpAndSupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPureWhite,
      appBar: AppBarForAccount(title: "help_support".tr,parentContext: context,),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          //whatsapp and call buttons
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16*SizeConfig.widthMultiplier!,vertical: 16*SizeConfig.heightMultiplier!),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("help_support_description".tr,style: AppTextStyle.black400Text,),
                  SizedBox(height: 16*SizeConfig.heightMultiplier!,),
                  Row(
                    children: [
                      //whatsapp button
                      Expanded(
                        child:InkWell(
                          onTap: (){
                            //todo add whatsapp functionality
                            Navigator.pushNamed(context, RouteName.privacyAndPolicy);
                          },
                          child: Container(
                            height: 48*SizeConfig.heightMultiplier!,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8*SizeConfig.widthMultiplier!),
                              color: kGreenColor
                            ),
                            child: Center(
                              child: SvgPicture.asset(ImagePath.whatsAppIcon,height: 24*SizeConfig.imageSizeMultiplier!,),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16*SizeConfig.widthMultiplier!,),
                      //call button
                      Expanded(
                        child:InkWell(
                          onTap: (){
                            //todo add call functionality
                            Navigator.pushNamed(context, RouteName.termOfUse);
                          },
                          child: Container(
                            height: 48*SizeConfig.heightMultiplier!,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8*SizeConfig.widthMultiplier!),
                                color: kGreenColor
                            ),
                            child: Center(
                              child: SvgPicture.asset(ImagePath.phoneCallIcon,height: 26*SizeConfig.imageSizeMultiplier!,width: 26*SizeConfig.imageSizeMultiplier!,),
                            ),
                          ),
                        ),
                      ),

                    ],
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 16*SizeConfig.heightMultiplier!,
              color: kLightGrey,
            ),
            SizedBox(height: 24*SizeConfig.heightMultiplier!,),
            Padding(
                padding: EdgeInsets.only(left: 16*SizeConfig.widthMultiplier!,bottom: 16*SizeConfig.heightMultiplier!),
                child: Text("FAQs".tr,style: AppTextStyle.boldBlackText,)),
            //todo add all the FAQ from cloud
            ExpandableWidget(title: "How do I cancel my subscription?",content: "It stands for frequently-asked questions, and it’s a page on a website that gives quick answers to customer questions. The idea is to keep the answers short and direct so that people find info quickly."),
          ExpandableWidget(title:"What is FitBasix?",content:"It stands for frequently-asked questions, and it’s a page on a website that gives quick answers to customer questions. The idea is to keep the answers short and direct so that people find info quickly."),
          ExpandableWidget(title:"Are the program results guaranteed?",content:"It stands for frequently-asked questions, and it’s a page on a website that gives quick answers to customer questions. The idea is to keep the answers short and direct so that people find info quickly."),
          ExpandableWidget(title:"How do I choose a Nutrition & Training coach?",content:"It stands for frequently-asked questions, and it’s a page on a website that gives quick answers to customer questions. The idea is to keep the answers short and direct so that people find info quickly."),
          ExpandableWidget(title:"How do I connect with my Nutrition & Training coach?",content:"It stands for frequently-asked questions, and it’s a page on a website that gives quick answers to customer questions. The idea is to keep the answers short and direct so that people find info quickly."),


          ],
      ),

    );
  }
  
}
