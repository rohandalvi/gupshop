import 'package:flutter/cupertino.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/widgets/customVideoPlayer.dart';

class CustomVideoPlayerRoute{

  static Widget main(BuildContext context) {
    Map<String, dynamic> map = ModalRoute.of(context).settings.arguments;

    final String videoURL=map[TextConfig.videoURL];

    return CustomVideoPlayer(
        videoURL:videoURL,
    );
  }

}