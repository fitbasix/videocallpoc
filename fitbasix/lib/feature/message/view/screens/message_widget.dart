
import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/feature/message/view/screens/message_functions.dart';
import 'package:flutter/material.dart';
import 'package:cometchat/cometchat_sdk.dart';
import 'package:get/get.dart';
import 'package:selectable_autolink_text/selectable_autolink_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/chat_controller.dart';

class MessageWidget extends StatefulWidget {
  final TextMessage passedMessage;
  final Function(BaseMessage msg) deleteFunction;
  final Function(BaseMessage, String) editFunction;
  final Conversation conversation;
  const MessageWidget(
      {Key? key,
      required this.passedMessage,
      required this.deleteFunction,
      required this.conversation,
      required this.editFunction})
      : super(key: key);

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  ChatController _chatController = Get.find();
  String? text;
  bool sentByMe = false;

  @override
  Widget build(BuildContext context) {
    if (_chatController.USERID == widget.passedMessage.sender!.uid) {
      sentByMe = true;
    } else {
      sentByMe = false;
    }

    text = widget.passedMessage.text;
    Color background = sentByMe == true ? greenChatColor : kBlack;

    return Column(
      crossAxisAlignment:
          sentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (widget.conversation.conversationType ==
                CometChatConversationType.group &&
            sentByMe == false)
          Text(widget.passedMessage.sender!.name,
              style: TextStyle(
                  color: const Color(0xff000000).withOpacity(0.6),
                  fontSize: 13)),
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
                      color: background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SelectableAutoLinkText(text??"",
                      style: sentByMe == true
                          ? AppTextStyle.white400Text
                          : AppTextStyle.black400Text
                          .copyWith(color: kPureWhite),
                      linkStyle: AppTextStyle.white400Text.copyWith(color: Colors.blue,decoration: TextDecoration.underline,),
                      highlightedLinkStyle: TextStyle(
                        color: Colors.blueAccent,
                        backgroundColor: Colors.blueAccent.withAlpha(0x33),
                      ),
                      onTransformDisplayLink: AutoLinkUtils.shrinkUrl,
                      onTap: (url) async {
                        if (await canLaunch(url)) {
                          launch(url, forceSafariVC: false);
                        } else {

                        }
                      },
                      onLongPress: (url) {
                        print('🍔LongPress: $url');
                      },
                      onTapOther: (local, global) {
                        print('🍇️onTapOther: $local, $global');
                      },
                    )

                    // AutolinkText(
                    //     text: 'Your text with link www.example.com',
                    //     textStyle: sentByMe == true
                    //         ? AppTextStyle.white400Text
                    //         : AppTextStyle.black400Text
                    //         .copyWith(color: kPureWhite),
                    //     linkStyle: AppTextStyle.white400Text.copyWith(color: Colors.blue,decoration: TextDecoration.underline,),
                    //     onWebLinkTap: (link) => launch(link)
                    // ),

                    // Text(text ?? "",
                    //     style: sentByMe == true
                    //         ? AppTextStyle.white400Text
                    //         : AppTextStyle.black400Text
                    //             .copyWith(color: kPureWhite)),
                  )
                ],
              ),
            )),
        // if (sentByMe == true)
        //   MessageReceipts(passedMessage: widget.passedMessage)
      ],
    );
  }
}
