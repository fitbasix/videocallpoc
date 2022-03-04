import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/message/model/reciever_message_model.dart';
import 'package:fitbasix/feature/message/view/chat_videocallscreen.dart';
import 'package:fitbasix/feature/message/view/documents_view_screen.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_attachment.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';
import 'package:quickblox_sdk/models/qb_event.dart';
import 'package:quickblox_sdk/models/qb_file.dart';
import 'package:quickblox_sdk/models/qb_filter.dart';
import 'package:quickblox_sdk/models/qb_message.dart';
import 'package:quickblox_sdk/models/qb_sort.dart';
import 'package:quickblox_sdk/models/qb_subscription.dart';
import 'package:quickblox_sdk/notifications/constants.dart';
import 'package:quickblox_sdk/push/constants.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_palette.dart';
import '../../../core/reponsive/SizeConfig.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mime_type/mime_type.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';


import 'package:flutter/services.dart';

import 'package:quickblox_sdk/models/qb_rtc_session.dart';

import 'package:quickblox_sdk/quickblox_sdk.dart';

import 'package:quickblox_sdk/webrtc/constants.dart';

import 'package:quickblox_sdk/webrtc/rtc_video_view.dart';

import '../controller/chat_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(new ChatScreen());
}

class ChatScreen extends StatefulWidget {
  int? opponentID;
  QBDialog? userDialogForChat;
  String trainerTitle = 'Jonathan Swift'.tr;

  ChatScreen({Key? key, this.userDialogForChat,this.opponentID}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  ChatController _chatController = Get.put(ChatController());
  HomeController _homeController = Get.find();
  QBDialog? userDialogForChat;
  var _massageController = TextEditingController().obs;
  StreamSubscription? _massageStreamSubscription;
  String event = QBChatEvents.RECEIVED_NEW_MESSAGE;
  List<QBMessage?>? messages;
  DateTime? messageDate = DateTime(2015, 5, 5);
  var _typedMessage = "".obs;
  StreamSubscription? _connectionStreamSubscription;

  StreamSubscription? _callEndSubscription;

  StreamSubscription? _rejectSubscription;

  StreamSubscription? _acceptSubscription;

  StreamSubscription? _hangUpSubscription;

  StreamSubscription? _videoTrackSubscription;

  StreamSubscription? _notAnswerSubscription;

  StreamSubscription? _peerConnectionSubscription;


  @override
  void dispose() {
    if (_massageStreamSubscription != null) {
      _massageStreamSubscription!.cancel();
      _massageStreamSubscription = null;
    }
    super.dispose();
  }


  @override
  void initState() {
    userDialogForChat = widget.userDialogForChat;
    initMassage();
    connectionEvent();
    getMassageFromHistory();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (messages != null) {}
    return Scaffold(
      appBar: AppbarforChat(
        onHangUpTapped: (value){
          //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VideoCallScreen(sessionIdForVideoCall: "12123123",)));
          callWebRTC(QBRTCSessionTypes.VIDEO).then((value) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VideoCallScreen(sessionIdForVideoCall: value!,)));
          });
        },
        onDocumentsTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DocumentsViewerScreen(
                        messages: messages,
                      )));
        },
        parentContext: context,
        trainertitle: widget.trainerTitle,
        trainerstatus: 'Online'.tr,
      ),
      body: SafeArea(
        child: Container(
          color: Color(0xffE5E5E5).withOpacity(0.5),
          child: Column(
            children: [
              (messages != null)
                  ? Expanded(
                      child: ListView.builder(
                          reverse: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: messages!.length,
                          itemBuilder: (context, index) {
                            if (messages![index]!.senderId ==
                                _homeController.userQuickBloxId.value) {
                              return MessageBubbleSender(
                                message: messages![index],
                              );
                            } else {
                              return MessageBubbleOpponent(
                                message: messages![index],
                              );
                            }
                          }),
                    )
                  : Expanded(
                      child: Center(
                      child: Text("no massage yet"),
                    )),
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
                            controller: _massageController.value,
                            onChanged: (value) {
                              _typedMessage.value = value;
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left: 16 * SizeConfig.widthMultiplier!,
                                    top: 12 * SizeConfig.heightMultiplier!),
                                hintText: "message".tr,
                                hintStyle: AppTextStyle.hsmallhintText,
                                border: InputBorder.none,
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 30 * SizeConfig.widthMultiplier!,
                                      child: IconButton(
                                          onPressed: () {
                                            sendAttachmentsFromDevice();
                                          },
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
                                            sendImageFromCamera();
                                          },
                                          icon: SvgPicture.asset(
                                            ImagePath.openCameraIcon,
                                            width: 15 *
                                                SizeConfig.widthMultiplier!,
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
                      Obx(()=>Padding(
                          padding: EdgeInsets.only(left: 8, bottom: 4),
                          child: CircleAvatar(
                            backgroundColor: greenChatColor,
                            child: (_typedMessage.value.isNotEmpty)
                                ? IconButton(
                                    onPressed: () {
                                      sendMsg(_typedMessage.value);
                                      _massageController.value.clear();
                                      _typedMessage.value = "";
                                    },
                                    icon: Icon(
                                      Icons.send,
                                      size: 16 * SizeConfig.heightMultiplier!,
                                      color: Colors.white,
                                    ))
                                : IconButton(
                                    onPressed: () async {


                                    },
                                    icon: SvgPicture.asset(
                                      ImagePath.chatMicIcon,
                                      width: 16 * SizeConfig.widthMultiplier!,
                                      height: 16 * SizeConfig.heightMultiplier!,
                                    )),
                          ),
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





  void sendNotification(String messageBody) async {
    try{
      FirebaseMessaging.instance.getToken().then((token)async{
        List<QBSubscription?> subscriptions = await QB.subscriptions.create(token!, QBPushChannelNames.GCM);
      });
    }catch(e){
      print("notification error"+e.toString());
    }
    String eventType = QBNotificationEventTypes.ONE_SHOT;
    String notificationEventType = QBNotificationTypes.PUSH;
    int pushType = QBNotificationPushTypes.GCM;
    int senderId = _homeController.userQuickBloxId.value;

    Map<String, Object> payload = new Map();
    payload["message"] = {
      "notification": {
        "body": messageBody,
        "title": "this is a title",
        "imageUrl":"https://community.custom-cursor.com/uploads/default/adcc703632967e01dba11b8ed4ed893d57b8388c",
        "name":_homeController.userQuickBloxId.value==133642567?"Tarun Prajapat":"Vartika",
        "dialogId":widget.userDialogForChat!.id,
        "opponentId":_homeController.userQuickBloxId.value.toString(),
      },
    "data": {
    "sound": "default",
    "status": "done",
    "screen": "ChatScreen",
    },
    "to": "<FCM TOKEN>"
  };

    try {
      print(widget.opponentID.toString()+" kkkkk");
      List<QBEvent?> events = await QB.events.create(eventType, notificationEventType, senderId, payload, pushType: pushType,recipientsIds: [widget.opponentID.toString()]);
    } on PlatformException catch (e) {
      // Some error occurred, look at the exception message for more details
    }

  }









  Future<String?> callWebRTC(int sessionType) async {
    print("call webRTC lllllll");
    try {
      QBRTCSession? session = await QB.webrtc.call([widget.opponentID!,_homeController.userQuickBloxId.value], sessionType,userInfo: {"userName":"Kashif Ahmad"});

      return session!.id;
    } on PlatformException catch (e) {
      return null;
    }

  }


  void initMassage() async {
    try {
      _massageStreamSubscription = await QB.chat.subscribeChatEvent(event, (data) {
        Map<String, dynamic> map = Map<String, dynamic>.from(data);
        Map<String, dynamic> payload = Map<String, dynamic>.from(map["payload"]);
        print("nnnnnn"+payload.toString());
        List<Attachment>? attachmentsFromJson;
        print(payload.toString());
        if (payload["attachments"] != null) {
          attachmentsFromJson =
              (json.decode(json.encode(payload["attachments"])) as List)
                  .map((data) => Attachment.fromJson(data))
                  .toList();
        }
        String? messageId = payload["id"];
        QBMessage newMessage = QBMessage();
        List<QBAttachment?>? getAttachments() {
          List<QBAttachment?>? attachments = [];
          if (attachmentsFromJson != null) {
            attachmentsFromJson.forEach((element) {
              QBAttachment attachment = QBAttachment();
              attachment.id = element.id!;
              attachment.url = element.url;
              attachment.type = element.type;
              attachment.name = element.name;
              attachment.data = element.data;
              attachment.contentType = element.contentType;
              attachments.add(attachment);
            });
            return attachments;
          }
          return null;
        }
        // print(payload["attachments"]);
        newMessage.id = payload["id"];
        newMessage.dialogId = payload["dialogId"];
        newMessage.attachments = getAttachments();
        newMessage.senderId = payload["senderId"];
        newMessage.recipientId = payload["recipientId"];
        newMessage.body = payload["body"];
        newMessage.dateSent = payload["dateSent"];
        newMessage.markable = payload["markable"];
        setState(() {
          messages!.insert(0, newMessage);
        });
      });
    } on PlatformException catch (e) {
      // Some error occurred, look at the exception message for more details
    }
  }

  checkUserConnection() async {
    try {
      bool? connected = await QB.chat.isConnected();
    } on PlatformException catch (e) {
      // Some error occurred, look at the exception message for more details
    }
  }

  connectionEvent() async {
    String event = QBChatEvents.CONNECTED;
    try {
      _connectionStreamSubscription = await QB.chat.subscribeChatEvent(
          QBChatEvents.CONNECTED, (data) {},
          onErrorMethod: (error) {

          });
    } on PlatformException catch (e) {}
  }

  void sendMsg(String messageBody) async {
    print("nnnnnn created dialog id"+widget.userDialogForChat!.id.toString());
    String dialogId = widget.userDialogForChat!.id!;
    print("massage dialog id is: " + widget.userDialogForChat!.id!);
    bool saveToHistory = true;
    try {
      await QB.chat
          .sendMessage(dialogId,
              body: messageBody, saveToHistory: saveToHistory)
          .then((value) {
        print("msg send");
      });
    } on PlatformException catch (e) {
      print(e);
    }
    sendNotification(messageBody);
  }

  getMassageFromHistory() async {

    QBSort sort = QBSort();
    sort.field = QBChatMessageSorts.DATE_SENT;
    sort.ascending = false;

    try {
      List<QBMessage?>? messageslist =
          await QB.chat.getDialogMessages(userDialogForChat!.id!, sort: sort);
      setState(() {
        messages = messageslist;
      });
    } on PlatformException catch (e) {
      // Some error occurred, look at the exception message for more details
    }
  }

  Future<XFile?> pickFromCamera() async {
    final ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.camera);
    if (file != null) {
      return file;
    } else
      return null;
  }

  void sendImageFromCamera() async {
    XFile? pickedFile = await pickFromCamera();
    if (pickedFile != null) {
      try {
        QBFile? file = await QB.content.upload(pickedFile.path, public: false);
        if (file != null) {
          int? id = file.id;
          print("image id " + file.uid!);
          String? contentType = file.contentType;

          QBAttachment attachment = QBAttachment();
          attachment.id = id.toString();
          attachment.contentType = contentType;
          attachment.url = file.uid;
          attachment.name = file.name;
          //Required parameter
          attachment.type = "PHOTO";
          attachment.data = pickedFile.path;
          //Required parameter
          //attachment.type = "PHOTO";

          List<QBAttachment>? attachmentsList = [];
          attachmentsList.add(attachment);

          QBMessage message = QBMessage();
          message.attachments = attachmentsList;
          message.body = "test attachment";
          QB.chat
              .sendMessage(widget.userDialogForChat!.id!,
                  attachments: attachmentsList,
                  body: "imageTest",
                  saveToHistory: true)
              .then((value) {
            print("demo msg send");
          });
          // Send a message logic
        }
      } on PlatformException catch (e) {
        // Some error occurred, look at the exception message for more details
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("pick a image first")));
    }
  }


  Future<FilePickerResult?> pickAttachments() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc','png','jpeg','mp3','mp4','mkv'],
    );

    if (result != null) {
      return result;
    } else {
      return null;
    }
  }

  void sendAttachmentsFromDevice() async {
    FilePickerResult? pickedFiles = await pickAttachments();
    if (pickedFiles != null) {
      try {
        List<QBAttachment>? attachmentsList = [];
        for(int i =0;i<pickedFiles.files.length;i++){
          QBFile? file = await QB.content.upload(pickedFiles.files[i].path!, public: false);
          if (file != null) {
            int? id = file.id;
            String? contentType = pickedFiles.files[i].path!.split('.').last;
            QBAttachment attachment = QBAttachment();
            attachment.id = id.toString();
            attachment.contentType = contentType;
            print(contentType+" dddd");
            attachment.url = file.uid;
            attachment.name = file.name;
            attachment.data = pickedFiles.files[i].path!;
            //Required parameter
            attachment.type = "PHOTO";
            attachmentsList.add(attachment);
            QBMessage message = QBMessage();
            message.attachments = attachmentsList;
            message.body = "test attachment";
            // Send a message logic
          }
        }
        QB.chat
            .sendMessage(widget.userDialogForChat!.id!,
            attachments: attachmentsList,
            body: "imageTest",
            saveToHistory: true)
            .then((value) {
          print("demo msg send");
        });
      } on PlatformException catch (e) {
        // Some error occurred, look at the exception message for more details
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("pick a some file to upload")));
    }
  }




}








class MessageBubbleSender extends StatelessWidget{

  MessageBubbleSender({Key? key, this.message}) : super(key: key);
  final QBMessage? message;

  ChatController _chatController = Get.find();

  var isDownloaded = false.obs;

  var filePath = "".obs;
  
  
  @override
  Widget build(BuildContext context) {
    if (message!.attachments == null)  {
      return Padding(
        padding: EdgeInsets.only(
            bottom: 8.0 * SizeConfig.heightMultiplier!,
            right: 16 * SizeConfig.widthMultiplier!),
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
                color: greenChatColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(message!.body.toString(),
                  style: AppTextStyle.white400Text),
            )
          ],
        ),
      );
    } else {
      checkFileExistence(message!.attachments![0]!.name);
      return Padding(
        padding: EdgeInsets.only(
            bottom: 8.0 * SizeConfig.heightMultiplier!,
            right: 16 * SizeConfig.widthMultiplier!),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
                constraints: BoxConstraints(
                    maxWidth: 200 * SizeConfig.widthMultiplier!,
                    maxHeight: 250 * SizeConfig.heightMultiplier!),
                padding: EdgeInsets.symmetric(
                  vertical: 3.0 * SizeConfig.heightMultiplier!,
                  horizontal: 3.0 * SizeConfig.widthMultiplier!,
                ),
                decoration: BoxDecoration(
                  color: greenChatColor,
                  borderRadius:
                      BorderRadius.circular(8 * SizeConfig.widthMultiplier!),
                ),
                child:Obx(()=>filePath.value.isEmpty ?Container(
                  child:GestureDetector(
                      onTap: ()async {
                        isDownloaded.value = await _getImageUrl(message!.attachments![0]!.url!,message!.attachments![0]!.name!);
                        },
                      child: Text("download")),
                ):Container(child: GestureDetector(
                    onTap: (){
                      OpenFile.open(filePath.value);
                    },
                    child: Text("${filePath.value}")),)
                ))



          ],
        ),
      );
    }
  }

  Future<bool> _getImageUrl(String id,String fileName) async {
    print(fileName+"this is the file name");
    try {
      String? url = await QB.content.getPrivateURL(id);
      bool flag = false;

      //FlutterDownloader.registerCallback(downloadCallback);
      try{
        PermissionStatus status = await Permission.storage.request();
        if (status == PermissionStatus.granted) {
          String? path;
          final Directory _appDocDir = await getApplicationDocumentsDirectory();
          //App Document Directory + folder name
          final Directory _appDocDirFolder = Directory('storage/emulated/0/fitBasix/media');
          if (await _appDocDirFolder.exists()) {
            //if folder already exists return path
            path = _appDocDirFolder.path;
          } else {
            //if folder not exists create folder and then return its path
            final Directory _appDocDirNewFolder =
            await _appDocDirFolder.create(recursive: true);
            path =  _appDocDirNewFolder.path;
          }
          print(path + "pp dir");
          Dio dio =  Dio();
          dio.download(url!, path+"/"+fileName,onReceiveProgress: (received, total){
            print(((received/total )* 100).floor().toString() + "ssssss");
            if(((received/total )* 100).floor() == 100){
                checkFileExistence(fileName);
            }
          });




        }
      }catch(e){
        print(e.toString());
      }

     return false;
    } on PlatformException catch (e) {
      print(e);
      return false;
      // Some error occurred, look at the exception message for more details
    }
  }

  void checkFileExistence(String? fileName) async {
    PermissionStatus status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      String? path;
      final downloadsPath = Directory('/storage/emulated/0/Download');
      final Directory _appDocDir = await getApplicationDocumentsDirectory();
      final Directory _appDocDirFolder = Directory('storage/emulated/0/fitBasix/media');

      if (await _appDocDirFolder.exists()) {
        path = _appDocDirFolder.path;
      }
      else{
        //if folder not exists create folder and then return its path
        final Directory _appDocDirNewFolder = await _appDocDirFolder.create(recursive: true);
        path =  _appDocDirNewFolder.path;
      }

      //if(File(message!.attachments![0]!.data!).existsSync())
      if(File(path+"/"+fileName!).existsSync()){

        print("file exists in "+path+"/$fileName");
        filePath.value = path+"/$fileName";

      }

      if(File(downloadsPath.path +"/"+fileName).existsSync()){
        print("file exists in "+downloadsPath.path+"/$fileName");
        filePath.value = downloadsPath.path +"/"+fileName;
      }
    }
  }

}



//  Message Bubble
class MessageBubbleOpponent extends StatelessWidget {
  MessageBubbleOpponent({
    Key? key,
    this.message,
  }) : super(key: key);

  final QBMessage? message;
  var isDownloaded = false.obs;

  var filePath = "".obs;

  @override
  Widget build(BuildContext context) {
    if (message!.attachments == null) {
      return Padding(
        padding: EdgeInsets.only(
            bottom: 8.0 * SizeConfig.heightMultiplier!,
            left: 16 * SizeConfig.widthMultiplier!),
        child: Column(
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
              child: Text(message!.body.toString(),
                  style: AppTextStyle.black400Text),
            )
          ],
        ),
      );
    } else {
      checkFileExistence(message!.attachments![0]!.name);
      return Padding(
        padding: EdgeInsets.only(
            bottom: 8.0 * SizeConfig.heightMultiplier!,
            left: 16 * SizeConfig.widthMultiplier!),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                constraints: BoxConstraints(
                    maxWidth: 200 * SizeConfig.widthMultiplier!,
                    maxHeight: 250 * SizeConfig.heightMultiplier!),
                padding: EdgeInsets.symmetric(
                  vertical: 3.0 * SizeConfig.heightMultiplier!,
                  horizontal: 3.0 * SizeConfig.widthMultiplier!,
                ),
                decoration: BoxDecoration(
                  color: kPureWhite,
                  borderRadius:
                  BorderRadius.circular(8 * SizeConfig.widthMultiplier!),
                ),
                child:Obx(()=>filePath.value.isEmpty ?Container(
                  child:GestureDetector(
                      onTap: ()async {
                        isDownloaded.value = await _getImageUrl(message!.attachments![0]!.url!,message!.attachments![0]!.name!);
                      },
                      child: Text("download")),
                ):Container(child: GestureDetector(
                    onTap: (){
                      OpenFile.open(filePath.value);
                    },
                    child: Text("${filePath.value}")),)
                )),
          ],
        ),
      );
    }
  }

  Future<bool> _getImageUrl(String id,String fileName) async {
    print(fileName+"this is the file name");
    try {
      String? url = await QB.content.getPrivateURL(id);
      bool flag = false;

      //FlutterDownloader.registerCallback(downloadCallback);
      try{
        PermissionStatus status = await Permission.storage.request();
        if (status == PermissionStatus.granted) {
          String? path;
          final Directory _appDocDir = await getApplicationDocumentsDirectory();
          //App Document Directory + folder name
          final Directory _appDocDirFolder = Directory('storage/emulated/0/fitBasix/media');
          if (await _appDocDirFolder.exists()) {
            //if folder already exists return path
            path = _appDocDirFolder.path;
          } else {
            //if folder not exists create folder and then return its path
            final Directory _appDocDirNewFolder =
            await _appDocDirFolder.create(recursive: true);
            path =  _appDocDirNewFolder.path;
          }
          print(path + "pp dir");
          Dio dio =  Dio();
          dio.download(url!, path+"/"+fileName,onReceiveProgress: (received, total){
            print(((received/total )* 100).floor().toString() + "ssssss");
            if(((received/total )* 100).floor() == 100){
              checkFileExistence(fileName);
            }
          });




        }
      }catch(e){
        print(e.toString());
      }

      return false;
    } on PlatformException catch (e) {
      print(e);
      return false;
      // Some error occurred, look at the exception message for more details
    }
  }

  void checkFileExistence(String? fileName) async {
    PermissionStatus status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      String? path;
      final downloadsPath = Directory('/storage/emulated/0/Download');
      final Directory _appDocDir = await getApplicationDocumentsDirectory();
      final Directory _appDocDirFolder = Directory('storage/emulated/0/fitBasix/media');

      if (await _appDocDirFolder.exists()) {
        path = _appDocDirFolder.path;
      }
      else{
        //if folder not exists create folder and then return its path
        final Directory _appDocDirNewFolder = await _appDocDirFolder.create(recursive: true);
        path =  _appDocDirNewFolder.path;
      }

      //if(File(message!.attachments![0]!.data!).existsSync())
      if(File(path+"/"+fileName!).existsSync()){

        print("file exists in "+path+"/$fileName");
        filePath.value = path+"/$fileName";

      }

      if(File(downloadsPath.path +"/"+fileName).existsSync()){
        print("file exists in "+downloadsPath.path+"/$fileName");
        filePath.value = downloadsPath.path +"/"+fileName;
      }
    }
  }


}

// Appbar
class AppbarforChat extends StatelessWidget with PreferredSizeWidget {
  String trainerProfilePicUrl =
      'http://www.pixelmator.com/community/download/file.php?avatar=17785_1569233053.png';
  String? trainertitle;
  String? trainerstatus;
  BuildContext? parentContext;
  GestureTapCallback? onDocumentsTap;
  ValueChanged<bool>? onHangUpTapped;

  AppbarforChat(
      {Key? key,
      this.trainertitle,
      this.parentContext,
      this.trainerstatus,
      this.onDocumentsTap,
      this.onHangUpTapped})
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
              Text(trainertitle ?? "", style: AppTextStyle.hnormal600BlackText),
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
            inactiveColor: Colors.white,
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
            onPressed: () {},
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


