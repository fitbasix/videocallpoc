import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/feature/chat_firebase/controller/firebase_chat_controller.dart';
import 'package:fitbasix/feature/chat_firebase/model/chat_model.dart';
import 'package:fitbasix/feature/message/view/screens/message_functions.dart';
import 'package:flutter/material.dart';
// import 'package:cometchat/cometchat_sdk.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:selectable_autolink_text/selectable_autolink_text.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageWidget extends StatefulWidget {
  final MessageData messageData;
  const MessageWidget({Key? key, required this.messageData}) : super(key: key);

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  final FirebaseChatController _chatController = Get.find();
  String? text;
  bool sentByMe = false;

  @override
  Widget build(BuildContext context) {
    if (_chatController.senderId == widget.messageData.senderId) {
      sentByMe = true;
    } else {
      sentByMe = false;
    }

    text = widget.messageData.message;
    Color background = sentByMe == true ? greenChatColor : kBlack;

    return Column(
      crossAxisAlignment:
          sentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        GestureDetector(
            onTap: () async {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => MessageFunctions(
              //               passedMessage: widget.passedMessage,
              //               sentByMe: sentByMe,
              //               deleteMessage: widget.deleteFunction,
              //               editMessage: widget.editFunction,
              //             )));
            },
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: 8.0 * SizeConfig.heightMultiplier!,
                  right: 16 * SizeConfig.widthMultiplier!,
                  left: 16 * SizeConfig.widthMultiplier!),
              child: Column(
                crossAxisAlignment: sentByMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
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
                      color: background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SelectableAutoLinkText(
                      text ?? "",
                      style: sentByMe == true
                          ? AppTextStyle.white400Text
                          : AppTextStyle.black400Text
                              .copyWith(color: kPureWhite),
                      linkStyle: AppTextStyle.white400Text.copyWith(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                      highlightedLinkStyle: TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.transparent,
                      ),
                      onTransformDisplayLink: AutoLinkUtils.shrinkUrl,
                      onTap: (url) async {
                        if (await canLaunch(url)) {
                          launch(url, forceSafariVC: false);
                        } else {}
                      },
                      onLongPress: (url) {
                        print('🍔LongPress: $url');
                      },
                      onTapOther: (local, global) {
                        print('🍇️onTapOther: $local, $global');
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5.0 * SizeConfig.heightMultiplier!,
                  ),
                  Text(
                      DateFormat.jm()
                          .format(DateTime.parse(widget.messageData.sentAt).toLocal()),
                      style: sentByMe == true
                          ? AppTextStyle.white400Text.copyWith(
                              fontSize: 9.0 * SizeConfig.textMultiplier!)
                          : AppTextStyle.black400Text.copyWith(
                              color: kPureWhite,
                              fontSize: 9.0 * SizeConfig.textMultiplier!)),
                ],
              ),
            )),
        // if (sentByMe == true)
        //   MessageReceipts(passedMessage: widget.passedMessage)
      ],
    );
  }
}
