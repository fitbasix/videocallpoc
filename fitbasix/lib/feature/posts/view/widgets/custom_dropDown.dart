import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/feature/posts/controller/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fitbasix/feature/log_in/model/countries_model.dart';
import 'package:photo_manager/photo_manager.dart';

Widget customDropDownBtn({
  String? label,
  VoidCallback? onPressed,
  //TODO change this logic to a cleaner way in future
  // must pass to make onOptionPressed work
  PostController? controller,
  required bool isExpanded,
  List<AssetPathEntity>? options,
  Color? color,
}) {
  return isExpanded
      ? SizedBox(
          width: 180 * SizeConfig.widthMultiplier!,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                children: [
                  Container(
                    height: 35 * SizeConfig.heightMultiplier!,
                  ),
                  Container(
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.10),
                          blurRadius: 7,
                          spreadRadius: 5,
                          offset: Offset(0, 3))
                    ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int i = 0; i < options!.length; i++)
                          GestureDetector(
                            // ignore: void_checks
                            onTap: () async {
                              DefaultCacheManager manager =
                                  new DefaultCacheManager();
                              var file = await manager
                                  .getFileFromMemory("330581640967182");
                              print("lll" + file.toString());
                              await manager.emptyCache();
                              imageCache!.clear();
                              imageCache!.clearLiveImages();
                              PaintingBinding.instance!.imageCache!.clear();
                              await controller!.setFolderIndex(
                                index: i,
                              );
                              controller.toggleDropDownExpansion();
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                i == 0
                                    ? Container(
                                        height:
                                            5 * SizeConfig.heightMultiplier!,
                                      )
                                    : Container(
                                        height:
                                            10 * SizeConfig.heightMultiplier!,
                                      ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 16),
                                        child: Text(options[i].name,
                                            style: AppTextStyle.titleText
                                                .copyWith(
                                                    fontSize: 16 *
                                                        SizeConfig
                                                            .textMultiplier!)),
                                      ),
                                    ),
                                  ],
                                ),
                                i == options.length - 1
                                    ? Container(
                                        height: 25,
                                      )
                                    : Container()
                                // if (i == 0)
                                //   const Divider(
                                //     color: Colors.transparent,
                                //   )
                                // else if (i <= options.length - 2)
                                //   const Divider(
                                //     color: Colors.blue,
                                //   )
                                // else
                                //   Container(),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              _DropDownTopHeader(
                color: color,
                onTap: onPressed,
                label: label,
                isExpanded: isExpanded,
              ),
            ],
          ),
        )
      : _DropDownTopHeader(
          color: color,
          onTap: onPressed,
          isExpanded: isExpanded,
          label: label,
        );
}

// Persistent Dropdown header
class _DropDownTopHeader extends StatelessWidget {
  const _DropDownTopHeader({
    Key? key,
    required this.color,
    required this.label,
    required this.isExpanded,
    required this.onTap,
  }) : super(key: key);

  final Color? color;
  final String? label;
  final bool isExpanded;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180 * SizeConfig.widthMultiplier!,
        height: 40 * SizeConfig.heightMultiplier!,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                label!,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.titleText
                    .copyWith(fontSize: 16 * SizeConfig.textMultiplier!),
              ),
            ),
            SizedBox(
              width: 12,
            ),
            // if (isExpanded)
            //   Icon(
            //     Icons.keyboard_arrow_up_rounded,
            //     color: Colors.black,
            //     size: 36,
            //   )
            // else
            //   Icon(
            //     Icons.keyboard_arrow_down_rounded,
            //     color: Colors.black,
            //     size: 36,
            //   ),
          ],
        ),
      ),
    );
  }
}
