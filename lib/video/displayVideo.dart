import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/image/displayCircularPicture.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/widgets/customVideoPlayerThumbnail.dart';

class DisplayVideo extends StatelessWidget {
  final String videoURL;
  final double width;
  final double height;

  DisplayVideo({this.videoURL, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width == null ? WidgetConfig.sizedBoxWidthFiveHundred : width,
      height: height == null ? WidgetConfig.sizedBoxHeightThreeHundred : height,
      child: CustomVideoPlayerThumbnail(videoURL: videoURL,),
    );
  }

}