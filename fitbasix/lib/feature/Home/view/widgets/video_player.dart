import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../core/constants/color_palette.dart';
import '../../../../core/reponsive/SizeConfig.dart';
import '../../../../core/universal_widgets/customized_circular_indicator.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoPlayerContainer extends StatefulWidget {
  const VideoPlayerContainer({Key? key, required this.videoUrl})
      : super(key: key);
  final String videoUrl;

  @override
  State<VideoPlayerContainer> createState() => _VideoPlayerContainerState();
}

class _VideoPlayerContainerState extends State<VideoPlayerContainer> {
  late VideoPlayerController _controller;
  late VideoPlayerController _controllerThumb;
  bool state = false;
  bool buffer = false;
  Uint8List? thumbnail;
  GlobalKey _key = GlobalKey();
  @override
  void initState() {
    getThumbnail();
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _controllerThumb = VideoPlayerController.network(widget.videoUrl);

    _controller.addListener(() {
      setState(() {
        state = _controller.value.isPlaying;
        buffer = _controller.value.isBuffering;
      });
    });
    _controller.initialize();
    _controllerThumb.initialize();
  }

  getThumbnail() async {
    thumbnail = await VideoThumbnail.thumbnailData(
      video: widget.videoUrl,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 25,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerThumb.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //Positioned.fill(child: Image.memory(thumbnail!)),
        Positioned.fill(child: Container(
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controllerThumb),
          ),
        ),),
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              width: 360*SizeConfig.widthMultiplier!,
              height: 360*SizeConfig.heightMultiplier!,
            ),
          ),
        ),
        VisibilityDetector(
          onVisibilityChanged: (VisibilityInfo info) {
            if (info.visibleFraction == 0 && this.mounted) {
              _controller.pause();
            }
            else{
              _controller.play();
            }
          },
          key: _key,
          child: Center(
            child: Container(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
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
          child: Center(
            child: buffer
                ? CustomizedCircularProgress()
                : !state ?Icon(
                    //state ? Icons.pause :
                    Icons.play_arrow,
                    color: kPureWhite,
                    size: 56 * SizeConfig.heightMultiplier!,
                  ):Container(),
          ),
        )
      ],
    );
  }
}
