import 'dart:io';

import 'package:fitbasix/feature/profile/view/appbar_for_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

// var _lowCodeUrl =
//     "https://fitbasixapp.yourvideo.live/host/NjI4MjI2Zjg5MTEyYzAxM2FlZGQxNzdjLTYyODIyNjY1ZjVkMmFmNGI5YTIxNGQxMw==";

// class WebCall extends StatelessWidget {
//   const WebCall({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     if (Platform.isAndroid) {
//       _lowCodeUrl += '?skipMediaPermissionPrompt';
//     }
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: InAppWebViewPage(),
//     );
//   }
// }

class InAppWebViewPage extends StatefulWidget {
  String url;
  InAppWebViewPage({required this.url});

  @override
  State<InAppWebViewPage> createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  @override
  void initState() {
    super.initState();
    getCameraAndOtherPermissions();
  }

  void getCameraAndOtherPermissions() async {
    if (await Permission.camera.request().isGranted) {}
    if (await Permission.microphone.request().isGranted) {}
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      widget.url += '?skipMediaPermissionPrompt';
    }
    return Scaffold(
        appBar: AppBarForAccount(
          onback: () {
            Navigator.pop(context);
          },
          title: 'message'.tr,
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
              initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    mediaPlaybackRequiresUserGesture: false,
                  ),
                  ios: IOSInAppWebViewOptions(
                    allowsInlineMediaPlayback: true,
                  )),
              androidOnPermissionRequest: (InAppWebViewController controller,
                  String origin, List<String> resources) async {
                await Permission.camera.request();
                await Permission.microphone.request();
                return PermissionRequestResponse(
                    resources: resources,
                    action: PermissionRequestResponseAction.GRANT);
              },
            ),
          ),
        ]));
  }
}
