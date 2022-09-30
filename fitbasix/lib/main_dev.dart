import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitbasix/GetXNetworkManager.dart';
import 'package:fitbasix/NetworkManager.dart';
import 'package:fitbasix/core/constants/credentials.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/Home/view/post_screen.dart';
import 'package:fitbasix/feature/chat_firebase/controller/firebase_chat_controller.dart';
import 'package:fitbasix/feature/chat_firebase/view/chat_page.dart';
import 'package:fitbasix/feature/get_trained/controller/trainer_controller.dart';
import 'package:fitbasix/feature/message/controller/chat_controller.dart';
import 'package:fitbasix/feature/message/view/screens/message_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fitbasix/setup-my-app.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import 'app_config.dart';
import 'feature/Home/services/home_service.dart';
import 'feature/Home/view/widgets/full_post_tile.dart';
import 'feature/log_in/services/login_services.dart';

initializeNotification() {
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            importance: NotificationImportance.Max,
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);
}

void selectNotification(String? payload) async {
  if (payload != null) {
    debugPrint('notification payload: $payload');
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            importance: NotificationImportance.Max,
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);

  var jsonResponse =
      jsonDecode(jsonEncode(message.data).toString()) as Map<String, dynamic>;
}

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    // CometChatService().init();

    final temp = Get.put(NetworkManager());

    await dotenv.load(fileName: ".env");
    await initializeNotification();
    await Firebase.initializeApp();
    if (Platform.isIOS) {
      FirebaseMessaging.instance.requestPermission();
    }
    final env = dotenv.env['ENV'];
    if (env != null) {
      if (env == 'prod')
        AppConfig.buildFlavour = Flavor.PRODUCTION;
      else if (env == 'stag')
        AppConfig.buildFlavour = Flavor.STAGING;
      else
        AppConfig.buildFlavour = Flavor.DEVELOPMENT;
    }

    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, dynamic> deviceData = <String, dynamic>{};
    AndroidDeviceInfo? androidInfo;
    IosDeviceInfo? iosInfo;
    if (Platform.isAndroid == true) {
      androidInfo = await deviceInfoPlugin.androidInfo;
      print(Platform.operatingSystemVersion + " os version");

      //String osVersion = Platform.operatingSystem
    } else {
      iosInfo = await deviceInfoPlugin.iosInfo;
    }
    String deviceId = Platform.isAndroid
        ? androidInfo!.androidId
        : iosInfo!.identifierForVendor;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString('AccessToken');

    Get.put(FirebaseChatController());

    var token = await FirebaseMessaging.instance.getToken();
    if (accessToken != null) {
      LogInService.RegisterDeviceToken(token.toString(), deviceId);
      print("fcm token" + token.toString());
    }

    FirebaseMessaging.instance.getAPNSToken().then((value) {
      print(value.toString() + " APN Token");
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    AwesomeNotifications()
        .actionStream
        .listen((ReceivedNotification notification) async {
      var json = jsonDecode(notification.payload!['data'].toString())
          as Map<String, dynamic>;

      log(json.toString());

      var chatId = json['senderChatId'];
      var userId = json['senderId'];
      var userName = json['senderName'];
      var userImage = json['senderProfilePhoto'];
      var postId = json['postId'];

      if (postId != '') {
        await sendToPost(postId: postId);
      } else {
        var controller = Get.find<FirebaseChatController>();
        controller.getValues();
        controller.receiverId = userId;
        controller.senderPhoto = userImage;
        controller.senderName = userName!;
        Get.to(
          () => ChatPage(),
        );
      }
    });

    FirebaseMessaging.onMessage.listen((message) async {
      print("Nitesh: " + message.data.toString());
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var chatId = prefs.getString('chatId') ?? "";
      print(chatId);
      if (Platform.isIOS) {
          print("nope");
        }
      print(message.data["receiverChatId"] + " - - - " + chatId);
      if (message.data["receiverChatId"] != chatId) {
        print(message.data["receiverChatId"] + " - - - " + chatId);
        
        AwesomeNotifications().createNotification(
          content: NotificationContent(
              displayOnForeground: true,
              displayOnBackground: true,
              channelKey: 'basic_channel',
              id: 10,
              title: message.notification!.title.toString(),
              wakeUpScreen: true,
              category: NotificationCategory.Reminder,
              autoDismissible: false,
              payload: {'data': jsonEncode(message.data)},
              body: message.notification!.body.toString()),
        );
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((initialMessage) async {
      if (initialMessage != null) {
        var json = jsonDecode(jsonEncode(initialMessage.data).toString())
            as Map<String, dynamic>;
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();

        if (json['postId'] != '') {
          sharedPreferences.setString('isChat', json['isChat']);
          sharedPreferences.setString('postId', json['postId']);
        } else {
          sharedPreferences.setString('senderChatId', json['senderChatId']);
          sharedPreferences.setString('senderId', json['senderId']);
          sharedPreferences.setString('senderName', json['senderName']);
          sharedPreferences.setString(
              'senderProfilePhoto', json['senderProfilePhoto']);
        }
      } else {
        prefs.remove('senderChatId');
        prefs.remove('senderId');
        prefs.remove('senderName');
        prefs.remove('senderProfilePhoto');
        prefs.remove('postId');
        prefs.remove('isChat');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      var json = jsonDecode(jsonEncode(message.data).toString())
          as Map<String, dynamic>;
      var isChat = json['isChat'];
      var postId = json['postId'];

      if (postId != '') {
        await sendToPost(postId: postId);
      } else {
        await sendToMessageList(
          json['senderChatId'],
          json['senderId'],
          json['senderName'],
          json['senderProfilePhoto'],
        );
      }
    });

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    setupApp();

    //await AndroidAlarmManager.oneShotAt(date, 0, printHello);
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

Future<void> sendToPost({required String postId}) async {
  var homeController = Get.put(HomeController());
  homeController.commentsList.clear();
  homeController.viewReplies!.clear();
  homeController.postLoading.value = true;
  Get.to(PostScreen());
  var post = await HomeService.getPostById(postId);
  homeController.post.value = post.response!.data!;
  homeController.postLoading.value = false;
  homeController.commentsLoading.value = true;
  homeController.postComments.value =
      await HomeService.fetchComment(postId: postId);

  if (homeController.postComments.value.response!.data!.isNotEmpty) {
    homeController.commentsList.value =
        homeController.postComments.value.response!.data!;
  }
  homeController.commentsLoading.value = false;
}

Future<void> sendToMessageList(
  String chatId,
  String userId,
  String userName,
  String userImage,
) async {
  var controller = Get.find<FirebaseChatController>();
  controller.getValues();
  controller.receiverId = userId;
  controller.senderPhoto = userImage;
  controller.senderName = userName!;
  Get.to(
    () => ChatPage(),
  );
}

Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
  return <String, dynamic>{
    'version.securityPatch': build.version.securityPatch,
    'version.sdkInt': build.version.sdkInt,
    'version.release': build.version.release,
    'version.previewSdkInt': build.version.previewSdkInt,
    'version.incremental': build.version.incremental,
    'version.codename': build.version.codename,
    'version.baseOS': build.version.baseOS,
    'board': build.board,
    'bootloader': build.bootloader,
    'brand': build.brand,
    'device': build.device,
    'display': build.display,
    'fingerprint': build.fingerprint,
    'hardware': build.hardware,
    'host': build.host,
    'id': build.id,
    'manufacturer': build.manufacturer,
    'model': build.model,
    'product': build.product,
    'supported32BitAbis': build.supported32BitAbis,
    'supported64BitAbis': build.supported64BitAbis,
    'supportedAbis': build.supportedAbis,
    'tags': build.tags,
    'type': build.type,
    'isPhysicalDevice': build.isPhysicalDevice,
    'androidId': build.androidId,
    'systemFeatures': build.systemFeatures,
  };
}

void registerFcmToken() async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> deviceData = <String, dynamic>{};
  AndroidDeviceInfo? androidInfo;
  IosDeviceInfo? iosInfo;
  if (Platform.isAndroid == true) {
    androidInfo = await deviceInfoPlugin.androidInfo;
  } else {
    iosInfo = await deviceInfoPlugin.iosInfo;
  }
  String deviceId = Platform.isAndroid
      ? androidInfo!.androidId
      : iosInfo!.identifierForVendor;
  // log(response.androidId + "   " + response.device);
  //deviceData = _readAndroidBuildData(response);
  log('Running on ${deviceData['device']}');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var accessToken = prefs.getString('AccessToken');
  var token = await FirebaseMessaging.instance.getToken();
  if (accessToken != null) {
    LogInService.RegisterDeviceToken(token.toString(), deviceId);
    print("fcm token" + token.toString());
  }
}
