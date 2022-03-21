import 'package:fitbasix/feature/view_documents/services/documents_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/reponsive/SizeConfig.dart';
import '../../profile/models/user_document_model.dart';
import '../../profile/view/appbar_for_account.dart';

class ViewAllUsersWithDocuments extends StatelessWidget {
   ViewAllUsersWithDocuments({Key? key}) : super(key: key);
  Rx<DocumentsUsersModel> usersWithDocs = DocumentsUsersModel().obs;

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
        ()=>usersWithDocs.value.response == null? Column(
          children: [
            TraineeDocumentTile(
              networkImage: 'https://image.pngaaa.com/721/1466721-middle.png',
              traineesName: 'Floyd Miles',
            ),
          ],
        ):ListView.builder(
          itemCount: usersWithDocs.value.response!.data!.length, itemBuilder: (BuildContext context, int index) {
            return TraineeDocumentTile(
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
  }
}
class TraineeDocumentTile extends StatelessWidget {
  TraineeDocumentTile({this.networkImage, this.traineesName, Key? key,this.fileCount})
      : super(key: key);

  String? networkImage;
  String? traineesName;
  int? fileCount;
  @override
  Widget build(BuildContext context) {
    return  Container(
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
    );
  }
}