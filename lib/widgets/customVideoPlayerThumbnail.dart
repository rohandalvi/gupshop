import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/individualChat/individualChatCache.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';

import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customVideoPlayer.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayerThumbnail extends StatefulWidget {
  final String videoURL;
  IndividualChatCache cache = new IndividualChatCache();

  CustomVideoPlayerThumbnail({this.videoURL, this.cache});

  @override
  _CustomVideoPlayerThumbnailState createState() => _CustomVideoPlayerThumbnailState();
}

class _CustomVideoPlayerThumbnailState extends State<CustomVideoPlayerThumbnail> {
  VideoPlayerController videoPlayerController;
  bool isInitialized = false;

  _initPlayer() async{
    videoPlayerController = VideoPlayerController.network(widget.videoURL)..initialize()
        .then((_) {
      setState(() {

      });
    });
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


    return
      Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Card(
          margin: EdgeInsets.all(PaddingConfig.pointThree),
          child: //widget.cache.video == null ? helper()
          SizedBox.expand(
            child: FittedBox(
              fit: widthSmallerThanHeight() ? BoxFit.cover : BoxFit.contain,
              child: GestureDetector(
                child: SizedBox(
                    width: videoPlayerController.value.size?.width ?? 0,
                    height: videoPlayerController.value.size?.height ?? 0,
                    child: VideoPlayer(videoPlayerController)
                ),
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
          ),

//          GestureDetector(
//            child: SizedBox(
//                width: videoPlayerController.value.size?.width ?? 0,
//                height: videoPlayerController.value.size?.height ?? 0,
////              width: MediaQuery.of(context).size.height / 2.75,
////              height: MediaQuery.of(context).size.width / 2,
//                child: VideoPlayer(videoPlayerController)
//            ),
////            Container(
////                width: videoPlayerController.value.size?.width ?? 0,
////                    height: videoPlayerController.value.size?.height ?? 0,
//////              width: MediaQuery.of(context).size.height / 2.75,
//////              height: MediaQuery.of(context).size.width / 2,
////              child: VideoPlayer(videoPlayerController)
////            ),
////            AspectRatio(
////                aspectRatio:
////                //videoPlayerController.value.aspectRatio,
////
////                //WidgetConfig.aspectRatioOnePointSix,
////                16/10,
////                child: VideoPlayer(videoPlayerController),
////            ) ,
//            onTap: (){
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                      builder: (context) => CustomVideoPlayer(videoURL:widget.videoURL),//pass Name() here and pass Home()in name_screen
//                      //builder: (context) => FullScreenPictureAndVideos(payLoad:widget.videoURL, isPicture: false, shouldZoom: false,),//pass Name() here and pass Home()in name_screen
//                    )
//                );
//            },
//          );
//        : cachedVideo(),
        ),
        CustomIconButton(iconNameInImageFolder: 'playButton',
          onPressed: (){
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

  cachedVideo(){
    return widget.cache.video;
  }
}
