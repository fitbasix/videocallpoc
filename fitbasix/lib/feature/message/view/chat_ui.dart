// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'dart:isolate';
// import 'dart:ui';
// import 'package:crypt/crypt.dart';
// import 'package:fitbasix/core/routes/api_routes.dart';
// import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
// import 'package:fitbasix/feature/Home/view/widgets/feedback_dialogbox.dart';
// import 'package:fitbasix/feature/get_trained/controller/trainer_controller.dart';
// import 'package:fitbasix/feature/message/controller/web_rtc_controller.dart';
// import 'package:fitbasix/feature/spg/view/set_goal_screen.dart';
// import 'package:get/get_rx/get_rx.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// import 'package:get/get_utils/src/extensions/internacionalization.dart';
// import 'package:get/instance_manager.dart';
// import 'package:http/http.dart' as http;
// import 'package:dio/dio.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:fitbasix/core/constants/image_path.dart';
// import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
// import 'package:fitbasix/feature/message/model/reciever_message_model.dart';
// import 'package:fitbasix/feature/message/view/documents_view_screen.dart';
// import 'package:fitbasix/core/routes/app_routes.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:flutter_switch/flutter_switch.dart';
//
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:lottie/lottie.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:quickblox_sdk/chat/constants.dart';
// import 'package:quickblox_sdk/models/qb_attachment.dart';
// import 'package:quickblox_sdk/models/qb_dialog.dart';
// import 'package:quickblox_sdk/models/qb_event.dart';
// import 'package:quickblox_sdk/models/qb_file.dart';
// import 'package:quickblox_sdk/models/qb_filter.dart';
// import 'package:quickblox_sdk/models/qb_message.dart';
// import 'package:quickblox_sdk/models/qb_sort.dart';
// import 'package:quickblox_sdk/models/qb_subscription.dart';
// import 'package:quickblox_sdk/models/qb_user.dart';
// import 'package:quickblox_sdk/notifications/constants.dart';
// import 'package:quickblox_sdk/push/constants.dart';
// import 'package:quickblox_sdk/quickblox_sdk.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shimmer/shimmer.dart';
// import '../../../core/api_service/dio_service.dart';
// import '../../../core/constants/app_text_style.dart';
// import '../../../core/constants/color_palette.dart';
// import '../../../core/reponsive/SizeConfig.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:mime_type/mime_type.dart';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
//
// import 'package:flutter/services.dart';
//
// import 'package:quickblox_sdk/models/qb_rtc_session.dart';
//
// import 'package:quickblox_sdk/quickblox_sdk.dart';
//
// import 'package:quickblox_sdk/webrtc/constants.dart';
//
// import 'package:quickblox_sdk/webrtc/rtc_video_view.dart';
//
// import '../../Home/view/widgets/healthData.dart';
// import '../../get_trained/model/PlanModel.dart';
// import '../../get_trained/model/all_trainer_model.dart';
// import '../../get_trained/services/trainer_services.dart';
// import '../../log_in/services/login_services.dart';
// import '../../posts/services/createPost_Services.dart';
// import '../../report_abuse/report_abuse_controller.dart';
// import '../controller/chat_controller.dart';
// import 'chat_error.dart';
// import 'chat_videocallscreen.dart';
//
// class ChatScreen extends StatefulWidget {
//   int? opponentID;
//   QBDialog? userDialogForChat;
//   bool? isCurrentlyEnrolled;
//   String? trainerTitle;
//   String? profilePicURL;
//   String? trainerId;
//   String? time;
//   List<int>? days;
//
//   ChatScreen(
//       {Key? key,
//       this.userDialogForChat,
//       this.opponentID,
//       this.trainerTitle,
//       this.isCurrentlyEnrolled,
//       this.profilePicURL,
//       this.trainerId,
//       this.time,
//       this.days})
//       : super(key: key);
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   ChatController _chatController = Get.put(ChatController());
//   var isPlanLoading = false.obs;
//   final TrainerController _trainerController = Get.find();
//   HomeController _homeController = Get.find();
//   //QBDialog? userDialogForChat;
//   var _massageController = TextEditingController().obs;
//   StreamSubscription? _massageStreamSubscription;
//   String event = QBChatEvents.RECEIVED_NEW_MESSAGE;
//   List<QBMessage?>? messages;
//   DateTime? messageDate = DateTime(2015, 5, 5);
//   var _typedMessage = "".obs;
//   var _userWantToSendMedia = false.obs;
//   var _mediaIsUploading = false.obs;
//   List<QBAttachment> attachmentsList = [];
//   QBAttachment attachment = QBAttachment();
//   var fileName = ''.obs;
//
//   StreamSubscription? _connectionStreamSubscription;
//
//   StreamSubscription? _callEndSubscription;
//
//   StreamSubscription? _rejectSubscription;
//
//   StreamSubscription? _acceptSubscription;
//
//   StreamSubscription? _hangUpSubscription;
//
//   StreamSubscription? _videoTrackSubscription;
//
//   StreamSubscription? _notAnswerSubscription;
//
//   StreamSubscription? _peerConnectionSubscription;
//   final ReportAbuseController _reportAbuseController = Get.find();
//
//   @override
//   void dispose() {
//     if (_massageStreamSubscription != null) {
//       _massageStreamSubscription!.cancel();
//       _massageStreamSubscription = null;
//     }
//     unSubscribeInitStreamManagement();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     getDialogId();
//     initStreamManagement();
//     initMassage();
//     connectionEvent();
//     super.initState();
//   }
//
//   void getDialogId() async {
//     bool dialogCreatedPreviously = false;
//     int openPage = 0;
//     final sharedPreferences = await SharedPreferences.getInstance();
//
//     _homeController.userQuickBloxId.value =
//         sharedPreferences.getInt("userQuickBloxId")!;
//     if (_homeController.userQuickBloxId.value == 0) {
//       deActiveAccount(context);
//       // showDialog(
//       //     context: context,
//       //     builder: (_) =>
//       //         HealthApp());
//     }
//
//     print(_homeController.userQuickBloxId.value.toString() + " demo id");
//     int UserQuickBloxId = widget.opponentID!; //133819788;
//     QBSort sort = QBSort();
//     sort.field = QBChatDialogSorts.LAST_MESSAGE_DATE_SENT;
//     sort.ascending = true;
//     try {
//       List<QBDialog?> dialogs = await QB.chat
//           .getDialogs(
//         sort: sort,
//       )
//           .then((value) async {
//         for (int i = 0; i < value.length; i++) {
//           if (value[i]!
//                   .occupantsIds!
//                   .contains(_homeController.userQuickBloxId.value) &&
//               value[i]!.occupantsIds!.contains(UserQuickBloxId)) {
//             dialogCreatedPreviously = true;
//             widget.userDialogForChat = value[i]!;
//             getMassageFromHistory();
//             break;
//           }
//         }
//         if (!dialogCreatedPreviously) {
//           List<int> occupantsIds = [
//             _homeController.userQuickBloxId.value,
//             UserQuickBloxId
//           ];
//           String dialogName = UserQuickBloxId.toString() +
//               _homeController.userQuickBloxId.value.toString() +
//               DateTime.now().millisecond.toString();
//           int dialogType = QBChatDialogTypes.CHAT;
//           try {
//             QBDialog? createdDialog = await QB.chat
//                 .createDialog(
//               occupantsIds,
//               dialogType: QBChatDialogTypes.CHAT,
//             )
//                 .then((value) {
//               widget.userDialogForChat = value;
//               getMassageFromHistory();
//             });
//           } on PlatformException catch (e) {}
//         }
//         return value;
//       });
//     } on PlatformException catch (e) {}
//   }
//
//   checkUserOnlineStatus() async {
//     try {
//       var status = await QB.chat.getOnlineUsers(widget.userDialogForChat!.id!);
//     } on PlatformException catch (e) {}
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kPureBlack,
//       appBar: AppbarforChat(
//         trainerProfilePicUrl: widget.profilePicURL,
//         onHangUpTapped: (value) async {
//           _trainerController.isVideoAvailable(widget.time.toString());
//
//           //showDialogForVideoCallNotPossible(context);
//           callWebRTC(QBRTCSessionTypes.VIDEO).then((value) {
//             Navigator.of(context).push(MaterialPageRoute(
//                 builder: (context) => VideoCallScreen(
//                   sessionIdForVideoCall: value!,
//                   name: widget.trainerTitle,
//                   imageURL: widget.profilePicURL,
//                 )));
//             //showDialogForVideoCallNotPossible(context);
//           });
//
//           if (widget.days!.indexOf(_trainerController.daysInt[
//                       DateFormat("EEE").format(DateTime.now().toUtc())]!) !=
//                   -1 &&
//               _trainerController.isVideoAvailable(widget.time.toString()) ==
//                   true) {
//             DateFormat("EEE").format(DateTime.now());
//             if (await Permission.camera.request().isGranted &&
//                 await Permission.microphone.request().isGranted) {
//               callWebRTC(QBRTCSessionTypes.VIDEO).then((value) {
//                 Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) => VideoCallScreen(
//                           sessionIdForVideoCall: value!,
//                           name: widget.trainerTitle,
//                           imageURL: widget.profilePicURL,
//                         )));
//                 //showDialogForVideoCallNotPossible(context);
//               });
//             }
//           } else {
//             showDialogForVideoCallNotPossible(
//                 context,
//                 _trainerController.getTime(widget.time.toString()),
//                 _trainerController.GetDays(widget.days));
//           }
//         },
//         onMenuTap: () {
//           if (messages != null) {
//             //checkUserOnlineStatus();
//
//             //QB.chat.disconnect();
//             createMenuDialog(context);
//           }
//         },
//         parentContext: context,
//         trainertitle: widget.trainerTitle,
//         trainerstatus: ''.tr,
//       ),
//       body: SafeArea(
//         child: Container(
//           child: Column(
//             children: [
//               (widget.userDialogForChat != null)
//                   ? (messages != null)
//                       ? Expanded(
//                           child: ListView.builder(
//                               reverse: true,
//                               physics: const BouncingScrollPhysics(),
//                               itemCount: messages!.length,
//                               itemBuilder: (context, index) {
//                                 if (messages![index]!.senderId ==
//                                     _homeController.userQuickBloxId.value) {
//                                   return MessageBubbleSender(
//                                     message: messages![index],
//                                   );
//                                 } else {
//                                   return MessageBubbleOpponent(
//                                     message: messages![index],
//                                   );
//                                 }
//                               }),
//                         )
//                       : Expanded(
//                           child: Shimmer.fromColors(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Spacer(),
//                                 Container(
//                                   margin: EdgeInsets.only(
//                                       left: 16 * SizeConfig.widthMultiplier!),
//                                   height: 28 * SizeConfig.heightMultiplier!,
//                                   width: 176 * SizeConfig.widthMultiplier!,
//                                   color: Color(0xFF3646464),
//                                 ),
//                                 SizedBox(
//                                   height: 8 * SizeConfig.heightMultiplier!,
//                                 ),
//                                 Container(
//                                   margin: EdgeInsets.only(
//                                       left: 16 * SizeConfig.widthMultiplier!),
//                                   height: 49 * SizeConfig.heightMultiplier!,
//                                   width: 215 * SizeConfig.widthMultiplier!,
//                                   color: Color(0xFF3646464),
//                                 ),
//                                 SizedBox(
//                                   height: 8 * SizeConfig.heightMultiplier!,
//                                 ),
//                                 Container(
//                                   margin: EdgeInsets.only(
//                                       left: 16 * SizeConfig.widthMultiplier!),
//                                   height: 28 * SizeConfig.heightMultiplier!,
//                                   width: 176 * SizeConfig.widthMultiplier!,
//                                   color: Color(0xFF3646464),
//                                 ),
//                                 SizedBox(
//                                     height: 16 * SizeConfig.heightMultiplier!),
//                                 Align(
//                                   alignment: Alignment.centerRight,
//                                   child: Container(
//                                     margin: EdgeInsets.only(
//                                         right:
//                                             16 * SizeConfig.widthMultiplier!),
//                                     height: 42 * SizeConfig.heightMultiplier!,
//                                     width: 191 * SizeConfig.widthMultiplier!,
//                                     color: Color(0xFF3646464),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                     height: 16 * SizeConfig.heightMultiplier!),
//                                 Container(
//                                   margin: EdgeInsets.only(
//                                       left: 16 * SizeConfig.widthMultiplier!),
//                                   height: 28 * SizeConfig.heightMultiplier!,
//                                   width: 176 * SizeConfig.widthMultiplier!,
//                                   color: Color(0xFF3646464),
//                                 ),
//                                 SizedBox(
//                                     height: 16 * SizeConfig.heightMultiplier!),
//                                 Align(
//                                   alignment: Alignment.centerRight,
//                                   child: Container(
//                                     margin: EdgeInsets.only(
//                                         right:
//                                             16 * SizeConfig.widthMultiplier!),
//                                     height: 78 * SizeConfig.heightMultiplier!,
//                                     width: 232 * SizeConfig.widthMultiplier!,
//                                     color: Color(0xFF3646464),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             baseColor: Color.fromARGB(0, 255, 255, 255)
//                                 .withOpacity(0.1),
//                             highlightColor: Color.fromARGB(1, 255, 255, 255)
//                                 .withOpacity(0.46),
//                           ),
//                         )
//                   : Expanded(
//                       child: Shimmer.fromColors(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Spacer(),
//                             Container(
//                               margin: EdgeInsets.only(
//                                   left: 16 * SizeConfig.widthMultiplier!),
//                               height: 28 * SizeConfig.heightMultiplier!,
//                               width: 176 * SizeConfig.widthMultiplier!,
//                               color: Color(0xFF3646464),
//                             ),
//                             SizedBox(
//                               height: 8 * SizeConfig.heightMultiplier!,
//                             ),
//                             Container(
//                               margin: EdgeInsets.only(
//                                   left: 16 * SizeConfig.widthMultiplier!),
//                               height: 49 * SizeConfig.heightMultiplier!,
//                               width: 215 * SizeConfig.widthMultiplier!,
//                               color: Color(0xFF3646464),
//                             ),
//                             SizedBox(
//                               height: 8 * SizeConfig.heightMultiplier!,
//                             ),
//                             Container(
//                               margin: EdgeInsets.only(
//                                   left: 16 * SizeConfig.widthMultiplier!),
//                               height: 28 * SizeConfig.heightMultiplier!,
//                               width: 176 * SizeConfig.widthMultiplier!,
//                               color: Color(0xFF3646464),
//                             ),
//                             SizedBox(height: 16 * SizeConfig.heightMultiplier!),
//                             Align(
//                               alignment: Alignment.centerRight,
//                               child: Container(
//                                 margin: EdgeInsets.only(
//                                     right: 16 * SizeConfig.widthMultiplier!),
//                                 height: 42 * SizeConfig.heightMultiplier!,
//                                 width: 191 * SizeConfig.widthMultiplier!,
//                                 color: Color(0xFF3646464),
//                               ),
//                             ),
//                             SizedBox(height: 16 * SizeConfig.heightMultiplier!),
//                             Container(
//                               margin: EdgeInsets.only(
//                                   left: 16 * SizeConfig.widthMultiplier!),
//                               height: 28 * SizeConfig.heightMultiplier!,
//                               width: 176 * SizeConfig.widthMultiplier!,
//                               color: Color(0xFF3646464),
//                             ),
//                             SizedBox(height: 16 * SizeConfig.heightMultiplier!),
//                             Align(
//                               alignment: Alignment.centerRight,
//                               child: Container(
//                                 margin: EdgeInsets.only(
//                                     right: 16 * SizeConfig.widthMultiplier!),
//                                 height: 78 * SizeConfig.heightMultiplier!,
//                                 width: 232 * SizeConfig.widthMultiplier!,
//                                 color: Color(0xFF3646464),
//                               ),
//                             ),
//                           ],
//                         ),
//                         baseColor:
//                             Color.fromARGB(0, 255, 255, 255).withOpacity(0.1),
//                         highlightColor:
//                             Color.fromARGB(1, 255, 255, 255).withOpacity(0.46),
//                       ),
//                     ),
//
//               ///todo remove this ! sign
//               widget.isCurrentlyEnrolled!
//                   ? Obx(() => _userWantToSendMedia.value
//                       ? Align(
//                           alignment: Alignment.bottomCenter,
//                           child: Container(
//                             padding: EdgeInsets.all(
//                                 16 * SizeConfig.widthMultiplier!),
//                             decoration: BoxDecoration(
//                               color: Colors.transparent,
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Expanded(
//                                   child: Container(
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal:
//                                               16 * SizeConfig.widthMultiplier!,
//                                           vertical: 24 *
//                                               SizeConfig.heightMultiplier!),
//                                       decoration: BoxDecoration(
//                                         color: kBlack,
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           color: kPureWhite.withOpacity(0.1),
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                         ),
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal:
//                                                 8 * SizeConfig.widthMultiplier!,
//                                             vertical: 16 *
//                                                 SizeConfig.heightMultiplier!),
//                                         child: Column(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 Expanded(
//                                                     child: Text(
//                                                   fileName.value,
//                                                   style: AppTextStyle
//                                                       .normalGreenText
//                                                       .copyWith(
//                                                           color: kPureWhite),
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                 )),
//                                                 SizedBox(
//                                                   width: 7 *
//                                                       SizeConfig
//                                                           .widthMultiplier!,
//                                                 ),
//                                                 GestureDetector(
//                                                   onTap: () async {
//                                                     _userWantToSendMedia.value =
//                                                         false;
//                                                     _mediaIsUploading.value =
//                                                         false;
//                                                     _userWantToSendMedia.value =
//                                                         false;
//                                                     _mediaIsUploading.value =
//                                                         false;
//                                                     List<QBAttachment>?
//                                                         attachmentsList = [];
//                                                     QBAttachment attachment =
//                                                         QBAttachment();
//                                                   },
//                                                   child: CircleAvatar(
//                                                     backgroundColor: kBlack,
//                                                     radius: 12 *
//                                                         SizeConfig
//                                                             .imageSizeMultiplier!,
//                                                     child: Icon(Icons.close,
//                                                         size: 13 *
//                                                             SizeConfig
//                                                                 .imageSizeMultiplier!,
//                                                         color: kPureWhite),
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                             Obx(() => _mediaIsUploading.value
//                                                 ? SizedBox(
//                                                     height: 21 *
//                                                         SizeConfig
//                                                             .heightMultiplier!)
//                                                 : Container()),
//                                             Obx(() => _mediaIsUploading.value
//                                                 ? LinearProgressIndicator(
//                                                     backgroundColor:
//                                                         Color(0xff747474),
//                                                     color: kBlack)
//                                                 : Container())
//                                           ],
//                                         ),
//                                       )),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.only(
//                                       left: 23 * SizeConfig.widthMultiplier!),
//                                   child: GestureDetector(
//                                       onTap: () {
//                                         if (!_mediaIsUploading.value) {
//                                           QB.chat
//                                               .sendMessage(
//                                                   widget.userDialogForChat!.id!,
//                                                   attachments: attachmentsList,
//                                                   body: "imageTest",
//                                                   saveToHistory: true)
//                                               .then((value) {})
//                                               .then((value) {
//                                             _userWantToSendMedia.value = false;
//                                             _mediaIsUploading.value = false;
//                                             List<QBAttachment>?
//                                                 attachmentsList = [];
//                                             QBAttachment attachment =
//                                                 QBAttachment();
//                                           });
//                                         } else {
//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(const SnackBar(
//                                             content:
//                                                 Text("Media is uploading..."),
//                                           ));
//                                         }
//                                       },
//                                       child: Icon(
//                                         Icons.send,
//                                         size: 21 * SizeConfig.heightMultiplier!,
//                                         color: greenChatColor,
//                                       )),
//                                 )
//                               ],
//                             ),
//                           ),
//                         )
//                       : Align(
//                           alignment: Alignment.bottomCenter,
//                           child: Container(
//                             padding: EdgeInsets.all(
//                                 16 * SizeConfig.widthMultiplier!),
//                             decoration: BoxDecoration(
//                               color: Colors.transparent,
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Expanded(
//                                   child: Container(
//                                       decoration: BoxDecoration(
//                                         color: kBlack,
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                       child: TextField(
//                                         keyboardType: TextInputType.multiline,
//                                         maxLines: null,
//                                         cursorColor: kPureWhite,
//                                         style: AppTextStyle.black400Text
//                                             .copyWith(
//                                                 color: kPureWhite, height: 1.3),
//                                         controller: _massageController.value,
//                                         onChanged: (value) {
//                                           _typedMessage.value = value;
//                                         },
//                                         decoration: InputDecoration(
//                                             contentPadding: EdgeInsets.only(
//                                                 left: 16 *
//                                                     SizeConfig.widthMultiplier!,
//                                                 top: 12 *
//                                                     SizeConfig
//                                                         .heightMultiplier!,
//                                                 bottom: 12 *
//                                                     SizeConfig
//                                                         .heightMultiplier!),
//                                             hintText: "message".tr,
//                                             hintStyle:
//                                                 AppTextStyle.hsmallhintText,
//                                             border: InputBorder.none,
//                                             suffixIcon: Row(
//                                               mainAxisSize: MainAxisSize.min,
//                                               children: [
//                                                 SizedBox(
//                                                   width: 30 *
//                                                       SizeConfig
//                                                           .widthMultiplier!,
//                                                   child: IconButton(
//                                                       onPressed: () async {
//                                                         await Permission.storage
//                                                             .request();
//                                                         sendAttachmentsFromDevice();
//                                                       },
//                                                       icon: SvgPicture.asset(
//                                                         ImagePath
//                                                             .attachdocumentIcon,
//                                                         width: 9.17 *
//                                                             SizeConfig
//                                                                 .widthMultiplier!,
//                                                         height: 18.34 *
//                                                             SizeConfig
//                                                                 .heightMultiplier!,
//                                                       )),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 30 *
//                                                       SizeConfig
//                                                           .widthMultiplier!,
//                                                   child: IconButton(
//                                                       onPressed: () {
//                                                         sendImageFromCamera();
//                                                       },
//                                                       icon: SvgPicture.asset(
//                                                         ImagePath
//                                                             .openCameraIcon,
//                                                         width: 15 *
//                                                             SizeConfig
//                                                                 .widthMultiplier!,
//                                                         height: 13.57 *
//                                                             SizeConfig
//                                                                 .heightMultiplier!,
//                                                       )),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 5 *
//                                                       SizeConfig
//                                                           .widthMultiplier!,
//                                                 ),
//                                               ],
//                                             )),
//                                         // maxLines: 3,
//                                       )),
//                                 ),
//                                 Obx(
//                                   () => (_typedMessage.value.isNotEmpty)
//                                       ? Padding(
//                                           padding: EdgeInsets.only(
//                                               left: 23 *
//                                                   SizeConfig.widthMultiplier!),
//                                           child: GestureDetector(
//                                               onTap: () {
//                                                 sendMsg(_typedMessage.value);
//                                                 _massageController.value
//                                                     .clear();
//                                                 _typedMessage.value = "";
//                                               },
//                                               child: Icon(
//                                                 Icons.send,
//                                                 size: 21 *
//                                                     SizeConfig
//                                                         .heightMultiplier!,
//                                                 color: greenChatColor,
//                                               )),
//                                         )
//                                       : Container(),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ))
//                   : Obx(() => !isPlanLoading.value
//                       ? Container(
//                           margin: EdgeInsets.only(
//                               top: 40 * SizeConfig.heightMultiplier!,
//                               bottom: 20 * SizeConfig.heightMultiplier!),
//                           child: RichText(
//                             textAlign: TextAlign.center,
//                             text: TextSpan(children: [
//                               TextSpan(
//                                   text: "enroll_expired_chat".tr,
//                                   style: AppTextStyle.hblack400Text
//                                       .copyWith(color: hintGrey)),
//                               TextSpan(
//                                   text: " ",
//                                   style: AppTextStyle.hblack400Text
//                                       .copyWith(color: hintGrey)),
//                               WidgetSpan(
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     getAllTrainerPlanData(widget.trainerId!);
//                                   },
//                                   child: Text(
//                                     "enroll_again".tr,
//                                     style: AppTextStyle.hblack400Text.copyWith(
//                                         color: Theme.of(context)
//                                             .textTheme
//                                             .bodyText1!
//                                             .color,
//                                         decoration: TextDecoration.underline),
//                                   ),
//                                 ),
//                               ),
//                             ]),
//                           ),
//                         )
//                       : Container(
//                           margin: EdgeInsets.only(
//                               top: 40 * SizeConfig.heightMultiplier!,
//                               bottom: 20 * SizeConfig.heightMultiplier!),
//                           child: CustomizedCircularProgress()))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   getAllTrainerPlanData(String trainerId) async {
//     _trainerController.planModel.value = PlanModel();
//     isPlanLoading.value = true;
//     _trainerController.planModel.value =
//         await TrainerServices.getPlanByTrainerId(trainerId).then((value) {
//       Navigator.pushNamed(context, RouteName.trainerplanScreen);
//       return value;
//     });
//     isPlanLoading.value = false;
//   }
//
//   void initStreamManagement() async {
//     try {
//       await QB.settings.initStreamManagement(3, autoReconnect: true);
//     } on PlatformException catch (e) {
//       // Some error occurred, look at the exception message for more details
//     }
//   }
//
//   void unSubscribeInitStreamManagement() async {
//     try {
//       await QB.settings.initStreamManagement(0, autoReconnect: false);
//     } on PlatformException catch (e) {
//       // Some error occurred, look at the exception message for more details
//     }
//   }
//
//   void sendNotification(String messageBody) async {
//     try {
//       FirebaseMessaging.instance.getToken().then((token) async {
//         List<QBSubscription?> subscriptions =
//             await QB.subscriptions.create(token!, QBPushChannelNames.GCM);
//       });
//     } catch (e) {}
//     String eventType = QBNotificationEventTypes.ONE_SHOT;
//     String notificationEventType = QBNotificationTypes.PUSH;
//     int pushType = QBNotificationPushTypes.GCM;
//     int senderId = _homeController.userQuickBloxId.value;
//
//     Map<String, Object> payload = new Map();
//     payload["message"] = {
//       "notification": {
//         "body": messageBody,
//         "title": "this is a title",
//         "imageUrl": "https://community.custom-cursor.com/uploads/default/adcc703632967e01dba11b8ed4ed893d57b8388c",
//         "name": _homeController.userQuickBloxId.value == 133642567
//             ? "Tarun Prajapat"
//             : "Vartika",
//         "dialogId": widget.userDialogForChat!.id,
//         "opponentId": _homeController.userQuickBloxId.value.toString(),
//       },
//       "data": {
//         "sound": "default",
//         "status": "done",
//         "screen": "ChatScreen",
//       },
//       "to": "<FCM TOKEN>"
//     };
//
//     try {
//       List<QBEvent?> events = await QB.events.create(
//           eventType, notificationEventType, senderId, payload,
//           pushType: pushType, recipientsIds: [widget.opponentID.toString()]);
//     } on PlatformException catch (e) {
//       // Some error occurred, look at the exception message for more details
//     }
//   }
//
//   Future<String?> callWebRTC(int sessionType) async {
//     try {
//       QBRTCSession? session = await QB.webrtc.call(
//           [widget.opponentID!, _homeController.userQuickBloxId.value],
//           sessionType,
//           userInfo: {"userName": "Kashif Ahmad"});
//
//       return session!.id;
//     } on PlatformException catch (e) {
//       return null;
//     }
//   }
//
//   void initMassage() async {
//     try {
//       _massageStreamSubscription =
//           await QB.chat.subscribeChatEvent(event, (data) {
//         Map<String, dynamic> map = Map<String, dynamic>.from(data);
//         Map<String, dynamic> payload =
//             Map<String, dynamic>.from(map["payload"]);
//         List<Attachment>? attachmentsFromJson;
//         if (payload["attachments"] != null) {
//           attachmentsFromJson =
//               (json.decode(json.encode(payload["attachments"])) as List)
//                   .map((data) => Attachment.fromJson(data))
//                   .toList();
//         }
//         String? messageId = payload["id"];
//         QBMessage newMessage = QBMessage();
//         List<QBAttachment?>? getAttachments() {
//           List<QBAttachment?>? attachments = [];
//           if (attachmentsFromJson != null) {
//             attachmentsFromJson.forEach((element) {
//               QBAttachment attachment = QBAttachment();
//               attachment.id = element.id!;
//               attachment.url = element.url;
//               attachment.type = element.type;
//               attachment.name = element.name;
//               attachment.data = element.data;
//               attachment.contentType = element.contentType;
//               attachments.add(attachment);
//             });
//             return attachments;
//           }
//           return null;
//         }
//
//         newMessage.id = payload["id"];
//         newMessage.dialogId = payload["dialogId"];
//         newMessage.attachments = getAttachments();
//         newMessage.senderId = payload["senderId"];
//         newMessage.recipientId = payload["recipientId"];
//         newMessage.body = payload["body"];
//         newMessage.dateSent = payload["dateSent"];
//         newMessage.markable = payload["markable"];
//         setState(() {
//           messages!.insert(0, newMessage);
//         });
//       });
//     } on PlatformException catch (e) {
//       // Some error occurred, look at the exception message for more details
//     }
//   }
//
//   checkUserConnection() async {
//     try {
//       bool? connected = await QB.chat.isConnected();
//     } on PlatformException catch (e) {
//       // Some error occurred, look at the exception message for more details
//     }
//   }
//
//   connectionEvent() async {
//     String event = QBChatEvents.CONNECTED;
//     try {
//       _connectionStreamSubscription = await QB.chat.subscribeChatEvent(
//           QBChatEvents.CONNECTED, (data) {},
//           onErrorMethod: (error) {});
//     } on PlatformException catch (e) {}
//   }
//
//   void sendMsg(String messageBody) async {
//     var chatStatus = await QB.chat.isConnected();
//     if (chatStatus!) {
//       sendMessageAfterVarification(messageBody);
//     } else {
//       String logIn =
//           _homeController.userProfileData.value.response!.data!.profile!.id!;
//       final password = Crypt.sha256(logIn, salt: '10');
//       CreatePostService.LogInUserToQuickBlox(
//               logIn, password.hash, _homeController.userQuickBloxId.value)
//           .then((value) async {
//         var check = await QB.chat.isConnected();
//         if (!check!) {
//           CreatePostService.connectUserToChat(
//               password.hash, _homeController.userQuickBloxId.value);
//           sendMsg(messageBody);
//         } else {
//           sendMsg(messageBody);
//         }
//         return value;
//       });
//     }
//   }
//
//   void sendMessageAfterVarification(String messageBody) async {
//     String dialogId = widget.userDialogForChat!.id!;
//     bool saveToHistory = true;
//     try {
//       await QB.chat
//           .sendMessage(dialogId,
//               body: messageBody, saveToHistory: saveToHistory)
//           .then((value) {});
//     } on PlatformException catch (e) {}
//     sendNotification(messageBody);
//   }
//
//   getMassageFromHistory() async {
//     QBSort sort = QBSort();
//     sort.field = QBChatMessageSorts.DATE_SENT;
//     sort.ascending = false;
//
//     try {
//       List<QBMessage?>? messageslist = await QB.chat
//           .getDialogMessages(widget.userDialogForChat!.id!, sort: sort);
//       setState(() {
//         messages = messageslist;
//       });
//     } on PlatformException catch (e) {
//       // Some error occurred, look at the exception message for more details
//     }
//   }
//
//   Future<XFile?> pickFromCamera() async {
//     final ImagePicker picker = ImagePicker();
//     XFile? file = await picker.pickImage(source: ImageSource.camera);
//     if (file != null) {
//       return file;
//     } else
//       return null;
//   }
//
//   void sendImageFromCamera() async {
//     XFile? pickedFile = await pickFromCamera();
//     if (pickedFile != null) {
//       _userWantToSendMedia.value = true;
//       _mediaIsUploading.value = true;
//       fileName.value = pickedFile.name;
//       try {
//         uploadFileToServerDB(pickedFile.path, pickedFile.path.split('.').last);
//         QBFile? file = await QB.content.upload(pickedFile.path, public: false);
//         if (file != null) {
//           _mediaIsUploading.value = false;
//           int? id = file.id;
//           String? contentType = file.contentType;
//           attachment.id = id.toString();
//           attachment.contentType = contentType;
//           attachment.url = file.uid;
//           attachment.name = pickedFile.name;
//           //Required parameter
//           attachment.type = "PHOTO";
//           attachment.data = pickedFile.path;
//           //Required parameter
//           //attachment.type = "PHOTO";
//           attachmentsList.add(attachment);
//           QBMessage message = QBMessage();
//           message.attachments = attachmentsList;
//           message.body = "test attachment";
//         }
//       } on PlatformException catch (e) {
//         // Some error occurred, look at the exception message for more details
//       }
//     } else {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("pick a image first")));
//     }
//   }
//
//   Future<FilePickerResult?> pickAttachments() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       allowMultiple: false,
//       type: FileType.custom,
//       allowedExtensions: [
//         'jpg',
//         'pdf',
//         'doc',
//         'docx',
//         'ppt',
//         'pptx',
//         'xls',
//         'xlsx'
//             'png',
//         'jpeg',
//         'mp3',
//         'mp4',
//         'mkv'
//       ],
//     );
//
//     if (result != null) {
//       if ((result.files[0].size / (1024 * 1024)) < 25) {
//         return result;
//       } else {
//         createFileSizeIsLargeDialog(context);
//       }
//     } else {
//       return null;
//     }
//   }
//
//   void sendAttachmentsFromDevice() async {
//     FilePickerResult? pickedFiles = await pickAttachments();
//     if (pickedFiles != null) {
//       _userWantToSendMedia.value = true;
//       _mediaIsUploading.value = true;
//       fileName.value = pickedFiles.files[0].name;
//       try {
//         for (int i = 0; i < pickedFiles.files.length; i++) {
//           uploadFileToServerDB(pickedFiles.files[i].path!,
//               pickedFiles.files[i].path!.split('.').last);
//           QBFile? file = await QB.content
//               .upload(pickedFiles.files[i].path!, public: false);
//
//           if (file != null) {
//             _mediaIsUploading.value = false;
//             int? id = file.id;
//             String? contentType = pickedFiles.files[i].path!.split('.').last;
//             attachment.id = id.toString();
//             attachment.contentType = contentType;
//             attachment.url = file.uid;
//             attachment.name = pickedFiles.files[i].name;
//             attachment.data = pickedFiles.files[i].path!;
//             //Required parameter
//             attachment.type = "PHOTO";
//             attachmentsList.add(attachment);
//             QBMessage message = QBMessage();
//             message.attachments = attachmentsList;
//             message.body = "test attachment";
//             // Send a message logic
//           }
//         }
//       } on PlatformException catch (e) {
//         // Some error occurred, look at the exception message for more details
//       }
//     } else {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("pick a some file to upload")));
//     }
//   }
//
//   void createFileSizeIsLargeDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           color: kBlack.withOpacity(0.6),
//           child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
//               child: AlertDialog(
//                 contentPadding: EdgeInsets.symmetric(
//                     vertical: 30 * SizeConfig.heightMultiplier!),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(
//                         8 * SizeConfig.imageSizeMultiplier!)),
//                 backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//                 content: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       "File is too large",
//                       style: AppTextStyle.black400Text.copyWith(
//                           color: Theme.of(context).textTheme.bodyText1!.color),
//                     ),
//                     SizedBox(
//                       height: 16 * SizeConfig.heightMultiplier!,
//                     ),
//                     Text(
//                       "Cannot upload files larger\n than 25MB.",
//                       style: AppTextStyle.black400Text.copyWith(
//                           color: Theme.of(context).textTheme.bodyText1!.color,
//                           fontSize: 12 * SizeConfig.textMultiplier!,
//                           fontWeight: FontWeight.w400),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               )),
//         );
//       },
//     );
//   }
//
//   void reportAbuseDialog(BuildContext context) {
//     RxBool blockUser = false.obs;
//     RxInt selectedProblemIndex = (-1).obs;
//     if (_reportAbuseController.reportAbuseList.value.response == null) {
//       _reportAbuseController.getReportAbuseData();
//     }
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           color: kBlack.withOpacity(0.6),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
//             child: AlertDialog(
//                 insetPadding: EdgeInsets.only(
//                   left: 16 * SizeConfig.widthMultiplier!,
//                   right: 16 * SizeConfig.widthMultiplier!,
//                 ),
//                 contentPadding: EdgeInsets.zero,
//                 backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(16.0))),
//                 content: Obx(() => (_reportAbuseController
//                         .isReportAbuseLoading.value)
//                     ? Container(
//                         child: Container(
//                         margin: EdgeInsets.symmetric(
//                             vertical: 30 * SizeConfig.heightMultiplier!),
//                         child: SizedBox(
//                             height: 30 * SizeConfig.widthMultiplier!,
//                             width: 30 * SizeConfig.widthMultiplier!,
//                             child: CustomizedCircularProgress()),
//                       ))
//                     : Stack(
//                         children: [
//                           Column(
//                             mainAxisSize: MainAxisSize.min,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               SizedBox(
//                                 height: 32 * SizeConfig.heightMultiplier!,
//                               ),
//                               Align(
//                                 alignment: Alignment.center,
//                                 child: Text(
//                                   "Report Abuse".tr,
//                                   style: AppTextStyle.black600Text.copyWith(
//                                     color: Theme.of(context)
//                                         .textTheme
//                                         .bodyText1
//                                         ?.color,
//                                     fontSize: (16) * SizeConfig.textMultiplier!,
//                                   ),
//                                 ),
//                               ),
//
//                               SizedBox(
//                                 height: 32 * SizeConfig.heightMultiplier!,
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal:
//                                         36 * SizeConfig.widthMultiplier!),
//                                 child: Text(
//                                   "Why_reporting?".tr,
//                                   style: AppTextStyle.black600Text.copyWith(
//                                     color: Theme.of(context)
//                                         .textTheme
//                                         .bodyText1
//                                         ?.color,
//                                     fontSize: (12) * SizeConfig.textMultiplier!,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 8.02 * SizeConfig.heightMultiplier!,
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal:
//                                         36 * SizeConfig.widthMultiplier!),
//                                 child: Text(
//                                   "report_abuse_description".tr,
//                                   style: AppTextStyle.black400Text.copyWith(
//                                     color: Theme.of(context)
//                                         .textTheme
//                                         .bodyText1
//                                         ?.color,
//                                     fontSize: (11) * SizeConfig.textMultiplier!,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 20 * SizeConfig.heightMultiplier!,
//                               ),
//                               Container(
//                                 height: 300 * SizeConfig.heightMultiplier!,
//                                 child: Obx(
//                                   () => SingleChildScrollView(
//                                     child: Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: List.generate(
//                                             _reportAbuseController
//                                                 .reportAbuseList
//                                                 .value
//                                                 .response!
//                                                 .data!
//                                                 .length,
//                                             (index) => Column(
//                                                   mainAxisSize:
//                                                       MainAxisSize.min,
//                                                   children: [
//                                                     InkWell(
//                                                       onTap: () {
//                                                         selectedProblemIndex
//                                                             .value = index;
//                                                       },
//                                                       child: Container(
//                                                         width: 328 *
//                                                             SizeConfig
//                                                                 .widthMultiplier!,
//                                                         color: selectedProblemIndex
//                                                                     .value ==
//                                                                 index
//                                                             ? Colors.white
//                                                                 .withOpacity(
//                                                                     0.1)
//                                                             : Colors
//                                                                 .transparent,
//                                                         child: Padding(
//                                                           padding: EdgeInsets.symmetric(
//                                                               horizontal: 36 *
//                                                                   SizeConfig
//                                                                       .widthMultiplier!,
//                                                               vertical: 10 *
//                                                                   SizeConfig
//                                                                       .heightMultiplier!),
//                                                           child: Text(
//                                                             _reportAbuseController
//                                                                 .reportAbuseList
//                                                                 .value
//                                                                 .response!
//                                                                 .data![index]
//                                                                 .reason!
//                                                                 .replaceAll(
//                                                                     "-EN", ""),
//                                                             style: AppTextStyle.black400Text.copyWith(
//                                                                 color: Theme.of(
//                                                                         context)
//                                                                     .textTheme
//                                                                     .bodyText1
//                                                                     ?.color,
//                                                                 fontSize: (12) *
//                                                                     SizeConfig
//                                                                         .textMultiplier!,
//                                                                 fontWeight: selectedProblemIndex
//                                                                             .value ==
//                                                                         index
//                                                                     ? FontWeight
//                                                                         .w600
//                                                                     : FontWeight
//                                                                         .w500,
//                                                                 height: 1.3),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ))),
//                                   ),
//                                 ),
//                               ),
//                               // SizedBox(
//                               //   height: 32 * SizeConfig.heightMultiplier!,
//                               // ),
//                               SizedBox(
//                                 height: 24 * SizeConfig.heightMultiplier!,
//                               ),
//                               Obx(() => Padding(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal:
//                                             35 * SizeConfig.widthMultiplier!),
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         blockUser.value = !blockUser.value;
//                                       },
//                                       child: Container(
//                                         color: Colors.transparent,
//                                         child: Row(
//                                           children: [
//                                             Container(
//                                               color: Colors.transparent,
//                                               child: Padding(
//                                                   padding: EdgeInsets.all(5 *
//                                                       SizeConfig
//                                                           .widthMultiplier!),
//                                                   child: SvgPicture.asset(
//                                                     blockUser.value
//                                                         ? ImagePath.selectedBox
//                                                         : ImagePath
//                                                             .unselectedBox,
//                                                     height: 18 *
//                                                         SizeConfig
//                                                             .heightMultiplier!,
//                                                     width: SizeConfig
//                                                         .widthMultiplier!,
//                                                   )),
//                                             ),
//                                             SizedBox(
//                                               width: 8 *
//                                                   SizeConfig.widthMultiplier!,
//                                             ),
//                                             RichText(
//                                               textAlign: TextAlign.center,
//                                               text: TextSpan(children: [
//                                                 TextSpan(
//                                                   text: 'Block_person'.tr,
//                                                   style: AppTextStyle.NormalText
//                                                       .copyWith(
//                                                           fontSize: 14 *
//                                                               SizeConfig
//                                                                   .textMultiplier!,
//                                                           fontWeight:
//                                                               FontWeight.w600,
//                                                           color: kPink),
//                                                 ),
//                                               ]),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   )),
//                               Obx(
//                                 () => Align(
//                                   alignment: Alignment.bottomCenter,
//                                   child: Padding(
//                                     padding: EdgeInsets.fromLTRB(
//                                       0 * SizeConfig.widthMultiplier!,
//                                       32 * SizeConfig.heightMultiplier!,
//                                       0 * SizeConfig.widthMultiplier!,
//                                       48 * SizeConfig.heightMultiplier!,
//                                     ),
//                                     child: Container(
//                                         width:
//                                             256 * SizeConfig.widthMultiplier!,
//                                         height:
//                                             48 * SizeConfig.heightMultiplier!,
//                                         child: ElevatedButton(
//                                             style: ButtonStyle(
//                                                 elevation:
//                                                     MaterialStateProperty.all(
//                                                         0),
//                                                 backgroundColor: selectedProblemIndex
//                                                             .value >=
//                                                         0
//                                                     ? MaterialStateProperty.all(
//                                                         kgreen49)
//                                                     : MaterialStateProperty.all(
//                                                         hintGrey),
//                                                 shape: MaterialStateProperty.all(
//                                                     RoundedRectangleBorder(
//                                                         borderRadius:
//                                                             BorderRadius.circular(8 *
//                                                                 SizeConfig
//                                                                     .widthMultiplier!)))),
//                                             onPressed: selectedProblemIndex.value >= 0
//                                                 ? () async {
//                                                     if (!_reportAbuseController
//                                                         .isReportSendAbuseLoading
//                                                         .value) {
//                                                       _reportAbuseController
//                                                           .isReportSendAbuseLoading
//                                                           .value = true;
//                                                       var response = await _reportAbuseController
//                                                           .sendRepostAbuseData(
//                                                               userId: widget
//                                                                   .trainerId,
//                                                               reason: _reportAbuseController
//                                                                   .reportAbuseList
//                                                                   .value
//                                                                   .response!
//                                                                   .data![
//                                                                       selectedProblemIndex
//                                                                           .value]
//                                                                   .serialId);
//                                                       _reportAbuseController
//                                                           .isReportSendAbuseLoading
//                                                           .value = false;
//                                                       if (response.isNotEmpty) {
//                                                         Navigator.pop(context);
//                                                         Navigator.pop(context);
//                                                         ScaffoldMessenger.of(
//                                                                 context)
//                                                             .showSnackBar(SnackBar(
//                                                                 content: Text(
//                                                                     response)));
//                                                       }
//                                                     }
//                                                   }
//                                                 : () {
//                                                     pleaseSelectAnOptionDialog(
//                                                         context);
//                                                   },
//                                             child: Text(
//                                               "Submit".tr,
//                                               style: AppTextStyle.hboldWhiteText
//                                                   .copyWith(
//                                                       color:
//                                                           selectedProblemIndex
//                                                                       .value >=
//                                                                   0
//                                                               ? kPureWhite
//                                                               : greyBorder),
//                                             ))),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Positioned(
//                             top: 7 * SizeConfig.heightMultiplier!,
//                             right: 7 * SizeConfig.widthMultiplier!,
//                             child: IconButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               icon: SvgPicture.asset(
//                                 ImagePath.closedialogIcon,
//                                 color: Theme.of(context).primaryColor,
//                                 width: 16 * SizeConfig.widthMultiplier!,
//                                 height: 16 * SizeConfig.heightMultiplier!,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ))),
//           ),
//         );
//       },
//     );
//   }
//
//   void pleaseSelectAnOptionDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           color: kBlack.withOpacity(0.6),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
//             child: AlertDialog(
//                 insetPadding: EdgeInsets.only(
//                   left: 16 * SizeConfig.widthMultiplier!,
//                   right: 16 * SizeConfig.widthMultiplier!,
//                 ),
//                 contentPadding: EdgeInsets.zero,
//                 backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(16.0))),
//                 content: Obx(
//                     () => (_reportAbuseController.isReportAbuseLoading.value)
//                         ? Container(
//                             child: Container(
//                             margin: EdgeInsets.symmetric(
//                                 vertical: 30 * SizeConfig.heightMultiplier!),
//                             child: SizedBox(
//                                 height: 30 * SizeConfig.widthMultiplier!,
//                                 width: 30 * SizeConfig.widthMultiplier!,
//                                 child: CustomizedCircularProgress()),
//                           ))
//                         : Stack(
//                             children: [
//                               Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   SizedBox(
//                                     height: 32 * SizeConfig.heightMultiplier!,
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsets.all(
//                                         16 * SizeConfig.widthMultiplier!),
//                                     child: Align(
//                                       alignment: Alignment.center,
//                                       child: Text(
//                                         "Please select a valid reason\n for reporting."
//                                             .tr,
//                                         style: AppTextStyle.black600Text
//                                             .copyWith(
//                                                 color: Theme.of(context)
//                                                     .textTheme
//                                                     .bodyText1
//                                                     ?.color,
//                                                 fontSize: (14) *
//                                                     SizeConfig.textMultiplier!,
//                                                 fontWeight: FontWeight.w400),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Positioned(
//                                 top: 7 * SizeConfig.heightMultiplier!,
//                                 right: 7 * SizeConfig.widthMultiplier!,
//                                 child: IconButton(
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                   },
//                                   icon: SvgPicture.asset(
//                                     ImagePath.closedialogIcon,
//                                     color: Theme.of(context).primaryColor,
//                                     width: 16 * SizeConfig.widthMultiplier!,
//                                     height: 16 * SizeConfig.heightMultiplier!,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ))),
//           ),
//         );
//       },
//     );
//   }
//
//   void createMenuDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           color: kBlack.withOpacity(0.6),
//           child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
//               child: AlertDialog(
//                   titlePadding: EdgeInsets.zero,
//                   actionsPadding: EdgeInsets.zero,
//                   insetPadding: EdgeInsets.only(
//                     top: 175 * SizeConfig.heightMultiplier!,
//                     bottom: 175 * SizeConfig.heightMultiplier!,
//                   ),
//                   contentPadding: EdgeInsets.symmetric(
//                       horizontal: 30 * SizeConfig.widthMultiplier!,
//                       vertical: 15 * SizeConfig.heightMultiplier!),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(
//                           8 * SizeConfig.imageSizeMultiplier!)),
//                   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//                   content: Stack(children: [
//                     Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Align(
//                           alignment: Alignment.center,
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               IconButton(
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                     Navigator.pop(context);
//                                   },
//                                   icon: Icon(
//                                     Icons.close,
//                                     size: 26 * SizeConfig.heightMultiplier!,
//                                     color: Colors.white,
//                                   )),
//                               SizedBox(
//                                 height: 10 * SizeConfig.heightMultiplier!,
//                               ),
//                               Text(
//                                 widget.trainerTitle!,
//                                 style: AppTextStyle.black400Text.copyWith(
//                                     color: Theme.of(context)
//                                         .textTheme
//                                         .bodyText1!
//                                         .color),
//                               ),
//                               SizedBox(
//                                 height: 26 * SizeConfig.heightMultiplier!,
//                               ),
//                               GestureDetector(
//                                 onTap: () async {
//                                   _trainerController.atrainerDetail.value =
//                                       Trainer();
//
//                                   _trainerController.isProfileLoading.value =
//                                       true;
//                                   _trainerController
//                                       .isMyTrainerProfileLoading.value = true;
//                                   Navigator.pushNamed(
//                                       context, RouteName.trainerProfileScreen);
//
//                                   var result =
//                                       await TrainerServices.getATrainerDetail(
//                                           widget.trainerId!);
//                                   _trainerController.atrainerDetail.value =
//                                       result.response!.data!;
//
//                                   _trainerController.planModel.value =
//                                       await TrainerServices.getPlanByTrainerId(
//                                           widget.trainerId!);
//
//                                   _trainerController.initialPostData.value =
//                                       await TrainerServices.getTrainerPosts(
//                                           widget.trainerId!, 0);
//                                   _trainerController
//                                       .isMyTrainerProfileLoading.value = false;
//                                   _trainerController.loadingIndicator.value =
//                                       false;
//                                   if (_trainerController.initialPostData.value
//                                           .response!.data!.length !=
//                                       0) {
//                                     _trainerController.trainerPostList.value =
//                                         _trainerController.initialPostData.value
//                                             .response!.data!;
//                                   } else {
//                                     _trainerController.trainerPostList.clear();
//                                   }
//                                   _trainerController.isProfileLoading.value =
//                                       false;
//                                   _trainerController
//                                       .isMyTrainerProfileLoading.value = false;
//                                 },
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     SvgPicture.asset(
//                                       ImagePath.penIcon,
//                                       color: Theme.of(context).primaryColor,
//                                       height:
//                                           15 * SizeConfig.imageSizeMultiplier!,
//                                     ),
//                                     SizedBox(
//                                       width: 10.5 * SizeConfig.widthMultiplier!,
//                                     ),
//                                     Text(
//                                       'Open profile',
//                                       style: AppTextStyle.black400Text.copyWith(
//                                           fontWeight: FontWeight.w600,
//                                           color: Theme.of(context)
//                                               .textTheme
//                                               .bodyText1!
//                                               .color),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 22 * SizeConfig.heightMultiplier!,
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               DocumentsViewerScreen(
//                                                 messages: messages,
//                                                 opponentName:
//                                                     widget.trainerTitle,
//                                               )));
//                                 },
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     SvgPicture.asset(
//                                       ImagePath.fileIcon,
//                                       color: Theme.of(context).primaryColor,
//                                       height:
//                                           15 * SizeConfig.imageSizeMultiplier!,
//                                     ),
//                                     SizedBox(
//                                       width: 10.5 * SizeConfig.widthMultiplier!,
//                                     ),
//                                     Text(
//                                       'View documents',
//                                       style: AppTextStyle.black400Text.copyWith(
//                                           fontWeight: FontWeight.w600,
//                                           color: Theme.of(context)
//                                               .textTheme
//                                               .bodyText1!
//                                               .color),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 22 * SizeConfig.heightMultiplier!,
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   reportAbuseDialog(context);
//                                 },
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     SvgPicture.asset(
//                                       ImagePath.reportabuseicon,
//                                       color: Theme.of(context).primaryColor,
//                                       height: 20 * SizeConfig.heightMultiplier!,
//                                       width: 20 * SizeConfig.widthMultiplier!,
//                                     ),
//                                     SizedBox(
//                                       width: 10.5 * SizeConfig.widthMultiplier!,
//                                     ),
//                                     Text(
//                                       'Report abuse',
//                                       style: AppTextStyle.black400Text.copyWith(
//                                           fontWeight: FontWeight.w600,
//                                           color: Theme.of(context)
//                                               .textTheme
//                                               .bodyText1!
//                                               .color),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 20 * SizeConfig.heightMultiplier!,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ]))),
//         );
//       },
//     );
//   }
//
//   void showDialogForVideoCallNotPossible(
//       BuildContext context, String time, String days) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           color: kBlack.withOpacity(0.6),
//           child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
//               child: AlertDialog(
//                   contentPadding: EdgeInsets.symmetric(
//                       vertical: 30 * SizeConfig.heightMultiplier!,
//                       horizontal: 30 * SizeConfig.widthMultiplier!),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(
//                           8 * SizeConfig.imageSizeMultiplier!)),
//                   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//                   content: Stack(
//                     children: [
//                       Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Align(
//                             alignment: Alignment.topRight,
//                             child: GestureDetector(
//                               onTap: () {
//                                 Navigator.pop(context);
//                               },
//                               child: SvgPicture.asset(
//                                 ImagePath.closedialogIcon,
//                                 color: Theme.of(context).primaryColor,
//                                 width: 16 * SizeConfig.imageSizeMultiplier!,
//                                 height: 16 * SizeConfig.imageSizeMultiplier!,
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 100 * SizeConfig.heightMultiplier!,
//                             width: 100 * SizeConfig.widthMultiplier!,
//                             child: Image.asset(ImagePath.animatedErrorIcon),
//                           ),
//                           SizedBox(
//                             height: 26 * SizeConfig.heightMultiplier!,
//                           ),
//                           Text(
//                             "call_not_possible".tr,
//                             style: AppTextStyle.black400Text.copyWith(
//                                 color: Theme.of(context)
//                                     .textTheme
//                                     .bodyText1!
//                                     .color),
//                             textAlign: TextAlign.center,
//                           ),
//                           SizedBox(
//                             height: 16 * SizeConfig.heightMultiplier!,
//                           ),
//                           Text(
//                             "call_not_possible_time"
//                                 .trParams({'time': time, 'days': days}),
//                             style: AppTextStyle.black400Text.copyWith(
//                                 color: Theme.of(context)
//                                     .textTheme
//                                     .bodyText1!
//                                     .color,
//                                 fontWeight: FontWeight.w700),
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ))),
//         );
//       },
//     );
//   }
//
//   void uploadFileToServerDB(String path, String fileType) async {
//     var dio = DioUtil().getInstance();
//     dio!.options.headers["language"] = "1";
//     dio.options.headers['Authorization'] = await LogInService.getAccessToken();
//     FormData data = FormData.fromMap({
//       'files': await MultipartFile.fromFile(path),
//       'trainerId': widget.trainerId!,
//     });
//     dio.post(ApiUrl.uploadChatFileToDb, data: data);
//   }
// }
//
// class MessageBubbleSender extends StatelessWidget {
//   MessageBubbleSender({Key? key, this.message}) : super(key: key);
//   final QBMessage? message;
//
//   ChatController _chatController = Get.find();
//
//   var isDownloaded = false.obs;
//   var isDownloadingStarted = false.obs;
//   var filePath = "".obs;
//   var downloadProgress = 0.0.obs;
//   var fileSize = "".obs;
//   String? fileExtension;
//
//   @override
//   Widget build(BuildContext context) {
//     if (message!.attachments == null) {
//       return Padding(
//         padding: EdgeInsets.only(
//             bottom: 8.0 * SizeConfig.heightMultiplier!,
//             right: 16 * SizeConfig.widthMultiplier!),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Container(
//               constraints: BoxConstraints(
//                 maxWidth: 300 * SizeConfig.widthMultiplier!,
//               ),
//               padding: EdgeInsets.symmetric(
//                 vertical: 10.0 * SizeConfig.heightMultiplier!,
//                 horizontal: 10.0 * SizeConfig.widthMultiplier!,
//               ),
//               decoration: BoxDecoration(
//                 color: greenChatColor,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Text(message!.body.toString(),
//                   style: AppTextStyle.white400Text),
//             )
//           ],
//         ),
//       );
//     } else {
//       fileExtension =
//           message!.attachments![0]!.name!.split(".").last.toUpperCase();
//       getFileSize();
//       checkFileExistence(message!.attachments![0]!.name);
//       return Padding(
//         padding: EdgeInsets.only(
//             bottom: 8.0 * SizeConfig.heightMultiplier!,
//             right: 16 * SizeConfig.widthMultiplier!),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Container(
//                 constraints: BoxConstraints(
//                     maxWidth: 300 * SizeConfig.widthMultiplier!,
//                     maxHeight: 250 * SizeConfig.heightMultiplier!),
//                 padding: EdgeInsets.symmetric(
//                   vertical: 14.0 * SizeConfig.heightMultiplier!,
//                   horizontal: 8.0 * SizeConfig.widthMultiplier!,
//                 ),
//                 decoration: BoxDecoration(
//                   color: greenChatColor,
//                   borderRadius: BorderRadius.circular(
//                       8 * SizeConfig.imageSizeMultiplier!),
//                 ),
//                 child: Obx(() => filePath.value.isEmpty
//                     ? Container(
//                         child: GestureDetector(
//                             onTap: () async {},
//                             child: Container(
//                               width: 220 * SizeConfig.widthMultiplier!,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Container(
//                                     padding: EdgeInsets.only(
//                                         left: 8 * SizeConfig.widthMultiplier!),
//                                     height: 50 * SizeConfig.heightMultiplier!,
//                                     decoration: BoxDecoration(
//                                       color: kPureWhite.withOpacity(0.15),
//                                       borderRadius: BorderRadius.circular(
//                                           8 * SizeConfig.imageSizeMultiplier!),
//                                     ),
//                                     child: Row(
//                                       children: [
//                                         Expanded(
//                                             child: Text(
//                                           message!.attachments![0]!.name!,
//                                           overflow: TextOverflow.ellipsis,
//                                           style: AppTextStyle
//                                               .whiteTextWithWeight600,
//                                         )),
//                                         SizedBox(
//                                           width:
//                                               10 * SizeConfig.widthMultiplier!,
//                                         ),
//                                         (!isDownloadingStarted.value)
//                                             ? GestureDetector(
//                                                 onTap: () async {
//                                                   isDownloadingStarted.value =
//                                                       true;
//                                                   isDownloaded.value =
//                                                       await _getImageUrl(
//                                                           message!
//                                                               .attachments![0]!
//                                                               .url!,
//                                                           message!
//                                                               .attachments![0]!
//                                                               .name!);
//                                                 },
//                                                 child: Image.asset(
//                                                   ImagePath.downloadDocIcon,
//                                                   width: 16.79 *
//                                                       SizeConfig
//                                                           .widthMultiplier!,
//                                                   height: 22.4 *
//                                                       SizeConfig
//                                                           .heightMultiplier!,
//                                                 ))
//                                             : SizedBox(
//                                                 height: 22 *
//                                                     SizeConfig
//                                                         .heightMultiplier!,
//                                                 width: 22 *
//                                                     SizeConfig
//                                                         .heightMultiplier!,
//                                                 child:
//                                                     CircularProgressIndicator(
//                                                   color: kPureWhite,
//                                                   value: downloadProgress.value,
//                                                   backgroundColor: Colors.grey
//                                                       .withOpacity(0.2),
//                                                   strokeWidth: 2.5 *
//                                                       SizeConfig
//                                                           .imageSizeMultiplier!,
//                                                 )),
//                                         SizedBox(
//                                           width:
//                                               12 * SizeConfig.widthMultiplier!,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 8 * SizeConfig.heightMultiplier!,
//                                   ),
//                                   Text(
//                                     "${fileSize.value.isNotEmpty ? fileSize.value : 0.0} MB ??? ${message!.attachments![0]!.name!.split(".").last.toUpperCase()}",
//                                     style: AppTextStyle.hmediumBlackText
//                                         .copyWith(color: kPureWhite, height: 1),
//                                   )
//                                 ],
//                               ),
//                             )),
//                       )
//                     : Container(
//                         child: GestureDetector(
//                             onTap: () {
//                               OpenFile.open(filePath.value);
//                             },
//                             child: Container(
//                                 width: 220 * SizeConfig.widthMultiplier!,
//                                 child: Row(
//                                   children: [
//                                     Image.asset(
//                                       (fileExtension == "JPEG" ||
//                                               fileExtension == "JPG")
//                                           ? ImagePath.jpgFileIcon
//                                           : (fileExtension == "PNG")
//                                               ? ImagePath.pngIcon
//                                               : (fileExtension!.contains("PPT"))
//                                                   ? ImagePath.pptIcon
//                                                   : (fileExtension!
//                                                           .contains("MP4"))
//                                                       ? ImagePath.mp4Icon
//                                                       : (fileExtension!
//                                                               .contains("XLX"))
//                                                           ? ImagePath.xlxIcon
//                                                           : (fileExtension ==
//                                                                   "PDF")
//                                                               ? ImagePath
//                                                                   .pdfFileIcon
//                                                               : ImagePath
//                                                                   .docFileIcon,
//                                       width:
//                                           32 * SizeConfig.imageSizeMultiplier!,
//                                       height:
//                                           32 * SizeConfig.imageSizeMultiplier!,
//                                     ),
//                                     SizedBox(
//                                       width: 7 * SizeConfig.widthMultiplier!,
//                                     ),
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Container(
//                                               padding: new EdgeInsets.only(
//                                                   right: 10 *
//                                                       SizeConfig
//                                                           .widthMultiplier!),
//                                               child: Text(
//                                                 message!.attachments![0]!.name!,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 style: AppTextStyle
//                                                     .whiteTextWithWeight600,
//                                               )),
//                                           SizedBox(
//                                             height: 5 *
//                                                 SizeConfig.imageSizeMultiplier!,
//                                           ),
//                                           FutureBuilder(
//                                               future: getFileSizeFromLocal(),
//                                               builder: (context,
//                                                   AsyncSnapshot<String>
//                                                       snapshot) {
//                                                 return Text(
//                                                   "${snapshot.hasData ? snapshot.data : 0.0} MB ??? ${message!.attachments![0]!.name!.split(".").last.toUpperCase()}",
//                                                   style: AppTextStyle
//                                                       .hmediumBlackText
//                                                       .copyWith(
//                                                           color: kPureWhite,
//                                                           height: 1),
//                                                 );
//                                               })
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 ))),
//                       )))
//           ],
//         ),
//       );
//     }
//   }
//
//   // Future<bool> _getImageUrl(String id, String fileName) async {
//   //   try {
//   //     String? url = await QB.content.getPrivateURL(id);
//   //     bool flag = false;
//   //
//   //     //FlutterDownloader.registerCallback(downloadCallback);
//   //     try {
//   //       PermissionStatus status = await Permission.storage.request();
//   //       PermissionStatus status1 =
//   //           await Permission.manageExternalStorage.request();
//   //       if (status == PermissionStatus.granted) {
//   //         String? path;
//   //         final Directory _appDocDir = await getApplicationDocumentsDirectory();
//   //         //App Document Directory + folder name
//   //         final Directory _appDocDirFolder =
//   //             Directory('storage/emulated/0/fitBasix/media');
//   //         //Environment.getExternalStoragePublicDirectory(...);
//   //         if (await _appDocDirFolder.exists()) {
//   //           //if folder already exists return path
//   //           path = _appDocDirFolder.path;
//   //         } else {
//   //           //if folder not exists create folder and then return its path
//   //           final Directory _appDocDirNewFolder =
//   //               await _appDocDirFolder.create(recursive: true);
//   //           path = _appDocDirNewFolder.path;
//   //         }
//   //         Dio dio = Dio();
//   //         dio.download(url!, path + "/" + fileName,
//   //             onReceiveProgress: (received, total) {
//   //           downloadProgress.value = ((received / total));
//   //           if (((received / total) * 100).floor() == 100) {
//   //             checkFileExistence(fileName);
//   //           }
//   //         });
//   //       }
//   //     } catch (e) {
//   //     }
//   //
//   //     return false;
//   //   } on PlatformException catch (e) {
//   //     return false;
//   //     // Some error occurred, look at the exception message for more details
//   //   }
//   // }
//
//   Future<bool> _getImageUrl(String id, String fileName) async {
//     try {
//       String? url = await QB.content.getPrivateURL(id);
//       bool flag = false;
//
//       //FlutterDownloader.registerCallback(downloadCallback);
//       try {
//         if (Platform.isAndroid) {
//           PermissionStatus status = await Permission.storage.request();
//           // if (!_chatController.storagePermissionCalled.value) {
//           //   _chatController.storagePermissionCalled.value = true;
//           //   PermissionStatus status1 =
//           //       await Permission.manageExternalStorage.request();
//           // }
//
//           String? path;
//           final Directory appDir = await getApplicationDocumentsDirectory();
//           print(appDir.path.toString()+ " lll");
//           final _appDocDirFolder = Directory(appDir.path);
//
//           //App Document Directory + folder name
//           // final Directory _appDocDirFolder =
//           //     Directory('storage/emulated/0/fitBasix/media');
//           if (await _appDocDirFolder.exists()) {
//             //if folder already exists return path
//             path = _appDocDirFolder.path;
//           } else {
//             //if folder not exists create folder and then return its path
//             final Directory _appDocDirNewFolder =
//                 await _appDocDirFolder.create(recursive: true);
//             path = _appDocDirNewFolder.path;
//           }
//           print(_appDocDirFolder.path+" new dir");
//           Dio dio = Dio();
//           dio.download(url!, path + "/" + fileName,
//               onReceiveProgress: (received, total) {
//             downloadProgress.value = ((received / total));
//             if (((received / total) * 100).floor() == 100) {
//               checkFileExistence(fileName);
//             }
//           });
//         } else {
//           String? path;
//           final Directory _appDocDir = Directory(
//               (await getTemporaryDirectory()).path + '/fitbasix/media');
//
//           //App Document Directory + folder name
//           if ((await _appDocDir.exists())) {
//             path = _appDocDir.path;
//           } else {
//             _appDocDir.create();
//             path = _appDocDir.path;
//           }
//           Dio dio = Dio();
//           dio.download(url!, path + "/" + fileName,
//               onReceiveProgress: (received, total) {
//             downloadProgress.value = ((received / total));
//             if (((received / total) * 100).floor() == 100) {
//               checkFileExistence(fileName);
//             }
//           });
//         }
//       } catch (e) {}
//
//       return false;
//     } on PlatformException catch (e) {
//       return false;
//       // Some error occurred, look at the exception message for more details
//     }
//   }
//
//   void checkFileExistence(String? fileName) async {
//     if (Platform.isAndroid) {
//       PermissionStatus status = await Permission.storage.request();
//       if (status == PermissionStatus.granted) {
//         String? path;
//         final downloadsPath = Directory('/storage/emulated/0/Download');
//         final Directory appDir = await getApplicationDocumentsDirectory();
//         final _appDocDirFolder = Directory(appDir.path);
//
//         if (await _appDocDirFolder.exists()) {
//           path = _appDocDirFolder.path;
//         } else {
//           //if folder not exists create folder and then return its path
//           final Directory _appDocDirNewFolder =
//               await _appDocDirFolder.create(recursive: true);
//           path = _appDocDirNewFolder.path;
//         }
//         //if(File(message!.attachments![0]!.data!).existsSync())
//         if (File(path + "/" + fileName!).existsSync()) {
//           filePath.value = path + "/$fileName";
//         }
//
//         if (File(downloadsPath.path + "/" + fileName).existsSync()) {
//           filePath.value = downloadsPath.path + "/" + fileName;
//         }
//       }
//     } else {
//       String? path;
//       final Directory _appDocDir =
//           Directory((await getTemporaryDirectory()).path + '/fitbasix/media');
//       //App Document Directory + folder name
//       if ((await _appDocDir.exists())) {
//         path = _appDocDir.path;
//       } else {
//         _appDocDir.create();
//         path = _appDocDir.path;
//       }
//       if (File(path + "/" + fileName!).existsSync()) {
//         filePath.value = path + "/$fileName";
//       }
//     }
//   }
//
//   void getFileSize() async {
//     String? url =
//         await QB.content.getPrivateURL(message!.attachments![0]!.url!);
//     http.Response size = await http.get(Uri.parse(url!));
//     double sizeInBytes = double.parse(size.headers["content-length"]!);
//     fileSize.value = NumberFormat("0.00").format((sizeInBytes / (1024 * 1024)));
//   }
//
//   Future<String> getFileSizeFromLocal() async {
//     File file = File(filePath.value);
//     int sizeInBytes = (await file.length());
//     var size = NumberFormat("0.00").format((sizeInBytes / (1024 * 1024)));
//     return size;
//   }
// }
//
// //  Message Bubble
// class MessageBubbleOpponent extends StatelessWidget {
//   ChatController _chatController = Get.find();
//   MessageBubbleOpponent({
//     Key? key,
//     this.message,
//   }) : super(key: key);
//
//   final QBMessage? message;
//   var isDownloaded = false.obs;
//   var isDownloadingStarted = false.obs;
//   var downloadProgress = 0.0.obs;
//   var filePath = "".obs;
//   var fileSize = "".obs;
//   String? fileExtension;
//
//   @override
//   Widget build(BuildContext context) {
//     if (message!.attachments == null) {
//       return Padding(
//         padding: EdgeInsets.only(
//             bottom: 8.0 * SizeConfig.heightMultiplier!,
//             left: 16 * SizeConfig.widthMultiplier!),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               constraints: BoxConstraints(
//                 maxWidth: 300 * SizeConfig.widthMultiplier!,
//               ),
//               padding: EdgeInsets.symmetric(
//                 vertical: 10.0 * SizeConfig.heightMultiplier!,
//                 horizontal: 10.0 * SizeConfig.widthMultiplier!,
//               ),
//               decoration: BoxDecoration(
//                 color: kBlack,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Text(message!.body.toString(),
//                   style: AppTextStyle.black400Text.copyWith(color: kPureWhite)),
//             )
//           ],
//         ),
//       );
//     } else {
//       ///if chat has documents
//       fileExtension =
//           message!.attachments![0]!.name!.split(".").last.toUpperCase();
//       getFileSize();
//       checkFileExistence(message!.attachments![0]!.name);
//       return Padding(
//         padding: EdgeInsets.only(
//             bottom: 8.0 * SizeConfig.heightMultiplier!,
//             left: 16 * SizeConfig.widthMultiplier!),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//                 constraints: BoxConstraints(
//                     maxWidth: 300 * SizeConfig.widthMultiplier!,
//                     maxHeight: 250 * SizeConfig.heightMultiplier!),
//                 padding: EdgeInsets.symmetric(
//                   vertical: 14.0 * SizeConfig.heightMultiplier!,
//                   horizontal: 8.0 * SizeConfig.widthMultiplier!,
//                 ),
//                 decoration: BoxDecoration(
//                   color: kBlack,
//                   borderRadius:
//                       BorderRadius.circular(8 * SizeConfig.widthMultiplier!),
//                 ),
//                 child: Obx(() => filePath.value.isEmpty
//                     ? Container(
//                         child: Container(
//                           width: 220 * SizeConfig.widthMultiplier!,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Container(
//                                 padding: EdgeInsets.only(
//                                     left: 8 * SizeConfig.widthMultiplier!),
//                                 height: 50 * SizeConfig.heightMultiplier!,
//                                 decoration: BoxDecoration(
//                                   color: kPureWhite.withOpacity(0.15),
//                                   borderRadius: BorderRadius.circular(
//                                       8 * SizeConfig.imageSizeMultiplier!),
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                         child: Text(
//                                       message!.attachments![0]!.name!,
//                                       overflow: TextOverflow.ellipsis,
//                                       style:
//                                           AppTextStyle.whiteTextWithWeight600,
//                                     )),
//                                     SizedBox(
//                                       width: 10 * SizeConfig.widthMultiplier!,
//                                     ),
//                                     (!isDownloadingStarted.value)
//                                         ? GestureDetector(
//                                             onTap: () async {
//                                               isDownloadingStarted.value = true;
//                                               isDownloaded.value =
//                                                   await _getImageUrl(
//                                                       message!.attachments![0]!
//                                                           .url!,
//                                                       message!.attachments![0]!
//                                                           .name!);
//                                             },
//                                             child: Image.asset(
//                                               ImagePath.downloadDocIcon,
//                                               width: 16.79 *
//                                                   SizeConfig.widthMultiplier!,
//                                               height: 22.4 *
//                                                   SizeConfig.heightMultiplier!,
//                                             ))
//                                         : SizedBox(
//                                             height: 22 *
//                                                 SizeConfig.heightMultiplier!,
//                                             width: 22 *
//                                                 SizeConfig.heightMultiplier!,
//                                             child: CircularProgressIndicator(
//                                               color: kPureWhite,
//                                               value: downloadProgress.value,
//                                               backgroundColor:
//                                                   Colors.grey.withOpacity(0.2),
//                                               strokeWidth: 2.5 *
//                                                   SizeConfig
//                                                       .imageSizeMultiplier!,
//                                             )),
//                                     SizedBox(
//                                       width: 12 * SizeConfig.widthMultiplier!,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 8 * SizeConfig.heightMultiplier!,
//                               ),
//                               Text(
//                                 "${fileSize.value.isNotEmpty ? fileSize.value : 0.0} MB ??? ${message!.attachments![0]!.name!.split(".").last.toUpperCase()}",
//                                 style: AppTextStyle.hmediumBlackText
//                                     .copyWith(color: hintGrey, height: 1),
//                               )
//                             ],
//                           ),
//                         ),
//                       )
//                     : Container(
//                         child: GestureDetector(
//                             onTap: () {
//                               OpenFile.open(filePath.value);
//                             },
//                             child: Container(
//                                 width: 220 * SizeConfig.widthMultiplier!,
//                                 child: Row(
//                                   children: [
//                                     Image.asset(
//                                       (fileExtension == "JPEG" ||
//                                               fileExtension == "JPG")
//                                           ? ImagePath.jpgFileIcon
//                                           : (fileExtension == "PNG")
//                                               ? ImagePath.pngIcon
//                                               : (fileExtension!.contains("PPT"))
//                                                   ? ImagePath.pptIcon
//                                                   : (fileExtension!
//                                                           .contains("MP4"))
//                                                       ? ImagePath.mp4Icon
//                                                       : (fileExtension!
//                                                               .contains("XLX"))
//                                                           ? ImagePath.xlxIcon
//                                                           : (fileExtension ==
//                                                                   "PDF")
//                                                               ? ImagePath
//                                                                   .pdfFileIcon
//                                                               : ImagePath
//                                                                   .docFileIcon,
//                                       width:
//                                           32 * SizeConfig.imageSizeMultiplier!,
//                                       height:
//                                           32 * SizeConfig.imageSizeMultiplier!,
//                                     ),
//                                     SizedBox(
//                                       width: 7 * SizeConfig.widthMultiplier!,
//                                     ),
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Container(
//                                               padding: new EdgeInsets.only(
//                                                   right: 10 *
//                                                       SizeConfig
//                                                           .widthMultiplier!),
//                                               child: Text(
//                                                 message!.attachments![0]!.name!,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 style: AppTextStyle
//                                                     .whiteTextWithWeight600,
//                                               )),
//                                           SizedBox(
//                                             height: 5 *
//                                                 SizeConfig.imageSizeMultiplier!,
//                                           ),
//                                           FutureBuilder(
//                                               future: getFileSizeFromLocal(),
//                                               builder: (context,
//                                                   AsyncSnapshot<String>
//                                                       snapshot) {
//                                                 return Text(
//                                                   "${snapshot.hasData ? snapshot.data : 0.0} MB ??? ${message!.attachments![0]!.name!.split(".").last.toUpperCase()}",
//                                                   style: AppTextStyle
//                                                       .hmediumBlackText
//                                                       .copyWith(
//                                                           color: kPureWhite,
//                                                           height: 1),
//                                                 );
//                                               })
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 ))),
//                       ))),
//           ],
//         ),
//       );
//     }
//   }
//
//   Future<bool> _getImageUrl(String id, String fileName) async {
//     try {
//       String? url = await QB.content.getPrivateURL(id);
//       bool flag = false;
//
//       //FlutterDownloader.registerCallback(downloadCallback);
//       try {
//         if (Platform.isAndroid) {
//           PermissionStatus status = await Permission.storage.request();
//           // if (!_chatController.storagePermissionCalled.value) {
//           //   _chatController.storagePermissionCalled.value = true;
//           //   PermissionStatus status1 =
//           //       await Permission.manageExternalStorage.request();
//           // }
//           String? path;
//           final Directory appDir = await getApplicationDocumentsDirectory();
//           print(appDir.path.toString()+ " lll");
//           final _appDocDirFolder = Directory(appDir.path);
//           if (await _appDocDirFolder.exists()) {
//             //if folder already exists return path
//             path = _appDocDirFolder.path;
//           } else {
//             //if folder not exists create folder and then return its path
//             final Directory _appDocDirNewFolder =
//                 await _appDocDirFolder.create(recursive: true);
//             path = _appDocDirNewFolder.path;
//           }
//           Dio dio = Dio();
//           dio.download(url!, path + "/" + fileName,
//               onReceiveProgress: (received, total) {
//             downloadProgress.value = ((received / total));
//             if (((received / total) * 100).floor() == 100) {
//               checkFileExistence(fileName);
//             }
//           });
//
//           if (Platform.isIOS) {
//             String? path;
//             final Directory _appDocDir = Directory(
//                 (await getTemporaryDirectory()).path + '/fitbasix/media');
//
//             //App Document Directory + folder name
//             if ((await _appDocDir.exists())) {
//               path = _appDocDir.path;
//             } else {
//               _appDocDir.create();
//               path = _appDocDir.path;
//             }
//
//             Dio dio = Dio();
//             dio.download(url, path + "/" + fileName,
//                 onReceiveProgress: (received, total) {
//               downloadProgress.value = ((received / total));
//               if (((received / total) * 100).floor() == 100) {
//                 checkFileExistence(fileName);
//               }
//             });
//           }
//         }
//       } catch (e) {}
//
//       return false;
//     } on PlatformException catch (e) {
//       return false;
//       // Some error occurred, look at the exception message for more details
//     }
//   }
//
//   void checkFileExistence(String? fileName) async {
//     if (Platform.isAndroid) {
//       PermissionStatus status = await Permission.storage.request();
//       // if (!_chatController.storagePermissionCalled.value) {
//       //   _chatController.storagePermissionCalled.value = true;
//       //   PermissionStatus status1 =
//       //       await Permission.manageExternalStorage.request();
//       // }
//       if (status == PermissionStatus.granted) {
//         String? path;
//         final downloadsPath = Directory('/storage/emulated/0/Download');
//         final Directory appDir = await getApplicationDocumentsDirectory();
//         print(appDir.path.toString()+ " lll");
//         final _appDocDirFolder = Directory(appDir.path);
//
//         if (await _appDocDirFolder.exists()) {
//           path = _appDocDirFolder.path;
//         } else {
//           //if folder not exists create folder and then return its path
//           final Directory _appDocDirNewFolder =
//               await _appDocDirFolder.create(recursive: true);
//           path = _appDocDirNewFolder.path;
//         }
//         //if(File(message!.attachments![0]!.data!).existsSync())
//         if (File(path + "/" + fileName!).existsSync()) {
//           filePath.value = path + "/$fileName";
//         }
//
//         if (File(downloadsPath.path + "/" + fileName).existsSync()) {
//           filePath.value = downloadsPath.path + "/" + fileName;
//         }
//       }
//     }
//     if (Platform.isIOS) {
//       String? path;
//       final Directory _appDocDir =
//           Directory((await getTemporaryDirectory()).path + '/fitbasix/media');
//       //App Document Directory + folder name
//       if ((await _appDocDir.exists())) {
//         path = _appDocDir.path;
//       } else {
//         _appDocDir.create();
//         path = _appDocDir.path;
//       }
//       if (File(path + "/" + fileName!).existsSync()) {
//         filePath.value = path + "/$fileName";
//       }
//     }
//   }
//
//   void getFileSize() async {
//     String? url =
//         await QB.content.getPrivateURL(message!.attachments![0]!.url!);
//     print(message!.attachments![0]!.url!);
//     http.Response size = await http.get(Uri.parse(url!));
//     double sizeInBytes = double.parse(size.headers["content-length"]!);
//     fileSize.value = NumberFormat("0.00").format((sizeInBytes / (1024 * 1024)));
//   }
//
//   Future<String> getFileSizeFromLocal() async {
//     File file = File(filePath.value);
//     int sizeInBytes = (await file.length());
//     var size = NumberFormat("0.00").format((sizeInBytes / (1024 * 1024)));
//     return size;
//   }
// }
//
// // Appbar
// class AppbarforChat extends StatelessWidget with PreferredSizeWidget {
//   String? trainerProfilePicUrl;
//   String? trainertitle;
//   String? trainerstatus;
//   BuildContext? parentContext;
//   GestureTapCallback? onMenuTap;
//   ValueChanged<bool>? onHangUpTapped;
//   final WebRTCController _webRtcController = Get.put(WebRTCController());
//
//   AppbarforChat(
//       {Key? key,
//       this.trainerProfilePicUrl,
//       this.trainertitle,
//       this.parentContext,
//       this.trainerstatus,
//       this.onMenuTap,
//       this.onHangUpTapped})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       automaticallyImplyLeading: false,
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       elevation: 0,
//       title: Row(
//         children: [
//           GestureDetector(
//               onTap: () {
//                 Navigator.pop(parentContext!);
//               },
//               child: Container(
//                 width: 20 * SizeConfig.widthMultiplier!,
//                 color: Colors.transparent,
//                 child: Center(
//                   child: SvgPicture.asset(
//                     ImagePath.backIcon,
//                     width: 7.41 * SizeConfig.widthMultiplier!,
//                     height: 12 * SizeConfig.heightMultiplier!,
//                     fit: BoxFit.contain,
//                     color: Theme.of(context).primaryColor,
//                   ),
//                 ),
//               )),
//           SizedBox(
//             width: 16.59 * SizeConfig.widthMultiplier!,
//           ),
//           CircleAvatar(
//             radius: 20 * SizeConfig.imageSizeMultiplier!,
//             backgroundImage: NetworkImage(
//               trainerProfilePicUrl!,
//             ),
//           ),
//           SizedBox(
//             width: 12 * SizeConfig.widthMultiplier!,
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(trainertitle ?? "",
//                   style: AppTextStyle.hnormal600BlackText.copyWith(
//                       color: Theme.of(context).textTheme.bodyText1!.color)),
//               Text(trainerstatus ?? "", style: AppTextStyle.hsmallGreenText),
//             ],
//           ),
//         ],
//       ),
//       actions: [
//         //call icon
//         if (_webRtcController.currentOSVersion.value < 12)
//           Container(
//             child: FlutterSwitch(
//               onToggle: onHangUpTapped!,
//               value: false,
//               height: 24 * SizeConfig.heightMultiplier!,
//               width: 48 * SizeConfig.widthMultiplier!,
//               borderRadius: 30.0,
//               padding: 1.0,
//               activeToggleColor: kPureWhite,
//               inactiveToggleColor: Color(0xffB7B7B7),
//               // toggleSize: 28,
//               activeColor: Color(0xff49AE50),
//               inactiveColor: Colors.transparent,
//               activeIcon: Icon(
//                 Icons.videocam,
//                 color: Color(0xff49AE50),
//               ),
//               inactiveIcon: Icon(
//                 Icons.videocam,
//                 color: kPureWhite,
//               ),
//
//               inactiveSwitchBorder: Border.all(
//                 color: Color(0xffB7B7B7),
//                 width: 1.0,
//               ),
//               activeToggleBorder: Border.all(
//                 color: Color(0xff49AE50),
//                 width: 1.0,
//               ),
//             ),
//           ),
//         // popupmenu icon
//         IconButton(
//             onPressed: onMenuTap,
//             icon: SvgPicture.asset(
//               ImagePath.chatpopupmenuIcon,
//               width: 4 * SizeConfig.widthMultiplier!,
//               height: 20 * SizeConfig.heightMultiplier!,
//               color: Theme.of(context).primaryColor,
//             )),
//       ],
//     );
//   }
//
//   @override
//   Size get preferredSize => Size.fromHeight(kToolbarHeight);
// }
