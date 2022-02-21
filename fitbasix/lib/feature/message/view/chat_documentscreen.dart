import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/feature/profile/view/appbar_for_account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrainerDocumentScreen extends StatelessWidget {
  const TrainerDocumentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPureWhite,
      appBar: AppBarForAccount(
        title: 'jonathan_swift'.tr,
        parentContext: context,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('document'.tr,
            style: AppTextStyle.hblack600Text.copyWith(
              color: kBlack
            ),),
           SizedBox(
             height: 26*SizeConfig.heightMultiplier!,
           ),
           DocumentHistory(),
          ],
        ),
      ),
    );
  }
}

class DocumentHistory extends StatelessWidget {
  const DocumentHistory({Key? key}) : super(key: key);

  @override

  Widget build(BuildContext context) {

    var imageurl = 'https://i.pinimg.com/736x/46/9b/56/469b56b2cb73b46e5866a2454df2260b.jpg';
    var documenttitle = 'Food Plan for March 2022';
    var pagecount = '4 pages';
    var pagesize = '23MB';
    var documentformat = 'PDF';
    var day = 'Yesterday';
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Last Month'.tr,
          style: AppTextStyle.black600Text.copyWith(
            color: hintGrey
          ),),
        ),
        SizedBox(
          height: 12*SizeConfig.heightMultiplier!,
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                child: Image.network(imageurl,
                fit: BoxFit.fill,),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                top: 50* SizeConfig.heightMultiplier!,
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      color: grey34.withOpacity(0.5),
                    ),
                  height: 52*SizeConfig.heightMultiplier!,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16*SizeConfig.widthMultiplier!,
                      vertical: 8*SizeConfig.heightMultiplier!
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(documenttitle.tr,
                        style: AppTextStyle.white400Text.copyWith(
                          fontWeight: FontWeight.w600,
                        ),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(pagecount.tr+' . '+pagesize.tr+' . '+documentformat.tr,
                            style: AppTextStyle.smallGreyText.copyWith(
                              color: kLightGrey
                            ),),
                            Text(day.tr,
                              style: AppTextStyle.smallGreyText.copyWith(
                                  color: kLightGrey
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )),
              ),
            ],
          ),
        )
      ],
    );
  }
}
