import 'package:flutter/material.dart';

import '../../../../core/constants/app_text_style.dart';
import '../../../../core/constants/color_palette.dart';
import '../../../../core/reponsive/SizeConfig.dart';
import '../../../profile/view/appbar_for_account.dart';
import 'package:get/get.dart';

import '../../widgets/enpandableWidget.dart';

class TermOfUseScreen extends StatefulWidget {
  const TermOfUseScreen({Key? key}) : super(key: key);

  @override
  _TermOfUseScreenState createState() => _TermOfUseScreenState();
}

class _TermOfUseScreenState extends State<TermOfUseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPureWhite,
      appBar: AppBarForAccount(title: "term_of_use".tr,parentContext: context,),
      body: ListView(
        physics: const BouncingScrollPhysics(),

        children: [

          //Last updated text
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16*SizeConfig.widthMultiplier!,vertical: 14*SizeConfig.heightMultiplier!),
              child: Text("Last updated 26 Nov 21",style: AppTextStyle.grey400Text,)),

          Container(
            width: double.infinity,
            height: 16*SizeConfig.heightMultiplier!,
            color: kLightGrey,
          ),
          SizedBox(height:  14*SizeConfig.heightMultiplier!,),
          //all privacy policy
          ExpandableWidget(title: "Introduction",content: "At Website Name, accessible at Website.com, one of our main priorities is the privacy of our visitors. This Privacy Policy document contains types of information that is collected and recorded by Website Name and how we use it.\n\nIf you have additional questions or require more information about our Privacy Policy, do not hesitate to contact us through email at Email@Website.com This privacy policy applies only to our online activities and is valid for visitors to our website with regards to the information that they shared and/or collect in Website Name.\n\nThis policy is not applicable to any information collected offline or via channels other than this website."),
          ExpandableWidget(title: "Consent",content: "At Website Name, accessible at Website.com, one of our main priorities is the privacy of our visitors. This Privacy Policy document contains types of information that is collected and recorded by Website Name and how we use it.\n\nIf you have additional questions or require more information about our Privacy Policy, do not hesitate to contact us through email at Email@Website.com This privacy policy applies only to our online activities and is valid for visitors to our website with regards to the information that they shared and/or collect in Website Name.\n\nThis policy is not applicable to any information collected offline or via channels other than this website."),
          ExpandableWidget(title: "Collection",content: "At Website Name, accessible at Website.com, one of our main priorities is the privacy of our visitors. This Privacy Policy document contains types of information that is collected and recorded by Website Name and how we use it.\n\nIf you have additional questions or require more information about our Privacy Policy, do not hesitate to contact us through email at Email@Website.com This privacy policy applies only to our online activities and is valid for visitors to our website with regards to the information that they shared and/or collect in Website Name.\n\nThis policy is not applicable to any information collected offline or via channels other than this website."),
          ExpandableWidget(title: "Use of Information",content: "At Website Name, accessible at Website.com, one of our main priorities is the privacy of our visitors. This Privacy Policy document contains types of information that is collected and recorded by Website Name and how we use it.\n\nIf you have additional questions or require more information about our Privacy Policy, do not hesitate to contact us through email at Email@Website.com This privacy policy applies only to our online activities and is valid for visitors to our website with regards to the information that they shared and/or collect in Website Name.\n\nThis policy is not applicable to any information collected offline or via channels other than this website."),
          ExpandableWidget(title: "Changes to this Privacy Policy",content: "At Website Name, accessible at Website.com, one of our main priorities is the privacy of our visitors. This Privacy Policy document contains types of information that is collected and recorded by Website Name and how we use it.\n\nIf you have additional questions or require more information about our Privacy Policy, do not hesitate to contact us through email at Email@Website.com This privacy policy applies only to our online activities and is valid for visitors to our website with regards to the information that they shared and/or collect in Website Name.\n\nThis policy is not applicable to any information collected offline or via channels other than this website."),
          SizedBox(height: 50*SizeConfig.heightMultiplier!,),
        ],
      ),
    );
  }
}
