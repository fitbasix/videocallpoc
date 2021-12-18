import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/api_service/remote_config_service.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  final googleSignIn = GoogleSignIn().obs;
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;
  RxString mobile = RxString('');
  RxString otp = RxString('');
  RxString userDetail = RxString('');
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController reEnterPasswordController =
      TextEditingController();
  final TextEditingController passwordForLoginController =
      TextEditingController();
  final TextEditingController resetPasswordController = TextEditingController();
  final TextEditingController resetConfirmPasswordController =
      TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  RxString name = "".obs;
  RxString email = "".obs;
  RxString password = "".obs;
  RxString confirmPassword = "".obs;
  RxString mobileNumber = "".obs;
  RxBool isHidePassword = false.obs;

  Future googleLogin() async {
    final googleUser = await googleSignIn.value.signIn();
    if (googleUser == null) return;
    _user = googleUser;
    print("Server Auth Code- " + googleUser.serverAuthCode.toString());
    final googleAuth = await googleUser.authentication;

    print("Access Token- " + googleAuth.accessToken.toString());
    print("idToken- " + googleAuth.idToken.toString());

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> getOTP() async {
    userDetail.value = await LogInService.getOTP(mobile.value);
  }

  Future<void> verifyOTP() async {
    await LogInService.verifyOTP(otp.value, userDetail.value);
  }

  @override
  void onInit() {
    RemoteConfigService.onForceFetched(RemoteConfigService.remoteConfig);
    //RemoteConfigService.fetchAndActivate();
    super.onInit();
  }
}
