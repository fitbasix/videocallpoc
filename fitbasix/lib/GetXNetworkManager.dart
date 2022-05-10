import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NetworkManager extends GetxController {
  //this variable 0 = No Internet, 1 = connected to WIFI ,2 = connected to Mobile Data.
  var connectionType = 0.obs;
  //Instance of Flutter Connectivity
  final Connectivity _connectivity = Connectivity();
  //Stream to keep listening to network change state
  late StreamSubscription _streamSubscription;

  @override
  void onInit() {
    print('vall');
    GetConnectionType();
    _streamSubscription =
        _connectivity.onConnectivityChanged.listen(_updateState);
    super.onInit();

  }

  // a method to get which connection result, if you we connected to internet or no if yes then which network
  Future<void> GetConnectionType() async {
    print('ppppp');
    var connectivityResult;
    try {
      connectivityResult = await (_connectivity.checkConnectivity());
    } on PlatformException catch (e) {}
    return _updateState(connectivityResult);
  }

  // state update, of network, if you are connected to WIFI connectionType will get set to 1,
  // and update the state to the consumer of that variable.
  _updateState(ConnectivityResult result) {

    switch (result) {
      case ConnectivityResult.wifi:
        connectionType.value = 1;
        update();
        print("connectionType ");
        break;
      case ConnectivityResult.mobile:
        connectionType.value = 2;
        print("connectionType ");
        update();
        break;
      case ConnectivityResult.none:
        connectionType.value = 0;
        print("connectionType ");
        Get.toNamed(RouteName.networkErrorScreen);
        update();
        break;
      default:
        Get.toNamed(RouteName.networkErrorScreen);
        print("connectionType ");
        break;
    }
  }

  @override
  void onClose() {
    //stop listening to network state when app is closed
    _streamSubscription.cancel();
  }
}

