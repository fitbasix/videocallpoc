import 'dart:io';

import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/feature/profile/view/appbar_for_account.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickblox_sdk/models/qb_message.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/image_path.dart';



class DocumentsViewerScreen extends StatefulWidget {
  String? opponentName;
  List<QBMessage?>? messages;

  DocumentsViewerScreen({Key? key,this.messages,this.opponentName}) : super(key: key);

  @override
  _DocumentsViewerScreenState createState() => _DocumentsViewerScreenState();
}

class _DocumentsViewerScreenState extends State<DocumentsViewerScreen> {
  List<QBMessage?>? messageWithAttachment;
  @override
  Widget build(BuildContext context) {
    getAllMessageWithAttachments();
    return Scaffold(
      backgroundColor: kPureBlack,
      appBar: AppBarForAccount(
       onback: (){Navigator.pop(context);},
        title: widget.opponentName!.trim(),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Container(
              margin: EdgeInsets.symmetric(horizontal: 16*SizeConfig.widthMultiplier!,vertical: 14*SizeConfig.heightMultiplier!),
              child: Text("Documents",style: AppTextStyle.hblack600Text.copyWith(color: Colors.white,height: 1),)),
          SizedBox(height: 12*SizeConfig.heightMultiplier!,),

          ListView.builder(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: messageWithAttachment!.length,
              itemBuilder: (context, index){
            return Container(
              margin: EdgeInsets.only(bottom: 16*SizeConfig.heightMultiplier!,left: 29*SizeConfig.widthMultiplier!),
              child: DocumentTiles(documentName: messageWithAttachment![index]!.attachments![0]!.name!,date: messageWithAttachment![index]!.dateSent!,),
            );
          }),

        ],

      ),
    );
  }

  void getAllMessageWithAttachments() {
    messageWithAttachment= List.from(widget.messages!.where((element) => element!.attachments != null));
    messageWithAttachment!.forEach((element) {
    });
  }
}

class DocumentTiles extends StatelessWidget {
  String documentName;
  int date;
  var filePath = "".obs;
  String? fileExtension;
  var documentDate = "".obs;
  DocumentTiles({Key? key,required this.documentName,required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    checkFileExistence(documentName);
    setDocumentDate();
    fileExtension = documentName.split(".").last.toUpperCase();
    return Obx(()=> Container(
      child: (filePath.value.isNotEmpty)?Container(
        margin: EdgeInsets.only(bottom: 16*SizeConfig.heightMultiplier!),
        child: GestureDetector(
            onTap: () {
              OpenFile.open(filePath.value);
            },
            child: Stack(
              children: [
                Container(
                    width: 220*SizeConfig.widthMultiplier!,
                    child: Row(
                      children: [
                        Image.asset((fileExtension == "JPEG"||fileExtension == "JPG")?ImagePath.jpgFileIcon:(fileExtension == "PNG")?ImagePath.pngIcon:(fileExtension!.contains("PPT"))?ImagePath.pptIcon:(fileExtension!.contains("MP4"))?ImagePath.mp4Icon:(fileExtension!.contains("XLX"))?ImagePath.xlxIcon:(fileExtension == "PDF")?ImagePath.pdfFileIcon:ImagePath.docFileIcon,width: 32*SizeConfig.imageSizeMultiplier!,height: 32*SizeConfig.imageSizeMultiplier!,),
                        SizedBox(width: 7*SizeConfig.widthMultiplier!,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container( padding: new EdgeInsets.only(right: 10*SizeConfig.widthMultiplier!),child: Text(documentName.split(".").first,overflow: TextOverflow.ellipsis,style: AppTextStyle.whiteTextWithWeight600,)),
                              SizedBox(height: 5*SizeConfig.imageSizeMultiplier!,),
                              FutureBuilder(
                                  future: getFileSizeFromLocal(),
                                  builder: (context,AsyncSnapshot<String> snapshot){

                                    return Text("${snapshot.hasData?snapshot.data:0.0} MB • ${fileExtension}",style: AppTextStyle.hmediumBlackText.copyWith(color: hintGrey,height: 1),);
                                  })
                            ],),
                        )


                      ],
                    )
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: Container(
                        margin: EdgeInsets.only(top: 25*SizeConfig.heightMultiplier!,right: 15*SizeConfig.widthMultiplier!),
                        child: Text(documentDate.value.isNotEmpty?documentDate.value:"",style: AppTextStyle.hmediumBlackText.copyWith(color: hintGrey,height: 1))))
              ],
            )),
      ):Container(),

    ));
  }


  void checkFileExistence(String? fileName) async {
    PermissionStatus status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      String? path;
      final downloadsPath = Directory('/storage/emulated/0/Download');
      final Directory _appDocDir = await getApplicationDocumentsDirectory();
      final Directory _appDocDirFolder =
      Directory('storage/emulated/0/fitBasix/media');

      if (await _appDocDirFolder.exists()) {
        path = _appDocDirFolder.path;
      } else {
        //if folder not exists create folder and then return its path
        final Directory _appDocDirNewFolder =
        await _appDocDirFolder.create(recursive: true);
        path = _appDocDirNewFolder.path;
      }

      //if(File(message!.attachments![0]!.data!).existsSync())
      if (File(path + "/" + fileName!).existsSync()) {
        print("file exists in " + path + "/$fileName");
        filePath.value = path + "/$fileName";
      }

      if (File(downloadsPath.path + "/" + fileName).existsSync()) {
        print("file exists in " + downloadsPath.path + "/$fileName");
        filePath.value = downloadsPath.path + "/" + fileName;
      }
    }
  }

  Future<String> getFileSizeFromLocal() async {

    File file = File(filePath.value);
    int sizeInBytes = (await file.length());
    var size = NumberFormat("0.00").format((sizeInBytes / (1024*1024)));
    return size;

  }
  setDocumentDate(){
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    DateTime dateOfFile = DateTime.fromMicrosecondsSinceEpoch(date * 1000);
    final checkDate = DateTime(dateOfFile.year, dateOfFile.month, dateOfFile.day);
    if(checkDate == today){
      documentDate.value = "Today";
    }
    else if(checkDate == yesterday){
      documentDate.value = "Yesterday";
    }
    else{
      documentDate.value = DateFormat("dd MMM yy").format(checkDate);
    }
  }
}

