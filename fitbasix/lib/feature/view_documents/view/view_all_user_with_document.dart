import 'dart:developer';

import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/feature/view_documents/controller/documents_controller.dart';
import 'package:fitbasix/feature/view_documents/models/documents_model.dart';
import 'package:fitbasix/feature/view_documents/services/documents_services.dart';
import 'package:fitbasix/feature/view_documents/view/view_all_document_of_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/reponsive/SizeConfig.dart';
import '../../profile/view/appbar_for_account.dart';
import '../models/user_document_model.dart';

class ViewAllUsersWithDocuments extends StatefulWidget {
   ViewAllUsersWithDocuments({Key? key}) : super(key: key);

  @override
  State<ViewAllUsersWithDocuments> createState() => _ViewAllUsersWithDocumentsState();
}

class _ViewAllUsersWithDocumentsState extends State<ViewAllUsersWithDocuments> {
   DocumentsController _documentsController = Get.put(DocumentsController());

  Rx<DocumentsUsersModel> usersWithDocs = DocumentsUsersModel().obs;

  var isUsersLoading = true.obs;
   final ScrollController _scrollController = ScrollController();
   @override
   void dispose() {
     _scrollController.dispose();
     super.dispose();
   }


   @override
  void initState() {
     getAllDocuments();
     _documentsController.currentPage.value = 1;
     _scrollController.addListener(() async {
       print(_documentsController.isNeedToLoadData.value);
       if (_documentsController.isNeedToLoadData.value == true) {
         if (_scrollController.position.maxScrollExtent ==
             _scrollController.position.pixels) {
           _documentsController.showLoader.value = true;
           final postQuery = await DocumentServices.getUsersWithDocuments(
               skip: _documentsController.currentPage.value);

           if (postQuery.response!.data!.length < 10) {
             _documentsController.isNeedToLoadData.value = false;
             usersWithDocs.value.response!.data!.addAll(postQuery.response!.data!);
             _documentsController.showLoader.value = false;

             return;
           } else {
             log(usersWithDocs.value.response!.data.toString());
             if (usersWithDocs.value.response!.data!.last.id ==
                 postQuery.response!.data!.last.id) {
               _documentsController.showLoader.value = false;
               return;
             }

             usersWithDocs.value.response!.data!.addAll(postQuery.response!.data!);
             _documentsController.showLoader.value = false;
           }

           _documentsController.currentPage.value++;
           _documentsController.showLoader.value = false;
           setState(() {});
         }
       }
     });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarForAccount(
        title: 'Documents',
        onback: () {
          Navigator.pop(context);
        },
      ),
      body: Obx(
        ()=>isUsersLoading.value? Center(
          child: CustomizedCircularProgress(),
        ):usersWithDocs.value.response!.data!.isEmpty?Center(
          child: Text("No documents yet",style: AppTextStyle.normalPureBlackText.copyWith(color:Theme.of(context).textTheme.bodyText1!.color),),
        ):Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: usersWithDocs.value.response!.data!.length, itemBuilder: (BuildContext context, int index) {
                  return TraineeDocumentTile(
                    onTap: () async {
                      _documentsController.listOfDocuments.value = [AllDocuments()];
                      _documentsController.allDocuments.value = DocumentsModel();
                      _documentsController.trainerID.value = usersWithDocs.value.response!.data![index].id!;
                      Get.to(()=>ViewAllDocumentsOfUser());
                      _documentsController.opponentName = usersWithDocs.value.response!.data![index].name;
                          _documentsController.isAllDocumentsLoading.value = true;
                      _documentsController.allDocuments.value = await DocumentServices.getAllDocumentsOfUser(trainerId: _documentsController.trainerID.value);
                      _documentsController.listOfDocuments.value = _documentsController.allDocuments.value.response!.data!;
                      _documentsController.isAllDocumentsLoading.value = false;
                    },
                    networkImage: usersWithDocs.value.response!.data![index].profilePhoto,
                    traineesName: usersWithDocs.value.response!.data![index].name,
                    fileCount: usersWithDocs.value.response!.data![index].files,
                  );
              },

              ),
            ),
            Obx(()=>_documentsController.showLoader.value?CustomizedCircularProgress():Container())
          ],
        ),


      ),
    );
  }

  void getAllDocuments({int? skip}) async{
    usersWithDocs.value = await DocumentServices.getUsersWithDocuments(skip: skip);

    isUsersLoading.value = false;
    if (usersWithDocs.value.response!.data!.length <
        10) {
      _documentsController.isNeedToLoadData
          .value = false;
    }
  }
}

class TraineeDocumentTile extends StatelessWidget {
  TraineeDocumentTile(
      {this.networkImage,
      this.traineesName,
      Key? key,
      this.fileCount,
      this.onTap})
      : super(key: key);

  String? networkImage;
  String? traineesName;
  int? fileCount;
  GestureTapCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Get.width,
        margin: EdgeInsets.only(right: 16 * SizeConfig.widthMultiplier!),
        padding: EdgeInsets.only(
            left: 16 * SizeConfig.widthMultiplier!,
            top: 16 * SizeConfig.heightMultiplier!,
            bottom: 12 * SizeConfig.heightMultiplier!),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20 * SizeConfig.imageSizeMultiplier!,
              backgroundImage: NetworkImage(networkImage!),
            ),
            SizedBox(
              width: 12 * SizeConfig.widthMultiplier!,
            ),
            Expanded(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    traineesName!,
                    style: AppTextStyle.black600Text.copyWith(
                        color: Theme.of(context).textTheme.bodyText1!.color),
                  ),
                  SizedBox(
                    height: 8 * SizeConfig.heightMultiplier!,
                  ),
                  Row(
                    children: [
                      Text(
                        'Media, Documents, Links',
                        style: AppTextStyle.black400Text.copyWith(
                            fontSize: (12) * SizeConfig.textMultiplier!,
                            color:
                                Theme.of(context).textTheme.headline1!.color),
                      ),
                      Spacer(),
                      Text(
                        '$fileCount Files',
                        style: AppTextStyle.black400Text.copyWith(
                            fontSize: (12) * SizeConfig.textMultiplier!,
                            color:
                                Theme.of(context).textTheme.headline1!.color),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
