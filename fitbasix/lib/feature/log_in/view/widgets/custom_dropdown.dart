import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/feature/log_in/controller/login_controller.dart';
import 'package:fitbasix/feature/log_in/model/countries_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SimpleAccountMenu extends StatefulWidget {
  final List<CountryData> listofItems;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  CountryData? hint;
  final ValueChanged<CountryData> onChange;

  SimpleAccountMenu({
    Key? key,
    required this.borderRadius,
    required this.listofItems,
    this.backgroundColor = const Color(0xFFF67C0B9),
    this.hint,
    required this.onChange,
  }) : super(key: key);
  @override
  SimpleAccountMenuState createState() => SimpleAccountMenuState();
}

class SimpleAccountMenuState extends State<SimpleAccountMenu>
    with SingleTickerProviderStateMixin {
  GlobalKey<SimpleAccountMenuState> globalKey = GlobalKey();
  GlobalKey? _key;
  bool isMenuOpen = false;
  Offset? buttonPosition;
  Size? buttonSize;
  OverlayEntry? _overlayEntry;
  BorderRadius? _borderRadius;
  AnimationController? _animationController;
  final LoginController _loginController = Get.put(LoginController());
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _borderRadius = widget.borderRadius;
    _key = LabeledGlobalKey("button_icon");
    super.initState();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  findButton() {
    RenderBox renderBox = _key!.currentContext!.findRenderObject() as RenderBox;
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

  void closeMenu() {
    _overlayEntry!.remove();
    _animationController!.reverse();
    isMenuOpen = !isMenuOpen;
  }

  void openMenu() {
    findButton();
    _animationController!.forward();
    _overlayEntry = _overlayEntryBuilder();
    Overlay.of(context)!.insert(_overlayEntry!);
    isMenuOpen = !isMenuOpen;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.borderRadius);
    return Container(
        key: _key,
        decoration: BoxDecoration(
          // color: const Color(0xfff5c6373),
          borderRadius: _borderRadius,
        ),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (isMenuOpen) {
                  closeMenu();
                } else {
                  openMenu();
                }
              },
              child: Padding(
                padding: EdgeInsets.only(
                  left: 14*SizeConfig.widthMultiplier!,
                  right: 14*SizeConfig.widthMultiplier!
                ),
                child: SvgPicture.network(
                  widget.hint?.flag == null
                      ? 'https://upload.wikimedia.org/wikipedia/en/4/41/Flag_of_India.svg'
                      : widget.hint!.flag!,
                  width: 24.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                if (isMenuOpen) {
                  closeMenu();
                } else {
                  openMenu();
                }
              },
              child: const Icon(
                Icons.keyboard_arrow_down,
                color: greyB7,
              ),
            )
          ],
        ));
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: buttonPosition!.dy + 10,
          left: buttonPosition!.dx+12,
          width: buttonSize!.width,
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 45),
                    child: ClipPath(
                      clipper: ArrowClipper(),
                      child: Container(
                        width: 17,
                        height: 17,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Container(
                    width: 82.w,
                    height: 74.h,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: _borderRadius,
                    ),
                    child: Theme(
                      data: ThemeData(
                        iconTheme: const IconThemeData(
                          color: Colors.white,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:
                            List.generate(widget.listofItems.length, (index) {
                          return GestureDetector(
                              onTap: () {
                                _loginController.selectedCountry.value =
                                    widget.listofItems[index];
                                closeMenu();
                              },
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.network(
                                    widget.listofItems[index].flag!,
                                    width: 24,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ));
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, size.height / 2);
    path.lineTo(size.width, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
