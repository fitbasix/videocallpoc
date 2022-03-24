
import 'dart:developer';

import '../../../core/api_service/dio_service.dart';
import '../../../core/routes/api_routes.dart';
import '../../log_in/services/login_services.dart';
import '../models/documents_model.dart';
import '../models/user_document_model.dart';

class DocumentServices{
  static var dio = DioUtil().getInstance();

  static Future<DocumentsUsersModel> getUsersWithDocuments() async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    // var token = await LogInService.getAccessToken();
    var response = await dio!.get(ApiUrl.getUserWithDocuments);
    log(response.toString());
    return documentsUsersModelFromJson(response.toString());
  }

  static Future<DocumentsModel> getAllDocumentsOfUser({String? trainerId}) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    dio!.options.headers['Content-Type'] = 'application/json';
    // var token = await LogInService.getAccessToken();
    var response = await dio!.post(ApiUrl.getUserAllDocuments,data: {
      "trainer":trainerId
    });
    log(response.toString());
    return documentsModelFromJson(response.toString());
  }

}