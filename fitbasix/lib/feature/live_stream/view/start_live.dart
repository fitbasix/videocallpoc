// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:quickblox_sdk/quickblox_sdk.dart';
// import 'package:quickblox_sdk/conference/conference_video_view.dart';
// import 'package:quickblox_sdk/conference/constants.dart';
// import 'package:quickblox_sdk/models/qb_conference_rtc_session.dart';
// import 'package:quickblox_sdk/quickblox_sdk.dart';
//
//
// class StartLive extends StatefulWidget {
//   const StartLive({Key? key}) : super(key: key);
//
//   @override
//   State<StartLive> createState() => _StartLiveState();
// }
//
// class _StartLiveState extends State<StartLive> {
//   String? _sessionId;
//
//   ConferenceVideoViewController? _localVideoViewController;
//   ConferenceVideoViewController? _remoteVideoViewController;
//
//   StreamSubscription? _videoTrackSubscription;
//   StreamSubscription? _participantReceivedSubscription;
//   StreamSubscription? _participantLeftSubscription;
//   StreamSubscription? _errorSubscription;
//   StreamSubscription? _conferenceClosedSubscription;
//   StreamSubscription? _conferenceStateChangedSubscription;
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
//   Future<void> init() async {
//     try {
//       await QB.conference.init(JANUS_SERVER_URL);
//
//     } on PlatformException catch (e) {
//
//     }
//   }
//
//   Future<void> release() async {
//     try {
//       await QB.conference.release();
//
//       _sessionId = null;
//         } on PlatformException catch (e) {
//
//     }
//   }
//
//   Future<void> releaseVideoViews() async {
//     try {
//       await _localVideoViewController!.release();
//       await _remoteVideoViewController!.release();
//
//         } on PlatformException catch (e) {
//
//     }
//   }
//
//   Future<void> create(int sessionType) async {
//     try {
//       QBConferenceRTCSession? session =
//       await QB.conference.create(DIALOG_ID, sessionType);
//
//       _sessionId = session!.id;
//
//     } on PlatformException catch (e) {
//     }
//   }
//
//   Future<void> joinAsPublisher(int sessionType) async {
//     try {
//       List<int?> participants =
//       await QB.conference.joinAsPublisher(_sessionId!);
//
//       for (int i = 0; i < participants.length; i++) {
//         int userId = participants[i]!;
//         subscribeToParticipant(_sessionId!, userId);
//       }
//
//     } on PlatformException catch (e) {
//     }
//   }
//
//   Future<void> getOnlineParticipants() async {
//     try {
//       List<int?> participants =
//       await QB.conference.getOnlineParticipants(_sessionId!);
//
//     } on PlatformException catch (e) {
//     }
//   }
//
//   Future<void> subscribeToParticipant(String sessionId, int userId) async {
//     try {
//       await QB.conference.subscribeToParticipant(sessionId, userId);
//     } on PlatformException catch (e) {
//     }
//   }
//
//   Future<void> unsubscribeFromParticipant(String sessionId, int userId) async {
//     try {
//       await QB.conference.unsubscribeFromParticipant(sessionId, userId);
//     } on PlatformException catch (e) {
//     }
//   }
//
//   Future<void> leaveSession() async {
//     try {
//       await QB.conference.leave(_sessionId!);
//     } on PlatformException catch (e) {
//     }
//   }
//
//   Future<void> enableVideo(bool enable) async {
//     try {
//       await QB.conference.enableVideo(_sessionId!, enable: enable);
//     } on PlatformException catch (e) {
//     }
//   }
//
//   Future<void> enableAudio(bool enable) async {
//     try {
//       await QB.conference.enableAudio(_sessionId!, enable: enable);
//     } on PlatformException catch (e) {
//     }
//   }
//
//   Future<void> switchCamera() async {
//     try {
//       await QB.conference.switchCamera(_sessionId!);
//     } on PlatformException catch (e) {
//     }
//   }
//
//   Future<void> switchAudioOutput(int output) async {
//     try {
//       await QB.conference.switchAudioOutput(output);
//     } on PlatformException catch (e) {
//     }
//   }
//
//   Future<void> startRenderingLocal() async {
//     try {
//       await _localVideoViewController!.play(_sessionId!, LOGGED_USER_ID);
//     } on PlatformException catch (e) {
//     }
//   }
//
//   Future<void> startRenderingRemote(int opponentId) async {
//     try {
//       await _remoteVideoViewController!.play(_sessionId!, opponentId);
//     } on PlatformException catch (e) {
//     }
//   }
//
//   Future<void> subscribeVideoTrack() async {
//     if (_videoTrackSubscription != null) {
//
//       return;
//     }
//
//     try {
//       _videoTrackSubscription = await QB.conference.subscribeConferenceEvent(
//           QBConferenceEventTypes.CONFERENCE_VIDEO_TRACK_RECEIVED, (data) {
//         Map<dynamic, dynamic> payloadMap =
//         Map<dynamic, dynamic>.from(data["payload"]);
//
//         int opponentId = payloadMap["userId"];
//
//         if (opponentId == LOGGED_USER_ID) {
//           startRenderingLocal();
//         } else {
//           startRenderingRemote(opponentId);
//         }
//
//
//       }, onErrorMethod: (error) {
//
//       });
//
//     } on PlatformException catch (e) {
//
//     }
//   }
//
//   void unsubscribeVideoTrack() {
//     if (_videoTrackSubscription != null) {
//       _videoTrackSubscription!.cancel();
//       _videoTrackSubscription = null;
//
//     }
//   }
//
//   void subscribeParticipantReceived() async {
//     if (_participantReceivedSubscription != null) {
//       return;
//     }
//
//     try {
//       _participantReceivedSubscription = await QB.conference
//           .subscribeConferenceEvent(
//           QBConferenceEventTypes.CONFERENCE_PARTICIPANT_RECEIVED, (data) {
//         int userId = data["payload"]["userId"];
//         String sessionId = data["payload"]["sessionId"];
//
//
//
//         subscribeToParticipant(sessionId, userId);
//       }, onErrorMethod: (error) {
//
//       });
//
//     } on PlatformException catch (e) {
//
//     }
//   }
//
//   void unsubscribeParticipantReceived() {
//     if (_participantReceivedSubscription != null) {
//       _participantReceivedSubscription!.cancel();
//       _participantReceivedSubscription = null;
//
//     }
//   }
//
//
//   void subscribeParticipantLeft() async {
//     if (_participantLeftSubscription != null) {
//
//       return;
//     }
//
//     try {
//       _participantLeftSubscription = await QB.conference
//           .subscribeConferenceEvent(
//           QBConferenceEventTypes.CONFERENCE_PARTICIPANT_LEFT, (data) {
//         String sessionId = data["payload"]["sessionId"];
//         int userId = data["payload"]["userId"];
//
//
//         unsubscribeFromParticipant(sessionId, userId);
//       }, onErrorMethod: (error) {
//
//       });
//
//     } on PlatformException catch (e) {
//     }
//   }
//
//   void unsubscribeParticipantLeft() {
//     if (_participantLeftSubscription != null) {
//       _participantLeftSubscription!.cancel();
//       _participantLeftSubscription = null;
//     }
//   }
//
//   void subscribeErrors() async {
//     if (_errorSubscription != null) {
//       return;
//     }
//
//     try {
//       _errorSubscription = await QB.conference.subscribeConferenceEvent(
//           QBConferenceEventTypes.CONFERENCE_ERROR_RECEIVED, (data) {
//         String errorMessage = data["payload"]["errorMessage"];
//         String sessionId = data["payload"]["sessionId"];
//
//       }, onErrorMethod: (error) {
//       });
//     } on PlatformException catch (e) {
//     }
//   }
//
//   void unsubscribeErrors() {
//     if (_errorSubscription != null) {
//       _errorSubscription!.cancel();
//       _errorSubscription = null;
//     }
//   }
//
//   void subscribeConferenceClosed() async {
//     if (_conferenceClosedSubscription != null) {
//       return;
//     }
//
//     try {
//       _conferenceClosedSubscription = await QB.conference
//           .subscribeConferenceEvent(QBConferenceEventTypes.CONFERENCE_CLOSED,
//               (data) {
//             String sessionId = data["payload"]["sessionId"];
//
//           }, onErrorMethod: (error) {
//           });
//     } on PlatformException catch (e) {
//     }
//   }
//
//   void unsubscribeConferenceClosed() {
//     if (_conferenceClosedSubscription != null) {
//       _conferenceClosedSubscription!.cancel();
//       _conferenceClosedSubscription = null;
//     }
//   }
//
//   void subscribeConferenceStateChanged() async {
//     if (_conferenceStateChangedSubscription != null) {
//       return;
//     }
//
//     try {
//       _conferenceStateChangedSubscription = await QB.conference
//           .subscribeConferenceEvent(
//           QBConferenceEventTypes.CONFERENCE_STATE_CHANGED, (data) {
//         int state = data["payload"]["state"];
//         String sessionId = data["payload"]["sessionId"];
//
//         String parsedState = "";
//
//         switch (state) {
//           case 0:
//             parsedState = "NEW";
//             break;
//           case 1:
//             parsedState = "PENDING";
//             break;
//           case 2:
//             parsedState = "CONNECTING";
//             break;
//           case 3:
//             parsedState = "CONNECTED";
//             break;
//           case 4:
//             parsedState = "CLOSED";
//             break;
//         }
//
//       }, onErrorMethod: (error) {
//       });
//     } on PlatformException catch (e) {
//     }
//   }
//
//   void unsubscribeConferenceStateChanged() {
//     if (_conferenceStateChangedSubscription != null) {
//       _conferenceStateChangedSubscription!.cancel();
//       _conferenceStateChangedSubscription = null;
//     }
//   }
// }
