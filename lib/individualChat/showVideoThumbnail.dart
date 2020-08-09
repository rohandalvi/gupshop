import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/widgets/customVideoPlayerThumbnail.dart';

class ShowVideoThumbnail extends StatelessWidget {
  final String videoURL;

  ShowVideoThumbnail({this.videoURL});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.height / 2.75,
          height: MediaQuery.of(context).size.width / 2.25,
          child: Card(
            child: CustomVideoPlayerThumbnail(videoURL: videoURL,),
          ),
        ),

      ],
    );
  }
}
