import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class DiscardPostBottomSheet extends StatelessWidget {
  const DiscardPostBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 235 * SizeConfig.heightMultiplier!,
      color: Colors.white,
      padding: EdgeInsets.only(
          top: 32 * SizeConfig.heightMultiplier!,
          left: 16 * SizeConfig.widthMultiplier!,
          right: 16 * SizeConfig.widthMultiplier!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'discard_post_title'.tr,
            style: AppTextStyle.boldBlackText
                .copyWith(fontSize: 14 * SizeConfig.textMultiplier!),
          ),
          SizedBox(
            height: 8 * SizeConfig.heightMultiplier!,
          ),
          Text(
            'discard_post_subtitle'.tr,
            style: AppTextStyle.normalBlackText
                .copyWith(fontSize: 12 * SizeConfig.textMultiplier!),
          ),
          SizedBox(
            height: 31 * SizeConfig.heightMultiplier!,
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.create),
            label: Text(
              'continue_editing'.tr,
              style: AppTextStyle.boldBlackText
                  .copyWith(fontSize: 14 * SizeConfig.textMultiplier!),
            ),
            style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap),
          ),
          SizedBox(
            height: 20 * SizeConfig.heightMultiplier!,
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.delete_outline),
            label: Text(
              'discard_post'.tr,
              style: AppTextStyle.boldBlackText
                  .copyWith(fontSize: 14 * SizeConfig.textMultiplier!),
            ),
            style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap),
          ),
        ],
      ),
    );
  }
}
