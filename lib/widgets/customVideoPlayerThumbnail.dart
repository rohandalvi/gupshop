import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customVideoPlayer.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayerThumbnail extends StatefulWidget {
  final String videoURL;

  CustomVideoPlayerThumbnail({this.videoURL,});

  @override
  _CustomVideoPlayerThumbnailState createState() => _CustomVideoPlayerThumbnailState();
}

class _CustomVideoPlayerThumbnailState extends State<CustomVideoPlayerThumbnail> {
  VideoPlayerController videoPlayerController;
  bool isInitialized = false;

  _initPlayer() async{
    print("in _initPlayer()");
    videoPlayerController = VideoPlayerController.network(widget.videoURL)..initialize()
        .then((_) {
      setState(() {

      });
    });
//    videoPlayerController.initialize()
//        .then((_) {
//      setState(() {
//
//      });
//    });
    
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomVideoPlayerThumbnail oldWidget) {
    /// if a video is sent for the first time in individualchat, then
    /// the initstate would get called and the thumbnail would get generated,
    /// but next time, the old video's thumbnail would show up because the
    /// initstate does not get called again.
    _initPlayer();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _initPlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    /// So, we put the method generating the thunmbnail in build method:
    /// ToDo - _initPlayer() take it out from initstate


    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Card(
          margin: EdgeInsets.all(0.3),
          child: GestureDetector(
            child: videoPlayerController.value.initialized ? AspectRatio(
                aspectRatio:
                //videoPlayerController.value.aspectRatio,
                16/10,
                child: VideoPlayer(videoPlayerController),
            ) : CircularProgressIndicator(),
            onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomVideoPlayer(videoURL:widget.videoURL),//pass Name() here and pass Home()in name_screen
                      //builder: (context) => FullScreenPictureAndVideos(payLoad:widget.videoURL, isPicture: false, shouldZoom: false,),//pass Name() here and pass Home()in name_screen
                    )
                );
            },
          ),
        ),
        CustomIconButton(iconNameInImageFolder: 'playButton', onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomVideoPlayer(videoURL:widget.videoURL),//pass Name() here and pass Home()in name_screen
              )
          );
        },)
      ],
    );
  }
}
