import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/image/imageVideoPermissionHandler.dart';
import 'package:gupshop/image/imagePickersDisplayPicturesFromURLorFile.dart';
import 'package:gupshop/individualChat/messageCardDisplay.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/video/displayVideo.dart';
import 'package:gupshop/video/pickVideoFromCamera.dart';
import 'package:gupshop/video/pickVideoFromGallery.dart';
import 'package:gupshop/widgets/customBottomSheet.dart';
import 'package:gupshop/widgets/customRaisedButton.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:gupshop/widgets/customVideoPlayer.dart';
import 'package:gupshop/widgets/customVideoPlayerThumbnail.dart';

class BazaarProfileSetVideo extends StatefulWidget {
  File video;
  String videoURL;
  File cameraVideo;
  bool videoSelected;
  String userPhoneNo;

  BazaarProfileSetVideo({this.video, this.cameraVideo, this.videoURL, this.videoSelected, this.userPhoneNo});

  @override
  _BazaarProfileSetVideoState createState() => _BazaarProfileSetVideoState();
}

class _BazaarProfileSetVideoState extends State<BazaarProfileSetVideo> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
//      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding:EdgeInsets.all(PaddingConfig.eight),
              child: CustomRaisedButton(
              child: CustomText(text: 'Tap to add video',),
                onPressed: (){
                  CustomBottomSheet(
                    customContext: context,
                    firstIconName: 'photoGallery',
                    firstIconText: 'Pick video from  Gallery',
                    firstIconAndTextOnPressed: (){
                      _pickVideoFromGallery();
                    },
                    secondIconName: 'image2vector',
                    secondIconText: 'Record video from Camera',
                    secondIconAndTextOnPressed: (){
                      _pickVideoFromCamer();
                    },
                  ).showTwo();
                },
              ).elevated(),
            ),
          ),
          if((widget.video != null || widget.cameraVideo != null))
            Expanded(
              flex: 10,
              child: CustomVideoPlayerThumbnail(videoURL: widget.videoURL,),
//            DisplayVideo(
//              videoURL: widget.videoURL,
//              width: WidgetConfig.sizedBoxWidthFiveHundred,
//              height: WidgetConfig.sizedBoxWidthFiveHundred,
//            ),
            ),
        ],
      ),
    );
  }

  _pickVideoFromGallery() async{
    var permission = await ImageVideoPermissionHandler().handleGalleryPermissions(context);
    if(permission == true){
      File _video = await PickVideoFromGallery().pick();
      widget.video = _video;
      String url = await ImagesPickersDisplayPictureURLorFile().getVideoURL(widget.video, widget.userPhoneNo, null);
      Navigator.pop(context);
      setState(() {
        widget.videoURL = url;
        widget.videoSelected = true;
      });
    }
  }

  _pickVideoFromCamer() async{
    var permission = await ImageVideoPermissionHandler().handleCameraPermissions(context);
    if(permission == true){
      File _video = await PickVideoFromCamera().pick();
      widget.cameraVideo = _video;
      String url = await ImagesPickersDisplayPictureURLorFile().getVideoURL(widget.cameraVideo, widget.userPhoneNo, null);
      Navigator.pop(context);
      setState(() {
        widget.videoURL = url;
        widget.videoSelected = true;
      });
    }
  }

  isVideoReady(){
    return widget.videoSelected;
  }
}
