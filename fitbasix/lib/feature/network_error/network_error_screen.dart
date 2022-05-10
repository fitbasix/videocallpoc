import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../GetXNetworkManager.dart';
import '../../core/constants/color_palette.dart';


class NetworkErrorScreen extends StatefulWidget {
  const NetworkErrorScreen({Key? key}) : super(key: key);

  @override
  State<NetworkErrorScreen> createState() => _NetworkErrorScreenState();
}

class _NetworkErrorScreenState extends State<NetworkErrorScreen> {
  bool isChecking = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        return false;
      },
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 120*SizeConfig.heightMultiplier!,),
            Padding(
              padding: EdgeInsets.only(left: 20*SizeConfig.widthMultiplier!),
                child: Image.asset(ImagePath.networkImageError,height: 120.61,width: 150,)),
            SizedBox(height: 40*SizeConfig.heightMultiplier!,),
            Center(child: Text('oops',style: AppTextStyle.smallWhiteText600.copyWith(fontSize: 24*SizeConfig.textMultiplier!),)),
            SizedBox(height: 16*SizeConfig.heightMultiplier!,),
            Padding(
          padding: EdgeInsets.symmetric(horizontal: 60*SizeConfig.widthMultiplier!),

          child: Text('no_internet_text'.tr,style: AppTextStyle.smallWhiteText600.copyWith(fontSize: 16*SizeConfig.textMultiplier!),textAlign: TextAlign.center,)),
            GestureDetector(
              onTap: ()async{
                final NetworkManager _networkManager =
                Get.find<NetworkManager>();
                if (_networkManager.connectionType == 1 ||
                    _networkManager.connectionType == 2) {
                  Navigator.pop(context);
                } else {
                  setState(() {
                    isChecking = true;
                  });
                  await Future.delayed(Duration(milliseconds: 1200),
                          () {
                        setState(() {
                          isChecking = false;
                        });
                      });
                }
              },
              child: isChecking?Padding(
                  padding: EdgeInsets.symmetric(vertical: 60*SizeConfig.heightMultiplier!),
                  child: CustomizedCircularProgress()):Container(
                height: 44 * SizeConfig.heightMultiplier!,
                margin: EdgeInsets.symmetric(horizontal: 64*SizeConfig.widthMultiplier!,vertical: 56*SizeConfig.heightMultiplier!),
                decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(12 * SizeConfig.heightMultiplier!),
                    color: kPink,
      ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 12 * SizeConfig.widthMultiplier!),
                  child: Center(
                    child: Text(
                      'try_again'.tr,
                      style: AppTextStyle.black600Text.copyWith(
                          color: kPureWhite, fontSize: 18 * SizeConfig.textMultiplier!),
                    ),
                  ),
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}
