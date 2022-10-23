  import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/video_controller.dart';
import 'iframe.dart';
class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({Key? key}) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final VideoController _videoController = Get.put(VideoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Container(
        width: double.infinity,
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           InkWell(
             child:  Container(
               padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
               decoration: BoxDecoration(
                   borderRadius: BorderRadius.all(Radius.circular(15)),
                   color: Colors.green
               ),
               child:  Text("Create Room",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900),),
             ),
             onTap: (){
               _videoController.createRoom();
             },
           ),
            SizedBox(height: 20,),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.8,
              child: TextField(
                controller: _videoController.roomIdText,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter room link"
                ),
              ),
            ),
            SizedBox(height: 20,),
           InkWell(
             child:  Container(
               padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
               decoration: BoxDecoration(
                   borderRadius: BorderRadius.all(Radius.circular(15)),
                   color: Colors.green
               ),
               child:  Text("Join Room",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900),),
             ),
             onTap: (){
               print("aaa");
               Navigator.push(context, MaterialPageRoute(builder: (context)=>IFrameScreen(Id: _videoController.roomId.value,)));
             },
           )
          ],
        ),
      ),
    );
  }
}
