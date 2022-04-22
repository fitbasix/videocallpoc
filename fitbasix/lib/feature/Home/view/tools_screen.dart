import 'package:fitbasix/feature/Bmr_calculator/view/bmr_homepage.dart';
import 'package:flutter/material.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BMRHomeScreen(),
        //Text('Tools Screen'),
      ),
    );
  }
}
