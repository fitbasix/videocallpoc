import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/image_path.dart';
import '../../../core/reponsive/SizeConfig.dart';
import '../../../core/routes/app_routes.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

String name = 'Veronica Taylor';
String followerscount = '345';
String followingcount = '52';
String about_user = 'Hi, This is Jonathan. I am certified by Institute Viverra cras facilisis massa amet,'
    ' hendrerit nunc. Tristique tellus, massa scelerisque tincidunt neque dui metus,'
    ' id pellentesque.'

    'Let’s start your fitness journey!!!';
String Imageurl = 'http://www.pixelmator.com/community/download/file.php?avatar=17785_1569233053.png';
String coverimageUrl = 'https://media.istockphoto.com/photos/blue-sky-with-scattered-clouds-picture-id106577335?k=20&m=106577335&s=170667a&w=0&h=ezJ6lRDtUbLfc5nZDJNNudEJdGBK2JCEPGFIiQnzZyY=';

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserPageInfo(
        username: name.tr,
        userfollowerscount: followerscount,
        userfollowingscount: followingcount,
        aboutuser: about_user.tr,
        userImage: Imageurl,
        userCoverImage: coverimageUrl,
        oneditprofile: (){
          Navigator.pushNamed(
              context, RouteName.edituserProfileScreen);
        },
        oneditcoverimage: (){},
      ),
    );
  }
}

class UserPageInfo extends StatefulWidget {
  const UserPageInfo({
    this.username,this.userImage,this.userCoverImage,
    this.userfollowerscount,this.userfollowingscount,
    this.aboutuser,this.oneditprofile,this.oneditcoverimage,
    Key? key}) : super(key: key);

  final String? username;
  final String? userImage;
  final String? userCoverImage;
  final String? userfollowerscount;
  final String? userfollowingscount;
  final String? aboutuser;
  final VoidCallback? oneditprofile;
  final VoidCallback? oneditcoverimage;
  @override
  _UserPageInfoState createState() => _UserPageInfoState();
}

class _UserPageInfoState extends State<UserPageInfo> {

  //demo user interest list for design purpose
  List<String> userinterestlist = [
    "Sports Nutrition",
    "Fat-loss",
    "General Well being",
    "Muscle-gain",
    "Improve Imunity",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPureWhite,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                left: 152 * SizeConfig.widthMultiplier!),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 187 * SizeConfig.heightMultiplier!,
                                ),
                                Text(
                                  widget.username!,
                                  style: AppTextStyle.titleText.copyWith(
                                      fontSize:
                                          18 * SizeConfig.textMultiplier!),
                                ),
                                SizedBox(
                                  height: 14 * SizeConfig.heightMultiplier!,
                                ),
                                GestureDetector(
                                  onTap: widget.oneditprofile!,
                                  child: Container(
                                    height: 28 * SizeConfig.heightMultiplier!,
                                    width: 141 * SizeConfig.widthMultiplier!,
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            4 * SizeConfig.heightMultiplier!,
                                        horizontal:
                                            16 * SizeConfig.widthMultiplier!),
                                    decoration: BoxDecoration(
                                        color: greyB7,
                                        borderRadius: BorderRadius.circular(8.0)),
                                    child: Center(
                                      child: Text(
                                        'edit_yourprofile'.tr,
                                        style: AppTextStyle.greenSemiBoldText
                                            .copyWith(color: kPureWhite),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 24 * SizeConfig.heightMultiplier!,
                          ),
                          //Follwers & followimg
                          Padding(
                            padding: EdgeInsets.only(
                              top: 11 * SizeConfig.heightMultiplier!,
                                left: 16.0 * SizeConfig.widthMultiplier!,
                                right: 27 * SizeConfig.widthMultiplier!),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.userfollowerscount!,
                                        style:
                                            AppTextStyle.hmedium13Text.copyWith(
                                          fontSize:
                                              (18) * SizeConfig.textMultiplier!,
                                        )),
                                    SizedBox(
                                      height: 4 * SizeConfig.heightMultiplier!,
                                    ),
                                    Text('follower'.tr,
                                        style: AppTextStyle.hmediumBlackText
                                            .copyWith(
                                          fontSize:
                                              (12) * SizeConfig.textMultiplier!,
                                        )),
                                  ],
                                ),
                                SizedBox(
                                    width: 32 * SizeConfig.widthMultiplier!),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.userfollowingscount!,
                                        style:
                                            AppTextStyle.hmedium13Text.copyWith(
                                          fontSize:
                                              (18) * SizeConfig.textMultiplier!,
                                        )),
                                    SizedBox(
                                      height: 4 * SizeConfig.heightMultiplier!,
                                    ),
                                    Text('following'.tr,
                                        style: AppTextStyle.hmediumBlackText
                                            .copyWith(
                                          fontSize:
                                              (12) * SizeConfig.textMultiplier!,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24 * SizeConfig.heightMultiplier!),
                          //About
                          Padding(
                            padding: EdgeInsets.only(
                                left: 16.0 * SizeConfig.widthMultiplier!,
                                right: 32 * SizeConfig.widthMultiplier!),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'about'.tr,
                                  style: AppTextStyle.hblackSemiBoldText,
                                ),
                                SizedBox(
                                  height: 12 * SizeConfig.heightMultiplier!,
                                ),
                                Text( widget.aboutuser!,
                              style: AppTextStyle.hblackSemiBoldText.copyWith(
                                fontWeight: FontWeight.w400,),
                                 ),
                                SizedBox(
                                  height: 24 * SizeConfig.heightMultiplier!,
                                ),
                                Text(
                                  'interested_in'.tr,
                                  style: AppTextStyle.hblackSemiBoldText,
                                ),
                                SizedBox(
                                  height: 12 * SizeConfig.heightMultiplier!,
                                ),
                              // common user interest list using a demo list
                              _userinterestBar(list: userinterestlist),
                              ],
                            ),
                          )
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        height: 177 * SizeConfig.heightMultiplier!,
                        child: Image.network(
                          widget.userCoverImage!,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned(
                        top: 127 * SizeConfig.heightMultiplier!,
                        left: 16 * SizeConfig.widthMultiplier!,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 4 * SizeConfig.widthMultiplier!,
                                  color: kPureWhite),
                              shape: BoxShape.circle),
                          height: 120 * SizeConfig.widthMultiplier!,
                          width: 120 * SizeConfig.widthMultiplier!,
                          child: CircleAvatar(
                          //  radius: 60 * SizeConfig.heightMultiplier!,
                            backgroundImage: NetworkImage(
                                widget.userImage!
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 16 * SizeConfig.heightMultiplier!,
                          left: 16 * SizeConfig.widthMultiplier!,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 40 * SizeConfig.heightMultiplier!,
                              width: 40 * SizeConfig.heightMultiplier!,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: SvgPicture.asset(
                                ImagePath.backIcon,
                                color: kPureBlack,
                                height: 12,
                                width: 7,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          )),
                      Positioned(
                          top: 16 * SizeConfig.heightMultiplier!,
                          right: 16 * SizeConfig.widthMultiplier!,
                          child: GestureDetector(
                            //open camera icon
                            onTap: widget.oneditcoverimage,
                            child: Container(
                              height: 40 * SizeConfig.heightMultiplier!,
                              width: 40 * SizeConfig.heightMultiplier!,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: grey34.withOpacity(0.5)),
                              child: SvgPicture.asset(
                                //replace icon with design
                                ImagePath.openCameraIcon,
                                color: kPureWhite,
                                height: 18,
                                width: 20,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          )),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

// user interest listview using demo list
  Widget _userinterestBar({List<String>? list}){
    return Container(
      height: 28 *
          SizeConfig.heightMultiplier!,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: list!.length,
          itemBuilder: (BuildContext context, int index){
            return Padding(
              padding: EdgeInsets.only(
                  left: 8.0 * SizeConfig.widthMultiplier!),
              child: Container(
                decoration: BoxDecoration(
                    color: greyF6,
                    borderRadius: BorderRadius.circular(
                        14 * SizeConfig.heightMultiplier!)
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 12 * SizeConfig.widthMultiplier!),
                  child: Center(
                    child: Text(
                      list[index],
                      style: AppTextStyle
                          .lightMediumBlackText.copyWith(
                        color: kBlack,
                      ),
                    ),
                  ),
                ),
              ),
            );
      }),
    );
  }

}
