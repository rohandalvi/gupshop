import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/service/viewPicturesFromChat.dart';
import 'package:video_player/video_player.dart';
import 'dart:math';

/// videoURL goes to VideoPlayerController controller = VideoPlayerController.network(videoURL);
/// and then this controller
/// is displayed in VideoPlayer(controller)
class CustomVideoPlayerTwo extends StatefulWidget {
  String videoURL;
  final double width;
  final double height;
  //final VideoPlayerController controller;

  CustomVideoPlayerTwo({this.videoURL ,this.width, this.height});

  @override
  _CustomVideoPlayerStateTwo createState() => _CustomVideoPlayerStateTwo(videoURL: videoURL, width: width, height: height);
}

class _CustomVideoPlayerStateTwo extends State<CustomVideoPlayerTwo> {
  String videoURL;
  double width;
  double height;
  //final VideoPlayerController controller;

  _CustomVideoPlayerStateTwo({this.videoURL,this.width, this.height});

  VideoPlayerController videoController;
  Future<void> _initializeVideoPlayerFuture;

  var range;
  var number;

  @override
  void initState() {
    videoController = VideoPlayerController.network(videoURL);
    _initializeVideoPlayerFuture = videoController.initialize();
    videoController.setVolume(1.0);

    range = new Random();
    number = new List.generate(12, (_) => range.nextInt(100));// TODO: check if this is correct


    super.initState();
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
//      width: 250,
//      height: 250,
      decoration: BoxDecoration(),
      child: Stack(
        children: <Widget>[
          GestureDetector(
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  return FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: width == null ? 240 : width,
                      height: height == null ? 190 : height,
                      child: VideoPlayer(videoController),
                    ),
                  );
                  /// FittedBox is used in placed of
                  ///                  AspectRatio(
                  ///                  aspectRatio: controller.value.aspectRatio,
                  ///                 child: VideoPlayer(controller),
                  ///                );
                } return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            onTap: (){
              /// to stop the video from playing in background when then the
              /// user navigates to ViewPicturesVideosFromChat
              if (videoController.value.isPlaying) {
                videoController.pause();
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewPicturesFromChat(payLoad: videoURL, isPicture: false,),//pass Name() here and pass Home()in name_screen
                  )
              );
            },
          ),
          FloatingActionButton(
            heroTag: "btn $number",
            onPressed: () {
              /// Wrap the play or pause in a call to `setState`. This ensures the
              /// correct icon is shown
              setState(() {
                /// If the video is playing, pause it.
                if (videoController.value.isPlaying) {
                  videoController.pause();
                } else {
                  // If the video is paused, play it.
                  videoController.play();
                }
              });
            },
            /// Display the correct icon depending on the state of the player.
            child: Icon(
              videoController.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          ),
        ],
      ),
    );
  }
}