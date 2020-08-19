import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/individualChat/individualChatCache.dart';
import 'package:gupshop/video/downloadVideo.dart';
import 'package:gupshop/widgets/customFlushBar.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:gupshop/widgets/customVideoPlayerThumbnail.dart';

class ShowVideoThumbnail extends StatelessWidget {
  final String videoURL;

  ShowVideoThumbnail({this.videoURL,});

  @override
  Widget build(BuildContext context) {
    print("in ShowVideoThumbnail build");
    return Stack(
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.height / 2.75,
          height: MediaQuery.of(context).size.width / 2.25,
          child: Card(
            child: CustomVideoPlayerThumbnail(videoURL: videoURL,),
          ),
        ),
        CustomIconButton(
          onPressed: () async{
            CustomFlushBar(
              duration: Duration(seconds: 5),
              customContext: context,
              iconName: 'speaker',
              text: CustomText(text : 'Downloading video...............', fontSize: 13,),
              message: 'Downloading video..........',
            ).showFlushBar();
            var videoId = await DownloadVideo(videoURL: videoURL).downloadVideo();
            if(videoId != null){
              return CustomFlushBar(
                customContext: context,
                iconName: 'speaker',
                text: CustomText(text : 'Video downloaded in your device', fontSize: 13,),
                message: 'Video downloaded in your device',
              ).showFlushBar();
            }
            if(videoId == null){
              return CustomFlushBar(
                customContext: context,
                iconName: 'exclamation',
                text: CustomText(text : 'Could not download Video', fontSize: 13,),
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
