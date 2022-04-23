import 'dart:developer';

import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/reponsive/SizeConfig.dart';
import '../../message/view/documents_view_screen.dart';
import '../../profile/view/appbar_for_account.dart';
import '../controller/documents_controller.dart';
import '../services/documents_services.dart';

class ViewAllDocumentsOfUser extends StatefulWidget {
  ViewAllDocumentsOfUser({Key? key,}) : super(key: key);

  @override
  State<ViewAllDocumentsOfUser> createState() => _ViewAllDocumentsOfUserState();
}

class _ViewAllDocumentsOfUserState extends State<ViewAllDocumentsOfUser> {
  final DocumentsController _documentsController = Get.find();
  final ScrollController _scrollController = ScrollController();
  String ShowDay = "demo";

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  @override
  void initState() {
    _documentsController.docCurrentPage.value = 1;
    _documentsController.isDocumentNeedToLoadData.value = true;

    _scrollController.addListener(() async {
      print(_documentsController.isDocumentNeedToLoadData.value);
      if (_documentsController.isDocumentNeedToLoadData.value == true) {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.position.pixels) {
          _documentsController.showLoaderOnDocs.value = true;
          final postQuery = await DocumentServices.getAllDocumentsOfUser(
              trainerId: _documentsController.trainerID.value,
              skip: _documentsController.docCurrentPage.value);

          if (postQuery.response!.data!.length < 10) {
            _documentsController.isDocumentNeedToLoadData.value = false;
            _documentsController.listOfDocuments.addAll(postQuery.response!.data!);
            print(_documentsController.listOfDocuments.length.toString() +" wwww");
            _documentsController.showLoaderOnDocs.value = false;
            return;
          } else {
            if (_documentsController.listOfDocuments.last.id ==
                postQuery.response!.data!.last.id) {
              _documentsController.showLoaderOnDocs.value = false;
              return;
            }

            _documentsController.listOfDocuments.addAll(postQuery.response!.data!);
            _documentsController.showLoaderOnDocs.value = false;
          }
          _documentsController.docCurrentPage.value++;
          _documentsController.showLoaderOnDocs.value = false;
          //setState(() {});
        }
      }
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
 appBar: AppBarForAccount(
        onback: (){Navigator.pop(context);},
    title: _documentsController.opponentName!.trim(),
    ),
      body: Obx(
              ()=>_documentsController.isAllDocumentsLoading.value?Center(
            child: CustomizedCircularProgress(),
          ):Column(
                crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
              margin: EdgeInsets.symmetric(horizontal: 16*SizeConfig.widthMultiplier!,vertical: 14*SizeConfig.heightMultiplier!),
              child: Text("Documents",style: AppTextStyle.hblack600Text.copyWith(color: Colors.white,height: 1),)),
        SizedBox(height: 12*SizeConfig.heightMultiplier!,),
        Expanded(
          child: Obx(
                ()=>ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _documentsController.listOfDocuments.length,
                  itemBuilder: (context, index){
                    _documentsController.listOfDocuments[index].showDate = _getGroupByDateString(_documentsController.listOfDocuments[index].createdAt!);
                    if(_documentsController.listOfDocuments.length<10){
                      print("ppp");
                      _documentsController.isDocumentNeedToLoadData.value = false;
                      print(_documentsController.isDocumentNeedToLoadData.value);
                    }
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _getGroupByDate(_documentsController.listOfDocuments[index].showDate!),
                        Container(
                          margin: EdgeInsets.only(bottom: 16*SizeConfig.heightMultiplier!,left: 29*SizeConfig.widthMultiplier!),
                          child: DocumentTiles(documentName: _documentsController.listOfDocuments[index].fileName!,date: _documentsController.listOfDocuments[index].createdAt!.millisecondsSinceEpoch,fileSizeFromDb: _documentsController.listOfDocuments[index].sizeInMb!,wantDownloadFeature: true,fileURL: _documentsController.listOfDocuments[index].url,),
                        ),
                      ],
                    );
                  }),
          ),
        ),
        Obx(()=>_documentsController.showLoaderOnDocs.value?Center(child: CustomizedCircularProgress()):Container())

      ],

    ),


      )
    );
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
  String? _getGroupByDateString(DateTime dateSent) {
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month-1, now.day);
    final previousMonth = DateTime(now.year, now.month-2, now.day);
    final Year = DateTime(now.year -1, now.month, now.day);
    DateTime dateOfFile = dateSent;
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

