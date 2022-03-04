import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButtonPlanScreen extends StatelessWidget {
   CustomButtonPlanScreen({
     this.Text,
     this.height,
     this.width,
     this.colour,
     this.onpressed,
     Key? key}) : super(key: key);
   Color? colour;
   double? width;
   double? height;
   VoidCallback? onpressed;
   Widget? Text;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        decoration: BoxDecoration(
          color: colour!,
          borderRadius: BorderRadius.circular(8),
        ),
        width: width!,
        height: height!,
        child: Center(child: Text!),
      ),
    );;
  }
}
