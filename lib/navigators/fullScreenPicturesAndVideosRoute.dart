import 'package:flutter/cupertino.dart';
import 'package:gupshop/image/fullScreenPictureVideos.dart';
import 'package:gupshop/responsive/textConfig.dart';

class FullScreenPicturesAndVideosRoute{

  static Widget main(BuildContext context) {
    Map<String, dynamic> map = ModalRoute.of(context).settings.arguments;

    bool isPicture=map[TextConfig.isPicture];
    String payLoad=map[TextConfig.payLoad];
    bool shouldZoom=map[TextConfig.shouldZoom];

    return FullScreenPictureAndVideos(
      isPicture: isPicture,
      payLoad: payLoad,
      shouldZoom: shouldZoom,
    );
  }

}