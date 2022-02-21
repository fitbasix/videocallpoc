import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/message/model/reciever_message_model.dart';
import 'package:fitbasix/feature/message/view/documents_view_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_attachment.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';
import 'package:quickblox_sdk/models/qb_file.dart';
import 'package:quickblox_sdk/models/qb_filter.dart';
import 'package:quickblox_sdk/models/qb_message.dart';
import 'package:quickblox_sdk/models/qb_sort.dart';
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

class ChatScreen extends StatefulWidget {
  QBDialog? userDialogForChat;
  String trainerTitle = 'Jonathan Swift'.tr;

  ChatScreen({Key? key, this.userDialogForChat}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  HomeController _homeController = Get.find();
  QBDialog? userDialogForChat;
  final TextEditingController _massageController = TextEditingController();
  StreamSubscription? _massageStreamSubscription;
  StreamSubscription? _connectionStreamSubscription;
  String event = QBChatEvents.RECEIVED_NEW_MESSAGE;
  List<QBMessage?>? messages;
  DateTime? messageDate = DateTime(2015, 5, 5);


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
    subscribeReject();
    print("subscribeReject demmm");
    subscribeAccept();
    print("subscribeAccept demmm");
    subscribeHangUp();
    print("subscribeHangUp demmm");
    subscribeVideoTrack();
    print("subscribeVideoTrack demmm");
    subscribeNotAnswer();
    print("subscribeNotAnswer demmm");
    subscribePeerConnection();
    print("subscribePeerConnection demmm");
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
                            String? showDate;
                            var date = new DateTime.fromMicrosecondsSinceEpoch(
                                messages![index]!.dateSent! * 1000);
                            if (messageDate!.day != date.day) {
                              messageDate = date;
                              print(date.toString() + "kashif");
                              showDate =
                                  DateFormat("yyyy MMMM dd").format(date);
                            } else {
                              showDate = "";
                            }

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
                      child: Text("no massage yey"),
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
                            controller: _massageController,
                            onChanged: (value) {
                              setState(() {});
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
                      Padding(
                        padding: EdgeInsets.only(left: 8, bottom: 4),
                        child: CircleAvatar(
                          backgroundColor: greenChatColor,
                          child: (_massageController.text.isNotEmpty)
                              ? IconButton(
                                  onPressed: () {
                                    sendMsg(_massageController.text);
                                    _massageController.clear();
                                  },
                                  icon: Icon(
                                    Icons.send,
                                    size: 16 * SizeConfig.heightMultiplier!,
                                    color: Colors.white,
                                  ))
                              : IconButton(
                                  onPressed: () async {
                                    callWebRTC(QBRTCSessionTypes.VIDEO);

                                  },
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







  ///related to video call
  String? _sessionId;

  RTCVideoViewController? _localVideoViewController;

  RTCVideoViewController? _remoteVideoViewController;

  Future<void> subscribeHangUp() async {
    if (_hangUpSubscription != null) {
      return;
    }
    try {
      _hangUpSubscription =
          await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.HANG_UP, (data) {
        int userId = data["payload"]["userId"];
      }, onErrorMethod: (error) {});
    } on PlatformException catch (e) {}
  }

  Future<void> subscribePeerConnection() async {
    if (_peerConnectionSubscription != null) {
      return;
    }
    try {
      _peerConnectionSubscription = await QB.webrtc.subscribeRTCEvent(
          QBRTCEventTypes.PEER_CONNECTION_STATE_CHANGED, (data) {
        int state = data["payload"]["state"];
        String parsedState = parseState(state);
      }, onErrorMethod: (error) {});
    } on PlatformException catch (e) {}
  }

  String parseState(int state) {
    String parsedState = "";

    switch (state) {
      case QBRTCPeerConnectionStates.NEW:
        parsedState = "NEW";

        break;

      case QBRTCPeerConnectionStates.FAILED:
        parsedState = "FAILED";

        break;

      case QBRTCPeerConnectionStates.DISCONNECTED:
        parsedState = "DISCONNECTED";

        break;

      case QBRTCPeerConnectionStates.CLOSED:
        parsedState = "CLOSED";

        break;

      case QBRTCPeerConnectionStates.CONNECTED:
        parsedState = "CONNECTED";

        break;
    }

    return parsedState;
  }

  Future<void> subscribeAccept() async {
    if (_acceptSubscription != null) {
      return;
    }

    try {
      _acceptSubscription =
      await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.ACCEPT, (data) {
        int userId = data["payload"]["userId"];
      }, onErrorMethod: (error) {});
    } on PlatformException catch (e) {}
  }
  Future<void> subscribeCallEnd() async {
    if (_callEndSubscription != null) {
      return;
    }

    try {
      _callEndSubscription =
          await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.CALL_END, (data) {
        Map<dynamic, dynamic> payloadMap =
            Map<dynamic, dynamic>.from(data["payload"]);

        Map<dynamic, dynamic> sessionMap =
            Map<dynamic, dynamic>.from(payloadMap["session"]);

        String sessionId = sessionMap["id"];
      }, onErrorMethod: (error) {});
    } on PlatformException catch (e) {}
  }
  Future<void> subscribeReject() async {
    if (_rejectSubscription != null) {
      return;
    }

    try {
      _rejectSubscription =
          await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.REJECT, (data) {
        int userId = data["payload"]["userId"];
      }, onErrorMethod: (error) {});
    } on PlatformException catch (e) {}
  }
  Future<void> startRenderingLocal() async {

    try {

      await _localVideoViewController!.play(_sessionId!, _homeController.userQuickBloxId.value);

    } on PlatformException catch (e) {



    }

  }
  Future<void> subscribeNotAnswer() async {
    if (_notAnswerSubscription != null) {
      return;
    }

    try {
      _notAnswerSubscription =
      await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.NOT_ANSWER, (data) {
        int userId = data["payload"]["userId"];
      }, onErrorMethod: (error) {});
    } on PlatformException catch (e) {}
  }
  Future<void> subscribeVideoTrack() async {
    if (_videoTrackSubscription != null) {
      return;
    }

    try {
      _videoTrackSubscription = await QB.webrtc
          .subscribeRTCEvent(QBRTCEventTypes.RECEIVED_VIDEO_TRACK, (data) {
        Map<dynamic, dynamic> payloadMap =
            Map<dynamic, dynamic>.from(data["payload"]);

        int opponentId = payloadMap["userId"];

        if (opponentId == _homeController.userQuickBloxId.value) {
          startRenderingLocal();
        } else {
          startRenderingRemote(opponentId);
        }
      }, onErrorMethod: (error) {});
    } on PlatformException catch (e) {}
  }
  Future<void> startRenderingRemote(int opponentId) async {

    try {

      await _remoteVideoViewController!.play(_sessionId!, opponentId);

    } on PlatformException catch (e) {



    }

  }
  Future<void> callWebRTC(int sessionType) async {
    try {
      QBRTCSession? session = await QB.webrtc.call([133536465], sessionType,userInfo: {"userName":"Kashif Ahmad"});
      _sessionId = session!.id;
    } on PlatformException catch (e) {
    }

  }


  void initMassage() async {
    try {
      _massageStreamSubscription =
          await QB.chat.subscribeChatEvent(event, (data) {
        Map<String, dynamic> map = Map<String, dynamic>.from(data);
        Map<String, dynamic> payload =
            Map<String, dynamic>.from(map["payload"]);
        List<Attachment>? attachmentsFromJson;
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

        //messages!.add(payload);
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
          onErrorMethod: (error) {});
    } on PlatformException catch (e) {}
  }

  void sendMsg(String messageBody) async {
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

//  Message Bubble
class MessageBubbleSender extends StatelessWidget {
  var isDownloaded = false.obs;
  MessageBubbleSender({Key? key, this.message}) : super(key: key);

  final QBMessage? message;

  @override
  Widget build(BuildContext context) {
    if (message!.attachments == null) {
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
                child:Obx(()=>isDownloaded == false?Container(
                  child:GestureDetector(
                      onTap: ()async {
                        isDownloaded.value = await _getImageUrl(message!.attachments![0]!.url!,message!.attachments![0]!.url!);
                      },
                      child: Text("download")),
                ):Container(child: Text("storage/emulated/0/fitBasix/media/${message!.attachments![0]!.url!}"),)
                ))


                // FutureBuilder(
                //   future: _getImageUrl(message!.attachments![0]!.url!,message!.attachments![0]!.url!),
                //   builder: (context, AsyncSnapshot<String?> snapshot) {
                //     if (snapshot.hasData) {
                //       return ClipRRect(
                //           borderRadius: BorderRadius.circular(
                //               8 * SizeConfig.widthMultiplier!),
                //           child: Image.network(snapshot.data!));
                //     } else {
                //       return Container(
                //         height: 100 * SizeConfig.heightMultiplier!,
                //         width: 100 * SizeConfig.widthMultiplier!,
                //         child: Center(
                //           child: CustomizedCircularProgress(),
                //         ),
                //       );
                //     }
                //   },
                // ))
          ],
        ),
      );
    }
  }


  Future<bool> _getImageUrl(String id,String fileName) async {
    try {
      String? url = await QB.content.getPrivateURL(id);
      // String localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';
      // final savedDir = Directory(localPath);
      // bool hasExisted = await savedDir.exists();
      // if (!hasExisted) {
      //   savedDir.create();
      // }
      //Directory("storage/emulated/0/downloads/").existsSync();
      // final taskId = await FlutterDownloader.enqueue(
      //   url: url!,
      //   fileName: fileName,
      //   savedDir: "storage/emulated/0/Download/",
      //   showNotification: false, // show download progress in status bar (for Android)
      //   openFileFromNotification: false, // click on notification to open downloaded file (for Android)
      // ).then((value) {
      //   print("file downdloadeddd");
      //   return true;
      // });

          try{
        PermissionStatus status = await Permission.storage.request();

        if (status == PermissionStatus.granted) {
          Directory? dir = await getExternalStorageDirectory();
          print(dir!.path + "pp dir");

          final taskId = await FlutterDownloader.enqueue(
              url: url!,
              savedDir: dir!.path,
              fileName: fileName,
              showNotification: false,
              // show download progress in status bar (for Android)
              openFileFromNotification: false,
              // click on notification to open downloaded file (for Android)
              saveInPublicStorage: true);
        }
      }catch(e){

          }

     return false;
    } on PlatformException catch (e) {
      return false;
      // Some error occurred, look at the exception message for more details
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
                child: FutureBuilder(
                  future: _getImageUrl(message!.attachments![0]!.url!),
                  builder: (context, AsyncSnapshot<String?> snapshot) {
                    if (snapshot.hasData) {
                      return ClipRRect(
                          borderRadius: BorderRadius.circular(
                              8 * SizeConfig.widthMultiplier!),
                          child: Image.network(snapshot.data!));
                    } else {
                      return Container(
                        height: 100 * SizeConfig.heightMultiplier!,
                        width: 100 * SizeConfig.widthMultiplier!,
                        color: Colors.white,
                        child: Center(
                          child: CustomizedCircularProgress(),
                        ),
                      );
                    }
                  },
                ))
          ],
        ),
      );
    }
  }

  Future<String?> _getImageUrl(String id) async {
    try {
      String? url = await QB.content.getPrivateURL(id);
      return url;
    } on PlatformException catch (e) {
      // Some error occurred, look at the exception message for more details
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

  AppbarforChat(
      {Key? key,
      this.trainertitle,
      this.parentContext,
      this.trainerstatus,
      this.onDocumentsTap})
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
        //document icon
        IconButton(
            onPressed: onDocumentsTap,
            icon: SvgPicture.asset(
              ImagePath.chatdocumentIcon,
              width: 16 * SizeConfig.widthMultiplier!,
              height: 20 * SizeConfig.heightMultiplier!,
            )),
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


class RTCVideoViewController {

//WebRTCVideoView Methods

  static const SET_MIRROR_METHOD = "mirror";

  static const SET_SCALE_TYPE_METHOD = "scaleType";

  static const PLAY_METHOD = "play";

  static const RELEASE_METHOD = "release";



  RTCVideoViewController._(int id)

      : _channel = MethodChannel('QBWebRTCFlutterVideoViewChannel/$id');



  final MethodChannel _channel;



  Future<void> setMirror(bool mirror) async {

    Map<String, Object> values = Map();



    values["mirror"] = mirror;



    return _channel.invokeMethod(SET_MIRROR_METHOD, values);

  }
  Future<void> play(String sessionId, int userId) async {

    Map<String, Object> values = Map();
    values["sessionId"] = sessionId;
    values["userId"] = userId;
    await _channel.invokeMethod(PLAY_METHOD, values);

  }

}
