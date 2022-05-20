import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

var _lowCodeUrl =
    "https://fitbasixapp.yourvideo.live/host/NjI4MjI2Zjg5MTEyYzAxM2FlZGQxNzdjLTYyODIyNjY1ZjVkMmFmNGI5YTIxNGQxMw==";

class WebCall extends StatelessWidget {
  const WebCall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      _lowCodeUrl += '?skipMediaPermissionPrompt';
    }
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InAppWebViewPage(),
    );
  }
}

class InAppWebViewPage extends StatefulWidget {
  const InAppWebViewPage();

  @override
  State<InAppWebViewPage> createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Meeting")),
        body: Column(children: <Widget>[
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(_lowCodeUrl)),
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
