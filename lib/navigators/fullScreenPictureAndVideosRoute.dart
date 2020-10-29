import 'package:flutter/cupertino.dart';
import 'package:gupshop/image/fullScreenPictureVideos.dart';
import 'package:gupshop/responsive/textConfig.dart';

class FullScreenPictureAndVideosRoute{


  static Widget main(BuildContext context){
    Map<String,dynamic> map = ModalRoute.of(context).settings.arguments;
    final String payLoad = map[TextConfig.payLoad];
    final bool isPicture = map[TextConfig.isPicture];

    return FullScreenPictureAndVideos(
      payLoad: payLoad,
      isPicture: isPicture,);
  }
}