import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/image/displayPicture.dart';
import 'package:gupshop/individualChat/individualChatCache.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
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
      alignment: Alignment.topLeft,
      children: <Widget>[
        /// videoPlayer:
        SizedBox(
          width: WidgetConfig().getChatMessageOuterFrameWidth(context),
          height: WidgetConfig().getChatMessageOuterFrameHeight(context),
          child: VideoThumbnailHelper(videoURL: videoURL, width: WidgetConfig().getChatMessageWidth(context), height: WidgetConfig().getChatMessageHeight(context),),
        ),
        /// download button:
        CustomIconButton(
          onPressed: () async{
            CustomFlushBar(
              //duration: Duration(seconds: 5),
              customContext: context,
              iconName: IconConfig.speaker,
              text: CustomText(text : 'Downloading video...............', fontSize: WidgetConfig.fontSizeTwelve,),
              message: 'Downloading video..........',
            ).showFlushBarNoDuration();
            var videoId = await DownloadVideo(videoURL: videoURL).downloadVideo();
            print("videoId : $videoId");
            if(videoId != null){
              Navigator.pop(context);
              return CustomFlushBar(
                customContext: context,
                iconName: IconConfig.speaker,
                text: CustomText(text : 'Video downloaded in your device', fontSize: WidgetConfig.fontSizeTwelve,),
                message: 'Video downloaded in your device',
              ).showFlushBar();
            }
            if(videoId == null){
              Navigator.pop(context);
              return CustomFlushBar(
                customContext: context,
                iconName: 'exclamation',
                text: CustomText(text : 'Could not download Video', fontSize: WidgetConfig.fontSizeTwelve,),
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
