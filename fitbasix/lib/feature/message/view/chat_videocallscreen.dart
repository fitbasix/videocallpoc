import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../core/constants/image_path.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({Key? key}) : super(key: key);

  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final panelController = PanelController();
  String urlimage =
      "https://cdna.artstation.com/p/assets/images/images/034/757/492/large/jorge-hardt-02112021-minimalist-japanese-mobile-hd.jpg?1613135473";
  String avatarImage =
      "http://tricky-photoshop.com/wp-content/uploads/2017/08/6.jpg";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        controller: panelController,
        color: kBlack,
        maxHeight: 132 * SizeConfig.heightMultiplier!,
        minHeight: 35 * SizeConfig.heightMultiplier!,
        panelBuilder: (controller) => PanelWidget(
          panelController: panelController,
          controller: controller,
        ),
        //body
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(urlimage), fit: BoxFit.cover)),
            ),
            Positioned(
              top: 81 * SizeConfig.heightMultiplier!,
              left: 130 * SizeConfig.widthMultiplier!,
              right: 130 * SizeConfig.widthMultiplier!,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      avatarImage,
                    ),
                  ),
                  SizedBox(
                    height: 15 * SizeConfig.heightMultiplier!,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 196 * SizeConfig.heightMultiplier!,
              left: 70 * SizeConfig.widthMultiplier!,
              right: 70 * SizeConfig.widthMultiplier!,
              child: Text(
                'Waiting for Jonathan Swift '
                'to join...',
                style: AppTextStyle.hboldWhiteText,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PanelWidget extends StatefulWidget {
  final ScrollController? controller;
  final PanelController panelController;
   PanelWidget({Key? key,
    this.controller,
    required this.panelController,
  })
      : super(key: key);

  @override
  State<PanelWidget> createState() => _PanelWidgetState();
}

class _PanelWidgetState extends State<PanelWidget> {
bool? ismicon = true;
bool? isspeakeron = true;
bool? iscameraon = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      controller: widget.controller,
      children: [
        SizedBox(
          height: 8 * SizeConfig.heightMultiplier!,
        ),
        buildDragHandle(),
        SizedBox(
          height: 32 * SizeConfig.heightMultiplier!,
        ),
        Padding(
          padding: EdgeInsets.only(
              left: 35 * SizeConfig.widthMultiplier!,
              right: 35 * SizeConfig.widthMultiplier!),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // mic
              ismicon!?IconButton(
                icon: SvgPicture.asset(
                  ImagePath.videomicON,
                  width: 18.67 * SizeConfig.widthMultiplier!,
                  height: 25.33 * SizeConfig.heightMultiplier!,
                  fit: BoxFit.contain,
                ),
                onPressed: () {
                  setState(() {
                    ismicon=!ismicon!;
                  });
                },
              )
              :CircleAvatar(
                backgroundColor: kPureWhite,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      ismicon=!ismicon!;
                    });
                  },
                  icon: SvgPicture.asset(
                    ImagePath.videomicOFF,
                    width: 24 * SizeConfig.widthMultiplier!,
                    height: 25.33 * SizeConfig.heightMultiplier!,
                    color: kPureBlack,
                  ),
                ),
              ),
              // speaker
              isspeakeron!?IconButton(
                icon: SvgPicture.asset(
                  ImagePath.videospeakerON,
                  width: 24 * SizeConfig.widthMultiplier!,
                  height: 23.39 * SizeConfig.heightMultiplier!,
                  fit: BoxFit.contain,
                ),
                onPressed: () {
                  setState(() {
                    isspeakeron=!isspeakeron!;
                  });
                },
              )
              :CircleAvatar(
                backgroundColor: kPureWhite,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      isspeakeron=!isspeakeron!;
                    });
                  },
                  icon: SvgPicture.asset(
                    ImagePath.videospeakerOFF,
                    width: 24 * SizeConfig.widthMultiplier!,
                    height: 24 * SizeConfig.heightMultiplier!,
                    color: kPureBlack,
                  ),
                ),
              ),
              // camera
              iscameraon!?IconButton(
                icon: SvgPicture.asset(
                  ImagePath.videocameraON,
                  width: 24 * SizeConfig.widthMultiplier!,
                  height: 16 * SizeConfig.heightMultiplier!,
                  fit: BoxFit.contain,
                ),
                onPressed: () {
                  setState(() {
                    iscameraon=!iscameraon!;
                  });
                },
              )
              :CircleAvatar(
                backgroundColor: kPureWhite,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      iscameraon=!iscameraon!;
                    });
                  },
                  icon: SvgPicture.asset(
                    ImagePath.videocameraOFF,
                    width: 25.33 * SizeConfig.widthMultiplier!,
                    height: 25.33 * SizeConfig.heightMultiplier!,
                    color: kPureBlack,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildDragHandle() => GestureDetector(
        child: Center(
          child: Container(
            height: 4 * SizeConfig.heightMultiplier!,
            width: 48 * SizeConfig.widthMultiplier!,
            decoration: BoxDecoration(
              color: kPureWhite,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
        onTap: togglePanel,
      );

  Future<void> togglePanel() => widget.panelController.isPanelOpen
      ? widget.panelController.close()
      : widget.panelController.open();
}
