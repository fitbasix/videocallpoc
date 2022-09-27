import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';

class PdfViewerFile extends StatefulWidget {
  final String link;
  const PdfViewerFile({Key? key, required this.link}) : super(key: key);

  @override
  State<PdfViewerFile> createState() => _PdfViewerFileState();
}

class _PdfViewerFileState extends State<PdfViewerFile> {
  late PDFDocument document;
  bool loader = true;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loader
          ? Center(child: CircularProgressIndicator())
          : PDFViewer(
              document: document,
            ),
    );
  }
}
