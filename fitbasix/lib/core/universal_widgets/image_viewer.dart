import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/feature/chat_firebase/view/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatelessWidget {
  final String label;
  final String imgUrl;
  const ImageViewer({Key? key, required this.label, required this.imgUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPureBlack,
      ),
      extendBodyBehindAppBar: false,
      body: SizedBox(
          height: double.maxFinite,
          child: Hero(
            tag: imgUrl,
            child: PhotoView(
              imageProvider: CachedNetworkImageProvider(imgUrl),
              backgroundDecoration: const BoxDecoration(color: kPureBlack),
            ),
          )),
    );
  }
}