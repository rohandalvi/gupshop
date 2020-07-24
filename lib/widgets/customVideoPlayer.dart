import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gupshop/service/viewPicturesFromChat.dart';
import 'package:gupshop/widgets/customFloatingActionButton.dart';
import 'package:gupshop/widgets/customIconButton.dart';
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

  var range;
  var number;

  _initPlayer() async{
    videoPlayerController = VideoPlayerController.network(widget.videoURL);
    /// Ensure the first frame is shown after the video is initialized,
    /// even before the play button has been pressed
    await videoPlayerController.initialize();
    setState(() {

    });
    //videoPlayerController.setLooping(true);
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }


  @override
  void initState() {
    /// first there would arise an error:
    /// There are multiple heroes that share the same tag within a subtree.
    /// To remove this:
    range = new Random();
    number = new List.generate(12, (_) => range.nextInt(100));// TODO: check if this is correct


    _initPlayer();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return videoPlayerWidget();
  }

  videoPlayerWidget(){
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            child: AspectRatio(
              aspectRatio:videoPlayerController.value.aspectRatio,
              //16/9,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    VideoPlayer(videoPlayerController),
                    VideoProgressIndicator(videoPlayerController, allowScrubbing: true,),
                  ],
                )
              ),
            onTap: (){
                if(videoPlayerController.value.isPlaying){
                  videoPlayerController.pause();
                }else {
                videoPlayerController.play();/// this means even if the user taps the video, the video plays if not playing already instead of pressing the play button
                }
            },
          ),
        ],
      ),
    );
  }

  videoPlayerThumbnail(){

  }
}

