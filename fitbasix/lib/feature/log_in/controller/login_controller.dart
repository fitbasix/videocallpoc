import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitbasix/feature/log_in/model/countries_model.dart';
import 'package:fitbasix/feature/log_in/model/logInRegisterModel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/api_service/remote_config_service.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fitbasix/feature/log_in/model/logInRegisterModel.dart';

class LoginController extends GetxController {
  final googleSignIn = GoogleSignIn().obs;
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
  RxList<Datum> countryList = <Datum>[].obs;
  Rx<Countries> countries = Countries().obs;
  Rx<Datum> selectedCountry = Rx(Datum());

  Future googleLogin() async {
    final googleUser = await googleSignIn.value.signIn();
    if (googleUser == null) return;
    _user.value = googleUser;
    print("Server Auth Code- " + googleUser.serverAuthCode.toString());
    final googleAuth = await googleUser.authentication;

    print("Access Token- " + googleAuth.accessToken.toString());
    print("idToken- " + googleAuth.idToken.toString());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('AccessToken', googleAuth.accessToken.toString());

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future googleSignout() async {
    _user.value = await googleSignIn.value.signOut();
  }

  Future<void> getOTP() async {
    userDetail.value = await LogInService.getOTP(mobile.value);
  }

  Future<void> getCountries() async {
    countries.value = await LogInService.getCountries();

    //print(countries.value.response!.country![0].countryCode);

    if (countries != null) {
      countryList.value = countries.value.response!.data!;
    }

    print(countries.value.response!.data![0].countryCode);
    print(countryList.value.length);

    // print(countryList.);
  }

  // Future<void> verifyOTP() async {
  //   await LogInService.verifyOTP(otp.value, userDetail.value);
  // }

  Future<void> logInRegisterUser(
      String regType,
      String email,
      String phnNumber,
      String countryCode,
      String accessToken,
      String serverAuthCode,
      String idToken) async {
    LogInRegisterResponse.value = await LogInService.logInRegisterUser(
        regType,
        "USER",
        email,
        phnNumber,
        countryCode,
        accessToken,
        serverAuthCode,
        idToken);
  }

  @override
  Future<void> onInit() async {
    RemoteConfigService.onForceFetched(RemoteConfigService.remoteConfig);
    //RemoteConfigService.fetchAndActivate();
    await getCountries();
    super.onInit();
  }
}
