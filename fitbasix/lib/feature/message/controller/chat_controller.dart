import 'package:get/get.dart';

class ChatController extends GetxController {


  RxMap<String,String> filePathWithRespectToFileName = RxMap<String,String>({});

  RxMap<String,String> urlWithRespectToTaskId = RxMap<String,String>({});

  RxBool storagePermissionCalled = false.obs;
  String USERID = '';

}