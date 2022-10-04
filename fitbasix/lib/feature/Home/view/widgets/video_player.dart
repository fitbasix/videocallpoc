import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../core/constants/color_palette.dart';
import '../../../../core/reponsive/SizeConfig.dart';
import '../../../../core/universal_widgets/customized_circular_indicator.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../controller/Home_Controller.dart';

class VideoPlayerContainer extends StatefulWidget {
  const VideoPlayerContainer({Key? key, required this.videoUrl})
      : super(key: key);
  final String videoUrl;

  @override
  State<VideoPlayerContainer> createState() => _VideoPlayerContainerState();
}

class _VideoPlayerContainerState extends State<VideoPlayerContainer> {
  final HomeController _homeController = Get.find();
  late VideoPlayerController _controller;
  bool videoIsMute = false;

  bool state = false;
  bool buffer = false;
  Uint8List? thumbnail;
  final GlobalKey _key = GlobalKey();
  Rx<double> videoProgress = 0.05.obs;
  Rx<int> videoLength = 1.obs;

  @override
  void initState() {
    // getThumbnail();
    super.initState();
    try {
      _controller = VideoPlayerController.network(widget.videoUrl)
        ..addListener(() {
          videoProgress.value = ((_controller.value.isPlaying
                  ? _controller.value.position.inSeconds
                  : 0.0) /
              videoLength.value);

          setState(() {
            state = _controller.value.isPlaying;
            buffer = _controller.value.isBuffering;
          });
        })
        ..initialize().then((value) {
          videoLength.value = _controller.value.duration.inSeconds;
          setState(() {});
        });
    } catch (e) {
      print("error here: " + e.toString());
    }
  }

  getThumbnail() async {
    thumbnail = await VideoThumbnail.thumbnailData(
      video: widget.videoUrl,
      imageFormat: ImageFormat.PNG,
      maxWidth: Get.width
          .toInt(), // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 25,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _homeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //Positioned.fill(child: Image.memory(thumbnail!)),
        // Positioned.fill(
        //   child: AspectRatio(
        //     aspectRatio: _controller.value.aspectRatio,
        //     child: VideoPlayer(_controllerThumb),
        //   ),
        // ),
        // ClipRect(
        //   child: BackdropFilter(
        //     filter: ImageFilter.blur(
        //         sigmaX: 10.0, sigmaY: 10.0),
        //     child: Container(
        //       width: 360*SizeConfig.widthMultiplier!,
        //       height: 360*SizeConfig.heightMultiplier!,
        //     ),
        //   ),
        // ),
        VisibilityDetector(
          onVisibilityChanged: (VisibilityInfo info) {
            if ((info.visibleFraction == 0 || info.visibleFraction < 0.6) &&
                this.mounted) {
              _controller.setVolume(_homeController.videoPlayerVolume.value);
              _controller.pause();
            }
            if (info.visibleFraction == 1 || info.visibleFraction > 0.6) {
              _controller.setVolume(_homeController.videoPlayerVolume.value);
              _controller.play();
            }
          },
          key: _key,
          child: Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Center(
              child: buffer
                  ? CustomizedCircularProgress()
                  : !state
                      ? Icon(
                          //state ? Icons.pause :
                          Icons.play_arrow,
                          color: kPureWhite,
                          size: 56 * SizeConfig.heightMultiplier!,
                        )
                      : Container(),
            ),
          ),
        ),
        AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: GestureDetector(
            onTap: () {
              if (_homeController.videoPlayerVolume.value == 0.0) {
                _homeController.videoPlayerVolume.value = 1.0;
              } else {
                _homeController.videoPlayerVolume.value = 0.0;
              }
              _controller.setVolume(_homeController.videoPlayerVolume.value);
            },
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                color: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.all(8.0 * SizeConfig.widthMultiplier!),
                  child: Obx(
                    () => CircleAvatar(
                      radius: 9.5 * SizeConfig.heightMultiplier!,
                      backgroundColor: Colors.black.withOpacity(0.5),
                      child: Icon(
                        //state ? Icons.pause :
                        _homeController.videoPlayerVolume.value == 0.0
                            ? Icons.volume_off
                            : Icons.volume_up,
                        color: kPureWhite,
                        size: 13 * SizeConfig.heightMultiplier!,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Obx(
          () => AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: LinearProgressIndicator(
                value: videoProgress.value,
                minHeight: 5 * SizeConfig.heightMultiplier!,
                color: kBlack.withOpacity(0.7),
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
