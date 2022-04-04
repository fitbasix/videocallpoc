import 'dart:async';

import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/proceed_button_with_arrow.dart';
import 'package:fitbasix/feature/Home/view/Home_page.dart';
import 'package:fitbasix/feature/log_in/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';

import '../../help_and_support/view/privacy_policy_and_term_of_use/legal_screen.dart';

class GetStartedPage extends StatefulWidget {

  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {

  Uri? _latestUri;

  Uri? _initialUri;

  late StreamSubscription _sub;
  @override
  void initState() {
    _handleInitialUri();
    splashClose();
    super.initState();
  }
  Future<void> _handleInitialUri() async {
    _sub = uriLinkStream.listen(
          (Uri? uri) {
        if (!mounted) return;
        _latestUri = uri;
      },
      onError: (Object err) {
        if (!mounted) return;
        _latestUri = null;
      },
    );
    try {
      final uri = await getInitialUri();
      if (!mounted) return;
      _initialUri = uri;
    } on PlatformException {
      if (!mounted) return;
      _initialUri = null;
    } on FormatException catch (err) {
      debugPrint(err.toString());
      if (!mounted) return;
      _initialUri = null;
    }
    print(_latestUri.toString()+ " latest zzzz");
    print(_initialUri.toString()+" init zzzz");
    // if(_initialUri != null){
    //   print(_latestUri.toString()+ " latest nnnn");
    //   print(_initialUri.toString()+" init nnnn");
    //   Navigator.pushNamed(context, RouteName.legal);
    // }
    // if(_latestUri != null){
    //   print(_latestUri.toString()+ " latest nnnn");
    //   print(_initialUri.toString()+" init nnnn");
    //   Navigator.pushNamed(context, RouteName.legal);
    // }

  }

  splashClose() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString('AccessToken');
    Future.delayed(const Duration(milliseconds: 700), () async {
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                accessToken == null ? LoginScreen() : _initialUri!=null||_latestUri!=null?HomeAndTrainerPage():const LegalScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Image.asset(
          "assets/log_in/welcome_image.png",
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
