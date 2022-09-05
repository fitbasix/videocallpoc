import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/core/universal_widgets/text_Field.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/get_trained/controller/trainer_controller.dart';
import 'package:fitbasix/feature/get_trained/services/trainer_services.dart';
import 'package:fitbasix/feature/get_trained/view/get_trained_screen.dart';
import 'package:fitbasix/feature/get_trained/view/widgets/star_rating.dart';
import 'package:fitbasix/feature/profile/view/appbar_for_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../get_trained/model/all_trainer_model.dart';
import '../../../log_in/view/widgets/black_textfield.dart';

class ReviewPage extends StatefulWidget {
  ReviewPage({
    Key? key,
    required this.name,
    required this.image,
    required this.trainerId,
  }) : super(key: key);

  final String name;
  final String image;
  final String trainerId;

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  double rating = 5;

  final _homeController = Get.find<HomeController>();

  final _trainerController = Get.find<TrainerController>();

  String getRatingMessage() {
    if (rating == 0.5) {
      return 'Terrible';
    } else if (rating == 1.0) {
      return 'Bad';
    } else if (rating == 1.5) {
      return 'Not Bad';
    } else if (rating == 2.0) {
      return 'Okay';
    } else if (rating == 2.5) {
      return 'Above Average';
    } else if (rating == 3.0) {
      return 'Satisfactory';
    } else if (rating == 3.5) {
      return 'Good';
    } else if (rating == 4.0) {
      return 'Very Good';
    } else if (rating == 4.5) {
      return 'Best';
    } else if (rating == 5.0) {
      return 'Excellent';
    } else {
      return 'Worst';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarForAccount(
        title: "Rate and Review",
        onback: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                SizedBox(
                  height: 20 * SizeConfig.heightMultiplier!,
                ),
                Center(
                  child: CircleAvatar(
                    radius: 60 * SizeConfig.heightMultiplier!,
                    backgroundImage: NetworkImage(
                      widget.image,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10 * SizeConfig.heightMultiplier!,
                ),
                Center(
                  child: Text(
                    widget.name.capitalize!,
                    style: AppTextStyle.boldWhiteText
                        .copyWith(fontSize: 18 * SizeConfig.textMultiplier!),
                  ),
                ),
                SizedBox(
                  height: 50 * SizeConfig.heightMultiplier!,
                ),
                Center(
                  child: RatingBar.builder(
                    initialRating: 5,
                    minRating: 0.5,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    glow: false,
                    itemCount: 5,
                    unratedColor: greyBorder,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, rating) => const Icon(
                      Icons.star,
                      color: kgreen49,
                    ),
                    onRatingUpdate: (newRating) {
                      setState(() {
                        rating = newRating;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 27 * SizeConfig.heightMultiplier!,
                ),
                Center(
                  child: Text(
                    getRatingMessage(),
                    style: AppTextStyle.normalWhiteText
                        .copyWith(fontSize: 18 * SizeConfig.textMultiplier!),
                  ),
                ),
                SizedBox(
                  height: 50 * SizeConfig.heightMultiplier!,
                ),
                Padding(
                  padding: EdgeInsets.all(20.0 * SizeConfig.heightMultiplier!),
                  child: Text('Please share your reviews for the trainer',
                      style: AppTextStyle.normalWhiteText.copyWith(
                          fontSize: 14 * SizeConfig.heightMultiplier!)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20 * SizeConfig.widthMultiplier!),
                  child: TextField(
                    controller: _homeController.reviewController,
                    onChanged: (value) {},
                    style: AppTextStyle.hintText.copyWith(color: kPureWhite),
                    textAlignVertical: TextAlignVertical.bottom,
                    maxLines: null,
                    minLines: 5,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(8 * SizeConfig.heightMultiplier!)),
                        borderSide: BorderSide(color: greyBorder, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(8 * SizeConfig.heightMultiplier!)),
                        borderSide: BorderSide(color: greyBorder, width: 1.0),
                      ),
                      isDense: true,
                      counter: Container(
                        height: 0,
                      ),
                      contentPadding: EdgeInsets.only(
                        top: 15 * SizeConfig.heightMultiplier!,
                        bottom: 15 * SizeConfig.heightMultiplier!,
                        left: 15 * SizeConfig.widthMultiplier!,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: InputBorder.none,
                      hintText: 'Write your review',
                      hintStyle: AppTextStyle.hintText.copyWith(
                        color: hintGrey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              Get.dialog(
                  Center(
                    child: CustomizedCircularProgress(),
                  ),
                  barrierDismissible: false);
              var response = await _homeController.postRateAndReview(
                trainerId: widget.trainerId,
                review: _homeController.reviewController.text,
                rating: rating,
              );
              Get.back();
              Get.back();
              _homeController.reviewController.clear();
              rating = 5;
              if (response != null) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Review Added'),
                ));
              }
            },
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.all(20 * SizeConfig.heightMultiplier!),
              padding: EdgeInsets.symmetric(
                horizontal: 20 * SizeConfig.widthMultiplier!,
                vertical: 15 * SizeConfig.heightMultiplier!,
              ),
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(4 * SizeConfig.heightMultiplier!),
                color: kgreen49,
              ),
              alignment: Alignment.center,
              child: Text(
                'Submit',
                style: AppTextStyle.NormalText.copyWith(
                  fontSize: 14 * SizeConfig.textMultiplier!,
                  color: kPureWhite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
