import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PdfViewerFile extends StatefulWidget {
  final String link;
  const PdfViewerFile({Key? key, required this.link}) : super(key: key);

  @override
  State<PdfViewerFile> createState() => _PdfViewerFileState();
}

class _PdfViewerFileState extends State<PdfViewerFile> {
  late PDFDocument document;
  bool loader = true;
  String filePath = "";

  @override
  void initState() {
    // TODO: implement initState
    loadDocument();
    super.initState();
  }

  loadDocument() async {
    print(widget.link);
    document = await PDFDocument.fromURL(widget.link);
    print("done");
    setState(() {
      loader = false;
    });
  }

  Future<String> downloadFile(String url, String fileName, String dir) async {
    HttpClient httpClient = HttpClient();
    File file;
    String filePath = '';
    String myUrl = '';
    if (Platform.isAndroid) {
      Directory directory = Directory(dir);
      if (!(await directory.exists())) directory.create();
    }
    try {
      myUrl = url;
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        log(bytes.toString());
        filePath = '$dir/Invoice_$fileName.pdf';
        file = File(filePath);
        await file.writeAsBytes(bytes);
      } else {
        filePath = 'Error code: ' + response.statusCode.toString();
      }
    } catch (ex) {
      print(ex.toString());
      filePath = 'Can not fetch url';
      log(filePath);
    }
    return filePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPureBlack,
        actions: [
          IconButton(
              onPressed: () async {
                await [
                  Permission.manageExternalStorage,
                  Permission.storage,
                  Permission.accessMediaLocation,
                  Permission.mediaLibrary
                ].request();
                setState(() {
                  loader = true;
                });
                if (Platform.isAndroid) {
                  var dt = await downloadFile(
                      widget.link,
                      widget.link.split('/').last,
                      '/storage/emulated/0/Fitbasix');

                  await Future.delayed(Duration(seconds: 1), () {
                    setState(() {
                      loader = false;
                    });
                  });
                  Get.rawSnackbar(
                    message: 'File Saved at $dt',
                  );
                } else {
                  Directory appDocDir =
                      await getApplicationDocumentsDirectory();
                  String appDocPath = appDocDir.path;
                  print('appDocPath');
                  var dt = await downloadFile(widget.link,
                      DateTime.now().toIso8601String(), appDocPath);
                  await Future.delayed(Duration(seconds: 1), () {
                    setState(() {
                      loader = false;
                    });
                  });
                  Get.rawSnackbar(
                    message: 'File Saved at $dt',
                  );
                }
              },
              icon: Icon(
                Icons.download,
                color: kgreen49,
              ))
        ],
      ),
      body: loader
          ? const Center(child: CircularProgressIndicator())
          : PDFViewer(
              document: document,
            ),
    );
  }
}
