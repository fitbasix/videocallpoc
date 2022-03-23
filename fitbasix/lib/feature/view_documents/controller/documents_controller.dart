

import 'package:get/get.dart';

import '../models/documents_model.dart';

class DocumentsController extends GetxController{
  Rx<DocumentsModel> allDocuments = DocumentsModel().obs;
  Rx<bool> isAllDocumentsLoading = false.obs;
  RxList<AllDocuments> listOfDocuments = [AllDocuments()].obs;
}