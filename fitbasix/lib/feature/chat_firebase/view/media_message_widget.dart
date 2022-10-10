import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/universal_widgets/image_viewer.dart';
import 'package:fitbasix/feature/chat_firebase/controller/firebase_chat_controller.dart';
import 'package:fitbasix/feature/chat_firebase/model/chat_model.dart';
import 'package:fitbasix/feature/message/controller/chat_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/constants/color_palette.dart';

class MediaMessageWidget extends StatefulWidget {
  final MessageData passedMessage;
  const MediaMessageWidget({Key? key, required this.passedMessage})
      : super(key: key);

  @override
  _MediaMessageState createState() => _MediaMessageState();
}

class _MediaMessageState extends State<MediaMessageWidget> {
  var _chatController = Get.find<FirebaseChatController>();
  String? text;
  bool sentByMe = false;
  
  @override
  Widget build(BuildContext context) {
    bool _isDownloading = false;

    if (_chatController.senderId == widget.passedMessage.senderId) {
      sentByMe = true;
    } else {
      sentByMe = false;
    }

    Color background = sentByMe == true
        ? const Color(0xff3399FF).withOpacity(0.92)
        : const Color(0xffF8F8F8).withOpacity(0.92);
    return Column(
      crossAxisAlignment:
          sentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (widget.passedMessage.mediaType == 'image')
          Hero(
            tag: widget.passedMessage.mediaUrl,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: 8.0 * SizeConfig.heightMultiplier!,
                  right: 16 * SizeConfig.widthMultiplier!,
                  left: 16 * SizeConfig.widthMultiplier!),
              child: Container(
                padding: EdgeInsets.all(1 * SizeConfig.widthMultiplier!),
                constraints: BoxConstraints(
                    maxHeight: 200 * SizeConfig.heightMultiplier!,
                    maxWidth: 150 * SizeConfig.widthMultiplier!),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(8 * SizeConfig.widthMultiplier!),
                    color: sentByMe ? Colors.grey[900] : Colors.grey[800]),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(8 * SizeConfig.widthMultiplier!),
                  child: CachedNetworkImage(
                    imageUrl: widget.passedMessage.mediaUrl,
                    fit: BoxFit.cover,
                    height: 200 * SizeConfig.widthMultiplier!,
                    width: 200 * SizeConfig.heightMultiplier!,
                    placeholder: (BuildContext context, String url) {
                      return Container(
                        height: 200 * SizeConfig.heightMultiplier!,
                        width: 150 * SizeConfig.widthMultiplier!,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: kGreenColor,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        if (widget.passedMessage.mediaType == 'video')
          FileCard(
            passedMessage: widget.passedMessage,
            backgroundColor: background,
            sendByMe: sentByMe,
          ),
        if (widget.passedMessage.mediaType == 'file')
          FileCard(
            passedMessage: widget.passedMessage,
            backgroundColor: background,
            sendByMe: sentByMe,
          ),
        if (widget.passedMessage.mediaType == 'audio')
          FileCard(
            passedMessage: widget.passedMessage,
            backgroundColor: background,
            sendByMe: sentByMe,
          ),
        Padding(
          padding: EdgeInsets.only(
              bottom: 8.0 * SizeConfig.heightMultiplier!,
              right: 16 * SizeConfig.widthMultiplier!,
              left: 16 * SizeConfig.widthMultiplier!),
          child: Text(
              DateFormat.jm().format(
                  DateTime.parse(widget.passedMessage.sentAt).toLocal()),
              style: sentByMe == true
                  ? AppTextStyle.white400Text
                      .copyWith(fontSize: 9.0 * SizeConfig.textMultiplier!)
                  : AppTextStyle.black400Text.copyWith(
                      color: kPureWhite,
                      fontSize: 9.0 * SizeConfig.textMultiplier!)),
        ),
      ],
    );
  }
}

class FileCard extends StatefulWidget {
  final MessageData passedMessage;
  final Color backgroundColor;
  final bool sendByMe;
  const FileCard(
      {Key? key,
      required this.passedMessage,
      required this.backgroundColor,
      required this.sendByMe})
      : super(key: key);

  @override
  _FileCardState createState() => _FileCardState();
}

class _FileCardState extends State<FileCard> {
  bool _isDownloading = false;
  var isDownloaded = false.obs;
  var isDownloadingStarted = false.obs;
  var filePath = "".obs;
  var downloadProgress = 0.0.obs;
  var fileSize = "".obs;
  String? fileExtension;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = widget.sendByMe ? greenChatColor : kBlack;
    checkFileExistence(widget.passedMessage.mediaUrl);
    fileExtension = widget.passedMessage.mediaUrl
        .split(".")
        .last
        .toUpperCase()
        .split('?')
        .first;
    return Padding(
      padding: EdgeInsets.only(
          bottom: 8.0 * SizeConfig.heightMultiplier!,
          right: 16 * SizeConfig.widthMultiplier!,
          left: 16 * SizeConfig.widthMultiplier!),
      child: Container(
          constraints: BoxConstraints(
              maxWidth: 300 * SizeConfig.widthMultiplier!,
              maxHeight: 250 * SizeConfig.heightMultiplier!),
          padding: EdgeInsets.symmetric(
            vertical: 14.0 * SizeConfig.heightMultiplier!,
            horizontal: 8.0 * SizeConfig.widthMultiplier!,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius:
                BorderRadius.circular(8 * SizeConfig.imageSizeMultiplier!),
          ),
          child: Obx(() => filePath.value.isEmpty
              ? Container(
                  child: GestureDetector(
                      onTap: () async {},
                      child: Container(
                        width: 220 * SizeConfig.widthMultiplier!,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 8 * SizeConfig.widthMultiplier!),
                              height: 50 * SizeConfig.heightMultiplier!,
                              decoration: BoxDecoration(
                                color: kPureWhite.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(
                                    8 * SizeConfig.imageSizeMultiplier!),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    widget.passedMessage.mediaName,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyle.whiteTextWithWeight600,
                                  )),
                                  SizedBox(
                                    width: 10 * SizeConfig.widthMultiplier!,
                                  ),
                                  (!isDownloadingStarted.value)
                                      ? GestureDetector(
                                          onTap: () async {
                                            isDownloadingStarted.value = true;
                                            isDownloaded.value =
                                                await _getImageUrl(
                                                    widget
                                                        .passedMessage.mediaUrl,
                                                    widget
                                                        .passedMessage.mediaUrl
                                                        .split('/')
                                                        .last);
                                          },
                                          child: Image.asset(
                                            ImagePath.downloadDocIcon,
                                            width: 16.79 *
                                                SizeConfig.widthMultiplier!,
                                            height: 22.4 *
                                                SizeConfig.heightMultiplier!,
                                          ))
                                      : SizedBox(
                                          height:
                                              22 * SizeConfig.heightMultiplier!,
                                          width:
                                              22 * SizeConfig.heightMultiplier!,
                                          child: CircularProgressIndicator(
                                            color: kPureWhite,
                                            value: downloadProgress.value,
                                            backgroundColor:
                                                Colors.grey.withOpacity(0.2),
                                            strokeWidth: 2.5 *
                                                SizeConfig.imageSizeMultiplier!,
                                          )),
                                  SizedBox(
                                    width: 12 * SizeConfig.widthMultiplier!,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 8 * SizeConfig.heightMultiplier!,
                            ),
                            // Text(
                            //   "${NumberFormat("#0.00").format(widget.passedMessage.attachment!.fileSize! / (1024 * 1024))} MB • ${widget.passedMessage.attachment!.fileName.split(".").last.toUpperCase()}",
                            //   style: AppTextStyle.hmediumBlackText
                            //       .copyWith(color: kPureWhite, height: 1),
                            // )
                          ],
                        ),
                      )),
                )
              : Container(
                  child: GestureDetector(
                      onTap: () {
                        OpenFile.open(filePath.value);
                      },
                      child: Container(
                          width: 220 * SizeConfig.widthMultiplier!,
                          child: Row(
                            children: [
                              Image.asset(
                                (fileExtension == "JPEG" ||
                                        fileExtension == "JPG")
                                    ? ImagePath.jpgFileIcon
                                    : (fileExtension == "PNG")
                                        ? ImagePath.pngIcon
                                        : (fileExtension!.contains("PPT"))
                                            ? ImagePath.pptIcon
                                            : (fileExtension!.contains("MP4"))
                                                ? ImagePath.mp4Icon
                                                : (fileExtension!
                                                        .contains("XLX"))
                                                    ? ImagePath.xlxIcon
                                                    : (fileExtension == "PDF")
                                                        ? ImagePath.pdfFileIcon
                                                        : ImagePath.docFileIcon,
                                width: 32 * SizeConfig.imageSizeMultiplier!,
                                height: 32 * SizeConfig.imageSizeMultiplier!,
                              ),
                              SizedBox(
                                width: 7 * SizeConfig.widthMultiplier!,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                        padding: new EdgeInsets.only(
                                            right: 10 *
                                                SizeConfig.widthMultiplier!),
                                        child: Text(
                                          widget.passedMessage.mediaUrl
                                              .split('/')
                                              .last,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTextStyle
                                              .whiteTextWithWeight600,
                                        )),
                                    SizedBox(
                                      height:
                                          5 * SizeConfig.imageSizeMultiplier!,
                                    ),
                                    FutureBuilder(
                                        future: getFileSizeFromLocal(),
                                        builder: (context,
                                            AsyncSnapshot<String> snapshot) {
                                          return Text(
                                            "${snapshot.hasData ? snapshot.data : 0.0} MB",
                                            style: AppTextStyle.hmediumBlackText
                                                .copyWith(
                                                    color: kPureWhite,
                                                    height: 1),
                                          );
                                        })
                                  ],
                                ),
                              )
                            ],
                          ))),
                ))),
    );

    // Card(
    //   color: widget.backgroundColor,
    //   child: Column(
    //     children: [
    //       SizedBox(
    //         height: 100,
    //         width: 150,
    //         child: Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Center(
    //             child: Text(widget.passedMessage.attachment!.fileName),
    //           ),
    //         ),
    //       ),
    //       GestureDetector(
    //         onTap: () async {
    //           setState(() {
    //             _isDownloading = true;
    //           });
    //           File ab = await _downloadFile(
    //               widget.passedMessage.attachment!.fileUrl,
    //               widget.passedMessage.attachment!.fileName);
    //           print(ab.path);
    //           setState(() {
    //             _isDownloading = false;
    //           });
    //
    //           OpenFile.open(ab.path);
    //         },
    //         child: Row(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             if (_isDownloading)
    //               const Padding(
    //                 padding: EdgeInsets.all(8.0),
    //                 child: LoadingIndicator(
    //                   height: 10,
    //                   width: 10,
    //                 ),
    //               ),
    //             const Text("Download")
    //           ],
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }

  Future<bool> _getImageUrl(String url, String fileName) async {
    try {
      bool flag = false;

      //FlutterDownloader.registerCallback(downloadCallback);
      try {
        if (Platform.isAndroid) {
          PermissionStatus status = await Permission.storage.request();

          String? path;
          final Directory appDir = await getApplicationDocumentsDirectory();
          final _appDocDirFolder = Directory(appDir.path);
          if (await _appDocDirFolder.exists()) {
            //if folder already exists return path
            path = _appDocDirFolder.path;
          } else {
            //if folder not exists create folder and then return its path
            final Directory _appDocDirNewFolder =
                await _appDocDirFolder.create(recursive: true);
            path = _appDocDirNewFolder.path;
          }
          Dio dio = Dio();
          dio.download(url, path + "/" + fileName,
              onReceiveProgress: (received, total) {
            downloadProgress.value = ((received / total));
            if (((received / total) * 100).floor() == 100) {
              checkFileExistence(fileName);
            }
          });
        } else {
          String? path;
          final Directory _appDocDir = Directory(
              (await getTemporaryDirectory()).path + '/fitbasix/media');

          //App Document Directory + folder name
          if ((await _appDocDir.exists())) {
            path = _appDocDir.path;
          } else {
            _appDocDir.create();
            path = _appDocDir.path;
          }
          Dio dio = Dio();
          dio.download(url, path + "/" + fileName,
              onReceiveProgress: (received, total) {
            downloadProgress.value = ((received / total));
            if (((received / total) * 100).floor() == 100) {
              checkFileExistence(fileName);
            }
          });
        }
      } catch (e) {}

      return false;
    } on PlatformException catch (e) {
      return false;
      // Some error occurred, look at the exception message for more details
    }
  }

  void checkFileExistence(String? fileName) async {
    if (Platform.isAndroid) {
      PermissionStatus status = await Permission.storage.request();

      if (status == PermissionStatus.granted) {
        String? path;
        final downloadsPath = Directory('/storage/emulated/0/Download');
        final Directory appDir = await getApplicationDocumentsDirectory();
        final _appDocDirFolder = Directory(appDir.path);

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
          filePath.value = path + "/$fileName";
        }

        if (File(downloadsPath.path + "/" + fileName).existsSync()) {
          filePath.value = downloadsPath.path + "/" + fileName;
        }
      }
    } else {
      String? path;
      final Directory _appDocDir =
          Directory((await getTemporaryDirectory()).path + '/fitbasix/media');
      //App Document Directory + folder name
      if ((await _appDocDir.exists())) {
        path = _appDocDir.path;
      } else {
        _appDocDir.create();
        path = _appDocDir.path;
      }
      if (File(path + "/" + fileName!).existsSync()) {
        filePath.value = path + "/$fileName";
      }
    }
  }

  Future<String> getFileSizeFromLocal() async {
    File file = File(filePath.value);
    int sizeInBytes = (await file.length());
    var size = NumberFormat("0.00").format((sizeInBytes / (1024 * 1024)));
    return size;
  }

  static var httpClient = HttpClient();

  int byteCount = 0;

  Future<File> _downloadFile(String url, String filename) async {
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = Platform.isIOS
        ? (await getApplicationSupportDirectory()).path
        : (await getExternalStorageDirectory())!.path;
    File file = new File('$dir/$filename');
    print('$dir/$filename');
    await file.writeAsBytes(bytes);
    print("File Done");
    return file;
  }
}
