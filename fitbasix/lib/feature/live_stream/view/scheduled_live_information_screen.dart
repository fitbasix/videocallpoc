import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ScheduledLiveInformationScreen extends StatelessWidget {
  String? imageUrl;
  ScheduledLiveInformationScreen({Key? key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        //shrinkWrap: true,
        children: [
          Stack(
            children: [
              Image.network(imageUrl!),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 16 * SizeConfig.widthMultiplier!,
                      vertical: 16 * SizeConfig.heightMultiplier!),
                  height: 40 * SizeConfig.heightMultiplier!,
                  width: 40 * SizeConfig.widthMultiplier!,
                  decoration: BoxDecoration(
                      color: kPureWhite,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          spreadRadius: -3,
                          offset: Offset(0, 10),
                        )
                      ]),
                  child: Center(
                    child: Padding(
                        padding: EdgeInsets.only(
                            right: 2 * SizeConfig.widthMultiplier!),
                        child: SvgPicture.asset(
                          ImagePath.backIcon,
                          height: 12 * SizeConfig.imageSizeMultiplier!,
                          width: 7.41 * SizeConfig.imageSizeMultiplier!,
                        )),
                  ),
                ),
              )
            ],
          ),
          _getDetailsUI(
              userName: "Steven Wang",
              liveTitle: "Endurance workout techniques",
              liveTime: DateTime.now(),
              aboutContent:
                  "Hi, This is Steven. I am certified by Institute Viverra cras facilisis massa amet, hendrerit nunc. Tristique tellus, massa scelerisque tincidunt neque dui metus, id pellentesque.\nLet’s start your fitness journey!!!"),
          _getPreviousSessionsUI(
              userName: "Steven Wang",
              liveTitle: "Endurance workout techniques",
              liveTime: DateTime.now(),
              aboutContent:
                  "Hi, This is Steven. I am certified by Institute Viverra cras facilisis massa amet, hendrerit nunc. Tristique tellus, massa scelerisque tincidunt neque dui metus, id pellentesque.\nLet’s start your fitness journey!!!"),
        ],
      ),
    );
  }

  Widget _getDetailsUI(
      {String? userName,
      String? liveTitle,
      DateTime? liveTime,
      String? aboutContent}) {
    return Container(
      padding: EdgeInsets.all(16 * SizeConfig.widthMultiplier!),
      color: kPureWhite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            userName!,
            style: AppTextStyle.boldBlackText,
          ),
          SizedBox(
            height: 25 * SizeConfig.heightMultiplier!,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$liveTitle",
                      style: AppTextStyle.normalPureBlackTextWithWeight600,
                    ),
                    SizedBox(
                      height: 4 * SizeConfig.heightMultiplier!,
                    ),
                    Text(
                      "live".tr +
                          " | " +
                          DateFormat("E, dd MMM yyyy, hh:mm a")
                              .format(liveTime!),
                      style: AppTextStyle.lightBlack400Text,
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 5 * SizeConfig.widthMultiplier!,
              ),
              Container(
                height: 32 * SizeConfig.heightMultiplier!,
                width: 72 * SizeConfig.widthMultiplier!,
                decoration: BoxDecoration(
                    color: kGreenColor,
                    borderRadius:
                        BorderRadius.circular(8 * SizeConfig.widthMultiplier!)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 8 * SizeConfig.widthMultiplier!),
                    SvgPicture.asset(
                      ImagePath.LiveIcon,
                      height: 24 * SizeConfig.imageSizeMultiplier!,
                      width: 24 * SizeConfig.imageSizeMultiplier!,
                    ),
                    SizedBox(width: 5 * SizeConfig.widthMultiplier!),
                    Text(
                      "live".tr,
                      style: AppTextStyle.whiteTextWithWeight600,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16 * SizeConfig.heightMultiplier!,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "about".tr,
                style: AppTextStyle.normalPureBlackTextWithWeight600,
              ),
              SizedBox(
                height: 4 * SizeConfig.heightMultiplier!,
              ),
              Container(
                  width: double.infinity,
                  child: Text(
                    aboutContent!,
                    style: AppTextStyle.lightBlack400Text,
                  ))
            ],
          ),
          SizedBox(height: 8 * SizeConfig.heightMultiplier!)
        ],
      ),
    );
  }

  Widget _getPreviousSessionsUI(
      {String? userName,
      String? liveTitle,
      DateTime? liveTime,
      String? aboutContent}) {
    return Container(
      margin: EdgeInsets.only(top: 16 * SizeConfig.heightMultiplier!),
      padding: EdgeInsets.all(16 * SizeConfig.widthMultiplier!),
      color: kPureWhite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "previous_sessions".tr,
            style: AppTextStyle.NormalBlackTitleText,
          ),
          SizedBox(
            height: 25 * SizeConfig.heightMultiplier!,
          ),

          ///add list of lives here
          _getLiveTitleAndTimeUI(
              liveTitle: liveTitle, liveTime: liveTime, isExpired: false),
          _getLiveTitleAndTimeUI(
              liveTitle: liveTitle, liveTime: liveTime, isExpired: false),
          _getLiveTitleAndTimeUI(
              liveTitle: liveTitle, liveTime: liveTime, isExpired: true),
          _getLiveTitleAndTimeUI(
              liveTitle: liveTitle, liveTime: liveTime, isExpired: true),
        ],
      ),
    );
  }

  Widget _getLiveTitleAndTimeUI(
      {String? liveTitle, DateTime? liveTime, bool? isExpired}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$liveTitle",
                    style: AppTextStyle.normalPureBlackTextWithWeight600,
                  ),
                  SizedBox(
                    height: 4 * SizeConfig.heightMultiplier!,
                  ),
                  Text(
                    "live".tr +
                        " | " +
                        DateFormat("E, dd MMM yyyy, hh:mm a").format(liveTime!),
                    style: AppTextStyle.lightBlack400Text,
                  )
                ],
              ),
            ),
            SizedBox(
              width: 5 * SizeConfig.widthMultiplier!,
            ),
            Container(
                height: 32 * SizeConfig.heightMultiplier!,
                decoration: BoxDecoration(
                    color: lightGrey,
                    borderRadius:
                        BorderRadius.circular(8 * SizeConfig.widthMultiplier!)),
                child: (!isExpired!)
                    ? InkWell(
                        onTap: () {
                          //todo implement watch onTap to watch saved live video
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(width: 8 * SizeConfig.widthMultiplier!),
                            SvgPicture.asset(
                              ImagePath.LiveIcon,
                              height: 24 * SizeConfig.imageSizeMultiplier!,
                              width: 24 * SizeConfig.imageSizeMultiplier!,
                              color: kGreenColor,
                            ),
                            SizedBox(width: 5 * SizeConfig.widthMultiplier!),
                            Text(
                              "Watch".tr,
                              style:
                                  AppTextStyle.normalPureBlackTextWithWeight600,
                            ),
                            SizedBox(width: 8 * SizeConfig.widthMultiplier!),
                          ],
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8 * SizeConfig.widthMultiplier!),
                        child: Center(
                            child: Text(
                          "expired".tr,
                          style: AppTextStyle.greyTextWithWeight600,
                        )))),
          ],
        ),
        SizedBox(height: 30 * SizeConfig.heightMultiplier!),
      ],
    );
  }
}
