import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/video/myVideoThumbnail.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customVideoPlayer.dart';

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


          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Card(
                child: Padding(
                  padding:EdgeInsets.all(PaddingConfig.three),
                  child: Container(
                    width: width,
                    height: height,
                    child: Image(
                      image: thumbnailImage.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              CustomIconButton(iconNameInImageFolder: IconConfig.playButton,
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomVideoPlayer(videoURL:videoURL),//pass Name() here and pass Home()in name_screen
                      )
                  );
                },)
            ],
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
