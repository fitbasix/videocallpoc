

import 'package:get/get.dart';

import '../models/documents_model.dart';

class DocumentsController extends GetxController{
  Rx<DocumentsModel> allDocuments = DocumentsModel().obs;
  String? opponentName;
  var trainerID = ''.obs;
  Rx<bool> isAllDocumentsLoading = false.obs;
  RxList<AllDocuments> listOfDocuments = [AllDocuments()].obs;
  RxBool showLoader = false.obs;
  var isNeedToLoadData = true.obs;
  RxInt currentPage = RxInt(1);

  RxBool showLoaderOnDocs = false.obs;
  var isDocumentNeedToLoadData = true.obs;
  RxInt docCurrentPage = RxInt(1);

}