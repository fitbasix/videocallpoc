import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:fitbasix/core/constants/credentials.dart';
import 'package:fitbasix/feature/message/view/screens/videoCall_conference.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/get_trained/controller/trainer_controller.dart';
import 'package:fitbasix/feature/get_trained/services/trainer_services.dart';
import 'package:fitbasix/feature/message/controller/chat_controller.dart';
import 'package:fitbasix/feature/message/model/fetch_message_model.dart';
import 'package:fitbasix/feature/message/view/screens/action_widget.dart';
import 'package:fitbasix/feature/message/view/screens/media_message_widget.dart';
import 'package:fitbasix/feature/message/view/screens/message_widget.dart';
import 'package:fitbasix/feature/message/view/screens/poll_widget.dart';
import 'package:fitbasix/feature/message/view/web_call.dart';
import 'package:fitbasix/feature/message/view/widgets/actionSheetLayoutMode.dart';
import 'package:fitbasix/feature/message/view/widgets/loading_indicator.dart';
import 'package:fitbasix/feature/report_abuse/report_abuse_controller.dart';
import 'package:flutter/material.dart';
import 'package:cometchat/cometchat_sdk.dart';
import 'package:cometchat/cometchat_sdk.dart' as action_alias;
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../get_trained/model/all_trainer_model.dart' as trainer_model;

class MessageList extends StatefulWidget {
  MessageList(
      {Key? key,
      this.profilePicURL,
      this.trainerTitle,
      this.trainerId,
      this.time,
      this.days,
      this.chatId})
      : super(key: key);

   Rx<Conversation> conversation = Conversation(conversationType: ConversationType.user,
     conversationWith: User(name: ''),).obs;
  String? profilePicURL;
  String? trainerTitle;
  String? trainerId;
  String? time;
  List<int>? days;
  String? chatId;

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList>
    with MessageListener, GroupListener, UserListener, WidgetsBindingObserver, ConnectionListener {
  ChatController _chatController = Get.find();
  final RxList<BaseMessage> _messageList = <BaseMessage>[].obs;
  final _itemFetcher = ItemFetcher<BaseMessage>();
  final textKey = const ValueKey<int>(1);

  String listenerId = "message_list_listener";
  bool _isLoading = true;
  bool _hasMore = true;
  MessagesRequest? messageRequest;
  String appTitle = "";
  String appSubtitle = "";
  Widget appBarAvatar = Container();
  final formKey = GlobalKey<FormState>();
  String messageText = "";
  bool typing = false;
  final FocusNode _focus = FocusNode();
  String conversationWithId = "";
  TextEditingController _massageController = TextEditingController();
  Rx<String> _typedMessage = ''.obs;

  ///user attachment related variables
  var _userWantToSendMedia = false.obs;
  var _mediaIsUploading = false.obs;
  var fileName = ''.obs;

  ///GetX Controllers
  final TrainerController _trainerController = Get.find();
  HomeController _homeController = Get.find();
  final ReportAbuseController _reportAbuseController = Get.find();
  
  /// variable for chat loading
  RxBool isChatLoading = true.obs;

  Future<void> checkUserLogInStatus() async {
    ///login user if not logged in
    final user = await CometChat.getLoggedInUser();
    if(user == null){
      final prefs = await SharedPreferences.getInstance();
      String? Id = await prefs.getString("userIdForCometChat");
      bool loginStatus = await CometChatService().logInUser(Id!);
      if(loginStatus){
        await fetchUserMessages();
      }
      else{
       await checkUserLogInStatus();
      }
    }

  }

  Future<void> fetchUserMessages()async{
    await CometChat.getUser(widget.chatId!,
        onSuccess: (User user) {
          Conversation createConversation = Conversation(
            conversationType: ConversationType.user,
            conversationWith: user,
          );
          widget.conversation.value = createConversation;
          isChatLoading.value = false;
          isChatLoading.refresh();
          getChatFromHistory();

        }, onError: (CometChatException e) {
          debugPrint("User Fetch Failed: ${e.message}");
        });
  }

  ///recover all the previous chat
  getChatFromHistory(){
    print("got hete");
    int _limit = 30;
    String? _avatar;
      if (widget.conversation.value.conversationType == "user") {
        conversationWithId = (widget.conversation.value.conversationWith as User).uid;
      } else {
        conversationWithId = (widget.conversation.value.conversationWith as Group).guid;
      }
      if (widget.conversation.value.conversationType == CometChatReceiverType.user) {
        messageRequest = (MessagesRequestBuilder()
          ..uid = (widget.conversation.value.conversationWith as User).uid
          ..limit = _limit
          ..hideDeleted = true
          ..categories = [
            CometChatMessageCategory.action,
            CometChatMessageCategory.message,
            CometChatMessageCategory.custom
          ])
            .build();
        appTitle = (widget.conversation.value.conversationWith as User).name;
        _avatar = (widget.conversation.value.conversationWith as User).avatar;
        appSubtitle = (widget.conversation.value.conversationWith as User).status ?? '';
      } else {
        messageRequest = (MessagesRequestBuilder()
          ..guid = (widget.conversation.value.conversationWith as Group).guid
          ..limit = _limit
          ..hideDeleted = true
          ..categories = [
            CometChatMessageCategory.action,
            CometChatMessageCategory.message,
            CometChatMessageCategory.custom
          ])
            .build();
        appTitle = (widget.conversation.value.conversationWith as Group).name;
        _avatar = (widget.conversation.value.conversationWith as Group).icon;
        appSubtitle =
        "${(widget.conversation.value.conversationWith as Group).membersCount.toString()} members";
      }

      appBarAvatar = Hero(
        tag: widget.conversation.value,
        child: CircleAvatar(
            child: _avatar != null && _avatar.trim() != ''
                ? Image.network(
              _avatar,
            )
                : Text(appTitle.substring(0, 2))),
      );
    _isLoading = true;
    _hasMore = true;
    _loadMore();
      // setState(() {
      //
      // });
  }
  @override
  void initState() {
    checkUserLogInStatus();
    fetchUserMessages();
    CometChat.addMessageListener("listenerId", this);
    _focus.addListener(_onFocusChange);
    WidgetsBinding.instance!.addObserver(this);
    checkCometChatConnectionStatus();
    super.initState();

  }

  @override
  void onDisconnected() {
    CometChat.connect();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    checkCometChatConnectionStatus();
  }

  void checkCometChatConnectionStatus() async {
    String connectionStatus = await CometChat.getConnectionStatus();
    if(connectionStatus == CometChatWSState.disconnected){
      CometChat.connect();
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
    CometChat.removeMessageListener(listenerId);
  }

  void _onFocusChange() {
    if (_focus.hasFocus) {
      if (widget.conversation.value.conversationType == CometChatReceiverType.user) {
        User _user = widget.conversation.value.conversationWith as User;
        CometChat.startTyping(
          receaverUid: _user.uid,
          receiverType: CometChatReceiverType.user,
        );
      } else {
        Group _group = widget.conversation.value.conversationWith as Group;
        CometChat.startTyping(
          receaverUid: _group.guid,
          receiverType: CometChatReceiverType.group,
        );
      }
    } else if (!_focus.hasFocus) {
      if (widget.conversation.value.conversationType == CometChatReceiverType.user) {
        User _user = widget.conversation.value.conversationWith as User;
        CometChat.endTyping(
            receaverUid: _user.uid, receiverType: CometChatReceiverType.user);
      } else {
        Group _group = widget.conversation.value.conversationWith as Group;
        CometChat.endTyping(
            receaverUid: _group.guid,
            receiverType: CometChatReceiverType.group);
      }
    }
  }

  @override
  void onTextMessageReceived(TextMessage textMessage) async {
    _messageList.insert(0, textMessage);
    setState(() {});
    CometChat.markAsRead(textMessage, onSuccess: (_) {}, onError: (_) {});
  }

  @override
  void onMediaMessageReceived(MediaMessage mediaMessage) {
    if (mounted == true) {
      _messageList.insert(0, mediaMessage);
      setState(() {});
    }
    CometChat.markAsRead(mediaMessage, onSuccess: (_) {}, onError: (_) {});
  }

  @override
  void onCustomMessageReceived(CustomMessage customMessage) {
    _messageList.insert(0, customMessage);
    setState(() {});
  }

  @override
  void onTypingStarted(TypingIndicator typingIndicator) {
    setState(() {
      if (typingIndicator.sender.uid.toLowerCase().trim() ==
          conversationWithId.toLowerCase().trim()) {
        typing = true;
      }
    });
  }

  @override
  void onTypingEnded(TypingIndicator typingIndicator) {
    setState(() {
      if (typingIndicator.sender.uid.toLowerCase().trim() ==
          conversationWithId.toLowerCase().trim()) {
        typing = false;
      }
    });
  }

  @override
  void onMessagesDelivered(MessageReceipt messageReceipt) {
    for (int i = 0; i < _messageList.length; i++) {
      if (_messageList[i].sender!.uid == _chatController.USERID &&
          _messageList[i].id <= messageReceipt.messageId &&
          _messageList[i].deliveredAt == null) {
        _messageList[i].deliveredAt = messageReceipt.deliveredAt;
      }
    }
    setState(() {});
  }

  @override
  void onMessagesRead(MessageReceipt messageReceipt) {
    for (int i = 0; i < _messageList.length; i++) {
      if (_messageList[i].sender!.uid == _chatController.USERID &&
          _messageList[i].id <= messageReceipt.messageId &&
          _messageList[i].readAt == null) {
        _messageList[i].readAt = messageReceipt.readAt;
      }
    }
    setState(() {});
  }

  @override
  void onMessageEdited(BaseMessage message) {
    if (mounted == true) {
      for (int count = 0; count < _messageList.length; count++) {
        if (message.id == _messageList[count].id) {
          _messageList[count] = message;
          setState(() {});
          break;
        }
      }
    }
  }

  @override
  void onMessageDeleted(BaseMessage message) {
    int matchingIndex =
        _messageList.indexWhere((element) => (element.id == message.id));
    _messageList.removeAt(matchingIndex);
    setState(() {});
  }

  // Triggers fetch() and then add new items or change _hasMore flag
  void _loadMore() {
    _isLoading = true;
    _itemFetcher.fetchPreviuos(messageRequest)
        .then((List<BaseMessage> fetchedList) {
      if (fetchedList.isEmpty) {
        setState(() {
          _isLoading = false;
          _hasMore = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _messageList.addAll(fetchedList.reversed);
        });
      }
    });
  }

  createPoll(String question, List<String> options) {
    Map<String, dynamic> body = {};
    late String receiverID;
    late String receiverType;

    if (widget.conversation.value.conversationType == "user") {
      receiverID = (widget.conversation.value.conversationWith as User).uid;
      receiverType = CometChatConversationType.user;
    } else {
      receiverID = (widget.conversation.value.conversationWith as Group).guid;
      receiverType = CometChatConversationType.group;
    }

    body["question"] = question;
    body["options"] = options;
    body["receiver"] = receiverID;
    body["receiverType"] = receiverType;

    CometChat.callExtension("polls", "POST", "/v2/create", body,
        onSuccess: (_) {
      debugPrint("Success");
    }, onError: (CometChatException e) {});
  }

  deleteMessage(BaseMessage message) async {
    int matchingIndex =
        _messageList.indexWhere((element) => (element.id == message.id));

    await CometChat.deleteMessage(message.id,
        onSuccess: (_) {}, onError: (_) {});

    _messageList.removeAt(matchingIndex);
    setState(() {});
  }

  editMessage(BaseMessage message, String updatedText) async {
    int matchingIndex =
        _messageList.indexWhere((element) => (element.id == message.id));

    TextMessage editedMessage = message as TextMessage;
    editedMessage.text = updatedText;

    await CometChat.editMessage(editedMessage,
        onSuccess: (BaseMessage updatedMessage) {
      _messageList[matchingIndex] = updatedMessage;
    }, onError: (CometChatException e) {});

    setState(() {});
  }

  addMessage() {
    CometChat.addMessageListener("listenerId", MessageListener());
  }

  choosePoll(String vote, String id) {
    Map<String, dynamic> body = {"vote": vote, "id": id};
    CometChat.callExtension("polls", "POST", "/v2/vote", body,
        onSuccess: (Map<String, dynamic> map) {}, onError: (e) {});
  }

  Widget getTypingIndicator() {
    return Row(
      children: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Typing...",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget getMessageComposer(BuildContext context) {
    return Column(
      children: [
        Obx(() => _userWantToSendMedia.value
            ? Align(
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 16 * SizeConfig.widthMultiplier!,
                                vertical: 24 * SizeConfig.heightMultiplier!),
                            decoration: BoxDecoration(
                              color: kBlack,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: kPureWhite.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8 * SizeConfig.widthMultiplier!,
                                  vertical: 16 * SizeConfig.heightMultiplier!),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        fileName.value,
                                        style: AppTextStyle.normalGreenText
                                            .copyWith(color: kPureWhite),
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                      SizedBox(
                                        width: 7 * SizeConfig.widthMultiplier!,
                                      ),
                                    ],
                                  ),
                                  Obx(() => _mediaIsUploading.value
                                      ? SizedBox(
                                          height:
                                              21 * SizeConfig.heightMultiplier!)
                                      : Container()),
                                  Obx(() => _mediaIsUploading.value
                                      ? LinearProgressIndicator(
                                          backgroundColor: Color(0xff747474),
                                          color: kBlack)
                                      : Container())
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              )
            : Align(
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
                              focusNode: _focus,
                              keyboardType: TextInputType.multiline,
                              onChanged: (value) {
                                _typedMessage.value = value;
                              },
                              maxLines: null,
                              cursorColor: kPureWhite,
                              style: AppTextStyle.black400Text
                                  .copyWith(color: kPureWhite, height: 1.3),
                              controller: _massageController,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      left: 16 * SizeConfig.widthMultiplier!,
                                      top: 12 * SizeConfig.heightMultiplier!,
                                      bottom:
                                          12 * SizeConfig.heightMultiplier!),
                                  hintText: "message".tr,
                                  hintStyle: AppTextStyle.hsmallhintText,
                                  border: InputBorder.none,
                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 30 * SizeConfig.widthMultiplier!,
                                        child: IconButton(
                                            onPressed: sendMediaMessage,
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
                      ),
                      Obx(
                        () => (_typedMessage.value.isNotEmpty)
                            ? Padding(
                                padding: EdgeInsets.only(
                                    left: 23 * SizeConfig.widthMultiplier!),
                                child: GestureDetector(
                                    onTap: () {
                                      sendTextMessage();
                                      _massageController.clear();
                                      _typedMessage.value = '';
                                    },
                                    child: Icon(
                                      Icons.send,
                                      size: 21 * SizeConfig.heightMultiplier!,
                                      color: greenChatColor,
                                    )),
                              )
                            : Container(),
                      )
                    ],
                  ),
                ),
              ))

      ],
    );
  }

  Widget getMessageWidget(int index) {
    print("got in messageWidget");
    if (_messageList[index] is MediaMessage) {
      return MediaMessageWidget(
        passedMessage: (_messageList[index] as MediaMessage),
      );
    } else if (_messageList[index] is TextMessage) {
      return MessageWidget(
        passedMessage: (_messageList[index] as TextMessage),
        deleteFunction: deleteMessage,
        conversation: widget.conversation.value,
        editFunction: editMessage,
      );
    } else if (_messageList[index] is action_alias.Action) {
      return ActionWidget(
        passedMessage: (_messageList[index] as action_alias.Action),
      );
    } else if ((_messageList[index] is CustomMessage) &&
        _messageList[index].type == "extension_poll") {
      return PollWidget(
        passedMessage: (_messageList[index] as CustomMessage),
        conversation: widget.conversation.value,
        votePoll: choosePoll,
      );
    } else {
      return const Text("No match");
    }
  }

  sendMediaMessage() async {
    late String receiverID;
    late String messageType;
    String receiverType = widget.conversation.value.conversationType;
    String filePath = "";
    if (widget.conversation.value.conversationType == "user") {
      receiverID = (widget.conversation.value.conversationWith as User).uid;
    } else {
      receiverID = (widget.conversation.value.conversationWith as Group).guid;
    }

    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null && result.files.single.path != null) {
      _userWantToSendMedia.value = true;
      _mediaIsUploading.value = true;
      filePath = result.files.single.path!;
      fileName.value = result.files[0].name;

      String? fileExtension = lookupMimeType(result.files.single.path!);
      if (fileExtension != null) {
        if (fileExtension.startsWith("audio")) {
          messageType = CometChatMessageType.audio;
        } else if (fileExtension.startsWith("image")) {
          messageType = CometChatMessageType.image;
        } else if (fileExtension.startsWith("video")) {
          messageType = CometChatMessageType.video;
        } else if (fileExtension.startsWith("application")) {
          messageType = CometChatMessageType.file;
        } else {
          messageType = CometChatMessageType.file;
        }
      }

      MediaMessage mediaMessage = MediaMessage(
          receiverType: receiverType,
          type: messageType,
          receiverUid: receiverID,
          file: filePath);

      await CometChat.sendMediaMessage(mediaMessage,
          onSuccess: (MediaMessage message) {
        debugPrint("Media message sent successfully: ${mediaMessage.metadata}");
        _messageList.insert(0, message);
        _userWantToSendMedia.value = false;
        _mediaIsUploading.value = false;
      }, onError: (e) {
        debugPrint("Media message sending failed with exception: ${e.message}");
      });
    } else {
      // User canceled the picker
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
    late String receiverID;
    late String messageType;
    String receiverType = widget.conversation.value.conversationType;
    String filePath = "";
    if (widget.conversation.value.conversationType == "user") {
      receiverID = (widget.conversation.value.conversationWith as User).uid;
    } else {
      receiverID = (widget.conversation.value.conversationWith as Group).guid;
    }
    XFile? pickedFile = await pickFromCamera();
    if (pickedFile != null) {
      _userWantToSendMedia.value = true;
      _mediaIsUploading.value = true;
      fileName.value = pickedFile.name;
      filePath = pickedFile.path;

      try {
        MediaMessage mediaMessage = MediaMessage(
            receiverType: receiverType,
            type: CometChatMessageType.image,
            receiverUid: receiverID,
            file: filePath);

        await CometChat.sendMediaMessage(mediaMessage,
            onSuccess: (MediaMessage message) {
          debugPrint(
              "Media message sent successfully: ${mediaMessage.metadata}");
          _messageList.insert(0, message);
          _userWantToSendMedia.value = false;
          _mediaIsUploading.value = false;
        }, onError: (e) {
          debugPrint(
              "Media message sending failed with exception: ${e.message}");
        });
      } on PlatformException catch (e) {
        // Some error occurred, look at the exception message for more details
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("pick a image first")));
    }
  }

  sendTextMessage() {
    late String receiverID;
    String messagesText = _massageController.text.trim();
    late String receiverType;
    String type = CometChatMessageType.text;

    if (widget.conversation.value.conversationType == "user") {
      receiverID = (widget.conversation.value.conversationWith as User).uid;
      receiverType = CometChatConversationType.user;
    } else {
      receiverID = (widget.conversation.value.conversationWith as Group).guid;
      receiverType = CometChatConversationType.group;
    }
    TextMessage textMessage = TextMessage(
        text: messagesText,
        receiverUid: receiverID,
        receiverType: receiverType,
        type: type);

    CometChat.sendMessage(textMessage, onSuccess: (TextMessage message) {
      debugPrint("Message sent successfully:  ${message.text}");

      _messageList.insert(0, message);
      messageText = "";
    }, onError: (CometChatException e) {
      debugPrint("Message sending failed with exception:  ${e.message}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPureBlack,
      appBar: AppbarforChat(
        onHangUpTapped: (value) async {
          ///get video call url from backend
          String url =
          await TrainerServices.getEnablexUrl(widget.trainerId!);
          bool cameraStatus = await Permission.camera.request().isGranted;
          bool micStatus = await Permission.microphone.request().isGranted;
          if(cameraStatus&&micStatus){
            String? roomID =  await TrainerServices.getEnablexUrl(widget.trainerId!);
            if(roomID != null){
              var value = {
                'user_ref': "2236",
                "roomId": roomID,
                "role": "participant",
                "name": widget.trainerTitle
              };
              print(jsonEncode(value));
              var response = await http.post(
                  Uri.parse(
                      kBaseURL + "createToken"), // replace FQDN with Your Server API URL
                  headers: headerForVideoCall,
                  body: jsonEncode(value));
              print(kBaseURL);
              print("ppppm "+response.body);
              if (response.statusCode == 200) {
                print(response.body);
                Map<String, dynamic> user = jsonDecode(response.body);
                String token = user['token'].toString();
                print('apptoken${token}');
                if(token!='null' && token.isNotEmpty) {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) =>
                  //           VideoConferenceScreen(token: token,)),
                  // );
                  //  Navigator.pushNamed(context, '/Conference');

                }

              }else{


              }

            }
          }
          ///call with timing logic
          // log(widget.days!.toString());

          // _trainerController.isVideoAvailable(widget.time.toString());
          //
          // if (widget.days!.indexOf(_trainerController.daysInt[
          //             DateFormat("EEE").format(DateTime.now().toUtc())]!) !=
          //         -1 &&
          //     _trainerController.isVideoAvailable(widget.time.toString()) ==
          //         true) {
          //   DateFormat("EEE").format(DateTime.now());
          //
          //
          // } else {
          //   showDialogForVideoCallNotPossible(
          //       context,
          //       _trainerController.getTime(widget.time.toString()),
          //       _trainerController.GetDays(widget.days));
          // }
        },
        onMenuTap: () {
          //checkUserOnlineStatus();

          //QB.chat.disconnect();
          createMenuDialog(context);
        },
        parentContext: context,
        trainertitle: widget.trainerTitle,
        trainerstatus: ''.tr,
        trainerProfilePicUrl: widget.profilePicURL,
      ),
      body: SafeArea(
          child: Column(
        children: [
          Obx(()=>!isChatLoading.value?Expanded(
            child: Obx(
              () => ListView.builder(
                physics: const BouncingScrollPhysics(),
                reverse: true,
                // to diisplay loading tile if more items
                itemCount:
                    _hasMore ? _messageList.length + 1 : _messageList.length,
                itemBuilder: (BuildContext context, int index) {
                  // Uncomment the following line to see in real time how ListView.builder works
                  // print('ListView.builder is building index $index');
                  if (index >= _messageList.length) {
                    // Don't trigger if one async loading is already under way
                    if (!_isLoading) {
                      _loadMore();
                    }
                    return const LoadingIndicator();
                  }
                  return getMessageWidget(index);
                },
              ),
            ),
          ):Expanded(
            child: Shimmer.fromColors(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
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
                  SizedBox(
                      height: 16 * SizeConfig.heightMultiplier!),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(
                          right:
                          16 * SizeConfig.widthMultiplier!),
                      height: 42 * SizeConfig.heightMultiplier!,
                      width: 191 * SizeConfig.widthMultiplier!,
                      color: Color(0xFF3646464),
                    ),
                  ),
                  SizedBox(
                      height: 16 * SizeConfig.heightMultiplier!),
                  Container(
                    margin: EdgeInsets.only(
                        left: 16 * SizeConfig.widthMultiplier!),
                    height: 28 * SizeConfig.heightMultiplier!,
                    width: 176 * SizeConfig.widthMultiplier!,
                    color: Color(0xFF3646464),
                  ),
                  SizedBox(
                      height: 16 * SizeConfig.heightMultiplier!),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(
                          right:
                          16 * SizeConfig.widthMultiplier!),
                      height: 78 * SizeConfig.heightMultiplier!,
                      width: 232 * SizeConfig.widthMultiplier!,
                      color: Color(0xFF3646464),
                    ),
                  ),
                ],
              ),
              baseColor: Color.fromARGB(0, 255, 255, 255)
                  .withOpacity(0.1),
              highlightColor: Color.fromARGB(1, 255, 255, 255)
                  .withOpacity(0.46),
            ),
          )),
          if (typing == true) getTypingIndicator(),
          getMessageComposer(context)
        ],
      )),
    );
  }

  void createFileSizeIsLargeDialog(BuildContext context) {
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
                      "File is too large",
                      style: AppTextStyle.black400Text.copyWith(
                          color: Theme.of(context).textTheme.bodyText1!.color),
                    ),
                    SizedBox(
                      height: 16 * SizeConfig.heightMultiplier!,
                    ),
                    Text(
                      "Cannot upload files larger\n than 25MB.",
                      style: AppTextStyle.black400Text.copyWith(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                          fontSize: 12 * SizeConfig.textMultiplier!,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )),
        );
      },
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
                    vertical: 0 * SizeConfig.heightMultiplier!),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8 * SizeConfig.imageSizeMultiplier!)),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 10.0 * SizeConfig.heightMultiplier!,
                                  left: 10 * SizeConfig.heightMultiplier!,
                                  right: 10 * SizeConfig.heightMultiplier!),
                              child: SvgPicture.asset(
                                ImagePath.closedialogIcon,
                                color: Theme.of(context).primaryColor,
                                width: 16 * SizeConfig.widthMultiplier!,
                                height: 16 * SizeConfig.heightMultiplier!,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.trainerTitle!,
                      style: AppTextStyle.black400Text.copyWith(
                          color: Theme.of(context).textTheme.bodyText1!.color),
                    ),
                    SizedBox(
                      height: 26 * SizeConfig.heightMultiplier!,
                    ),
                    GestureDetector(
                      onTap: () async {
                        //_trainerController.atrainerDetail.value = Trainer();
                        _trainerController.atrainerDetail.value = trainer_model.Trainer();

                                  _trainerController.isProfileLoading.value =
                                      true;
                                  _trainerController
                                      .isMyTrainerProfileLoading.value = true;
                                  Navigator.pushNamed(
                                      context, RouteName.trainerProfileScreen);

                                  var result =
                                      await TrainerServices.getATrainerDetail(
                                          widget.trainerId!);
                                  _trainerController.atrainerDetail.value =
                                      result.response!.data!;

                                  _trainerController.planModel.value =
                                      await TrainerServices.getPlanByTrainerId(
                                          widget.trainerId!);

                                  _trainerController.initialPostData.value =
                                      await TrainerServices.getTrainerPosts(
                                          widget.trainerId!, 0);
                                  _trainerController
                                      .isMyTrainerProfileLoading.value = false;
                                  _trainerController.loadingIndicator.value =
                                      false;
                                  if (_trainerController.initialPostData.value
                                          .response!.data!.length !=
                                      0) {
                                    _trainerController.trainerPostList.value =
                                        _trainerController.initialPostData.value
                                            .response!.data!;
                                  } else {
                                    _trainerController.trainerPostList.clear();
                                  }
                                  _trainerController.isProfileLoading.value =
                                      false;
                                  _trainerController
                                      .isMyTrainerProfileLoading.value = false;
                      },
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
                            'open_profile'.tr,
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
                      onTap: () {
                        reportAbuseDialog(context);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            ImagePath.reportabuseicon,
                            color: Colors.white,
                            height: 20 * SizeConfig.heightMultiplier!,
                            width: 20 * SizeConfig.widthMultiplier!,
                          ),
                          SizedBox(
                            width: 10.5 * SizeConfig.widthMultiplier!,
                          ),
                          Text(
                            'Report abuse',
                            style: AppTextStyle.black400Text.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 26 * SizeConfig.heightMultiplier!,
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }

  void showDialogForVideoCallNotPossible(
      BuildContext context, String time, String days) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: kBlack.withOpacity(0.6),
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: AlertDialog(
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 30 * SizeConfig.heightMultiplier!,
                      horizontal: 30 * SizeConfig.widthMultiplier!),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          8 * SizeConfig.imageSizeMultiplier!)),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  content: Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: SvgPicture.asset(
                                ImagePath.closedialogIcon,
                                color: Theme.of(context).primaryColor,
                                width: 16 * SizeConfig.imageSizeMultiplier!,
                                height: 16 * SizeConfig.imageSizeMultiplier!,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 100 * SizeConfig.heightMultiplier!,
                            width: 100 * SizeConfig.widthMultiplier!,
                            child: Image.asset(ImagePath.animatedErrorIcon),
                          ),
                          SizedBox(
                            height: 26 * SizeConfig.heightMultiplier!,
                          ),
                          Text(
                            "call_not_possible".tr,
                            style: AppTextStyle.black400Text.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 16 * SizeConfig.heightMultiplier!,
                          ),
                          Text(
                            "call_not_possible_time"
                                .trParams({'time': time, 'days': days}),
                            style: AppTextStyle.black400Text.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ))),
        );
      },
    );
  }

  void reportAbuseDialog(BuildContext context) {
    RxInt selectedProblemIndex = (-1).obs;
    RxBool blockUser = false.obs;

    if (_reportAbuseController.reportAbuseList.value.response == null) {
      _reportAbuseController.getReportAbuseData();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: kBlack.withOpacity(0.6),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: AlertDialog(
                insetPadding: EdgeInsets.only(
                  left: 16 * SizeConfig.widthMultiplier!,
                  right: 16 * SizeConfig.widthMultiplier!,
                ),
                contentPadding: EdgeInsets.zero,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0))),
                content: Obx(() => (_reportAbuseController
                        .isReportAbuseLoading.value)
                    ? Container(
                        child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 30 * SizeConfig.heightMultiplier!),
                        child: SizedBox(
                            height: 30 * SizeConfig.widthMultiplier!,
                            width: 30 * SizeConfig.widthMultiplier!,
                            child: CustomizedCircularProgress()),
                      ))
                    : Stack(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 32 * SizeConfig.heightMultiplier!,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Report Abuse".tr,
                                  style: AppTextStyle.black600Text.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.color,
                                    fontSize: (16) * SizeConfig.textMultiplier!,
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 32 * SizeConfig.heightMultiplier!,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        36 * SizeConfig.widthMultiplier!),
                                child: Text(
                                  "Why_reporting?".tr,
                                  style: AppTextStyle.black600Text.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.color,
                                    fontSize: (12) * SizeConfig.textMultiplier!,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8.02 * SizeConfig.heightMultiplier!,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        36 * SizeConfig.widthMultiplier!),
                                child: Text(
                                  "report_abuse_description".tr,
                                  style: AppTextStyle.black400Text.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.color,
                                    fontSize: (11) * SizeConfig.textMultiplier!,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20 * SizeConfig.heightMultiplier!,
                              ),
                              Container(
                                height: 300 * SizeConfig.heightMultiplier!,
                                child: Obx(
                                  () => SingleChildScrollView(
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: List.generate(
                                            _reportAbuseController
                                                .reportAbuseList
                                                .value
                                                .response!
                                                .data!
                                                .length,
                                            (index) => Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        selectedProblemIndex
                                                            .value = index;
                                                      },
                                                      child: Container(
                                                        width: 328 *
                                                            SizeConfig
                                                                .widthMultiplier!,
                                                        color: selectedProblemIndex
                                                                    .value ==
                                                                index
                                                            ? Colors.white
                                                                .withOpacity(
                                                                    0.1)
                                                            : Colors
                                                                .transparent,
                                                        child: Padding(
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal: 36 *
                                                                  SizeConfig
                                                                      .widthMultiplier!,
                                                              vertical: 10 *
                                                                  SizeConfig
                                                                      .heightMultiplier!),
                                                          child: Text(
                                                            _reportAbuseController
                                                                .reportAbuseList
                                                                .value
                                                                .response!
                                                                .data![index]
                                                                .reason!
                                                                .replaceAll(
                                                                    "-EN", ""),
                                                            style: AppTextStyle.black400Text.copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyText1
                                                                    ?.color,
                                                                fontSize: (12) *
                                                                    SizeConfig
                                                                        .textMultiplier!,
                                                                fontWeight: selectedProblemIndex
                                                                            .value ==
                                                                        index
                                                                    ? FontWeight
                                                                        .w600
                                                                    : FontWeight
                                                                        .w500,
                                                                height: 1.3),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ))),
                                  ),
                                ),
                              ),
                              // SizedBox(
                              //   height: 32 * SizeConfig.heightMultiplier!,
                              // ),
                              SizedBox(
                                height: 24 * SizeConfig.heightMultiplier!,
                              ),
                              Obx(() => Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            35 * SizeConfig.widthMultiplier!),
                                    child: GestureDetector(
                                      onTap: () {
                                        blockUser.value = !blockUser.value;
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            Container(
                                              color: Colors.transparent,
                                              child: Padding(
                                                  padding: EdgeInsets.all(5 *
                                                      SizeConfig
                                                          .widthMultiplier!),
                                                  child: SvgPicture.asset(
                                                    blockUser.value
                                                        ? ImagePath.selectedBox
                                                        : ImagePath
                                                            .unselectedBox,
                                                    height: 18 *
                                                        SizeConfig
                                                            .heightMultiplier!,
                                                    width: SizeConfig
                                                        .widthMultiplier!,
                                                  )),
                                            ),
                                            SizedBox(
                                              width: 8 *
                                                  SizeConfig.widthMultiplier!,
                                            ),
                                            RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(children: [
                                                TextSpan(
                                                  text: 'Block_person'.tr,
                                                  style: AppTextStyle.NormalText
                                                      .copyWith(
                                                          fontSize: 14 *
                                                              SizeConfig
                                                                  .textMultiplier!,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: kPink),
                                                ),
                                              ]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    0 * SizeConfig.widthMultiplier!,
                                    32 * SizeConfig.heightMultiplier!,
                                    0 * SizeConfig.widthMultiplier!,
                                    48 * SizeConfig.heightMultiplier!,
                                  ),
                                  child: Container(
                                      width: 256 * SizeConfig.widthMultiplier!,
                                      height: 48 * SizeConfig.heightMultiplier!,
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              elevation:
                                                  MaterialStateProperty.all(0),
                                              backgroundColor:
                                                  selectedProblemIndex.value >=
                                                          0
                                                      ? MaterialStateProperty
                                                          .all(kgreen49)
                                                      : MaterialStateProperty
                                                          .all(hintGrey),
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(8 *
                                                              SizeConfig
                                                                  .widthMultiplier!)))),
                                          onPressed: () async {
                                            if (selectedProblemIndex.value >=
                                                0) {
                                              if (!_reportAbuseController
                                                  .isReportSendAbuseLoading
                                                  .value) {
                                                _reportAbuseController
                                                    .isReportSendAbuseLoading
                                                    .value = true;
                                                var response =
                                                    await _reportAbuseController
                                                        .sendRepostAbuseData(
                                                            userId: widget
                                                                .trainerId,
                                                            reason: _reportAbuseController
                                                                .reportAbuseList
                                                                .value
                                                                .response!
                                                                .data![
                                                                    selectedProblemIndex
                                                                        .value]
                                                                .serialId);
                                                _reportAbuseController
                                                    .isReportSendAbuseLoading
                                                    .value = false;
                                                if (response.isNotEmpty) {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content:
                                                              Text(response)));
                                                }
                                              }
                                            } else {
                                              pleaseSelectAnOptionDialog(
                                                  context);
                                            }
                                          },
                                          child: Text(
                                            "Submit".tr,
                                            style: AppTextStyle.hboldWhiteText
                                                .copyWith(
                                                    color: selectedProblemIndex
                                                                .value >=
                                                            0
                                                        ? kPureWhite
                                                        : greyBorder),
                                          ))),
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 7 * SizeConfig.heightMultiplier!,
                            right: 7 * SizeConfig.widthMultiplier!,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: SvgPicture.asset(
                                ImagePath.closedialogIcon,
                                color: Theme.of(context).primaryColor,
                                width: 16 * SizeConfig.widthMultiplier!,
                                height: 16 * SizeConfig.heightMultiplier!,
                              ),
                            ),
                          ),
                        ],
                      ))),
          ),
        );
      },
    );
  }

  void pleaseSelectAnOptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: kBlack.withOpacity(0.6),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: AlertDialog(
                insetPadding: EdgeInsets.only(
                  left: 16 * SizeConfig.widthMultiplier!,
                  right: 16 * SizeConfig.widthMultiplier!,
                ),
                contentPadding: EdgeInsets.zero,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0))),
                content: Obx(
                    () => (_reportAbuseController.isReportAbuseLoading.value)
                        ? Container(
                            child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 30 * SizeConfig.heightMultiplier!),
                            child: SizedBox(
                                height: 30 * SizeConfig.widthMultiplier!,
                                width: 30 * SizeConfig.widthMultiplier!,
                                child: CustomizedCircularProgress()),
                          ))
                        : Stack(
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 32 * SizeConfig.heightMultiplier!,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(
                                        16 * SizeConfig.widthMultiplier!),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Please select a valid reason\n for reporting."
                                            .tr,
                                        style: AppTextStyle.black600Text
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    ?.color,
                                                fontSize: (14) *
                                                    SizeConfig.textMultiplier!,
                                                fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 7 * SizeConfig.heightMultiplier!,
                                right: 7 * SizeConfig.widthMultiplier!,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: SvgPicture.asset(
                                    ImagePath.closedialogIcon,
                                    color: Theme.of(context).primaryColor,
                                    width: 16 * SizeConfig.widthMultiplier!,
                                    height: 16 * SizeConfig.heightMultiplier!,
                                  ),
                                ),
                              ),
                            ],
                          ))),
          ),
        );
      },
    );
  }
}

class ActionItem {
  int id;
  String title;
  IconData? icon;

  ActionItem({
    required this.id,
    required this.title,
    this.icon,
  });
}

///Function to show comeChat action sheet
Future<ActionItem?>? showCometChatActionSheet(
    {required BuildContext context,
    required List<ActionItem> actionItems,
    final String? title,
    final TextStyle? titleStyle,
    final IconData? layoutModeIcon,
    final bool? isLayoutModeIconVisible,
    final bool? isTitleVisible,
    final bool? isGridLayout,
    final ShapeBorder? alertShapeBorder}) {
  return showModalBottomSheet<ActionItem>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      enableDrag: true,
      shape: alertShapeBorder ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
      builder: (BuildContext context) => CometChatActionSheet(
          actionItems: actionItems,
          title: title,
          titleStyle: titleStyle,
          layoutModeIcon: layoutModeIcon,
          isLayoutModeIconVisible: isLayoutModeIconVisible,
          isTitleVisible: isTitleVisible,
          isGridLayout: isGridLayout));
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
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
