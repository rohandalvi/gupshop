import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/image/imageZoom.dart';

class DisplayVideo extends StatelessWidget {
  final String videoURL;

  DisplayVideo({this.videoURL});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.height / 1.25,
      height: MediaQuery.of(context).size.width / 1.25,
      /// for zoom:
      child: new ImageZoom(
        new NetworkImage(videoURL),
        placeholder: Center(child: CircularProgressIndicator(),),
        //fit: BoxFit.contain,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
    );
  }

  zoomableFullScreen(context){

  }
}