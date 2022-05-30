import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final double height;
  final double width;
  const LoadingIndicator({Key? key, this.height = 50, this.width = 50})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        child: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          strokeWidth: 1.0,
        ),
        height: height,
        width: width,
      ),
    );
  }
}
