import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:math';

class CustomVideoPlayer extends StatefulWidget {
  String videoURL;
  //final VideoPlayerController controller;

  CustomVideoPlayer({this.videoURL});

  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState(videoURL: videoURL);
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  String videoURL;
  //final VideoPlayerController controller;

  _CustomVideoPlayerState({this.videoURL});

  VideoPlayerController controller;
  Future<void> _initializeVideoPlayerFuture;

  var range;
  var number;

  @override
  void initState() {
    print("controller in _CustomVideoPlayerState: $controller");
    controller = VideoPlayerController.network(videoURL);
    _initializeVideoPlayerFuture = controller.initialize();
    controller.setVolume(1.0);

    range = new Random();
    number = new List.generate(12, (_) => range.nextInt(100));// TODO: check if this is correct


    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 250,
      child: Stack(
        children: <Widget>[
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                return AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: VideoPlayer(controller),
                );
              } return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          FloatingActionButton(
            heroTag: "btn $number",
            onPressed: () {
              // Wrap the play or pause in a call to `setState`. This ensures the
              // correct icon is shown
              setState(() {
                // If the video is playing, pause it.
                print("controller: ${controller.value}");
                if (controller.value.isPlaying) {
                  controller.pause();
                } else {
                  // If the video is paused, play it.
                  controller.play();
                }
              });
            },
            // Display the correct icon depending on the state of the player.
            child: Icon(
              controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          ),
        ],
      ),
    );
  }
}
