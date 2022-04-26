import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/constants/color_palette.dart';
import '../../../../core/reponsive/SizeConfig.dart';
import '../../../../core/universal_widgets/customized_circular_indicator.dart';

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
  @override
  void initState() {
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: AspectRatio(
          aspectRatio: _controllerThumb.value.aspectRatio,
          child: VideoPlayer(_controllerThumb),
        )),
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
        Center(
          child: Container(
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
          child: Center(
            child: buffer
                ? CustomizedCircularProgress()
                : Icon(
                    state ? Icons.pause : Icons.play_arrow,
                    color: kPureWhite,
                    size: 56 * SizeConfig.heightMultiplier!,
                  ),
          ),
        )
      ],
    );
  }
}
