import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gupshop/image/imagePickersDisplayPicturesFromURLorFile.dart';
import 'package:gupshop/individualChat/messageCardDisplay.dart';
import 'package:gupshop/service/videoPicker.dart';
import 'package:gupshop/widgets/customBottomSheet.dart';
import 'package:gupshop/widgets/customIconButton.dart';

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CustomIconButton(
        iconNameInImageFolder: 'videoCamera',
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
        ),
        if((widget.video != null || widget.cameraVideo != null)) MessageCardDisplay().showVideo(widget.videoURL,),
      ],
    );
  }

  _pickVideoFromGallery() async{
    File _video = await VideoPicker().pickVideoFromGallery();
    widget.video = _video;
    String url = await ImagesPickersDisplayPictureURLorFile().getVideoURL(widget.video, widget.userPhoneNo, null);
    Navigator.pop(context);
    setState(() {
      widget.videoURL = url;
      widget.videoSelected = true;
    });
  }

  _pickVideoFromCamer() async{
    File _video = await VideoPicker().pickVideoFromCamer();
    widget.cameraVideo = _video;
    String url = await ImagesPickersDisplayPictureURLorFile().getVideoURL(widget.cameraVideo, widget.userPhoneNo, null);
    Navigator.pop(context);
    setState(() {
      widget.videoURL = url;
      widget.videoSelected = true;
    });
  }

  isVideoReady(){
    return widget.videoSelected;
  }
}
