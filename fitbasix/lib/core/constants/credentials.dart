//
//
//
// import 'package:cometchat/Builders/app_settings_request.dart';
// import 'package:cometchat/cometchat_sdk.dart';
// import 'package:cometchat/utils/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// final DateFormat receiptFormatter = DateFormat('hh:mm a');
// const String appId = "2103351ac49960a9";
// const String authKey = "d05afcd1f1ee40dbe70c7de948569e3abccb0e1b";
// const String region = "eu";
// const String apiKey = "63623ba8055d5c2242d4012d26fba0174f1cfc8f";
//
// AppSettings appSettings= (AppSettingsBuilder()
//   ..subscriptionType = CometChatSubscriptionType.allUsers
//   ..region= region
//   ..autoEstablishSocketConnection =  true
// ).build();
//
// class CometChatService {
//
//   void init(){
//     CometChat.init(appId, appSettings,
//         onSuccess: (String successMessage) {
//           debugPrint("Initialization completed successfully  $successMessage");
//         }, onError: (CometChatException excep) {
//           debugPrint("Initialization failed with exception: ${excep.message}");
//         }
//     );
//   }
//
//   bool checkUserIfExisted(String uid){
//     CometChat.getUser(uid, onSuccess: (user){
//       print(user);
//       return true;
//     }, onError: (e){
//       return false;
//     });
//     return false;
//   }
//
//   void createUser(String uid, String name){
//     User user = User( uid: uid, name: name );//Replace with name and uid of user
//     CometChat.createUser(user,  authKey,
//         onSuccess: (User user){
//           debugPrint("Create User succesful ${user}");
//         }, onError: (CometChatException e){
//           debugPrint("Create User Failed with exception ${e.message}");
//         }
//     );
//   }
//
//   Future<bool> logInUser(String uid) async {
//     final user = await CometChat.getLoggedInUser();
//     if (user == null) {
//       CometChat.login(uid, authKey, onSuccess: (user){
//         return true;
//       }, onError: (e){
//         return false;
//       });
//     }
//     return true;
//   }
//
//   void logOutUserFromCometChat(){
//     CometChat.logout( onSuccess: ( successMessage) {
//       debugPrint("Logout successful with message $successMessage");
//     }, onError: (CometChatException e ){
//       debugPrint("Logout failed with exception:  ${e.message}");
//     }
//     );
//   }
//
//   Future<bool> checkIfUserLoggedIn() async {
//     final user = await CometChat.getLoggedInUser();
//     if(user == null){
//       return false;
//     }
//     else{
//       return true;
//     }
//   }
//
//
//
//
// }
