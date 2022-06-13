// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:enx_flutter_plugin/enx_player_widget.dart';
// import 'package:enx_flutter_plugin/enx_flutter_plugin.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_switch/flutter_switch.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';
//
// import '../../../../core/constants/color_palette.dart';
// import '../../../../core/constants/image_path.dart';
// import '../../../../core/reponsive/SizeConfig.dart';
//
// class VideoConferenceScreen extends StatefulWidget {
//   VideoConferenceScreen({required this.token});
//   final String token;
//   @override
//   Conference createState() => Conference();
// }
//
// class Conference extends State<VideoConferenceScreen> {
//   bool isAudioMuted = false;
//   bool isVideoMuted = false;
//   bool isAudioEnergy=false;
//   late String streamId;
//   late String streamId3;
//   late int streamId2;
//   late String base64String;
//   bool isScreenShare=false;
//   final panelController = PanelController();
//   @override
//   void initState() {
//     super.initState();
//     print('Enablex Demo');
//     initEnxRtc();
//     openBottomPanel();
//
//     // _initForegroundTask();
//
//
//     _addEnxrtcEventHandlers();
//   }
//
//   void openBottomPanel(){
//     WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
//       panelController.open();
//     });
//   }
//
//   Future<void> initEnxRtc() async {
//     Map<String, dynamic> map2 = {
//       'minWidth': 320,
//       'minHeight': 180,
//       'maxWidth': 1280,
//       'maxHeight': 720
//     };
//     Map<String, dynamic> map1 = {
//       'audio': true,
//       'video': true,
//       'data': true,
//       // 'framerate': 30,
//       // 'maxVideoBW': 1500,
//       // 'minVideoBW': 150,
//       'audioMuted': false,
//       'videoMuted': false,
//       'name': 'flutter',
//       // 'videoSize': map2
//     };
//     Map<String, dynamic> map3 = {
//       'allow_reconnect': true,
//       'number_of_attempts': 3,
//       'timeout_interval': 15,
//
//     };
//
//     print('tokenRelease:${widget.token}');
//     await EnxRtc.joinRoom(widget.token, map1, {}, []);
//   }
//
//   void _addEnxrtcEventHandlers() {
//     EnxRtc.onRoomConnected = (Map<dynamic, dynamic> map) {
//       setState(() {
//         print('onRoomConnectedFlutter' + jsonEncode(map));
//       });
//       EnxRtc.publish();
//
//     };
//
//     EnxRtc.onPublishedStream = (Map<dynamic, dynamic> map) {
//       setState(() {
//         print('onPublishedStream' + jsonEncode(map));
//         streamId = map['streamId'];
//         EnxRtc.setupVideo(0, 0, true, 300, 200);
//       });
//     };
//     EnxRtc.OnCapturedView=(String bitmap){
//       setState(() {
//         base64String=bitmap;
//         print('OnCapturedView' + bitmap);
//         Clipboard.setData(ClipboardData(text: bitmap));
//
//
//
//       });
//     };
//     EnxRtc.onStreamAdded = (Map<dynamic, dynamic> map) {
//       print('onStreamAdded' + jsonEncode(map));
//       print('onStreamAdded Id' + map['streamId']);
//
//       late  String streamId1;
//       setState(() {
//         streamId1 = map['streamId'];
//       });
//       EnxRtc.subscribe(streamId1);
//     };
//
//     EnxRtc.onRoomError = (Map<dynamic, dynamic> map) {
//       setState(() {
//         print('onRoomError' + jsonEncode(map));
//       });
//     };
//     EnxRtc.onNotifyDeviceUpdate = (String deviceName) {
//       print('onNotifyDeviceUpdate' + deviceName);
//     };
//
//     EnxRtc.onActiveTalkerList = (Map<dynamic, dynamic> map) {
//       print('onActiveTalkerList ' + map.toString());
//
//       final items = (map['activeList'] as List)
//           .map((i) => new ActiveListModel.fromJson(i));
//       if(_remoteUsers.length>0){
//         for(int i=0;i<_remoteUsers.length;i++){
//           setState(() {
//             _remoteUsers.removeAt(i);
//           });
//
//         }
//       }
//       if (items.length > 0) {
//         for (final item in items) {
//           if(!_remoteUsers.contains(item.streamId)){
//             print('_remoteUsers ' + map.toString());
//             setState(() {
//               streamId2 = item.streamId  ;
//               base64String=  item.clientId;
//               _remoteUsers.add(item.streamId);
//             });
//           }
//         }
//         print('_remoteUsersascashjc');
//         print(_remoteUsers);
//
//       }
//     };
//
//     EnxRtc.onEventError = (Map<dynamic, dynamic> map) {
//       setState(() {
//         print('onEventError' + jsonEncode(map));
//       });
//     };
//
//     EnxRtc.onEventInfo = (Map<dynamic, dynamic> map) {
//       setState(() {
//         print('onEventInfo' + jsonEncode(map));
//       });
//     };
//     EnxRtc.onUserConnected = (Map<dynamic, dynamic> map) {
//       setState(() {
//         print('onUserConnected' + jsonEncode(map));
//       });
//     };
//     EnxRtc.onUserDisConnected = (Map<dynamic, dynamic> map) {
//       setState(() {
//         print('onUserDisConnected' + jsonEncode(map));
//
//       });
//     };
//     EnxRtc.onRoomDisConnected = (Map<dynamic, dynamic> map) {
//       setState(() {
//         print('onRoomDisConnected' + jsonEncode(map));
//         //  Navigator.pop(context);
//         Navigator.pop(context, '/Conference');
//       });
//     };
//     EnxRtc.onAudioEvent = (Map<dynamic, dynamic> map) {
//       print('onAudioEvent' + jsonEncode(map));
//       setState(() {
//         if (map['msg'].toString() == "Audio Off") {
//           isAudioMuted = true;
//         } else {
//           isAudioMuted = false;
//         }
//       });
//     };
//     EnxRtc.onVideoEvent = (Map<dynamic, dynamic> map) {
//       print('onVideoEvent' + jsonEncode(map));
//       setState(() {
//         if (map['msg'].toString() == "Video Off") {
//           isVideoMuted = true;
//         } else {
//           isVideoMuted = false;
//         }
//       });
//     };
//     EnxRtc.onAckSubscribeTalkerNotification=(Map<dynamic, dynamic> map) {
//       isAudioEnergy = true;
//       print('onAckSubscribeTalkerNotification12' + jsonEncode(map));
//
//     };
//     EnxRtc.onAckUnsubscribeTalkerNotification=(Map<dynamic, dynamic> map) {
//       print('onAckUnsubscribeTalkerNotification12' + jsonEncode(map));
//       isAudioEnergy = false;
//
//     };
//     EnxRtc.onTalkerNtification=(Map<dynamic, dynamic> map) {
//       print('onTalkerNtification' + jsonEncode(map));
//
//     };
//     EnxRtc.onClientDiagnosisFailed=(Map<dynamic, dynamic> map) {
//       print('onClientDiagnosisFailed' + jsonEncode(map));
//     };
//     EnxRtc.onClientDiagnosisFinished=(Map<dynamic, dynamic> map) {
//       print('onClientDiagnosisFinished' + jsonEncode(map));
//     };
//     EnxRtc.onClientDiagnosisStatus=(Map<dynamic, dynamic> map) {
//       print('onClientDiagnosisStatus' + jsonEncode(map));
//     };
//     EnxRtc.onClientDiagnosisStopped=(Map<dynamic, dynamic> map) {
//       print('onClientDiagnosisStopped' + jsonEncode(map));
//     };
//     //
//     EnxRtc.onAckCreateBreakOutRoom=(Map<dynamic, dynamic> map) {
//       print('onAckCreateBreakOutRoom' + jsonEncode(map));
//     };
//     EnxRtc.onAckCreateAndInviteBreakOutRoom=(Map<dynamic, dynamic> map) {
//       print('onAckCreateAndInviteBreakOutRoom' + jsonEncode(map));
//     };
//     EnxRtc.onAckInviteBreakOutRoom=(Map<dynamic, dynamic> map) {
//       print('onAckInviteBreakOutRoom' + jsonEncode(map));
//     };
//     /* EnxRtc.onAckPause=(Map<dynamic, dynamic> map) {
//       print('onAckPause' + jsonEncode(map));
//     };
//     EnxRtc.onAckResume=(Map<dynamic, dynamic> map) {
//       print('onAckResume' + jsonEncode(map));
//     };
//     EnxRtc.onAckMuteRoom=(Map<dynamic, dynamic> map) {
//       print('onAckMuteRoom' + jsonEncode(map));
//     };
//     EnxRtc.onAckUnmuteRoom=(Map<dynamic, dynamic> map) {
//       print('onAckUnmuteRoom' + jsonEncode(map));
//     };*/
//     EnxRtc.onFailedJoinBreakOutRoom=(Map<dynamic, dynamic> map) {
//       print('onFailedJoinBreakOutRoom' + jsonEncode(map));
//     };
//     EnxRtc.onConnectedBreakoutRoom=(Map<dynamic, dynamic> map) {
//       print('onConnectedBreakoutRoom' + jsonEncode(map));
//     };
//     EnxRtc.onDisconnectedBreakoutRoom=(Map<dynamic, dynamic> map) {
//       print('onDisconnectedBreakoutRoom' + jsonEncode(map));
//     };
//     EnxRtc.onUserJoinedBreakoutRoom=(Map<dynamic, dynamic> map) {
//       print('onUserJoinedBreakoutRoom' + jsonEncode(map));
//     };
//     EnxRtc.onInvitationForBreakoutRoom=(Map<dynamic, dynamic> map) {
//       print('onInvitationForBreakoutRoom' + jsonEncode(map));
//     };
//     EnxRtc.onDestroyedBreakoutRoom=(Map<dynamic, dynamic> map) {
//       print('onDestroyedBreakoutRoom' + jsonEncode(map));
//     };
//     EnxRtc.onUserDisconnectedFromBreakoutRoom=(Map<dynamic, dynamic> map) {
//       print('onUserDisconnectedFromBreakoutRoom' + jsonEncode(map));
//     };
//
//     EnxRtc.onUserAwaited=(Map<dynamic, dynamic> map) {
//       print('onUserAwaited' + jsonEncode(map));
//     };
//     EnxRtc.onRoomAwaited=(Map<dynamic, dynamic> map) {
//       print('onRoomAwaited' + jsonEncode(map));
//     };
//     EnxRtc.onAckForApproveAwaitedUser=(Map<dynamic, dynamic> map) {
//       print('onAckForApproveAwaitedUser' + jsonEncode(map));
//     };
//     EnxRtc.onAckForApproveAwaitedUser=(Map<dynamic, dynamic> map) {
//       print('onAckForApproveAwaitedUser' + jsonEncode(map));
//     };
//     EnxRtc.onAckForDenyAwaitedUser=(Map<dynamic, dynamic> map) {
//       print('onAckForDenyAwaitedUser' + jsonEncode(map));
//     };
//     EnxRtc.onAckAddSpotlightUsers=(Map<dynamic, dynamic> map) {
//       isAudioEnergy = true;
//       print('onAckAddSpotlightUsers' + jsonEncode(map));
//
//     };
//     EnxRtc.onAckRemoveSpotlightUsers=(Map<dynamic, dynamic> map) {
//       isAudioEnergy = false;
//       print('onAckRemoveSpotlightUsers' + jsonEncode(map));
//
//     };
//     EnxRtc.onUpdateSpotlightUsers=(Map<dynamic, dynamic> map) {
//       print('onUpdateSpotlightUsers' + jsonEncode(map));
//     };
//     EnxRtc.onAckSwitchedRoom=(Map<dynamic, dynamic> map) {
//       print('onAckSwitchedRoom' + jsonEncode(map));
//
//     };
//     EnxRtc.onRoomModeSwitched=(Map<dynamic, dynamic> map) {
//       print('onRoomModeSwitched' + jsonEncode(map));
//
//     };
//     //
//     EnxRtc.onHardMutedAudio=(Map<dynamic, dynamic> map){
//       isAudioMuted=true;
//     };
//
//     EnxRtc.onHardUnMutedAudio=(Map<dynamic, dynamic> map){
//       isAudioMuted=false;
//
//     };
//     EnxRtc.onReceivedHardMuteAudio=(Map<dynamic, dynamic> map){
//       isAudioMuted=false;
//     };
//
//     EnxRtc.onReceivedHardUnMuteAudio=(Map<dynamic, dynamic> map){
//       isAudioMuted=false;
//     };
//
//     EnxRtc.onRoomBandwidthAlert=(Map<dynamic,dynamic> map){
//
//     };
//     EnxRtc.onAckForDenyAwaitedUser=(Map<dynamic,dynamic> map){
//
//     };
//     EnxRtc.onRoomAwaited=(Map<dynamic,dynamic> map){
//
//     };
//
//     EnxRtc.onUserAwaited=(Map<dynamic,dynamic> map){
//
//     };
//
//     EnxRtc.onMessageReceived=(Map<dynamic,dynamic> map){
//
//     };
//
//     EnxRtc.onScreenSharedStarted=(Map<dynamic, dynamic> map){
//
//     };
//
//     EnxRtc.onScreenSharedStopped=(Map<dynamic, dynamic> map){
//       setState(() {
//         isScreenShare=false;
//       });
//
//     };
//     EnxRtc.onACKStartLiveRecording=(Map<dynamic, dynamic> map){
//       print('onACKStartLiveRecording' + jsonEncode(map));
//     };
//     EnxRtc.onACKStopLiveRecording=(Map<dynamic, dynamic> map){
//       print('onACKStopLiveRecording' + jsonEncode(map));
//     };
//     EnxRtc.onLiveRecordingNotification=(Map<dynamic, dynamic> map){
//       print('onLiveRecordingNotification' + jsonEncode(map));
//     };
//     EnxRtc.onRoomliverecordOn=(Map<dynamic, dynamic> map){
//       print('onRoomliverecordOn' + jsonEncode(map));
//
//     };
//   }
//
//   void _setMediaDevice(String value) {
//     EnxRtc.switchMediaDevice(value);
//   }
//
//   // createDialog() {
//   //   showDialog(
//   //       context: context,
//   //       builder: (BuildContext context) {
//   //         log("inside dialog");
//   //         return Container(
//   //           margin: EdgeInsets.symmetric(horizontal: 30*SizeConfig.widthMultiplier!,
//   //           vertical: 100*SizeConfig.heightMultiplier!),
//   //           child: AlertDialog(
//   //               title: Text('Media Devices'),
//   //               content: Container(
//   //                 height: 400,
//   //                 child: Column(
//   //                   mainAxisSize: MainAxisSize.min,
//   //                   children: <Widget>[
//   //                     Container(
//   //                       height: 200*SizeConfig.heightMultiplier!,
//   //                       child: ListView.builder(
//   //                         shrinkWrap: true,
//   //                         itemCount: deviceList.length,
//   //                         itemBuilder: (BuildContext context, int index) {
//   //                           return ListTile(
//   //                             title: Text(deviceList[index].toString()),
//   //                             onTap: () =>
//   //                                 _setMediaDevice(deviceList[index].toString()),
//   //                           );
//   //                         },
//   //                       ),
//   //                     )
//   //                   ],
//   //                 ),
//   //               )),
//   //         );
//   //       });
//   // }
//
//   //
//
//
//
//
//
//   void _disconnectRoom() {
//
//     // EnxRtc.captureScreenShot(streamId2.toString());
//     EnxRtc.disconnect();
//
//     Navigator.of(context).pop();
//     //EnxRtc.hardUnMuteVideo(clientId)
//     // if(isAudioMuted){
//     //   EnxRtc.stopScreenShare();
//     //   _stopForegroundTask();
//     // }else{
//     //   _startForegroundTask();
//     //   EnxRtc.startScreenShare();
//     //
//     // }
//
//     /* else
//       EnxRtc.stopScreenShare();*/
//     /*  if(isAudioMuted)
//    EnxRtc.hardUnMuteVideo(base64String);
//     else
//       EnxRtc.hardMuteVideo(base64String);*/
//     //EnxRtc.onScreenSharedStarted()
//   }
//
//
//   void knockKnock(){
//
//   }
//
// /* void _precallTest() {
//    Map<String, dynamic> map = {
//      'regionId': 'IN',
//      'stop': false,
//      'testNames': "MicroPhone"
//    };
//    EnxRtc.clientDiagnostics(map);
//  }*/
//
//   void _spotLight(){
//
//     /* var userlist= ['81c168cf-2007-405c-8867-172c59224cda'];
//     if (isAudioEnergy) {
//       EnxRtc.addSpotlightUsers(userlist);
//     } else {
//       EnxRtc.removeSpotlightUsers(userlist);
//     }*/
//
//     //create breakoutroom
//     /* Map<String, dynamic> map = {
//       "participants" :2,
//       "audio" : true,
//       "video": false ,
//       "canvas": false,
//       "share": false,
//       "max_rooms": 1
//     };
//     EnxRtc.createBreakOutRoom(map);*/
//
//     if(!isAudioEnergy)
//       EnxRtc.switchRoomMode("lecture");
//     else
//       EnxRtc.switchRoomMode("group");
//
//     isAudioEnergy=!isAudioEnergy;
//   }
//
//   void _toggleAudioEnergy() {
//
//     if (isAudioEnergy) {
//       EnxRtc.subscribeForTalkerNotification(false);
//     } else {
//       EnxRtc.subscribeForTalkerNotification(true);
//     }
//   }
//   void _toggleAudio() {
//     if (isAudioMuted) {
//       //EnxRtc.startLiveRecording({"urlDetails" : {}});
//       EnxRtc.muteSelfAudio(false);
//     } else {
//       //EnxRtc.startLiveRecording({"urlDetails" : {}});
//       EnxRtc.muteSelfAudio(true);
//     }
//   }
//
//   void _toggleVideo() {
//     if (isVideoMuted) {
//       //EnxRtc.stopLiveRecording();
//       EnxRtc.muteSelfVideo(false);
//     } else {
//       //EnxRtc.stopLiveRecording();
//       EnxRtc.muteSelfVideo(true);
//     }
//   }
//
//
//   void _toggleSpeaker() async {
//     List<dynamic> list = await EnxRtc.getDevices();
//     setState(() {
//       deviceList = list;
//     });
//     print('deviceList');
//     print(deviceList);
//     deviceList.forEach((element) {
//       _setMediaDevice(element);
//     });
//   }
//
//   void _toggleCamera() {
//     // EnxRtc.sendMessage(
//     //     "🤑", true, []);
//     EnxRtc.switchCamera();
//   }
//
//   int remoteView = -1;
//   late List<dynamic> deviceList;
//
//   Widget _viewRows() {
//     return ListView(
//       scrollDirection: Axis.horizontal,
//       children: <Widget>[
//         for (final widget in _renderWidget)
//           Container(
//             height: 120,
//             width: 120,
//             child: widget,
//
//           ),
//
//       ],
//     );
//   }
//
//   Iterable<Widget> get _renderWidget sync* {
//     for (final streamId in _remoteUsers) {
//       // double width = MediaQuery.of(context).size.width;
//       yield EnxPlayerWidget(streamId, local: false,width:40,height:40);
//
//     }
//   }
//
//   final _remoteUsers = <int>[];
//
//
//   @override
//   Widget build(BuildContext context) {
//     int playerWidth = MediaQuery.of(context).size.width.toInt();
//     int playerHeight = MediaQuery.of(context).size.height.toInt();
//     print(playerWidth);
//     return  Scaffold(
//       body: SlidingUpPanel(
//         controller: panelController,
//         color: kBlack,
//         maxHeight: 100 * SizeConfig.heightMultiplier!,
//         minHeight: 20 * SizeConfig.heightMultiplier!,
//         panelBuilder: (controller) => PanelWidget(
//           onHangUpTapped: (value) {
//             _disconnectRoom();
//           },
//           onCameraTap: _toggleVideo,
//           onMicTap: _toggleAudio,
//           onSpeakerTap: _toggleSpeaker,
//           panelController: panelController,
//           controller: controller,
//         ),
//         body: Container(
//           color: Colors.black,
//           child: Column(
//             children: [
//               Stack(
//                 children: <Widget>[
//                   isScreenShare?  Container(
//                     height: MediaQuery.of(context).size.height,
//                     width: MediaQuery.of(context).size.width,
//                     child: EnxPlayerWidget(int.parse(streamId3), local: false,width: playerWidth, height: double.infinity.toInt()),
//                   ):Visibility( visible:false,child: Container()),Visibility(
//                     visible: isScreenShare?false:true,
//                     child: Container(
//                       height: MediaQuery.of(context).size.height,
//                       width: MediaQuery.of(context).size.width,
//                       child: EnxPlayerWidget(0, local: true,width: playerWidth, height: playerHeight),
//                     ),
//                   ),
//                   _remoteUsers.length> 0 ? Positioned(
//                       bottom: 95,
//                       left: 20,
//                       right: 20,
//                       child:Card(
//                         color: Colors.transparent,
//                         child: Container(
//                             alignment: Alignment.bottomCenter,
//                             height:90,
//                             width: MediaQuery.of(context).size.width,
//                             child: _viewRows()
//                         ),
//                       )) : Container(),
//                   // Positioned(
//                   //   bottom: 20,
//                   //   left: 20,
//                   //   right: 20,
//                   //   child: Container(
//                   //     color: Colors.white,
//                   //     // height: 100,
//                   //     width: MediaQuery.of(context).size.width,
//                   //     child: Row(
//                   //       children: [
//                   //         Container(
//                   //           width: MediaQuery.of(context).size.width / 7,
//                   //           child: MaterialButton(
//                   //             child: isAudioMuted
//                   //                 ? Image.asset(
//                   //               'assets/mute_audio.png',
//                   //               fit: BoxFit.cover,
//                   //               height: 30,
//                   //               width: 30,
//                   //             )
//                   //                 : Image.asset(
//                   //               'assets/unmute_audio.png',
//                   //               fit: BoxFit.cover,
//                   //               height: 30,
//                   //               width: 30,
//                   //             ),
//                   //             onPressed: _toggleAudio,
//                   //           ),
//                   //         ),
//                   //         Container(
//                   //           width: MediaQuery.of(context).size.width / 7,
//                   //           child: MaterialButton(
//                   //             child: Image.asset(
//                   //               'assets/camera_switch.png',
//                   //               fit: BoxFit.cover,
//                   //               height: 30,
//                   //               width: 30,
//                   //             ),
//                   //             onPressed: _toggleCamera,
//                   //           ),
//                   //         ),
//                   //         Container(
//                   //           width: MediaQuery.of(context).size.width / 7,
//                   //           child: MaterialButton(
//                   //             child: isVideoMuted
//                   //                 ? Image.asset(
//                   //               'assets/mute_video.png',
//                   //               fit: BoxFit.cover,
//                   //               height: 30,
//                   //               width: 30,
//                   //             )
//                   //                 : Image.asset(
//                   //               'assets/unmute_video.png',
//                   //               fit: BoxFit.cover,
//                   //               height: 30,
//                   //               width: 30,
//                   //             ),
//                   //             onPressed: _toggleVideo,
//                   //           ),
//                   //         ),
//                   //         Container(
//                   //           width: MediaQuery.of(context).size.width / 8,
//                   //           child: MaterialButton(
//                   //             child: Image.asset(
//                   //               'assets/unmute_speaker.png',
//                   //               fit: BoxFit.cover,
//                   //               height: 30,
//                   //               width: 30,
//                   //             ),
//                   //             onPressed: _toggleSpeaker,
//                   //           ),
//                   //         ),
//                   //         Container(
//                   //           width: MediaQuery.of(context).size.width / 8,
//                   //           child: MaterialButton(
//                   //             child: Image.asset(
//                   //               'assets/disconnect.png',
//                   //               fit: BoxFit.cover,
//                   //               height: 30,
//                   //               width: 30,
//                   //             ),
//                   //             onPressed: _disconnectRoom,
//                   //           ),
//                   //         ),
//                   //         Container(
//                   //           width: MediaQuery.of(context).size.width / 8,
//                   //           child: MaterialButton(
//                   //             child: Image.asset(
//                   //               'assets/unmute_speaker.png',
//                   //               fit: BoxFit.cover,
//                   //               height: 30,
//                   //               width: 30,
//                   //             ),
//                   //             onPressed: _spotLight,
//                   //           ),
//                   //         ),
//                   //       ],
//                   //     ),
//                   //   ),
//                   // ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
// }
//
//
//
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
//         this.controller,
//         required this.panelController,
//         this.onHangUpTapped,
//         this.onMicTap,
//         this.onCameraTap,
//         this.onSpeakerTap})
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
//                 ismicon!
//                     ? SvgPicture.asset(
//                   ImagePath.videomicON,
//                   width: 18.67 * SizeConfig.widthMultiplier!,
//                   height: 25.33 * SizeConfig.heightMultiplier!,
//                   fit: BoxFit.contain,
//                 )
//                     : CircleAvatar(
//                   backgroundColor: kPureWhite,
//                   child: SvgPicture.asset(
//                     ImagePath.videomicOFF,
//                     width: 24 * SizeConfig.widthMultiplier!,
//                     height: 25.33 * SizeConfig.heightMultiplier!,
//                     color: kPureBlack,
//                   ),
//                 ),
//               ),
//               Spacer(),
//               // speaker
//               GestureDetector(
//                 onTap: () {
//                   widget.onSpeakerTap!.call();
//                   setState(() {
//                     isspeakeron = !isspeakeron!;
//                   });
//                 },
//                 child: isspeakeron!
//                     ? SvgPicture.asset(
//                   ImagePath.videospeakerON,
//                   width: 24 * SizeConfig.widthMultiplier!,
//                   height: 23.39 * SizeConfig.heightMultiplier!,
//                   fit: BoxFit.contain,
//                 )
//                     : CircleAvatar(
//                     backgroundColor: kPureWhite,
//                     child: SvgPicture.asset(
//                       ImagePath.videospeakerOFF,
//                       width: 24 * SizeConfig.widthMultiplier!,
//                       height: 24 * SizeConfig.heightMultiplier!,
//                       color: kPureBlack,
//                     )),
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
//                   ImagePath.videocameraON,
//                   width: 24 * SizeConfig.widthMultiplier!,
//                   height: 16 * SizeConfig.heightMultiplier!,
//                   fit: BoxFit.contain,
//                 )
//                     : CircleAvatar(
//                   backgroundColor: kPureWhite,
//                   child: SvgPicture.asset(
//                     ImagePath.videocameraOFF,
//                     width: 25.33 * SizeConfig.widthMultiplier!,
//                     height: 25.33 * SizeConfig.heightMultiplier!,
//                     color: kPureBlack,
//                   ),
//                 ),
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
//     child: Center(
//       child: Container(
//         height: 4 * SizeConfig.heightMultiplier!,
//         width: 48 * SizeConfig.widthMultiplier!,
//         decoration: BoxDecoration(
//           color: kPureWhite,
//           borderRadius: BorderRadius.circular(3),
//         ),
//       ),
//     ),
//     onTap: togglePanel,
//   );
//
//   Future<void> togglePanel() => widget.panelController.isPanelOpen
//       ? widget.panelController.close()
//       : widget.panelController.open();
// }
//
// class ActiveList {
//   bool active;
//   List<ActiveListModel> activeList = [];
//   String event;
//
//   ActiveList(this.active, this.activeList, this.event);
//
//   factory ActiveList.fromJson(Map<dynamic, dynamic> json) {
//     return ActiveList(
//       json['active'] as bool,
//       (json['activeList'] as List).map((i) {
//         return ActiveListModel.fromJson(i);
//       }).toList(),
//       json['event'] as String,
//     );
//   }
// }
//
// class ActiveListModel {
//   String name;
//   int streamId;
//   String clientId;
//   String videoaspectratio;
//   String mediatype;
//   bool videomuted;
//   String reason;
//
//   ActiveListModel(this.name, this.streamId, this.clientId,
//       this.videoaspectratio, this.mediatype, this.videomuted, this.reason);
//
//   // convert Json to an exercise object
//   factory ActiveListModel.fromJson(Map<dynamic, dynamic> json) {
//     int sId = int.parse(json['streamId'].toString());
//     return ActiveListModel(
//       json['name'] as String,
//       sId,
// //      json['streamId'] as int,
//       json['clientId'] as String,
//       json['videoaspectratio'] as String,
//       json['mediatype'] as String,
//       json['videomuted'] as bool,
//       json['reason']==null?"":json['reason'] as String,
//     );
//   }
// }