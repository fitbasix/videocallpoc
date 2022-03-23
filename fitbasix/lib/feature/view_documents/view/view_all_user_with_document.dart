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

class ViewAllUsersWithDocuments extends StatelessWidget {
   ViewAllUsersWithDocuments({Key? key}) : super(key: key);
   DocumentsController _documentsController = Get.put(DocumentsController());
  Rx<DocumentsUsersModel> usersWithDocs = DocumentsUsersModel().obs;
  var isUsersLoading = true.obs;

  @override
  Widget build(BuildContext context) {

    getAllDocuments();
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
        ):ListView.builder(
          itemCount: usersWithDocs.value.response!.data!.length, itemBuilder: (BuildContext context, int index) {
            return TraineeDocumentTile(
              onTap: () async {
                _documentsController.listOfDocuments.value = [AllDocuments()];
                Get.to(()=>ViewAllDocumentsOfUser());
                _documentsController.isAllDocumentsLoading.value = true;
                _documentsController.allDocuments.value = await DocumentServices.getAllDocumentsOfUser(trainerId: usersWithDocs.value.response!.data![index].id!);
                _documentsController.listOfDocuments.value = _documentsController.allDocuments.value.response!.data!;
                _documentsController.isAllDocumentsLoading.value = false;
              },
              networkImage: usersWithDocs.value.response!.data![index].profilePhoto,
              traineesName: usersWithDocs.value.response!.data![index].name,
              fileCount: usersWithDocs.value.response!.data![index].files,
            );
        },

        )
      ),

    );
  }

  void getAllDocuments() async{
    usersWithDocs.value = await DocumentServices.getUsersWithDocuments();
    isUsersLoading.value = false;
  }
}
class TraineeDocumentTile extends StatelessWidget {
  TraineeDocumentTile({this.networkImage, this.traineesName, Key? key,this.fileCount,this.onTap})
      : super(key: key);

  String? networkImage;
  String? traineesName;
  int? fileCount;
  GestureTapCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onTap,
      child: Container(
        width: Get.width,
        margin: EdgeInsets.only(right: 16*SizeConfig.widthMultiplier!),
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