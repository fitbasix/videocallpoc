import 'package:fitbasix/core/constants/image_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_palette.dart';
import '../../../core/reponsive/SizeConfig.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  List demoChatMessages = [
    ChatMessage(
      text: "Hi What's up"
    ),
    ChatMessage(
        text: "Good Morning"
    ),
    ChatMessage(
        text: "Have a nice day "
    ),
    ChatMessage(
        text: "Bye"
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarforChat(
        parentContext: context,
        trainertitle: 'Jonathan Swift'.tr,
        trainerstatus: 'Online'.tr,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            //body
            Column(
              children: [
                Expanded(child: ListView.builder(
                  itemCount: demoChatMessages.length,
                  itemBuilder: (context, index) =>
                      MessageBubble(message: demoChatMessages[index],)
                ),
                ),
              ],
            ),
              // bottom textfield
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
                        decoration: InputDecoration(
                          hintText: " Message",
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
                      backgroundColor: Color(0xFF4FC24C),
                      child: IconButton(
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
    );
  }
}

//  Message Bubble
class MessageBubble extends StatelessWidget {
  const MessageBubble({Key? key, this.message}) : super(key: key);

  final ChatMessage? message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0 * SizeConfig.widthMultiplier!),
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
              color: kGreenColor,
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
