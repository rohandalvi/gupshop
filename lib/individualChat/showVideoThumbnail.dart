import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/image/displayPicture.dart';
import 'package:gupshop/individualChat/individualChatCache.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/video/downloadVideo.dart';
import 'package:gupshop/video/videoThumbnailHelper.dart';
import 'package:gupshop/widgets/customFlushBar.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:gupshop/widgets/customVideoPlayer.dart';
import 'package:gupshop/widgets/customVideoPlayerThumbnail.dart';

class ShowVideoThumbnail extends StatelessWidget {
  final String videoURL;
  IndividualChatCache cache = new IndividualChatCache();

  ShowVideoThumbnail({this.videoURL, this.cache});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        //CustomVideoPlayer(videoURL: videoURL,),
        //CustomVideoPlayerThumbnail(videoURL: videoURL, cache: cache,),
        /// videoPlayer:
        SizedBox(
          width: MediaQuery.of(context).size.height / 2.75,
          height: MediaQuery.of(context).size.width / 2,
//          width: MediaQuery.of(context).size.height / 2.75,
          //height: MediaQuery.of(context).size.width / 2.25,
          child: Card(
            child: VideoThumbnailHelper(videoURL: videoURL,),
            //CustomVideoPlayerThumbnail(videoURL: videoURL, cache: cache,),
          ),
        ),
        /// download button:
        CustomIconButton(
          onPressed: () async{
            CustomFlushBar(
              //duration: Duration(seconds: 5),
              customContext: context,
              iconName: 'speaker',
              text: CustomText(text : 'Downloading video...............', fontSize: TextConfig.fontSizeTwelve,),
              message: 'Downloading video..........',
            ).showFlushBarNoDuration();
            var videoId = await DownloadVideo(videoURL: videoURL).downloadVideo();
            print("videoId : $videoId");
            if(videoId != null){
              Navigator.pop(context);
              return CustomFlushBar(
                customContext: context,
                iconName: 'speaker',
                text: CustomText(text : 'Video downloaded in your device', fontSize: TextConfig.fontSizeTwelve,),
                message: 'Video downloaded in your device',
              ).showFlushBar();
            }
            if(videoId == null){
              Navigator.pop(context);
              return CustomFlushBar(
                customContext: context,
                iconName: 'exclamation',
                text: CustomText(text : 'Could not download Video', fontSize: TextConfig.fontSizeTwelve,),
                message: 'Could not download Video',
              ).showFlushBar();
            }
          },
          iconNameInImageFolder: 'download',
        ),

      ],
    );
  }
}
