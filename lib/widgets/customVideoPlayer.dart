import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:video_player/video_player.dart';
import 'dart:math';


class CustomVideoPlayer extends StatefulWidget {
  final String videoURL;

  CustomVideoPlayer({this.videoURL});

  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController videoPlayerController;

  var range;
  var number;

  _initPlayer() async{
    videoPlayerController = VideoPlayerController.file(File(widget.videoURL));
    videoPlayerController = VideoPlayerController.network(widget.videoURL);
    /// Ensure the first frame is shown after the video is initialized,
    /// even before the play button has been pressed
    await videoPlayerController.initialize();
    setState(() {

    });
    //videoPlayerController.setLooping(true);

//    print("width :${videoPlayerController.value.size?.width}");
//    print("height :${videoPlayerController.value.size?.height}");
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
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            videoPlayerController.value.size == null ? Center(child: CircularProgressIndicator()) :
            SizedBox.expand(
              child: FittedBox(
                fit: widthSmallerThanHeight() ? BoxFit.cover : BoxFit.contain,
                child: GestureDetector(
                  child: SizedBox(
                      width: videoPlayerController.value.size?.width ?? 0,
                      height: videoPlayerController.value.size?.height ?? 0,
                      //aspectRatio:videoPlayerController.value.aspectRatio,
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
              ),
            ),
            Container(
              height: 75,/// to increase the size of floatingActionButton use container along with FittedBox
              width: 75,
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: CustomIconButton(iconNameInImageFolder: 'backArrowColor', onPressed: (){Navigator.pop(context);},),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  widthSmallerThanHeight() {
    /// to check if the video is portrait video or landscape video
    /// because portriat needs Boxfit.cover and landcape needs Boxfit.contain,
    /// we check if the width is smaller than height.
    ///
    /// to avoid error:
    /// The getter 'width' was called on null.
    /// we use:
    /// videoPlayerController.value.size != null
    if((videoPlayerController.value.size != null) && (videoPlayerController.value.size.width) < (videoPlayerController.value.size.height)){
      return true;
    }return false;
  }

}

