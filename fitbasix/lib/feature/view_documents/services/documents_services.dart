
import 'dart:developer';

import '../../../core/api_service/dio_service.dart';
import '../../../core/routes/api_routes.dart';
import '../../log_in/services/login_services.dart';
import '../../profile/models/user_document_model.dart';

class DocumentServices{
  static var dio = DioUtil().getInstance();

  static Future<DocumentsUsersModel> getUsersWithDocuments({int? skip}) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    // var token = await LogInService.getAccessToken();
    var response = await dio!.get(ApiUrl.getUserWithDocuments);
    log(response.toString());
    return documentsUsersModelFromJson(response.toString());
  }

}