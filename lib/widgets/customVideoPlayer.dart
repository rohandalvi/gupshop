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
    videoPlayerController.setLooping(true);
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

    /// for scrolling the video ahead and back we need to add a listener
    videoPlayerController.addListener(() {
      setState(() {
        _playBackTime = videoPlayerController.value.position.inSeconds;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    //print("videoPlayerController : ${videoPlayerController.value}");
    return Scaffold(
      body: videoPlayerController.value.initialized ? videoPlayerWidget(): Center(child: CircularProgressIndicator(),),
//      floatingActionButton: CustomFloatingActionButton(
//        heroTag: "btn $number",
//        child: videoPlayerController.value.isPlaying ? pause() : play(),
//        onPressed: (){
//          videoPlayerController.value.isPlaying ? videoPlayerController.pause() : videoPlayerController.play();
//          setState(() {
//          });
//        },
//      ),
//      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  play(){
    return CustomIconButton(
      iconNameInImageFolder: 'youtubePlay',
      onPressed:(){
        videoPlayerController.play();
      setState(() {
      });
    },
    );
  }

//  pause(){
//    return IconButton(icon: SvgPicture.asset('images/pauseButton.svg',));
//  }

  videoPlayerWidget(){
    print("videoPlayerController.value.isPlaying : ${videoPlayerController.value.isPlaying}");
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Stack(
          //alignment: Alignment.bottomLeft,
          children: <Widget>[
            GestureDetector(
              child: AspectRatio(
                aspectRatio: videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(videoPlayerController)
                ),
              onTap: (){
                if(videoPlayerController.value.isPlaying){
                  setState(() {
                    videoPlayerController.pause();
                  });
                } else videoPlayerController.play();/// this means even if the user taps the video, the video plays if not playing already instead of pressing the play button
              },
            ),
            Visibility(
              visible: widget.shouldZoom,
              child: CustomIconButton(
                iconNameInImageFolder: 'fullScreen',
                onPressed: (){
                  /// to stop the video from playing in background when then the
                  /// user navigates to ViewPicturesVideosFromChat
                  if (videoPlayerController.value.isPlaying) {
                    videoPlayerController.pause();
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewPicturesFromChat(payLoad: widget.videoURL, isPicture: false, shouldZoom: false,),//pass Name() here and pass Home()in name_screen
                      )
                  );
              },)
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Visibility(
                visible: videoPlayerController.value.isPlaying == false,
                child: play(),
              ),
            ),
          ],
        ),
        Slider(
          activeColor: Colors.black38,
          inactiveColor: Colors.black38,
          value: _playBackTime.toDouble(),
          max: videoPlayerController.value.initialized ? videoPlayerController.value.duration.inSeconds.toDouble() : 0,
          min: 0,
          onChanged: (v){
            videoPlayerController.seekTo(Duration(seconds: v.toInt()));
          },
        ),
      ],
    );
  }
}

