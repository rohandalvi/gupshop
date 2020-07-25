import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/service/fullScreenPictureVideos.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customVideoPlayer.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayerThumbnail extends StatefulWidget {
  final String videoURL;
  final bool shouldZoom;

  CustomVideoPlayerThumbnail({this.videoURL, this.shouldZoom});

  @override
  _CustomVideoPlayerThumbnailState createState() => _CustomVideoPlayerThumbnailState();
}

class _CustomVideoPlayerThumbnailState extends State<CustomVideoPlayerThumbnail> {
  VideoPlayerController videoPlayerController;

  _initPlayer() async{
    videoPlayerController = VideoPlayerController.network(widget.videoURL);
    /// Ensure the first frame is shown after the video is initialized,
    /// even before the play button has been pressed
    await videoPlayerController.initialize();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }


  @override
  void initState() {
    _initPlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Card(
          margin: EdgeInsets.all(0.3),
          child: GestureDetector(
            child: AspectRatio(
                aspectRatio:
                //videoPlayerController.value.aspectRatio,
                16/10,
                child: VideoPlayer(videoPlayerController),
            ),
            onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomVideoPlayer(videoURL:widget.videoURL,shouldZoom: false,),//pass Name() here and pass Home()in name_screen
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
                builder: (context) => CustomVideoPlayer(videoURL:widget.videoURL,shouldZoom: false,),//pass Name() here and pass Home()in name_screen
              )
          );
        },)
      ],
    );
  }
}
