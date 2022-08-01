import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/feature/chat_firebase/controller/firebase_chat_controller.dart';
import 'package:fitbasix/feature/chat_firebase/model/chat_model.dart';
import 'package:fitbasix/feature/chat_firebase/view/message_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ChatPage extends StatelessWidget {
  ChatPage({Key? key}) : super(key: key);

  final _chatController = Get.find<FirebaseChatController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPureBlack,
      appBar: AppbarforChat(
        onHangUpTapped: (value) async {},
        onMenuTap: () {},
        parentContext: context,
        trainertitle: _chatController.senderName,
        trainerstatus: '',
        trainerProfilePicUrl:
        _chatController.senderPhoto,
        // trainerProfilePicUrl: _chatController.senderPhoto,
      ),
      body: SafeArea(
        child: Column(
          children: [
            GetBuilder<FirebaseChatController>(
              id: 'message-list',
              builder: (_chatController) {
                return StreamBuilder<QuerySnapshot>(
                    stream: _chatController.firebaseService.getMessageStream(
                        chatId: _chatController.chatId,
                        userId: _chatController.userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Expanded(
                          child: Shimmer.fromColors(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Spacer(),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 16 * SizeConfig.widthMultiplier!),
                                  height: 28 * SizeConfig.heightMultiplier!,
                                  width: 176 * SizeConfig.widthMultiplier!,
                                  color: Color(0xFF3646464),
                                ),
                                SizedBox(
                                  height: 8 * SizeConfig.heightMultiplier!,
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 16 * SizeConfig.widthMultiplier!),
                                  height: 49 * SizeConfig.heightMultiplier!,
                                  width: 215 * SizeConfig.widthMultiplier!,
                                  color: Color(0xFF3646464),
                                ),
                                SizedBox(
                                  height: 8 * SizeConfig.heightMultiplier!,
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 16 * SizeConfig.widthMultiplier!),
                                  height: 28 * SizeConfig.heightMultiplier!,
                                  width: 176 * SizeConfig.widthMultiplier!,
                                  color: Color(0xFF3646464),
                                ),
                                SizedBox(height: 16 * SizeConfig.heightMultiplier!),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        right: 16 * SizeConfig.widthMultiplier!),
                                    height: 42 * SizeConfig.heightMultiplier!,
                                    width: 191 * SizeConfig.widthMultiplier!,
                                    color: Color(0xFF3646464),
                                  ),
                                ),
                                SizedBox(height: 16 * SizeConfig.heightMultiplier!),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 16 * SizeConfig.widthMultiplier!),
                                  height: 28 * SizeConfig.heightMultiplier!,
                                  width: 176 * SizeConfig.widthMultiplier!,
                                  color: Color(0xFF3646464),
                                ),
                                SizedBox(height: 16 * SizeConfig.heightMultiplier!),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        right: 16 * SizeConfig.widthMultiplier!),
                                    height: 78 * SizeConfig.heightMultiplier!,
                                    width: 232 * SizeConfig.widthMultiplier!,
                                    color: Color(0xFF3646464),
                                  ),
                                ),
                              ],
                            ),
                            baseColor: const Color.fromARGB(0, 255, 255, 255)
                                .withOpacity(0.1),
                            highlightColor: const Color.fromARGB(1, 255, 255, 255)
                                .withOpacity(0.46),
                          ),
                        );
                      } else {
                        var data = snapshot.data!.docs;
                        return Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            reverse: true,
                            // to display loading tile if more items
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return MessageTile(
                                index: index,
                                messageList: data,
                              );
                            },
                          ),
                        );
                      }
                    });
              }
            ),
            SendMessageWidget(),
          ],
        ),
      ),
    );
  }
}

class AppbarforChat extends StatelessWidget with PreferredSizeWidget {
  String? trainerProfilePicUrl;
  String? trainertitle;
  String? trainerstatus;
  BuildContext? parentContext;
  GestureTapCallback? onMenuTap;
  ValueChanged<bool>? onHangUpTapped;

  AppbarforChat(
      {Key? key,
      this.trainerProfilePicUrl,
      this.trainertitle,
      this.parentContext,
      this.trainerstatus,
      this.onMenuTap,
      this.onHangUpTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      title: Row(
        children: [
          GestureDetector(
              onTap: () {
                Navigator.pop(parentContext!);
              },
              child: Container(
                width: 20 * SizeConfig.widthMultiplier!,
                color: Colors.transparent,
                child: Center(
                  child: SvgPicture.asset(
                    ImagePath.backIcon,
                    width: 7.41 * SizeConfig.widthMultiplier!,
                    height: 12 * SizeConfig.heightMultiplier!,
                    fit: BoxFit.contain,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              )),
          SizedBox(
            width: 16.59 * SizeConfig.widthMultiplier!,
          ),
          CircleAvatar(
            radius: 20 * SizeConfig.imageSizeMultiplier!,
            backgroundImage: NetworkImage(
              trainerProfilePicUrl!,
            ),
          ),
          SizedBox(
            width: 12 * SizeConfig.widthMultiplier!,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(trainertitle ?? "",
                  style: AppTextStyle.hnormal600BlackText.copyWith(
                      color: Theme.of(context).textTheme.bodyText1!.color)),
              Text(trainerstatus ?? "", style: AppTextStyle.hsmallGreenText),
            ],
          ),
        ],
      ),
      actions: [
        //call icon
        Container(
          child: FlutterSwitch(
            onToggle: onHangUpTapped!,
            value: false,
            height: 24 * SizeConfig.heightMultiplier!,
            width: 48 * SizeConfig.widthMultiplier!,
            borderRadius: 30.0,
            padding: 1.0,
            activeToggleColor: kPureWhite,
            inactiveToggleColor: Color(0xffB7B7B7),
            // toggleSize: 28,
            activeColor: Color(0xff49AE50),
            inactiveColor: Colors.transparent,
            activeIcon: Icon(
              Icons.videocam,
              color: Color(0xff49AE50),
            ),
            inactiveIcon: Icon(
              Icons.videocam,
              color: kPureWhite,
            ),

            inactiveSwitchBorder: Border.all(
              color: Color(0xffB7B7B7),
              width: 1.0,
            ),
            activeToggleBorder: Border.all(
              color: Color(0xff49AE50),
              width: 1.0,
            ),
          ),
        ),
        // popupmenu icon
        IconButton(
            onPressed: onMenuTap,
            icon: SvgPicture.asset(
              ImagePath.chatpopupmenuIcon,
              width: 4 * SizeConfig.widthMultiplier!,
              height: 20 * SizeConfig.heightMultiplier!,
              color: Theme.of(context).primaryColor,
            )),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class MessageTile extends StatefulWidget {
  MessageTile({
    Key? key,
    required this.index,
    required this.messageList,
  }) : super(key: key);
  final int index;
  final List<QueryDocumentSnapshot<Object?>> messageList;

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  final _chatController = Get.find<FirebaseChatController>();

  var message = MessageData(
    senderName: '',
    senderId: '',
    senderAvatar: '',
    message: '',
    sentAt: '',
  );

  @override
  void initState() {
    message = MessageData.fromJson(
        widget.messageList[widget.index].data() as Map<String, dynamic>);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: (_chatController.userId == message.senderId)
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        if (widget.index == widget.messageList.length - 1)
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: 18 * SizeConfig.heightMultiplier!),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    _chatController.getDayString(
                        DateTime.parse(message.sentAt), DateTime.now()),
                    style: AppTextStyle.grey400Text
                        .copyWith(fontSize: 12 * SizeConfig.textMultiplier!)),
              ],
            ),
          ),
        if (widget.messageList.length > widget.index + 1)
          if ((DateTime.parse(message.sentAt)).day >
              DateTime.parse((MessageData.fromJson(
                          widget.messageList[widget.index].data()
                              as Map<String, dynamic>)
                      .sentAt))
                  .day)
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 18 * SizeConfig.heightMultiplier!),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      _chatController.getDayString(
                          message.sentAt as DateTime, DateTime.now()),
                      style: AppTextStyle.grey400Text
                          .copyWith(fontSize: 12 * SizeConfig.textMultiplier!)),
                ],
              ),
            ),
        MessageWidget(
          messageData: message,
        ),
      ],
    );
  }
}

class SendMessageWidget extends StatelessWidget {
  SendMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FirebaseChatController>(
        id: 'send-message-field',
        builder: (_chatController) {
      return Column(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(16 * SizeConfig.widthMultiplier!),
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                          color: kBlack,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          // focusNode: _focus,
                          keyboardType: TextInputType.multiline,
                          onChanged: (value) {
                            _chatController.update(['send-message-field']);
                          },
                          maxLines: null,
                          cursorColor: kPureWhite,
                          style: AppTextStyle.black400Text
                              .copyWith(color: kPureWhite, height: 1.3),
                          controller: _chatController.messageController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  left: 16 * SizeConfig.widthMultiplier!,
                                  top: 12 * SizeConfig.heightMultiplier!,
                                  bottom: 12 * SizeConfig.heightMultiplier!),
                              hintText: "message".tr,
                              hintStyle: AppTextStyle.hsmallhintText,
                              border: InputBorder.none,
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 30 * SizeConfig.widthMultiplier!,
                                    child: IconButton(
                                        onPressed: () {},
                                        icon: SvgPicture.asset(
                                          ImagePath.attachdocumentIcon,
                                          width: 9.17 *
                                              SizeConfig.widthMultiplier!,
                                          height: 18.34 *
                                              SizeConfig.heightMultiplier!,
                                        )),
                                  ),
                                  SizedBox(
                                    width: 30 * SizeConfig.widthMultiplier!,
                                    child: IconButton(
                                        onPressed: () {
                                          // sendImageFromCamera();
                                        },
                                        icon: SvgPicture.asset(
                                          ImagePath.openCameraIcon,
                                          width:
                                              15 * SizeConfig.widthMultiplier!,
                                          height: 13.57 *
                                              SizeConfig.heightMultiplier!,
                                        )),
                                  ),
                                  SizedBox(
                                    width: 5 * SizeConfig.widthMultiplier!,
                                  ),
                                ],
                              )),
                          // maxLines: 3,
                        )),
                  ),
                  if (_chatController.messageController.text.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(
                          left: 23 * SizeConfig.widthMultiplier!),
                      child: GestureDetector(
                          onTap: () {
                            _chatController.sendTextMessage(context);
                            _chatController.messageController.clear();
                            _chatController.update(['send-message-field','message-list']);
                          },
                          child: Icon(
                            Icons.send,
                            size: 21 * SizeConfig.heightMultiplier!,
                            color: greenChatColor,
                          )),
                    ),
                ],
              ),
            ),
          )
        ],
      );
    });
  }
}
