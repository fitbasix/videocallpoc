import 'dart:convert';

import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int length;
  const CustomBottomNavigationBar({
    Key? key,
    required this.length,
  }) : super(key: key);

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  final HomeController _homeController = Get.put(HomeController());
  bool test = false;
  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());
    var dependencyupdate =
        homeController.remoteConfig.getString('UiDependency');
    var jsonOb = json.decode(dependencyupdate);
    var screenlength = widget.length;
    void onTapped(int index) {

      if(index == 0 && _homeController.selectedIndex.value == 0){
        _homeController.scrollController.animateTo(0,
            duration: const Duration(seconds: 2), curve: Curves.linear);
      }

      index == screenlength
          ? _homeController.drawerKey.currentState!.openEndDrawer()
          : setState(() {
              _homeController.selectedIndex.value = index;
            });
    }

    return Obx(() => Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
              blurRadius: 15 * SizeConfig.imageSizeMultiplier!,
            ),
          ],
        ),
        child: BottomNavigationBar(
          selectedFontSize: 12*SizeConfig.textMultiplier!,
          unselectedFontSize: 12*SizeConfig.textMultiplier!,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: kgreen49,
          unselectedItemColor: hintGrey,
          currentIndex: _homeController.selectedIndex.value,
          items: [
            if (jsonOb['home'] == 1)
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                  ),
                  label: 'home'.tr),
            if (jsonOb['get_trained'] == 1)
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.chat_bubble_outline,
                  ),
                  label: 'getTrainedTitle'.tr),
            if (jsonOb['post'] == 1)
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.add,
                 //   color: kPureWhite,
                  ),
                  label: 'post'.tr),
            if (jsonOb['tools'] == 1)
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.calculate_outlined,
                  ),
                  label: 'tools'.tr),
            if (jsonOb['more'] == 1)
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.more_horiz,
                  ),
                  label: 'more'.tr)
          ],
          onTap: (value) {
            onTapped(value);
          },
        )));
  }
}
