import 'dart:ui';

import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';
import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/image_path.dart';
import '../../../core/reponsive/SizeConfig.dart';
import '../../../core/routes/app_routes.dart';

class MyTrainerTileScreen extends StatelessWidget {
  MyTrainerTileScreen({
    Key? key,
    this.chatHistoryList,
  }) : super(key: key);
  List<String> taggedPersonList = [
    "Sports Nutrition",
    "Hi",
    "Hk",
    "Hx",
    "Hz",
  ];

  List<QBDialog>? chatHistoryList;
  var trainerName = 'Jonathan Swift'.obs;
  var trainerStatus = "".obs;
  String trainerProfilePicUrl =
      'http://www.pixelmator.com/community/download/file.php?avatar=17785_1569233053.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(

        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Padding(
            padding: EdgeInsets.only(left: 5*SizeConfig.widthMultiplier!),
            child: Text('my_trainer'.tr, style: AppTextStyle.hblack600Text.copyWith(color: Theme.of(context).textTheme.bodyText1!.color))),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 345 * SizeConfig.heightMultiplier!,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 32 * SizeConfig.heightMultiplier!,
                                  left: 16 * SizeConfig.widthMultiplier!,
                                  bottom: 30 * SizeConfig.heightMultiplier!),
                              child: Text(
                                trainerName.value.isNotEmpty
                                    ? trainerName.value
                                    : "Loading..",
                                style: AppTextStyle.hblackSemiBoldText,
                              ),
                            ),
                            //bottomsheet open profile
                            BottomSheetField(
                              BottomFieldImage: ImagePath.penIcon,
                              BottomFieldText: 'open_profile'.tr,
                              onTap: () {},
                            ),
                            //bottomsheet mute notification
                            BottomSheetField(
                              BottomFieldImage: ImagePath.unmuteIcon,
                              BottomFieldText: 'mute_notification'.tr,
                              onTap: () {},
                            ),
                            // mark as unread
                            BottomSheetField(
                              BottomFieldImage: ImagePath.penIcon,
                              BottomFieldText: 'mark_as_unread'.tr,
                              onTap: () {},
                            ),
                            // cancel enrollment
                            BottomSheetField(
                              BottomFieldImage: ImagePath.cancelEnrollmentIcon,
                              BottomFieldText: 'cancel_enrollment'.tr,
                              onTap: () {},
                            ),
                            // share feedback
                            BottomSheetField(
                              BottomFieldImage: ImagePath.sharefeedbackIcon,
                              BottomFieldText: 'share_feedback'.tr,
                              onTap: () {},
                            ),
                          ],
                        ),
                      );
                    });
              },
              icon: Icon(
                Icons.search,
                color: Theme.of(context).primaryColor,
                size: 25 * SizeConfig.heightMultiplier!,
              )),
        ],
      ),
      body: ListView.builder(
          itemCount: chatHistoryList!.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return TrainersTileUI(
              taggedPersonList: taggedPersonList,
              trainerName: trainerName.value,
              lastMessage: chatHistoryList![index].lastMessage!.capitalized(),
              trainerProfilePicUrl: trainerProfilePicUrl,
            );
          },
      )
    );
  }
}

extension StringExtension on String {
  String capitalized() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

class TrainersTileUI extends StatelessWidget {
  TrainersTileUI(
      {Key? key,
      required this.taggedPersonList,
      this.trainerName,
      this.trainerProfilePicUrl,
      this.lastMessage})
      : super(key: key);
  List<String> taggedPersonList;
  String? trainerName;
  String? lastMessage;
  String? trainerProfilePicUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        createMenuDialog(context);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8*SizeConfig.heightMultiplier!),
        color: Theme.of(context).secondaryHeaderColor,
        child: Column(
          children: [
            SizedBox(
              height: 24 * SizeConfig.heightMultiplier!,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24 * SizeConfig.widthMultiplier!,
                ),
                // TrainerAvatar
                Container(
                    width: 40 * SizeConfig.widthMultiplier!,
                    height: 40 * SizeConfig.heightMultiplier!,
                    child: InkWell(
                      onTap: null,
                      child: CircleAvatar(
                        child: Image.network(
                          trainerProfilePicUrl!,
                          width: 40 * SizeConfig.widthMultiplier!,
                          height: 40 * SizeConfig.heightMultiplier!,
                        ),
                      ),
                    )),
                SizedBox(
                  width: 12 * SizeConfig.widthMultiplier!,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(trainerName!.isNotEmpty ? trainerName! : "Loading..",
                        style: AppTextStyle.hnormal600BlackText.copyWith(color: Theme.of(context).textTheme.bodyText1!.color)),
                    //_taggedBar Widget
                    _taggedBar(list: taggedPersonList,context: context)
                  ],
                ),
                Spacer(),
                Padding(
                  padding:
                      EdgeInsets.only(right: 16 * SizeConfig.widthMultiplier!),
                  child: Text('1:29 pm'.tr, style: AppTextStyle.hsmallhintText),
                )
              ],
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 16 * SizeConfig.widthMultiplier!,
                    right: 38 * SizeConfig.widthMultiplier!,
                    top: 16 * SizeConfig.heightMultiplier!,
                    bottom: 16 * SizeConfig.heightMultiplier!),
                child: Text(lastMessage!.isNotEmpty ? lastMessage! : "loading...",
                    style: AppTextStyle.hmedium13Text.copyWith(color: Theme.of(context).textTheme.bodyText1!.color)),
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 16 * SizeConfig.widthMultiplier!,
                    bottom: 24 * SizeConfig.heightMultiplier!),
                child: Row(
                  children: [
                    Text('enrolled_on'.tr, style: AppTextStyle.hsmallhintText),
                    SizedBox(
                      width: 4 * SizeConfig.widthMultiplier!,
                    ),
                    Text('7 Nov 2021'.tr, style: AppTextStyle.hsmallGreenText)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void createMenuDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: kBlack.withOpacity(0.6),
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: AlertDialog(
                contentPadding: EdgeInsets.symmetric(vertical: 30*SizeConfig.heightMultiplier!),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8*SizeConfig.imageSizeMultiplier!)
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(trainerName!,style: AppTextStyle.black400Text.copyWith(color: Theme.of(context).textTheme.bodyText1!.color),),
                    SizedBox(height: 26*SizeConfig.heightMultiplier!,),
                    GestureDetector(
                      onTap: (){
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(ImagePath.penIcon,color: Theme.of(context).primaryColor,height: 15*SizeConfig.imageSizeMultiplier!,),
                          SizedBox(width: 10.5*SizeConfig.widthMultiplier!,),
                          Text('Open profile',style: AppTextStyle.black400Text.copyWith(color: Theme.of(context).textTheme.bodyText1!.color),),
                        ],
                      ),
                    ),
                    SizedBox(height: 22*SizeConfig.heightMultiplier!,),
                    GestureDetector(
                      onTap: (){
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(ImagePath.muteBell,color: Theme.of(context).primaryColor,height: 15*SizeConfig.imageSizeMultiplier!,),
                          SizedBox(width: 10.5*SizeConfig.widthMultiplier!,),
                          Text('Mute notifications',style: AppTextStyle.black400Text.copyWith(color: Theme.of(context).textTheme.bodyText1!.color),),
                        ],
                      ),
                    ),
                    SizedBox(height: 22*SizeConfig.heightMultiplier!,),
                    GestureDetector(
                      onTap: (){
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(ImagePath.penIcon,color: Theme.of(context).primaryColor,height: 15*SizeConfig.imageSizeMultiplier!,),
                          SizedBox(width: 10.5*SizeConfig.widthMultiplier!,),
                          Text('Mark as unread',style: AppTextStyle.black400Text.copyWith(color: Theme.of(context).textTheme.bodyText1!.color),),
                        ],
                      ),
                    ),

                  ],
                ),
              )
          ),
        );



      },
    );
  }

  Widget _taggedBar({List<String>? list,required BuildContext context}) {
    return Row(
      children: [
        Container(
          height: 28 * SizeConfig.heightMultiplier!,
          decoration: BoxDecoration(
              color: Color(0xff747474),
              borderRadius:
                  BorderRadius.circular(28 * SizeConfig.heightMultiplier!)),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 12 * SizeConfig.widthMultiplier!),
            child: Center(
              child: Text(
                list![0].tr,
                style: AppTextStyle.lightMediumBlackText.copyWith(color: Theme.of(context).textTheme.bodyText1!.color),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 8 * SizeConfig.widthMultiplier!,
        ),
        Container(
          height: 28 * SizeConfig.heightMultiplier!,
          decoration: BoxDecoration(
              color: Color(0xff747474),
              borderRadius:
                  BorderRadius.circular(28 * SizeConfig.heightMultiplier!)),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 12 * SizeConfig.widthMultiplier!),
            child: Center(
              child: Text(
                '+' + (list.length - 1).toString().tr,
                style: AppTextStyle.lightMediumBlackText.copyWith(color: Theme.of(context).textTheme.bodyText1!.color),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Bottom sheet class
class BottomSheetField extends StatelessWidget {
  final String? BottomFieldImage;
  final String? BottomFieldText;
  final VoidCallback? onTap;

  BottomSheetField({this.BottomFieldImage, this.BottomFieldText, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            bottom: 34 * SizeConfig.heightMultiplier!,
            left: 18.5 * SizeConfig.widthMultiplier!),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            color: Colors.transparent,
            child: Row(
              children: [
                SvgPicture.asset(BottomFieldImage!,
                    width: 16 * SizeConfig.widthMultiplier!,
                    fit: BoxFit.contain),
                SizedBox(width: 10.5 * SizeConfig.widthMultiplier!),
                Text(BottomFieldText!, style: AppTextStyle.hblackSemiBoldText)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
