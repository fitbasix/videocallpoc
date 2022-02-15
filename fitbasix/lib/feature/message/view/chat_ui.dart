import 'dart:async';

import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';
import 'package:quickblox_sdk/models/qb_filter.dart';
import 'package:quickblox_sdk/models/qb_message.dart';
import 'package:quickblox_sdk/models/qb_sort.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_palette.dart';
import '../../../core/reponsive/SizeConfig.dart';

class ChatScreen extends StatefulWidget {
  QBDialog? userDialogForChat;

  ChatScreen({Key? key,this.userDialogForChat}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  HomeController _homeController = Get.find();
  QBDialog? userDialogForChat;
  final TextEditingController _massageController = TextEditingController();

  @override
  void dispose() {
    if(_massageStreamSubscription != null) {
      _massageStreamSubscription!.cancel();
      _massageStreamSubscription = null;
    }

    super.dispose();
  }

  void sendMsg(String messageBody) async {
    print(userDialogForChat!.id!);
    String dialogId = userDialogForChat!.id!;
    bool saveToHistory = true;
    try {
      await QB.chat.sendMessage(dialogId, body: messageBody, saveToHistory: saveToHistory).then((value){
        print("msg send");
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  getMassageFromHistory() async {
    QBSort sort = QBSort();
    sort.field = QBChatMessageSorts.DATE_SENT;
    sort.ascending = false;

    try {
      List<QBMessage?>? messageslist = await QB.chat.getDialogMessages(userDialogForChat!.id!,sort: sort);
      setState(() {
        messages = messageslist;
      });
    } on PlatformException catch (e) {
      // Some error occurred, look at the exception message for more details
    }
  }

  StreamSubscription? _massageStreamSubscription;
  String event = QBChatEvents.RECEIVED_NEW_MESSAGE;
  @override
  void initState() {
    userDialogForChat = widget.userDialogForChat;
    initMassage();
    getMassageFromHistory();
    super.initState();

  }

  void initMassage() async {
    try {
      _massageStreamSubscription = await QB.chat.subscribeChatEvent(event, (data) {
        Map<dynamic, dynamic> map = Map<dynamic, dynamic>.from(data);
        Map<dynamic, dynamic> payload = Map<dynamic, dynamic>.from(map["payload"]);
        String? messageId = payload["id"];
        print(payload.toString()+"Kashif msg");
        getMassageFromHistory();


        //messages!.add(payload);
      });
    } on PlatformException catch (e) {
      // Some error occurred, look at the exception message for more details
    }
  }


  List<QBMessage?>? messages;

  @override
  Widget build(BuildContext context) {
    // final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    // if (arguments.containsKey("dialogId")) {
    //   userDialogForChat = arguments["dialogId"];
    //
    // }
    return Scaffold(
      appBar: AppbarforChat(
        parentContext: context,
        trainertitle: 'Jonathan Swift'.tr,
        trainerstatus: 'Online'.tr,
      ),
      body: SafeArea(
        child: Container(
          color: Color(0xffE5E5E5).withOpacity(0.5),
          child: Column(
            children: [
              (messages != null)?Expanded(child: ListView.builder(
                reverse: true,
                physics: const BouncingScrollPhysics(),
                itemCount: messages!.length,
                itemBuilder: (context, index) =>(messages![index]!.senderId == _homeController.userQuickBloxId.value)?
                    MessageBubbleSender(message: ChatMessage(text: messages![index]!.body!),):MessageBubbleOpponent(message: ChatMessage(text: messages![index]!.body!),)
              ),):Expanded(child: Center(child: Text("no massage yey"),)),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.all(16 * SizeConfig.widthMultiplier!),
                  height: 76 * SizeConfig.heightMultiplier!,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      Container(
                          height: 44 * SizeConfig.heightMultiplier!,
                          width: 280 * SizeConfig.widthMultiplier!,
                          decoration: BoxDecoration(
                            color: kPureWhite,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: _massageController,
                            onChanged: (value){
                              setState(() {

                              });
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 16*SizeConfig.widthMultiplier!,top: 12*SizeConfig.heightMultiplier!),
                                hintText: "message".tr,
                                hintStyle: AppTextStyle.hsmallhintText,
                                border: InputBorder.none,
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        onPressed: (){},
                                        icon: SvgPicture.asset(
                                          ImagePath.attachdocumentIcon,
                                          width: 9.17 * SizeConfig.widthMultiplier!,
                                          height: 18.34 * SizeConfig.heightMultiplier!,
                                        )),
                                    IconButton(
                                        onPressed: (){},
                                        icon: SvgPicture.asset(
                                          ImagePath.openCameraIcon,
                                          width: 15 * SizeConfig.widthMultiplier!,
                                          height: 13.57 * SizeConfig.heightMultiplier!,
                                        )),
                                  ],
                                )
                            ),
                            // maxLines: 3,
                          )
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 8,
                            bottom: 4),
                        child: CircleAvatar(
                          backgroundColor: greenChatColor,
                          child: (_massageController.text.isNotEmpty)?IconButton(
                              onPressed: (){
                                sendMsg(_massageController.text);
                                _massageController.clear();
                              },
                              icon: Icon(
                                Icons.send,
                                size: 16 * SizeConfig.heightMultiplier!,
                                color: Colors.white,
                              )):IconButton(
                              onPressed: (){},
                              icon: SvgPicture.asset(
                                ImagePath.chatMicIcon,
                                width: 16 * SizeConfig.widthMultiplier!,
                                height: 16 * SizeConfig.heightMultiplier!,
                              )),
                        ),
                      )
                    ],
                  ),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//  Message Bubble
class MessageBubbleSender extends StatelessWidget {
  const MessageBubbleSender({Key? key, this.message}) : super(key: key);

  final ChatMessage? message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0 * SizeConfig.heightMultiplier!,right: 16*SizeConfig.widthMultiplier!),
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
            Container(
            constraints: BoxConstraints(
              maxWidth: 300 * SizeConfig.widthMultiplier!,
            ),
            padding: EdgeInsets.symmetric(
              vertical: 10.0 * SizeConfig.heightMultiplier!,
              horizontal: 10.0 * SizeConfig.widthMultiplier!,
            ),
            decoration: BoxDecoration(
              color: greenChatColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(message!.text.toString(),
            style: AppTextStyle.white400Text),
          )
        ],
      ),
    );
  }
}

//  Message Bubble
class MessageBubbleOpponent extends StatelessWidget {
  const MessageBubbleOpponent({Key? key, this.message}) : super(key: key);

  final ChatMessage? message;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0 * SizeConfig.heightMultiplier!,left: 16*SizeConfig.widthMultiplier!),
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: 300 * SizeConfig.widthMultiplier!,
            ),
            padding: EdgeInsets.symmetric(
              vertical: 10.0 * SizeConfig.heightMultiplier!,
              horizontal: 10.0 * SizeConfig.widthMultiplier!,
            ),
            decoration: BoxDecoration(
              color: kPureWhite,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(message!.text.toString(),
                style: AppTextStyle.black400Text),
          )
        ],
      ),
    );
  }
}
// demo message list class
class ChatMessage{
  final String? text;
  ChatMessage({
    this.text
});
}

// Appbar
class AppbarforChat extends StatelessWidget with PreferredSizeWidget {

  String trainerProfilePicUrl =
      'http://www.pixelmator.com/community/download/file.php?avatar=17785_1569233053.png';
  String? trainertitle;
  String? trainerstatus;
  BuildContext? parentContext;
  AppbarforChat({Key? key, this.trainertitle, this.parentContext,this.trainerstatus})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: kPureWhite,
      elevation: 0,
      title: Row(
        children: [
          SizedBox(
            width: 7 * SizeConfig.widthMultiplier!,
          ),
          GestureDetector(
              onTap: () {
                Navigator.pop(parentContext!);
              },
              child: SvgPicture.asset(
                ImagePath.backIcon,
                width: 7.41 * SizeConfig.widthMultiplier!,
                height: 12 * SizeConfig.heightMultiplier!,
                fit: BoxFit.contain,
              )),
          SizedBox(
            width: 16.59 * SizeConfig.widthMultiplier!,
          ),
          CircleAvatar(
            child: Image.network(
              trainerProfilePicUrl,
              width: 40 * SizeConfig.widthMultiplier!,
              height: 40 * SizeConfig.heightMultiplier!,
            ),
          ),
          SizedBox(
            width: 12 * SizeConfig.widthMultiplier!,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(trainertitle ?? "",
                  style: AppTextStyle.hnormal600BlackText),
              Text(trainerstatus ?? "",
                  style: AppTextStyle.hsmallGreenText),
            ],
          ),
        ],
      ),
      actions: [
        //document icon
          IconButton(
              onPressed: (){},
              icon: SvgPicture.asset(
             ImagePath.chatdocumentIcon,
             width: 16 * SizeConfig.widthMultiplier!,
             height: 20 * SizeConfig.heightMultiplier!,
          )),
          // popupmenu icon
          IconButton(
            onPressed: (){},
             icon: SvgPicture.asset(
              ImagePath.chatpopupmenuIcon,
              width: 4 * SizeConfig.widthMultiplier!,
              height: 20 * SizeConfig.heightMultiplier!,
            )),
       ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
