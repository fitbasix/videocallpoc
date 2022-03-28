import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/feature/profile/view/appbar_for_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  DateTime dateToShow = DateTime.now();
  List<QBMessage?>? messageWithAttachment;
  String ShowDay = "demo";

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
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _getGroupByDate(messageWithAttachment![index]!.body!),
                Container(
                  margin: EdgeInsets.only(bottom: 16*SizeConfig.heightMultiplier!,left: 29*SizeConfig.widthMultiplier!),
                  child: DocumentTiles(documentName: messageWithAttachment![index]!.attachments![0]!.name!,date: messageWithAttachment![index]!.dateSent!,),
                ),
              ],
            );
          }),

        ],

      ),
    );
  }

  void getAllMessageWithAttachments() {
    messageWithAttachment= List.from(widget.messages!.where((element) => element!.attachments != null));
    messageWithAttachment!.forEach((element) {
      element!.body = _getGroupByDateString(element.dateSent!);
    });
  }

  Widget _getGroupByDate(String sentDateString) {
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month-1, now.day);
    final Year = DateTime(now.year -1, now.month, now.day);
    // DateTime dateOfFile = DateTime.fromMicrosecondsSinceEpoch(dateSent * 1000);
    // final checkDate = DateTime(dateOfFile.year, dateOfFile.month, dateOfFile.day);
    if( ShowDay != sentDateString){
      ShowDay = sentDateString;
      return Container(
          margin: EdgeInsets.only(left: 16*SizeConfig.widthMultiplier!,bottom: 20*SizeConfig.heightMultiplier!),
          child: Text(sentDateString,style: AppTextStyle.hnormal600BlackText.copyWith(color: Theme.of(context).textTheme.headline1!.color),));
    }
    else{
      return Container();
    }
  }

  String? _getGroupByDateString(int dateSent) {
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month-1, now.day);
    final previousMonth = DateTime(now.year, now.month-2, now.day);
    final Year = DateTime(now.year -1, now.month, now.day);
    DateTime dateOfFile = DateTime.fromMicrosecondsSinceEpoch(dateSent * 1000);
    final checkDate = DateTime(dateOfFile.year, dateOfFile.month, dateOfFile.day);
    if(checkDate.isAfter(lastMonth)){
      return "This Month";
    }
    else if(checkDate.month == lastMonth.month &&checkDate.isAfter(previousMonth)){
      return "Last Month";
    }
    else if(checkDate.isAfter(Year)){
      return DateFormat("MMMM").format(checkDate);
    }
    else{
      return DateFormat("yyyy").format(checkDate);
    }

  }

}

class DocumentTiles extends StatelessWidget {
  String documentName;
  int date;
  String? fileURL;
  var filePath = "".obs;
  String? fileExtension;
  var documentDate = "".obs;
  double? fileSizeFromDb;
  bool? wantDownloadFeature;
  var isDownloaded = false.obs;
  var isDownloadingStarted = false.obs;
  var downloadProgress = 0.0.obs;
  DocumentTiles({Key? key,required this.documentName,required this.date,this.fileSizeFromDb,this.wantDownloadFeature,this.fileURL}) : super(key: key);

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
                              (fileSizeFromDb == null)?FutureBuilder(
                                  future: getFileSizeFromLocal(),
                                  builder: (context,AsyncSnapshot<String> snapshot){
                                    return Text("${snapshot.hasData?snapshot.data:0.0} MB • ${fileExtension}",style: AppTextStyle.hmediumBlackText.copyWith(color: hintGrey,height: 1),);
                                  }):Text("$fileSizeFromDb MB • ${fileExtension}",style: AppTextStyle.hmediumBlackText.copyWith(color: hintGrey,height: 1),)
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
      ):(wantDownloadFeature!=null)?Container(
        margin: EdgeInsets.only(bottom: 16*SizeConfig.heightMultiplier!),
        child: GestureDetector(
            onTap: () {
              OpenFile.open(filePath.value);
            },
            child: Stack(
              children: [
                Row(
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
                          Text("$fileSizeFromDb MB • ${fileExtension}",style: AppTextStyle.hmediumBlackText.copyWith(color: hintGrey,height: 1),)
                        ],),
                    ),
                    (!isDownloadingStarted.value)?GestureDetector(
                        onTap: () async {
                          isDownloadingStarted.value = true;
                          isDownloaded.value = await _DownloadFile(
                              fileURL!,
                              documentName);
                        },
                        child: Image.asset(ImagePath.downloadDocIcon,width: 16.79*SizeConfig.widthMultiplier!,height: 22.4*SizeConfig.heightMultiplier!,)):SizedBox(
                        height: 22*SizeConfig.heightMultiplier!,
                        width: 22*SizeConfig.heightMultiplier!,
                        child: CircularProgressIndicator(color: kPureWhite,value: downloadProgress.value,backgroundColor: Colors.grey.withOpacity(0.2),strokeWidth: 2.5*SizeConfig.imageSizeMultiplier!,)),
                    SizedBox(width: 20*SizeConfig.widthMultiplier!,),



                  ],
                ),

              ],
            )),
      ):Container()

    ));
  }

  Future<bool> _DownloadFile(String url, String fileName) async {
    print(fileName + "this is the file name");
    try {
      bool flag = false;

      //FlutterDownloader.registerCallback(downloadCallback);
      try {
        print("jjjjjjj");
        if(Platform.isAndroid){
          PermissionStatus status  = await Permission.storage.request();
          PermissionStatus status1 = await Permission.manageExternalStorage.request();
          String? path;
          final Directory _appDocDir = await getApplicationDocumentsDirectory();
          //App Document Directory + folder name
          final Directory _appDocDirFolder = Directory('storage/emulated/0/fitBasix/media');
          if (await _appDocDirFolder.exists()) {
            //if folder already exists return path
            path = _appDocDirFolder.path;
          } else {
            //if folder not exists create folder and then return its path
            final Directory _appDocDirNewFolder =
            await _appDocDirFolder.create(recursive: true);
            path = _appDocDirNewFolder.path;
          }
          print(path + "pp dir");
          Dio dio = Dio();
          dio.download(url, path + "/" + fileName,
              onReceiveProgress: (received, total) {
                downloadProgress.value = ((received / total));
                print(downloadProgress.value);
                if (((received / total) * 100).floor() == 100) {
                  checkFileExistence(fileName);
                }
              });
        }
        if(Platform.isIOS){
          print("yyyyyy");
          String? path;
          final Directory _appDocDir = Directory((await getTemporaryDirectory()).path + '/fitbasix/media');
          print(_appDocDir.path.toString()+" uuuuu");
          //App Document Directory + folder name
          if ((await _appDocDir.exists())) {
            path = _appDocDir.path;
          } else {
            _appDocDir.create();
            path = _appDocDir.path;
          }
          print(path + "pp dir");
          Dio dio = Dio();
          dio.download(url, path + "/" + fileName,
              onReceiveProgress: (received, total) {
                downloadProgress.value = ((received / total));
                print(downloadProgress.value);
                if (((received / total) * 100).floor() == 100) {
                  checkFileExistence(fileName);
                }
              });
        }

      } catch (e) {
        print(e.toString());
      }

      return false;
    } on PlatformException catch (e) {
      print(e);
      return false;
      // Some error occurred, look at the exception message for more details
    }
  }


  void checkFileExistence(String? fileName) async {
    if(Platform.isAndroid){
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
    if(Platform.isIOS){
      String? path;
      final Directory _appDocDir = Directory((await getTemporaryDirectory()).path + '/fitbasix/media');
      print(_appDocDir.path.toString()+" uuuuu");
      //App Document Directory + folder name
      if ((await _appDocDir.exists())) {
        path = _appDocDir.path;
      } else {
        _appDocDir.create();
        path = _appDocDir.path;
      }
      if (File(path + "/" + fileName!).existsSync()) {
        print("file exists in " + path + "/$fileName");
        filePath.value = path + "/$fileName";
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



