import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/feature/posts/controller/post_controller.dart';
import 'package:fitbasix/feature/posts/model/category_model.dart';
import 'package:fitbasix/feature/posts/services/createPost_Services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shimmer/shimmer.dart';

class SelectCategoryDialog extends StatelessWidget {
  const SelectCategoryDialog({Key? key, required this.category})
      : super(key: key);

  final List<Category> category;

  @override
  Widget build(BuildContext context) {
    final PostController _postController = Get.put(PostController());
    return Dialog(
      insetPadding: EdgeInsets.all(70 * SizeConfig.widthMultiplier!),
      backgroundColor: Colors.white,
      insetAnimationDuration: const Duration(milliseconds: 100),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 30 * SizeConfig.heightMultiplier!,
                  ),
                  Text(
                    'category'.tr,
                    style: AppTextStyle.boldBlackText
                        .copyWith(fontSize: 14 * SizeConfig.textMultiplier!),
                  ),
                  SizedBox(
                    height: 30 * SizeConfig.heightMultiplier!,
                  ),
                  Obx(
                    () => _postController.categories.length == 0
                        ? Center(
                            child: CustomizedCircularProgress(),
                          )
                        : Column(
                            children: [
                              for (int index = 0;
                                  index < category.length;
                                  index++)
                                GestureDetector(
                                  onTap: () async {
                                    _postController.selectedCategory.value =
                                        category[index];
                                    Navigator.pop(context);
                                    _postController.postData.value =
                                        await CreatePostService.createPost(
                                            postId:
                                                _postController.postId.value,
                                            category: _postController
                                                .selectedCategory
                                                .value
                                                .serialId);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        bottom:
                                            10 * SizeConfig.heightMultiplier!),
                                    height: 28 * SizeConfig.heightMultiplier!,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: hintGrey,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            8 * SizeConfig.heightMultiplier!)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              12 * SizeConfig.widthMultiplier!,
                                          vertical:
                                              5 * SizeConfig.heightMultiplier!),
                                      child: Text(
                                        category[index].name.toString(),
                                        style: AppTextStyle.smallGreyText
                                            .copyWith(color: hintGrey),
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          ),
                  ),
                  SizedBox(
                    height: 30 * SizeConfig.heightMultiplier!,
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
