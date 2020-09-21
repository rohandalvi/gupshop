import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/image/displayPicture.dart';
import 'package:gupshop/video/myVideoThumbnail.dart';

class VideoThumbnailHelper extends StatelessWidget {
  final String videoURL;

  VideoThumbnailHelper({this.videoURL});


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MyVideoThumbnail(videoURL: videoURL).main(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        if(snapshot.hasData) {
          Image _image = snapshot.data.image;
          final _width = snapshot.data.width;
          final _height = snapshot.data.height;
          final _dataSize = snapshot.data.dataSize;

          return DisplayPicture().hack(context, _image);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
//        if (snapshot.connectionState == ConnectionState.done) {
//          print("snapshot.data in videoThumbnailHelper : ${snapshot}");
//          String thumbnail = snapshot.data;
//          return DisplayPicture(imageURL: thumbnail,).chatPictureFrame(context);
//        }
//        return Center(
//          child: CircularProgressIndicator(),
//        );
      },
    );
  }
}
