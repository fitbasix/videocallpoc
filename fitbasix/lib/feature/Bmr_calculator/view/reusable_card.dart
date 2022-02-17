import 'package:flutter/cupertino.dart';

import '../../../core/reponsive/SizeConfig.dart';

class Reusablecard extends StatelessWidget {
  Reusablecard({this.colour, this.cardwidget, this.onpress});
  final Color? colour;
  final Widget? cardwidget;
  final VoidCallback? onpress;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpress,
      child: Container(
        height: 52*SizeConfig.heightMultiplier!,
        child: cardwidget,
      //  margin: EdgeInsets.all(0),
        decoration:
        BoxDecoration(color: colour),
      ),
    );
  }
}