import 'dart:ui';

import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/get_trained/controller/trainer_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';
import 'package:quickblox_sdk/models/qb_sort.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/image_path.dart';
import '../../../core/reponsive/SizeConfig.dart';
import '../../../core/routes/app_routes.dart';
import '../../get_trained/model/get_trained_model.dart';
import '../../get_trained/services/trainer_services.dart';
import 'chat_ui.dart';

class MyTrainerTileScreen extends StatefulWidget {

  MyTrainerTileScreen({
    Key? key,
    this.chatHistoryList,
   
  }) : super(key: key);



  List<QBDialog>? chatHistoryList;

  

  @override
  State<MyTrainerTileScreen> createState() => _MyTrainerTileScreenState();
}

class _MyTrainerTileScreenState extends State<MyTrainerTileScreen> {
  TrainerController _trainerController = Get.find();

  ScrollController _scrollController = ScrollController();

  bool isMessageLoading = false;

 final HomeController _homeController = Get.find();
 

  @override
  Widget build(BuildContext context) {
    RxList<MyTrainer>? myTrainers= _trainerController.trainers.value.response!.data!.myTrainers!.obs;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                ImagePath.backIcon,
                width: 7 * SizeConfig.widthMultiplier!,
                height: 12 * SizeConfig.heightMultiplier!,
                color: Theme.of(context).primaryColor,
              ),
            )),
        title: Obx(() => _trainerController.isMyTrainerSearchActive.value
            ? Transform(
          transform: Matrix4.translationValues(
              -20 * SizeConfig.widthMultiplier!, 0, 0),
          child: Container(
            height: 32 * SizeConfig.heightMultiplier!,
            decoration: BoxDecoration(
              color: kLightGrey,
              borderRadius: BorderRadius.circular(
                  8 * SizeConfig.widthMultiplier!),
            ),
            child: TextField(
              controller: _trainerController.searchMyTrainerController,
              style: AppTextStyle.smallGreyText.copyWith(
                  fontSize: 14 * SizeConfig.textMultiplier!,
                  color: kBlack),
              onChanged: (value) async {
                if (_trainerController.searchMyTrainer.value != value) {
                  _trainerController.searchMyTrainer.value = value;
                  if (value.length >= 3) {
                    _trainerController.trainerFilterIsLoading.value = true;
                    _trainerController.searchedMyTrainerName.value = value;
                    myTrainers.value =
                    await TrainerServices.getMyTrainers(
                      name: value,
                    );
                    _scrollController.jumpTo(0);
                    _trainerController.trainerFilterIsLoading.value = false;
                    //setState(() {});
                  }
                  if (value.length == 0) {
                    _trainerController.trainerFilterIsLoading.value = true;
                    _trainerController.searchedMyTrainerName.value = value;
                    myTrainers.value =
                    await TrainerServices.getMyTrainers(
                      name: value,
                    );
                    _scrollController.jumpTo(0);
                    _trainerController.trainerFilterIsLoading.value = false;
                    //setState(() {});
                  }
                }
              },
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: EdgeInsets.only(
                      left: 10.5 * SizeConfig.widthMultiplier!,
                      right: 5 * SizeConfig.widthMultiplier!),
                  child: Icon(
                    Icons.search,
                    color: hintGrey,
                    size: 22 * SizeConfig.heightMultiplier!,
                  ),
                ),
                suffixIcon: GestureDetector(
                  onTap: () async {
                    _trainerController.searchMyTrainerController.text.length ==
                        0
                        ? _trainerController.isMyTrainerSearchActive.value =
                    false
                        : _trainerController.searchMyTrainerController.clear();
                    _trainerController.trainerFilterIsLoading.value = true;
                    _trainerController.searchedMyTrainerName.value = "";
                    myTrainers.value =
                    await TrainerServices.getMyTrainers(
                      name: "",
                    );
                    _scrollController.jumpTo(0);
                    _trainerController.trainerFilterIsLoading.value = false;
                    // setState(() {
                    // });

                  },
                  child: Icon(
                    Icons.clear,
                    color: hintGrey,
                    size: 18 * SizeConfig.heightMultiplier!,
                  ),
                ),
                border: InputBorder.none,
                hintText: 'searchHint'.tr,
                hintStyle: AppTextStyle.smallGreyText.copyWith(
                    fontSize: 14 * SizeConfig.textMultiplier!,
                    color: hintGrey),
                /*contentPadding: EdgeInsets.only(
                              top: -2,
                            )*/
              ),
            ),
          ),
        )
            : Transform(
          transform: Matrix4.translationValues(-20, 0, 0),
          child: Text(
            'my_trainer'.tr,
            style: AppTextStyle.titleText.copyWith(
                color: Theme.of(context)
                    .appBarTheme
                    .titleTextStyle
                    ?.color,
                fontSize: 16 * SizeConfig.textMultiplier!),
          ),
        )),
        actions: [
          Obx(() => _trainerController.isMyTrainerSearchActive.value
              ? SizedBox()
              : IconButton(
              onPressed: () {
                _trainerController.isMyTrainerSearchActive.value = true;
              },
              icon: Icon(
                Icons.search,
                color: Theme.of(context).primaryColor,
                size: 25 * SizeConfig.heightMultiplier!,
              )))
        ],

        // Padding(
        //     padding: EdgeInsets.only(left: 5*SizeConfig.widthMultiplier!),
        //     child: Text(, style: AppTextStyle.hblack600Text.copyWith(color: Theme.of(context).textTheme.bodyText1!.color))),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //
        //       },
        //       icon: Icon(
        //         Icons.search,
        //         color: Theme.of(context).primaryColor,
        //         size: 25 * SizeConfig.heightMultiplier!,
        //       )),
        // ],
      ),
      body: Obx(
        ()=> (myTrainers.isNotEmpty)?ListView.builder(
            controller: _scrollController,
            itemCount: myTrainers.value!.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              int indexWhereChatPresent = -1;
              if(widget.chatHistoryList != null&&widget.chatHistoryList![0].lastMessage!=null){
                indexWhereChatPresent = widget.chatHistoryList!.indexWhere((element) => element.occupantsIds!.contains(myTrainers.value![index].quickBlox));
              }
              return TrainersTileUI(
                taggedPersonList: myTrainers.value![index].strengths!.isNotEmpty?List.generate(myTrainers.value![index].strengths!.length, (i) => myTrainers.value![index].strengths![i].name!):[],
                trainerName: myTrainers.value![index].name,
                lastMessage: indexWhereChatPresent!=-1?widget.chatHistoryList![indexWhereChatPresent].lastMessage!.capitalized():"",
                trainerProfilePicUrl: myTrainers.value![index].profilePhoto,
                isCurrentlyEnrolled:myTrainers.value![index].isCurrentlyEnrolled,
                userHasChatHistory:indexWhereChatPresent!=-1?true:false,
                enrolledDate: myTrainers.value![index].isCurrentlyEnrolled!?myTrainers.value![index].startDate:myTrainers.value![index].endDate,
                lastMessageTime: indexWhereChatPresent!=-1?widget.chatHistoryList![indexWhereChatPresent].lastMessageDateSent:0,
                onTrainerTapped: ()async{

                  if (!isMessageLoading) {
                    isMessageLoading = true;
                    bool dialogCreatedPreviously = false;
                    int openPage = 0;
                    //133817477	user1
                    //133815819 trainer1
                    //133612091 trainer
                    final sharedPreferences = await SharedPreferences.getInstance();
                    _homeController.userQuickBloxId.value =
                    sharedPreferences.getInt("userQuickBloxId")!;
                    int UserQuickBloxId = myTrainers.value![index].quickBlox!;//133819788;
                    String trainerName = myTrainers.value![index].name!;
                    bool isCurrentlyEnrolled = myTrainers.value![index].isCurrentlyEnrolled!;

                    print(UserQuickBloxId.toString() +
                        "this is opponent id\n${_homeController.userQuickBloxId.value} this is sender id");
                    QBSort sort = QBSort();
                    sort.field = QBChatDialogSorts.LAST_MESSAGE_DATE_SENT;
                    sort.ascending = true;
                    try {
                      List<QBDialog?> dialogs = await QB.chat
                          .getDialogs(
                        sort: sort,
                      )
                          .then((value) async {
                        for (int i = 0; i < value.length; i++) {
                          if (value[i]!.occupantsIds!.contains(
                              _homeController.userQuickBloxId.value) &&
                              value[i]!.occupantsIds!.contains(UserQuickBloxId)) {
                            dialogCreatedPreviously = true;
                            print(value[i]!.id.toString() + "maxxxx");

                            isMessageLoading = false;
                            if (openPage < 1) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                        userDialogForChat: value[i],
                                        opponentID: UserQuickBloxId,
                                        trainerTitle:trainerName,
                                        isCurrentlyEnrolled: isCurrentlyEnrolled,
                                        profilePicURL: myTrainers.value![index].profilePhoto!,
                                        trainerId: myTrainers.value![index].user,
                                      )));

                              ++openPage;
                            }
                            isMessageLoading = false;
                            break;
                          }
                        }
                        if (!dialogCreatedPreviously) {
                          List<int> occupantsIds = [
                            _homeController.userQuickBloxId.value,
                            UserQuickBloxId
                          ];
                          String dialogName = UserQuickBloxId.toString() +
                              _homeController.userQuickBloxId.value.toString() +
                              DateTime.now().millisecond.toString();
                          int dialogType = QBChatDialogTypes.CHAT;
                          print("got here too");
                          try {
                            QBDialog? createdDialog = await QB.chat
                                .createDialog(
                              occupantsIds,
                              dialogName,
                              dialogType: QBChatDialogTypes.CHAT,
                            )
                                .then((value) {
                              print("dialog id is:" + value!.id!);
                              isMessageLoading = false;
                              if (openPage < 1) {
                                isMessageLoading = false;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                            userDialogForChat: value,
                                            opponentID: UserQuickBloxId,
                                            trainerTitle: trainerName,
                                            isCurrentlyEnrolled: isCurrentlyEnrolled,
                                          profilePicURL: myTrainers.value![index].profilePhoto!,
                                          trainerId: myTrainers.value![index].user,
                                        )));
                                ++openPage;
                              }
                            });
                          } on PlatformException catch (e) {
                            isMessageLoading = false;
                            print(e.toString());
                          }
                        }
                        return value;
                      });
                    } on PlatformException catch (e) {
                      isMessageLoading = false;
                      // some error occurred, look at the exception message for more details
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Message is loading")));
                  }

                },
              );
            },
        ):Container(
          margin: EdgeInsets.only(top: 110*SizeConfig.heightMultiplier!),
          child: Container(
            padding: EdgeInsets.only(
                top: 71 * SizeConfig.heightMultiplier!,
                left: 56 * SizeConfig.widthMultiplier!,
                right:
                55 * SizeConfig.widthMultiplier!),
            child: Column(
              children: [
                Image.asset(
                  ImagePath.nomatchesfoundImage,
                  height: 102 *
                      SizeConfig.heightMultiplier!,
                  width:
                  100 * SizeConfig.widthMultiplier!,
                ),
                SizedBox(
                  height: 8.78 *
                      SizeConfig.heightMultiplier!,
                ),
                Text(
                  'no_matches_description'.tr,
                  style: AppTextStyle.black400Text
                      .copyWith(
                      fontSize:
                      (24) *
                          SizeConfig
                              .textMultiplier!,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.color),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height:
                  8 * SizeConfig.heightMultiplier!,
                ),
                Text(
                  'different_search'.tr,
                  style: AppTextStyle.black400Text
                      .copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.color),
                ),
              ],
            ),
          ),
        ),
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
      this.lastMessage,
      this.isCurrentlyEnrolled,
      this.userHasChatHistory,
      this.enrolledDate,
      this.lastMessageTime,
      this.onTrainerTapped})
      : super(key: key);
  List<String> taggedPersonList;
  String? trainerName;
  String? lastMessage;
  String? trainerProfilePicUrl;
  bool? isCurrentlyEnrolled;
  bool? userHasChatHistory = true;
  DateTime? enrolledDate;
  int? lastMessageTime;
  var lastMessageDateToShow = "".obs;
  GestureTapCallback? onTrainerTapped;

  @override
  Widget build(BuildContext context) {
    setLastMessageDate();
    return GestureDetector(
      onTap: onTrainerTapped,
      child: Container(
        margin: EdgeInsets.only(bottom: 8 * SizeConfig.heightMultiplier!),
        color: Theme.of(context).secondaryHeaderColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        backgroundImage: NetworkImage(
                          trainerProfilePicUrl!,
                        ),
                        radius: 25 * SizeConfig.imageSizeMultiplier!,
                      ),
                    )),
                SizedBox(
                  width: 12 * SizeConfig.widthMultiplier!,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(trainerName!.isNotEmpty ? trainerName! : "Loading..",
                        style: AppTextStyle.hnormal600BlackText.copyWith(
                            color: isCurrentlyEnrolled!
                                ? Theme.of(context).textTheme.bodyText1!.color
                                : greyB7)),
                    //_taggedBar Widget
                    (taggedPersonList.isNotEmpty)?_taggedBar(list: taggedPersonList,context: context):Container()

                  ],
                ),
                Spacer(),
                Obx(
                  () => lastMessageDateToShow.value.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.only(
                              right: 16 * SizeConfig.widthMultiplier!),
                          child: Text(
                              userHasChatHistory!
                                  ? lastMessageDateToShow.value
                                  : "",
                              style: AppTextStyle.hsmallhintText),
                        )
                      : Container(),
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
                child: Text(
                    lastMessage!.isNotEmpty
                        ? lastMessage!
                        : (userHasChatHistory!
                            ? "loading..."
                            : "lets_start_conversation".tr),
                    style: AppTextStyle.hmedium13Text.copyWith(
                        color: isCurrentlyEnrolled!
                            ? Theme.of(context).textTheme.bodyText1!.color
                            : greyB7)),
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 16 * SizeConfig.widthMultiplier!,
                    bottom: 24 * SizeConfig.heightMultiplier!),
                child: Row(
                  children: [
                    Text(
                        isCurrentlyEnrolled!
                            ? 'enrolled_on'.tr
                            : "enrolled_end_on",
                        style: AppTextStyle.hsmallhintText),
                    SizedBox(
                      width: 4 * SizeConfig.widthMultiplier!,
                    ),
                    Text(DateFormat("d MMM yyyy").format(enrolledDate!),
                        style: isCurrentlyEnrolled!
                            ? AppTextStyle.hsmallGreenText
                            : AppTextStyle.hsmallGreenText
                                .copyWith(color: hintGrey))
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
                contentPadding: EdgeInsets.symmetric(
                    vertical: 30 * SizeConfig.heightMultiplier!),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8 * SizeConfig.imageSizeMultiplier!)),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      trainerName!,
                      style: AppTextStyle.black400Text.copyWith(
                          color: Theme.of(context).textTheme.bodyText1!.color),
                    ),
                    SizedBox(
                      height: 26 * SizeConfig.heightMultiplier!,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            ImagePath.penIcon,
                            color: Theme.of(context).primaryColor,
                            height: 15 * SizeConfig.imageSizeMultiplier!,
                          ),
                          SizedBox(
                            width: 10.5 * SizeConfig.widthMultiplier!,
                          ),
                          Text(
                            'Open profile',
                            style: AppTextStyle.black400Text.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 22 * SizeConfig.heightMultiplier!,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            ImagePath.muteBell,
                            color: Theme.of(context).primaryColor,
                            height: 15 * SizeConfig.imageSizeMultiplier!,
                          ),
                          SizedBox(
                            width: 10.5 * SizeConfig.widthMultiplier!,
                          ),
                          Text(
                            'Mute notifications',
                            style: AppTextStyle.black400Text.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 22 * SizeConfig.heightMultiplier!,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            ImagePath.penIcon,
                            color: Theme.of(context).primaryColor,
                            height: 15 * SizeConfig.imageSizeMultiplier!,
                          ),
                          SizedBox(
                            width: 10.5 * SizeConfig.widthMultiplier!,
                          ),
                          Text(
                            'Mark as unread',
                            style: AppTextStyle.black400Text.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }

  setLastMessageDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    DateTime dateOfFile =
        DateTime.fromMicrosecondsSinceEpoch(lastMessageTime! * 1000);
    final checkDate =
        DateTime(dateOfFile.year, dateOfFile.month, dateOfFile.day);
    if (checkDate == today) {
      lastMessageDateToShow.value = "Today";
    } else if (checkDate == yesterday) {
      lastMessageDateToShow.value = "Yesterday";
    } else {
      lastMessageDateToShow.value = DateFormat("dd MMM yy").format(checkDate);
    }
  }

  Widget _taggedBar({List<String>? list, required BuildContext context}) {
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
                style: AppTextStyle.lightMediumBlackText.copyWith(
                    color: Theme.of(context).textTheme.bodyText1!.color),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 8 * SizeConfig.widthMultiplier!,
        ),
        list.length > 1
            ? Container(
                height: 28 * SizeConfig.heightMultiplier!,
                decoration: BoxDecoration(
                    color: Color(0xff747474),
                    borderRadius: BorderRadius.circular(
                        28 * SizeConfig.heightMultiplier!)),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 12 * SizeConfig.widthMultiplier!),
                  child: Center(
                    child: Text(
                      '+' + (list.length - 1).toString().tr,
                      style: AppTextStyle.lightMediumBlackText.copyWith(
                          color: Theme.of(context).textTheme.bodyText1!.color),
                    ),
                  ),
                ),
              )
            : Container(),
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
