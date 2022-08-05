import 'package:fitbasix/core/api_service/dio_service.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';
import 'package:get/get.dart';

import '../../../core/routes/api_routes.dart';

class MessageService {
  static var dio = DioUtil().getInstance();

  static Future<void> sendMessageNotification(
      {required String receiverId,
      required String senderId,
      required String message}) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();

    var response = await dio!.post(
      ApiUrl.sendChatNotification,
      data: {
        "data": {
          "receiver": "chat_${receiverId}",
          "sender": "chat_${senderId}",
          "type": 'text',
          "data": message
        }
      },
    );
  }
}
