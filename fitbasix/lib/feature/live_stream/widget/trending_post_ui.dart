import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/feature/live_stream/controller/trending_post_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TrendingPostUI extends StatelessWidget {
  String titleOfLive = "HIIT for fat loss";
  String userName = "Steven Sufjan";
  String liveDescription =
      "Live high intensity interval training for fat loss.";
  String imageURL =
      "https://www.slazzer.com/static/images/home-page/banner-orignal-image.jpg";
  String profileImageURL =
      "https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg";
  GestureTapCallback? onTap;

  bool isLiked = false;
  int likeCount = 123;
  int liveCommentCount = 80;
  int liveViewersCount = 123;
  ValueChanged<bool>? hitLike;

  ///confirm this part
  TrendingPostUIController _trendingPostUIController =
      Get.put(TrendingPostUIController());
  bool? isAccountLive;
  GlobalKey _widgetKey = GlobalKey();
  String Time = "5:00";

  TrendingPostUI({Key? key, this.hitLike, this.isAccountLive, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPureWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 7 * SizeConfig.heightMultiplier!,
          ),
          ListTile(
            horizontalTitleGap: 12 * SizeConfig.widthMultiplier!,
            dense: true,
            leading: CircleAvatar(
                radius: 20 * SizeConfig.widthMultiplier!,
                backgroundImage: NetworkImage(profileImageURL)),
            title: Text(
              titleOfLive,
              style: AppTextStyle.black600Text,
            ),
            subtitle: Text(
              userName,
              style: AppTextStyle.smallGreyText,
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 16 * SizeConfig.widthMultiplier!),
              child: Text(
                liveDescription,
                style: AppTextStyle.black400Text,
              )),
          SizedBox(
            height: 12 * SizeConfig.widthMultiplier!,
          ),
          Stack(
            children: [
              ///video of live user
              Container(
                  key: _widgetKey,
                  child: InkWell(
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: onTap,
                    child: Image.network(
                      imageURL,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          if (!isAccountLive!) {
                            _getWidgetInfo();
                          }
                          return child;
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        }
                      },
                    ),
                  )),

              ///live user viewer counts and live icon
              isAccountLive!
                  ? Row(
                      children: [
                        Container(
                          height: 24 * SizeConfig.heightMultiplier!,
                          width: 60 * SizeConfig.widthMultiplier!,
                          margin: EdgeInsets.only(
                              top: 12 * SizeConfig.heightMultiplier!,
                              left: 16 * SizeConfig.widthMultiplier!),
                          decoration: BoxDecoration(
                              color: kGreenColor,
                              borderRadius: BorderRadius.circular(
                                  8 * SizeConfig.widthMultiplier!)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(width: 6 * SizeConfig.widthMultiplier!),
                              SvgPicture.asset(
                                ImagePath.LiveIcon,
                                height: 18 * SizeConfig.imageSizeMultiplier!,
                                width: 18 * SizeConfig.imageSizeMultiplier!,
                              ),
                              SizedBox(width: 5 * SizeConfig.widthMultiplier!),
                              Text(
                                "live".tr,
                                style: AppTextStyle.smallWhiteText600,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 24 * SizeConfig.heightMultiplier!,
                          margin: EdgeInsets.only(
                              top: 12 * SizeConfig.heightMultiplier!,
                              left: 4 * SizeConfig.widthMultiplier!),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(34, 34, 34, 0.5),
                              borderRadius: BorderRadius.circular(
                                  8 * SizeConfig.widthMultiplier!)),
                          child: Row(
                            children: [
                              SizedBox(width: 8 * SizeConfig.widthMultiplier!),
                              Icon(
                                Icons.visibility,
                                color: Colors.white,
                                size: 18.20 * SizeConfig.imageSizeMultiplier!,
                              ),
                              SizedBox(width: 5 * SizeConfig.widthMultiplier!),
                              Text(
                                "${liveViewersCount}",
                                style: AppTextStyle.smallWhiteText600,
                              ),
                              SizedBox(width: 8 * SizeConfig.widthMultiplier!),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Container(),

              ///black shade for video if user is not live
              (!isAccountLive!)
                  ? Obx(() => InkWell(
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: onTap,
                        child: Container(
                          height: _trendingPostUIController.height.value,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ))
                  : Container(),

              ///user live schedule time if user is not live
              (!isAccountLive!)
                  ? Container(
                      height: 24 * SizeConfig.heightMultiplier!,
                      margin: EdgeInsets.only(
                          left: 16 * SizeConfig.widthMultiplier!,
                          top: 12 * SizeConfig.heightMultiplier!),
                      decoration: BoxDecoration(
                        color: lightBlack,
                        borderRadius: BorderRadius.circular(
                            8 * SizeConfig.widthMultiplier!),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(width: 6 * SizeConfig.widthMultiplier!),
                          SvgPicture.asset(
                            ImagePath.LiveIcon,
                            height: 18 * SizeConfig.imageSizeMultiplier!,
                            width: 18 * SizeConfig.imageSizeMultiplier!,
                          ),
                          SizedBox(width: 5 * SizeConfig.widthMultiplier!),
                          Text(
                            "scheduled_for".tr + " " + Time + " PM",
                            style: AppTextStyle.smallWhiteText600,
                          ),
                          SizedBox(width: 8 * SizeConfig.widthMultiplier!),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
          SizedBox(
            height: 12 * SizeConfig.heightMultiplier!,
          ),

          ///like and comment buttons
          Row(
            children: [
              ///like button
              SizedBox(
                width: 16 * SizeConfig.widthMultiplier!,
              ),
              Obx(
                () => InkWell(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    _trendingPostUIController.isLiked.value =
                        !_trendingPostUIController.isLiked.value;
                    hitLike!(_trendingPostUIController.isLiked.value);
                  },
                  child: _trendingPostUIController.isLiked.value
                      ? Icon(
                          Icons.favorite,
                          color: kRedColor,
                          size: 22.35 * SizeConfig.widthMultiplier!,
                        )
                      : Icon(
                          Icons.favorite_outline,
                          color: kGreyColor,
                          size: 22.35 * SizeConfig.widthMultiplier!,
                        ),
                ),
              ),
              SizedBox(
                width: 6 * SizeConfig.widthMultiplier!,
              ),
              Text("${likeCount.toString()} " + "Likes".tr,
                  style: AppTextStyle.black600Text),

              Spacer(),

              ///comment button
              InkWell(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  //todo add comment onClick function
                  if (isAccountLive!) {
                  } else {}
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      ImagePath.commentIcon,
                      height: 20 * SizeConfig.imageSizeMultiplier!,
                      color: (isAccountLive!) ? kPureBlack : hintGrey,
                    ),
                    SizedBox(
                      width: 6 * SizeConfig.widthMultiplier!,
                    ),
                    Text(
                        (isAccountLive!)
                            ? "${liveCommentCount} " + "in_live_chat".tr
                            : "live_chat".tr,
                        style: (isAccountLive!)
                            ? AppTextStyle.normalPureBlackTextWithWeight600
                            : AppTextStyle.greyTextWithWeight600),
                    SizedBox(
                      width: 16 * SizeConfig.widthMultiplier!,
                    ),
                  ],
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 12 * SizeConfig.heightMultiplier!),
            width: double.infinity,
            height: 12 * SizeConfig.heightMultiplier!,
            color: kLightGrey,
          ),
        ],
      ),
    );
  }

  _getWidgetInfo() {
    Future.delayed(Duration(milliseconds: 50), () {
      final RenderBox renderBox =
          _widgetKey.currentContext!.findRenderObject() as RenderBox;
      final Size size = renderBox.size; // or _widgetKey.currentContext?.size
      _trendingPostUIController.height.value = renderBox.size.height;
    });
  }
}
