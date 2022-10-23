import 'dart:convert';

import 'package:dio/dio.dart';

class VideoCallService {
   Future<String> createRoom() async{
    Dio dio = Dio();
    var body = {
      "name": "Topic or Room Title",
      "owner_ref": "xyz",
      "settings": {
        "description": "Descriptive text",
        "mode": "group",
        "scheduled": false,
        "adhoc": false,
        "duration": 30,
        "moderators": "1",
        "participants": "5",
        "billing_code": "",
        "auto_recording": false,
        "quality": "SD",
        "canvas": false,
        "screen_share": false,
        "abwd": true,
        "max_active_talkers": 4,
        "knock": false,
        "wait_for_moderator": false,
        "single_file_recording": false,
        "role_based_recording": {
          "moderator": "audiovideo",
          "participant": "audio"
        },
        "live_recording": {
          "auto_recording": true,
          "url": "https://your-custom-view-url"
        }
      },
      "sip": {"enabled": false},
      "data": {"custom_key": ""}
    };
    String username = '';
    String password = 'Rase2ySyTeaaAyraPemaUymu9eEebygydyNu';
    String basicAuth =
        'Basic ' + base64.encode(utf8.encode('$username:$password'));

    var res = await dio.post('https://api.enablex.io/video/v2/rooms',
        options: Options(headers: <String, String>{'authorization': basicAuth}),
        data: body);
    return res.data['room']['room_id'];
  }
}
