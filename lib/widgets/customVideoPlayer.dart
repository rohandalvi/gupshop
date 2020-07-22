import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gupshop/service/viewPicturesFromChat.dart';
import 'package:gupshop/widgets/customFloatingActionButton.dart';
import 'package:video_player/video_player.dart';
import 'dart:math';


class CustomVideoPlayer extends StatefulWidget {
  String videoURL;
  bool shouldZoom;

  CustomVideoPlayer({this.videoURL, this.shouldZoom});

  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController videoPlayerController;
  int _playBackTime = 0;

  _initPlayer(){
    videoPlayerController = VideoPlayerController.network(widget.videoURL);
    videoPlayerController.initialize();
    setState(() {

    });
  }


  @override
  void initState() {
    _initPlayer();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: videoPlayerWidget(),
      floatingActionButton: CustomFloatingActionButton(
        child: videoPlayerController.value.isPlaying ? pause() : play(),
        onPressed: (){
          videoPlayerController.value.isPlaying ? videoPlayerController.pause() : videoPlayerController.play();
          setState(() {
          });
        },
      ),
    );
  }

  play(){
    return IconButton(icon: SvgPicture.asset('images/playButton.svg',));
  }

  pause(){
    return IconButton(icon: SvgPicture.asset('images/pauseButton.svg',));
  }

  videoPlayerWidget(){
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          child: AspectRatio(
            aspectRatio: videoPlayerController.value.aspectRatio,
              child: VideoPlayer(videoPlayerController)
            ),
          onTap: (){
            /// to stop the video from playing in background when then the
            /// user navigates to ViewPicturesVideosFromChat
            if (videoPlayerController.value.isPlaying) {
              videoPlayerController.pause();
            }
            if(widget.shouldZoom != null && widget.shouldZoom == true){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewPicturesFromChat(payLoad: widget.videoURL, isPicture: false, shouldZoom: false,),//pass Name() here and pass Home()in name_screen
                  )
              );
            }
          },
        ),
//        Slider(
//
//        ),
      ],
    );
  }
}

