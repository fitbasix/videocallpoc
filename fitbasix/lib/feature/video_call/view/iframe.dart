import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

class IFrameScreen extends StatefulWidget {
  final String Id;
  const IFrameScreen({required this.Id});

  @override
  State<IFrameScreen> createState() => _IFrameScreenState();
}

class _IFrameScreenState extends State<IFrameScreen> {
  String  _lowCodeUrl = "https://fitbasixapp.yourvideo.live/";
  @override
  void initState() {
    _lowCodeUrl=_lowCodeUrl+widget.Id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(children: <Widget>[
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
