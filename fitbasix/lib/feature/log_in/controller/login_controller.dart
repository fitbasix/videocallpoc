import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitbasix/core/sevices/remote_config_service.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  final googleSignIn = GoogleSignIn().obs;
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    final googleUser = await googleSignIn.value.signIn();
    if (googleUser == null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  void onInit() {
    RemoteConfigService.onForceFetched(RemoteConfigService.remoteConfig);
    //RemoteConfigService.fetchAndActivate();
    super.onInit();
  }
}
