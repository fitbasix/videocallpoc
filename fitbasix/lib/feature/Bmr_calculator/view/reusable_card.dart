import 'package:flutter/cupertino.dart';

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
        child: cardwidget,
        margin: EdgeInsets.all(8),
        decoration:
        BoxDecoration(color: colour, borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}