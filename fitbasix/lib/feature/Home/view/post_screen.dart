import 'package:fitbasix/feature/get_trained/view/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: CustomAppBar(titleOfModule: 'post'.tr),
          preferredSize: const Size(double.infinity, kToolbarHeight)),
      body: Center(
        child: Text('Post Screen'),
      ),
    );
  }
}
