import 'package:flutter/material.dart';
import 'package:quickblox_sdk/models/qb_message.dart';



class DocumentsViewerScreen extends StatefulWidget {
  List<QBMessage?>? messages;
  DocumentsViewerScreen({Key? key,this.messages}) : super(key: key);

  @override
  _DocumentsViewerScreenState createState() => _DocumentsViewerScreenState();
}

class _DocumentsViewerScreenState extends State<DocumentsViewerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(

      ),
    );
  }
}
