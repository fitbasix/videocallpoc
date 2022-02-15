import 'package:flutter/services.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';


const String APP_ID = "95622";
const String AUTH_KEY = "JeSeKeyEkEMBFps";
const String AUTH_SECRET = "bY-YdQQPDvuZZWa";
const String ACCOUNT_KEY = "RxbHctz7wFyZ8sWW67rY";
const String API_ENDPOINT = "";
const String CHAT_ENDPOINT = "";


class InitializeQuickBlox{

  Future<void> init() async {
    try {
      await QB.settings.init(APP_ID, AUTH_KEY, AUTH_SECRET, ACCOUNT_KEY,
          apiEndpoint: API_ENDPOINT, chatEndpoint: CHAT_ENDPOINT);

    } on PlatformException catch (e) {
      print("error $e");
      // DialogUtils.showError(context!, e);
    }
  }
}