import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitbasix/feature/log_in/model/third_party_login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:fitbasix/feature/log_in/model/countries_model.dart';
import 'package:fitbasix/feature/log_in/model/logInRegisterModel.dart';
import 'package:fitbasix/feature/log_in/model/third_party_model.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';


class LoginController extends GetxController {
  final googleSignIn = GoogleSignIn().obs;
  Rx<bool> isGoogleSignInLoading = false.obs;
  //GoogleSignInAccount? _user;
  var _user = Rx<GoogleSignInAccount?>(null);
  //GoogleSignInAccount get user => _user!;
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
  Rx<LogInRegisterModel> LogInRegisterResponse = LogInRegisterModel().obs;
  RxString name = "".obs;
  RxString email = "".obs;
  RxString password = "".obs;
  RxString confirmPassword = "".obs;
  RxString mobileNumber = "".obs;
  RxBool isHidePassword = false.obs;
  RxBool isLoading = false.obs;
  RxList<CountryData> countryList = <CountryData>[].obs;
  Rx<Countries> countries = Countries().obs;
  Rx<CountryData> selectedCountry = Rx(CountryData(
      id: "61c2f699b5c8afaf1e15a670",
      name: "India",
      code: "+91",
      flag: "https://upload.wikimedia.org/wikipedia/en/4/41/Flag_of_India.svg",
      v: 0,
      createdAt: DateTime.parse("2021-12-22T09:57:45.915Z"),
      updatedAt: DateTime.parse("2021-12-22T09:57:45.915Z")));
  RxString idToken = "".obs;
  RxString accessToken = "".obs;
  RxString token = RxString('');
  RxString otpErrorMessage = RxString('');
  Rx<ThirdPartyLogin> ApplethirdPartyModel = Rx(ThirdPartyLogin());
  Rx<ThirdPartyLogin> thirdPartyLogin = Rx(ThirdPartyLogin());

  Future googleLogin() async {
    final googleUser = await googleSignIn.value.signIn();
    if (googleUser == null) return;
    _user.value = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    idToken.value = googleAuth.idToken.toString();
    accessToken.value = googleAuth.accessToken.toString();
  }

  Future googleSignout() async {
    _user.value = await googleSignIn.value.signOut();
  }

  Future<void> getOTP() async {
    await LogInService.getOTP(mobile.value, selectedCountry.value.code!);
  }

  Future<void> getCountries() async {
    countries.value = await LogInService.getCountries();

    if (countries != null) {
      countryList.value = countries.value.response!.data!;
    }
  }

  @override
  Future<void> onInit() async {
    await getCountries();
    await _initData();
    super.onInit();
  }

  Future<void> _initData() async {
    try {
      var _timezone = await FlutterNativeTimezone.getLocalTimezone();
      print(' =====================>  $_timezone');
      if (_timezone == 'Asia/Kolkata' ||
          _timezone == 'Asia/Calcutta' ||
          _timezone == 'Asia/Chennai' ||
          _timezone == 'Asia/Delhi' ||
          _timezone == 'Asia/New Delhi') {
        selectedCountry.value = countryList[1];
      } else {
        selectedCountry.value = countryList[0];
      }
      update();
    } catch (e) {
      print('Could not get the local timezone');
    }
  }
}
