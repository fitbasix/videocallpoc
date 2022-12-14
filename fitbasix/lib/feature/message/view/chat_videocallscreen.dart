// import 'dart:async';
//
// import 'package:fitbasix/core/constants/app_text_style.dart';
// import 'package:fitbasix/core/constants/color_palette.dart';
// import 'package:fitbasix/core/reponsive/SizeConfig.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:flutter_switch/flutter_switch.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import 'package:sliding_up_panel/sliding_up_panel.dart';
// import '../../../core/constants/image_path.dart';
// import '../../Home/controller/Home_Controller.dart';
// import 'package:get/get.dart';
// import 'package:quickblox_sdk/models/qb_rtc_session.dart';
//
// import 'package:quickblox_sdk/quickblox_sdk.dart';
//
// import 'package:quickblox_sdk/webrtc/constants.dart';
//
// import 'package:quickblox_sdk/webrtc/rtc_video_view.dart';
//
// class VideoCallScreen extends StatefulWidget {
//   String? sessionIdForVideoCall;
//   String? name;
//   String? imageURL;
//
//   VideoCallScreen({Key? key, this.sessionIdForVideoCall,this.name,this.imageURL}) : super(key: key);
//
//   @override
//   _VideoCallScreenState createState() => _VideoCallScreenState();
// }
//
// class _VideoCallScreenState extends State<VideoCallScreen> {
//
//   bool turnCameraOnOff = true;
//   bool turnMicOnOff = true;
//   var _isCallPicked = false.obs;
//   final panelController = PanelController();
//
//   String urlimage =
//       "https://cdna.artstation.com/p/assets/images/images/034/757/492/large/jorge-hardt-02112021-minimalist-japanese-mobile-hd.jpg?1613135473";
//   String avatarImage =
//       "http://tricky-photoshop.com/wp-content/uploads/2017/08/6.jpg";
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
//   StreamSubscription? _connectionStreamSubscription;
//   HomeController _homeController = Get.find();
//
//   RTCVideoViewController? _localVideoViewController;
//
//   RTCVideoViewController? _remoteVideoViewController;
//
//
//
//   @override
//   void dispose() {
//     // _localVideoViewController!.release();
//     // _remoteVideoViewController!.release();
//     unsubscribeCallEnd();
//     unsubscribeReject();
//     unsubscribeAccept();
//     unsubscribeHangUp();
//     unsubscribeVideoTrack();
//     unsubscribeNotAnswer();
//     unsubscribePeerConnection();
//     super.dispose();
//   }
//
//   void unsubscribeNotAnswer() {
//     if (_notAnswerSubscription != null) {
//       _notAnswerSubscription!.cancel();
//
//       _notAnswerSubscription = null;
//     }
//   }
//
//   void unsubscribePeerConnection() {
//     if (_peerConnectionSubscription != null) {
//       _peerConnectionSubscription!.cancel();
//
//       _peerConnectionSubscription = null;
//     }
//   }
//
//   void unsubscribeHangUp() {
//     if (_hangUpSubscription != null) {
//       _hangUpSubscription!.cancel();
//
//       _hangUpSubscription = null;
//     }
//   }
//
//   void unsubscribeVideoTrack() {
//     if (_videoTrackSubscription != null) {
//       _videoTrackSubscription!.cancel();
//
//       _videoTrackSubscription = null;
//     }
//   }
//
//   void unsubscribeReject() {
//     if (_rejectSubscription != null) {
//       _rejectSubscription!.cancel();
//       _rejectSubscription = null;
//     }
//   }
//
//   void unsubscribeAccept() {
//     if (_acceptSubscription != null) {
//       _acceptSubscription!.cancel();
//
//       _acceptSubscription = null;
//     }
//   }
//
//   void unsubscribeCallEnd() {
//     if (_callEndSubscription != null) {
//       _callEndSubscription!.cancel();
//
//       _callEndSubscription = null;
//     }
//   }
//
//   @override
//   void initState() {
//     getCameraAndOtherPermissions();
//     print("llll user id: " + _homeController.userQuickBloxId.value.toString());
//     print(widget.sessionIdForVideoCall);
//     subscribeReject();
//     subscribeAccept();
//     subscribeHangUp();
//     subscribeVideoTrack();
//     subscribeNotAnswer();
//     subscribePeerConnection();
//     super.initState();
//   }
//
//   void getCameraAndOtherPermissions() async {
//     if (await Permission.bluetooth.request().isGranted) {}
//     if (await Permission.camera.request().isGranted) {}
//     if (await Permission.microphone.request().isGranted) {}
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SlidingUpPanel(
//         controller: panelController,
//         color: kBlack,
//         maxHeight: 132 * SizeConfig.heightMultiplier!,
//         minHeight: 35 * SizeConfig.heightMultiplier!,
//         panelBuilder: (controller) => PanelWidget(
//           onHangUpTapped: (value) {
//             hangUpWebRTC();
//           },
//           onCameraTap: () {
//             turnUserCameraOnOFF();
//             print("camera off pressed");
//           },
//           onMicTap: () {
//             turnUserMicOnOFF();
//             print("mic off pressed");
//           },
//           onSpeakerTap: () {
//             switchCameraInCall();
//           },
//           panelController: panelController,
//           controller: controller,
//         ),
//         //body
//         body: Obx(
//           () => Stack(
//             children: [
//               SizedBox(
//                 width: double.infinity,
//                 height: double.infinity,
//                 child:
//                     RTCVideoView(onVideoViewCreated: _onRemoteVideoViewCreated),
//               ),
//               Container(
//                 margin: (_isCallPicked.value)
//                     ? EdgeInsets.only(
//                         top: 38 * SizeConfig.heightMultiplier!,
//                         left: 16 * SizeConfig.widthMultiplier!)
//                     : EdgeInsets.zero,
//                 width: (_isCallPicked.value)
//                     ? 90 * SizeConfig.widthMultiplier!
//                     : double.infinity,
//                 height: (_isCallPicked.value)
//                     ? 160 * SizeConfig.heightMultiplier!
//                     : double.infinity,
//                 child:
//                     RTCVideoView(onVideoViewCreated: _onLocalVideoViewCreated),
//               ),
//               Visibility(
//                 visible: !_isCallPicked.value,
//                 child: Positioned(
//                   top: 81 * SizeConfig.heightMultiplier!,
//                   left: 130 * SizeConfig.widthMultiplier!,
//                   right: 130 * SizeConfig.widthMultiplier!,
//                   child: Column(
//                     children: [
//                       CircleAvatar(
//                         radius: 50,
//                         backgroundImage: NetworkImage(
//                           widget.imageURL!,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 15 * SizeConfig.heightMultiplier!,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Visibility(
//                 visible: !_isCallPicked.value,
//                 child: Positioned(
//                   top: 196 * SizeConfig.heightMultiplier!,
//                   left: 70 * SizeConfig.widthMultiplier!,
//                   right: 70 * SizeConfig.widthMultiplier!,
//                   child: Text(
//                     'Waiting for'.tr+" "+widget.name!+" "+
//                     'to join...',
//                     style: AppTextStyle.hboldWhiteText,
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void switchCameraInCall()  {
//     var result = QB.webrtc.switchCamera(widget.sessionIdForVideoCall!);
//
//   }
//
//   void turnUserMicOnOFF() async {
//     turnMicOnOff = !turnMicOnOff;;
//     print("lllllll"+turnMicOnOff.toString());
//     try {
//       await QB.webrtc.enableAudio(
//         widget.sessionIdForVideoCall!,
//         enable: turnMicOnOff,
//       );
//     } on PlatformException catch (e) {
//       // Some error occurred, look at the exception message for more details
//     }
//   }
//
//   void turnUserCameraOnOFF() async {
//     turnCameraOnOff = !turnCameraOnOff;
//     try {
//       await QB.webrtc
//           .enableVideo(widget.sessionIdForVideoCall!, enable: turnCameraOnOff);
//     } on PlatformException catch (e) {
//       // Some error occurred, look at the exception message for more details
//     }
//   }
//
//   Future<void> hangUpWebRTC() async {
//     try {
//       print("hang up triggeed");
//       QBRTCSession? session =
//           await QB.webrtc.hangUp(widget.sessionIdForVideoCall!).then((value) {
//             Navigator.pop(context);
//           });
//       String? id = session!.id;
//     } on PlatformException catch (e) {}
//   }
//
//   void _onLocalVideoViewCreated(RTCVideoViewController controller) {
//     print("onlocal called");
//     _localVideoViewController = controller;
//   }
//
//   void _onRemoteVideoViewCreated(RTCVideoViewController controller) {
//     print("onRemote called");
//     _remoteVideoViewController = controller;
//   }
//
//   ///related to video call
//   String? _sessionId;
//
//   Future<void> subscribeHangUp() async {
//     if (_hangUpSubscription != null) {
//       return;
//     }
//     try {
//       _hangUpSubscription =
//           await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.HANG_UP, (data) {
//             Navigator.pop(context);
//         int userId = data["payload"]["userId"];
//       }, onErrorMethod: (error) {});
//     } on PlatformException catch (e) {}
//   }
//
//   Future<void> subscribePeerConnection() async {
//     if (_peerConnectionSubscription != null) {
//       return;
//     }
//     try {
//       _peerConnectionSubscription = await QB.webrtc.subscribeRTCEvent(
//           QBRTCEventTypes.PEER_CONNECTION_STATE_CHANGED, (data) {
//         int state = data["payload"]["state"];
//         String parsedState = parseState(state);
//       }, onErrorMethod: (error) {});
//     } on PlatformException catch (e) {}
//   }
//
//   String parseState(int state) {
//     String parsedState = "";
//
//     switch (state) {
//       case QBRTCPeerConnectionStates.NEW:
//         parsedState = "NEW";
//
//         break;
//
//       case QBRTCPeerConnectionStates.FAILED:
//         parsedState = "FAILED";
//
//         break;
//
//       case QBRTCPeerConnectionStates.DISCONNECTED:
//         parsedState = "DISCONNECTED";
//
//         break;
//
//       case QBRTCPeerConnectionStates.CLOSED:
//         parsedState = "CLOSED";
//
//         break;
//
//       case QBRTCPeerConnectionStates.CONNECTED:
//         parsedState = "CONNECTED";
//
//         break;
//     }
//
//     return parsedState;
//   }
//
//   Future<void> subscribeAccept() async {
//     print("call pick mmmm");
//     if (_acceptSubscription != null) {
//       return;
//     }
//     try {
//       _acceptSubscription =
//           await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.ACCEPT, (data) {
//
//         _isCallPicked.value = true;
//         int userId = data["payload"]["userId"];
//         print(data["payload"] + "got this on accept triggeed");
//       }, onErrorMethod: (error) {});
//     } on PlatformException catch (e) {}
//   }
//
//   Future<void> subscribeCallEnd() async {
//     if (_callEndSubscription != null) {
//       return;
//     }
//
//     try {
//       _callEndSubscription =
//           await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.CALL_END, (data) {
//             Navigator.pop(context);
//         print("video end triggeed");
//         Map<dynamic, dynamic> payloadMap =
//             Map<dynamic, dynamic>.from(data["payload"]);
//
//         Map<dynamic, dynamic> sessionMap =
//             Map<dynamic, dynamic>.from(payloadMap["session"]);
//
//         String sessionId = sessionMap["id"];
//       }, onErrorMethod: (error) {});
//     } on PlatformException catch (e) {}
//   }
//
//   Future<void> subscribeReject() async {
//     if (_rejectSubscription != null) {
//       return;
//     }
//
//     try {
//       print("video reject triggeed");
//       _rejectSubscription =
//           await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.REJECT, (data) {
//
//         int userId = data["payload"]["userId"];
//       }, onErrorMethod: (error) {});
//     } on PlatformException catch (e) {}
//   }
//
//   Future<void> subscribeNotAnswer() async {
//     if (_notAnswerSubscription != null) {
//       return;
//     }
//
//     try {
//       print("video not answered triggeed");
//       _notAnswerSubscription =
//           await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.NOT_ANSWER, (data) {
//         int userId = data["payload"]["userId"];
//       }, onErrorMethod: (error) {});
//     } on PlatformException catch (e) {}
//   }
//
//   Future<void> subscribeVideoTrack() async {
//     print("video track started mmmm");
//     if (_videoTrackSubscription != null) {
//       return;
//     }
//
//     try {
//       _videoTrackSubscription = await QB.webrtc
//           .subscribeRTCEvent(QBRTCEventTypes.RECEIVED_VIDEO_TRACK, (data) {
//         print("video track triggeed");
//         Map<dynamic, dynamic> payloadMap =
//             Map<dynamic, dynamic>.from(data["payload"]);
//         int opponentId = payloadMap["userId"];
//         print(opponentId.toString() + " oppp\n"+_homeController.userQuickBloxId.value.toString()+" usssss");
//         print(_homeController.userQuickBloxId.value.toString() + " mmmm");
//         if (opponentId == _homeController.userQuickBloxId.value) {
//           print("local rendring started");
//           startRenderingLocal();
//         } else {
//           print("remote rendering started");
//           startRenderingRemote(opponentId);
//         }
//       }, onErrorMethod: (error) {});
//     } on PlatformException catch (e) {}
//   }
//
//   Future<void> startRenderingLocal() async {
//     WidgetsBinding.instance!.addPostFrameCallback((_) async {
//       print("started rendering local");
//       print(widget.sessionIdForVideoCall!.toString() + "session id check");
//       try {
//         await _localVideoViewController!.play(widget.sessionIdForVideoCall!,
//             _homeController.userQuickBloxId.value);
//       } on PlatformException catch (e) {}
//     });
//   }
//
//   Future<void> startRenderingRemote(int opponentId) async {
//     WidgetsBinding.instance!.addPostFrameCallback((_) async {
//       print("redering started mmmm");
//       try {
//         await _remoteVideoViewController!
//             .play(widget.sessionIdForVideoCall!, opponentId);
//       } on PlatformException catch (e) {}
//     });
//   }
//
//   Future<void> callWebRTC(int sessionType) async {
//     try {
//       QBRTCSession? session = await QB.webrtc.call([133536465], sessionType,
//           userInfo: {"userName": "Kashif Ahmad"});
//       _sessionId = session!.id;
//     } on PlatformException catch (e) {}
//   }
// }
//
// class PanelWidget extends StatefulWidget {
//   final ScrollController? controller;
//   final PanelController panelController;
//   ValueChanged<bool>? onHangUpTapped;
//   GestureTapCallback? onMicTap;
//   GestureTapCallback? onCameraTap;
//   GestureTapCallback? onSpeakerTap;
//
//   PanelWidget(
//       {Key? key,
//       this.controller,
//       required this.panelController,
//       this.onHangUpTapped,
//       this.onMicTap,
//       this.onCameraTap,
//       this.onSpeakerTap})
//       : super(key: key);
//
//   @override
//   State<PanelWidget> createState() => _PanelWidgetState();
// }
//
// class _PanelWidgetState extends State<PanelWidget> {
//   bool? ismicon = true;
//   bool? isspeakeron = true;
//   bool? iscameraon = true;
//   bool status = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: EdgeInsets.zero,
//       controller: widget.controller,
//       children: [
//         SizedBox(
//           height: 8 * SizeConfig.heightMultiplier!,
//         ),
//         buildDragHandle(),
//         SizedBox(
//           height: 32 * SizeConfig.heightMultiplier!,
//         ),
//         Padding(
//           padding: EdgeInsets.only(
//               left: 35 * SizeConfig.widthMultiplier!,
//               right: 35 * SizeConfig.widthMultiplier!),
//           child: Row(
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   widget.onMicTap!.call();
//                   setState(() {
//                     ismicon = !ismicon!;
//                     print("mic pressed");
//                   });
//                 },
//                 child: // mic
//                     ismicon!
//                         ? SvgPicture.asset(
//                             ImagePath.videomicON,
//                             width: 18.67 * SizeConfig.widthMultiplier!,
//                             height: 25.33 * SizeConfig.heightMultiplier!,
//                             fit: BoxFit.contain,
//                           )
//                         : CircleAvatar(
//                             backgroundColor: kPureWhite,
//                             child: SvgPicture.asset(
//                               ImagePath.videomicOFF,
//                               width: 24 * SizeConfig.widthMultiplier!,
//                               height: 25.33 * SizeConfig.heightMultiplier!,
//                               color: kPureBlack,
//                             ),
//                           ),
//               ),
//               Spacer(),
//               // speaker
//               GestureDetector(
//                 onTap: () {
//                   widget.onSpeakerTap!.call();
//                   setState(() {
//                     isspeakeron = !isspeakeron!;
//
//                   });
//                 },
//                 child: isspeakeron!
//                     ? SvgPicture.asset(
//                         ImagePath.videospeakerON,
//                         width: 24 * SizeConfig.widthMultiplier!,
//                         height: 23.39 * SizeConfig.heightMultiplier!,
//                         fit: BoxFit.contain,
//                       )
//                     : CircleAvatar(
//                         backgroundColor: kPureWhite,
//                         child: SvgPicture.asset(
//                           ImagePath.videospeakerOFF,
//                           width: 24 * SizeConfig.widthMultiplier!,
//                           height: 24 * SizeConfig.heightMultiplier!,
//                           color: kPureBlack,
//                         )),
//               ),
//               Spacer(),
//               // camera
//               GestureDetector(
//                 onTap: () {
//                   widget.onCameraTap!.call();
//                   setState(() {
//                     iscameraon = !iscameraon!;
//                   });
//                 },
//                 child: iscameraon!
//                     ? SvgPicture.asset(
//     ImagePath.videocameraON,
//     width: 24 * SizeConfig.widthMultiplier!,
//     height: 16 * SizeConfig.heightMultiplier!,
//     fit: BoxFit.contain,
//     )
//                     : CircleAvatar(
//                         backgroundColor: kPureWhite,
//                         child: SvgPicture.asset(
//                           ImagePath.videocameraOFF,
//                           width: 25.33 * SizeConfig.widthMultiplier!,
//                           height: 25.33 * SizeConfig.heightMultiplier!,
//                           color: kPureBlack,
//                         ),
//                       ),
//               ),
//               Spacer(),
//               //Video end button
//               Container(
//                 child: FlutterSwitch(
//                   onToggle: widget.onHangUpTapped!,
//                   value: status,
//                   height: 24 * SizeConfig.heightMultiplier!,
//                   width: 48 * SizeConfig.widthMultiplier!,
//                   borderRadius: 30.0,
//                   padding: 1.0,
//                   activeToggleColor: kPureWhite,
//                   inactiveToggleColor: Color(0xffB7B7B7),
//                   // toggleSize: 28,
//                   activeColor: Color(0xff49AE50),
//                   inactiveColor: Colors.white,
//                   activeIcon: Icon(
//                     Icons.videocam,
//                     color: Color(0xff49AE50),
//                   ),
//                   inactiveIcon: Icon(
//                     Icons.videocam,
//                     color: kPureWhite,
//                   ),
//                   // activeSwitchBorder: Border.all(
//                   //   color: Color(0xFF3C1E70),
//                   //   width: 6.0,
//                   // ),
//                   inactiveSwitchBorder: Border.all(
//                     color: Color(0xffB7B7B7),
//                     width: 1.0,
//                   ),
//                   activeToggleBorder: Border.all(
//                     color: Color(0xff49AE50),
//                     width: 1.0,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget buildDragHandle() => GestureDetector(
//         child: Center(
//           child: Container(
//             height: 4 * SizeConfig.heightMultiplier!,
//             width: 48 * SizeConfig.widthMultiplier!,
//             decoration: BoxDecoration(
//               color: kPureWhite,
//               borderRadius: BorderRadius.circular(3),
//             ),
//           ),
//         ),
//         onTap: togglePanel,
//       );
//
//   Future<void> togglePanel() => widget.panelController.isPanelOpen
//       ? widget.panelController.close()
//       : widget.panelController.open();
// }
