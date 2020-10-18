import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/image/imageVideoPermissionHandler.dart';
import 'package:gupshop/image/imagePickersDisplayPicturesFromURLorFile.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/imageConfig.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/video/pickVideoFromCamera.dart';
import 'package:gupshop/video/pickVideoFromGallery.dart';
import 'package:gupshop/video/videoThumbnailHelper.dart';
import 'package:gupshop/widgets/customBottomSheet.dart';
import 'package:gupshop/widgets/customRaisedButton.dart';
import 'package:gupshop/widgets/customText.dart';

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
          Padding(
            padding:EdgeInsets.all(PaddingConfig.sixteen),
            child: CustomRaisedButton(
            child: CustomText(text: TextConfig.tapToAddVideo,),
              onPressed: (){
                CustomBottomSheet(
                  customContext: context,
                  firstIconName: IconConfig.photoGallery,
                  firstIconText: TextConfig.pickGalleryVideo,
                  firstIconAndTextOnPressed: (){
                    _pickVideoFromGallery();
                  },
                  secondIconName: IconConfig.camera,
                  secondIconText: TextConfig.pickCameraVideo,
                  secondIconAndTextOnPressed: (){
                    _pickVideoFromCamer();
                  },
                ).showTwo();
              },
            ).elevated(),
          ),
          (widget.video != null || widget.cameraVideo != null) ?
            Expanded(
              flex: 4,
              child: VideoThumbnailHelper(videoURL: widget.videoURL, width: WidgetConfig().getOnBoardingWidth(context), height: WidgetConfig().getOnBoradingHeight(context),)
              //MyVideoThumbnail(videoURL: widget.videoURL),
              //CustomVideoPlayerThumbnail(videoURL: widget.videoURL,),
            ) :
          Expanded(
            flex: 4,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: PaddingConfig.eight),
                    child: Image.asset(
                      ImageConfig.bazaarOnBoardingVideoLogo,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
//                Expanded(
//                  flex: 1,
//                  child: Align(
//                    alignment: Alignment.topCenter,
//                    child: Container(),
//                  ),
//                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(),
            ),
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
      String url = await ImagesPickersDisplayPictureURLorFile().getVideoURL(widget.video, widget.userPhoneNo, null, context);
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
      String url = await ImagesPickersDisplayPictureURLorFile().getVideoURL(widget.cameraVideo, widget.userPhoneNo, null,context);
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
