import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/image/displayPicture.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/video/myVideoThumbnail.dart';
import 'package:gupshop/widgets/customVideoPlayerThumbnail.dart';

class VideoThumbnailHelper extends StatelessWidget {
  final String videoURL;
  final double width;
  final double height;

  VideoThumbnailHelper({this.videoURL, this.height, this.width});


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MyVideoThumbnail(videoURL: videoURL).main(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        if(snapshot.hasData) {
          Image thumbnailImage = snapshot.data.image;
//          final _width = snapshot.data.width;
//          final _height = snapshot.data.height;
//          final _dataSize = snapshot.data.dataSize;


          return Card(
            child: Padding(
              padding:EdgeInsets.all(PaddingConfig.three),
              child: Container(
                width: width ?? 0,
                height: height ?? 0,
                child: Image(
                  image: thumbnailImage.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
            //
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
