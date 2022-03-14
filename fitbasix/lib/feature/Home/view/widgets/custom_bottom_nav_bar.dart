import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  void onTapped(int index) {
    index == 4
        ? _homeController.drawerKey.currentState!.openEndDrawer()
        : setState(() {
            _homeController.selectedIndex.value = index;
            print('object');
          });
  }

  final HomeController _homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.2),
            blurRadius: 15*SizeConfig.imageSizeMultiplier!,
          ),
        ],
      ),
      child: BottomNavigationBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: kgreen49,
            unselectedItemColor: hintGrey,
            currentIndex: _homeController.selectedIndex.value,
            items: [
              BottomNavigationBarItem(
                  icon: new Icon(
                    Icons.home,
                  ),
                  label: 'home'.tr),
              BottomNavigationBarItem(
                  icon: new Icon(
                    Icons.chat_bubble_outline,
                  ),
                  label: 'getTrainedTitle'.tr),
              BottomNavigationBarItem(
                  icon: new Icon(
                    Icons.add,
                    color: kPureWhite,
                  ),
                  label: 'post'.tr),
              BottomNavigationBarItem(
                  icon: new Icon(
                    Icons.calculate_outlined,
                  ),
                  label: 'tools'.tr),
              BottomNavigationBarItem(
                  icon: new Icon(
                    Icons.more_horiz,
                  ),
                  label: 'more'.tr)
            ],
            onTap: (value) {
              onTapped(value);
            },
          ),
    ));
  }
}
