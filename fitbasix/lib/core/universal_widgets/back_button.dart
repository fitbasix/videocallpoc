import 'package:fitbasix/core/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          height: 16,
          width: 16,
          color: Colors.transparent,
          child: SvgPicture.asset(
            ImagePath.backIcon,
          ),
        ));
  }
}
