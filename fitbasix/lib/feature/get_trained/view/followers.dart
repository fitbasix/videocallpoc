import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/feature/get_trained/model/followersModel.dart';
import 'package:fitbasix/feature/get_trained/services/trainer_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FollowersList extends StatefulWidget {
  final String id;
  final int index;
  const FollowersList({Key? key, required this.id, required this.index})
      : super(key: key);

  @override
  State<FollowersList> createState() => _FollowersListState();
}

class _FollowersListState extends State<FollowersList> {
  final ScrollController _scrollController = ScrollController();
  RxInt currentPage = 1.obs;
  RxBool loadingIndicator = false.obs;
  RxList<Datum> list = <Datum>[].obs;

  @override
  void initState() {
    onInit();
    super.initState();
    _scrollController.addListener(() async {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        loadingIndicator.value = true;
        final postQuery = await TrainerServices.getFollowers(
            id: widget.id,
            currentPage: currentPage.value * 5,
            index: widget.index);
        list.addAll(postQuery!.response.data);
        currentPage.value++;
        if (postQuery.response.data.length < 5) {
          list.addAll(postQuery.response.data);
          loadingIndicator.value = false;
          //return;
        } else {
          if (list.last.id == postQuery.response.data.last.id) {
            loadingIndicator.value = false;
            //return;
          }
          list.addAll(postQuery.response.data);
        }

        loadingIndicator.value = false;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  onInit() async {
    currentPage.value = 1;
    loadingIndicator.value = true;
    final postQuery = await TrainerServices.getFollowers(
        id: widget.id, currentPage: currentPage.value, index: widget.index);
    list.addAll(postQuery!.response.data);
    currentPage.value++;
    loadingIndicator.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPureBlack,
        title: Text(widget.index == 0 ? "Followers" : "Followings"),
      ),
      body: Obx(() => Stack(
            children: [
              Obx(() => list.isEmpty
                  ? Container()
                  : ListView.builder(
                      itemCount: (list).length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.only(
                              left: 16 * SizeConfig.widthMultiplier!,
                              right: 16 * SizeConfig.widthMultiplier!,
                              top: 16 * SizeConfig.heightMultiplier!,
                              bottom: 12 * SizeConfig.heightMultiplier!),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 40 * SizeConfig.heightMultiplier!,
                                width: 40 * SizeConfig.widthMultiplier!,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      40 * SizeConfig.heightMultiplier!),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: list[index].user.profilePhoto,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 12 * SizeConfig.widthMultiplier!,
                              ),
                              Column(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    list[index].user.name,
                                    style: AppTextStyle.black600Text.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .color),
                                  ),
                                  // SizedBox(
                                  //   height: 8 * SizeConfig.heightMultiplier!,
                                  // ),
                                  // Row(
                                  //   children: [
                                  //     Text(
                                  //       'User',
                                  //       style: AppTextStyle.black400Text.copyWith(
                                  //           fontSize: (12) * SizeConfig.textMultiplier!,
                                  //           color: Theme.of(context)
                                  //               .textTheme
                                  //               .headline1!
                                  //               .color),
                                  //     ),
                                  //   ],
                                  // )
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    )),
              loadingIndicator.value == true
                  ? Center(child: CustomizedCircularProgress())
                  : Container()
            ],
          )),
    );
  }
}
