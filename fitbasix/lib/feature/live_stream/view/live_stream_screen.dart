import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/feature/live_stream/controller/live_stream_controller.dart';
import 'package:fitbasix/feature/live_stream/view/scheduled_live_information_screen.dart';
import 'package:fitbasix/feature/live_stream/widget/date_picker_widget.dart';
import 'package:fitbasix/feature/live_stream/widget/trending_post_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/image_path.dart';
import '../../get_trained/view/widgets/custom_app_bar.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

class LiveStreamScreen extends StatelessWidget {
  LiveStreamScreen({Key? key}) : super(key: key);
  DateTime _currentDate = DateTime.now();
  int selectedIndex = 3;
  LiveStreamController _liveStreamController = Get.put(LiveStreamController());

  @override
  Widget build(BuildContext context) {
    _liveStreamController.pageTitle.value = "trainers".tr;
    return Scaffold(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        appBar: PreferredSize(
            //todo add appbar search feature
            child: AppBar(
              backgroundColor: kPureBlack,
              elevation: 0,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: SvgPicture.asset(
                    ImagePath.backIcon,
                    width: 7 * SizeConfig.widthMultiplier!,
                    height: 12 * SizeConfig.heightMultiplier!,
                    color: Theme.of(context).textTheme.bodyText1?.color,
                  )),
              title: Obx(() => _liveStreamController.isSearchActive.value
                  ? Transform(
                      transform: Matrix4.translationValues(
                          -20 * SizeConfig.widthMultiplier!, 0, 0),
                      child: Container(
                        height: 32 * SizeConfig.heightMultiplier!,
                        decoration: BoxDecoration(
                          color: lightGrey,
                          borderRadius: BorderRadius.circular(
                              8 * SizeConfig.widthMultiplier!),
                        ),
                        child: Center(
                          child: TextField(
                            controller: _liveStreamController.searchController,
                            style: AppTextStyle.smallGreyText.copyWith(
                                fontSize: 14 * SizeConfig.textMultiplier!,
                                color: kBlack),
                            onChanged: (value) async {
                              //todo add search functionality in live stream appbar
                            },
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(
                                    left: 10.5 * SizeConfig.widthMultiplier!,
                                    right: 5),
                                child: Icon(
                                  Icons.search,
                                  color: hintGrey,
                                  size: 22 * SizeConfig.heightMultiplier!,
                                ),
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  _liveStreamController
                                              .searchController.text.length ==
                                          0
                                      ? _liveStreamController
                                          .isSearchActive.value = false
                                      : _liveStreamController.searchController
                                          .clear();
                                },
                                child: Icon(
                                  Icons.clear,
                                  color: hintGrey,
                                  size: 18 * SizeConfig.heightMultiplier!,
                                ),
                              ),
                              border: InputBorder.none,
                              hintText: 'searchHintLiveStream'.tr,
                              hintStyle: AppTextStyle.smallGreyText.copyWith(
                                  fontSize: 14 * SizeConfig.textMultiplier!,
                                  color: hintGrey,
                                  height: 1.3),
                              /*contentPadding: EdgeInsets.only(
                                top: -2,
                              )*/
                            ),
                          ),
                        ),
                      ),
                    )
                  : Transform(
                      transform: Matrix4.translationValues(-20, 0, 0),
                      child: Text(
                        _liveStreamController.pageTitle.value,
                        style: AppTextStyle.titleText.copyWith(
                            fontSize: 16 * SizeConfig.textMultiplier!),
                      ),
                    )),
              actions: [
                Obx(() => _liveStreamController.isSearchActive.value
                    ? SizedBox()
                    : IconButton(
                        onPressed: () {
                          _liveStreamController.isSearchActive.value = true;
                        },
                        icon: Icon(
                          Icons.search,
                          color: kBlue,
                          size: 25 * SizeConfig.heightMultiplier!,
                        )))
              ],
            ),
            preferredSize: const Size(double.infinity, kToolbarHeight)),
        body: ListView(physics: const BouncingScrollPhysics(), children: [
          ///date selector and trending posts
          Container(
            color: Theme.of(context).secondaryHeaderColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///display current month
                Padding(
                    padding: EdgeInsets.only(
                        left: 16 * SizeConfig.widthMultiplier!,
                        bottom: 17 * SizeConfig.heightMultiplier!,
                        top: 15 * SizeConfig.heightMultiplier!),
                    child: Text(
                      DateFormat.MMMM().format(DateTime.now()),
                      style: AppTextStyle.normalWhiteText.copyWith(
                          color: Theme.of(context).textTheme.bodyText1?.color),
                    )),

                ///date changer
                CustomDatePickerWidget(
                  currentDate: DateTime.now(),
                  onChanged: (selectedDate) {
                    //todo add on date change functionality
                  },
                ),
                Container(
                  margin:
                      EdgeInsets.only(top: 20 * SizeConfig.heightMultiplier!),
                  width: double.infinity,
                  height: 12 * SizeConfig.heightMultiplier!,
                  color: kPureBlack,
                ),
                Padding(
                    padding: EdgeInsets.only(
                        left: 16 * SizeConfig.widthMultiplier!,
                        bottom: 10 * SizeConfig.heightMultiplier!,
                        top: 15 * SizeConfig.heightMultiplier!),
                    child: Text(
                      "trending_posts".tr,
                      style: AppTextStyle.NormalBlackTitleText.copyWith(
                          color: Theme.of(context).textTheme.bodyText1?.color),
                    )),
              ],
            ),
          ),

          ///trending posts and lives goes here
          TrendingPostUI(
            isAccountLive: true,
            onTap: () {
              print("Called");
            },
            hitLike: (hitLike) {},
          ),
          TrendingPostUI(
            onTap: () {
              //if user is not live
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScheduledLiveInformationScreen(
                            imageUrl:
                                "https://www.slazzer.com/static/images/home-page/banner-orignal-image.jpg",
                          )));
            },
            isAccountLive: false,
            hitLike: (hitLike) {},
          )
        ]));
  }
}
