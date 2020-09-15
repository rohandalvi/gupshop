import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/image/imageVideoPermissionHandler.dart';
import 'package:gupshop/image/imagePickersDisplayPicturesFromURLorFile.dart';
import 'package:gupshop/video/pickVideoFromCamera.dart';
import 'package:gupshop/video/pickVideoFromGallery.dart';
import 'package:gupshop/widgets/customRaisedButton.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:gupshop/widgets/customVideoPlayer.dart';

class VideoPlayerAndSelectOptions extends StatefulWidget {
  File video;
  File cameraVideo;
  String videoURL;
  bool videoSelected;
  bool isBazaarWala;
  String userPhoneNo;
//  VoidCallback onPressedForHittingChangeVideoButton;

  VideoPlayerAndSelectOptions({this.video, this.cameraVideo, this.videoURL, this.videoSelected, this.isBazaarWala, this.userPhoneNo});

  @override
  _VideoPlayerAndSelectOptionsState createState() => _VideoPlayerAndSelectOptionsState();
}

class _VideoPlayerAndSelectOptionsState extends State<VideoPlayerAndSelectOptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if((widget.video != null || widget.cameraVideo != null)) Row(
                  children: <Widget>[
                    CustomVideoPlayer(videoURL: widget.videoURL),
                    changeVideo(),
                  ],
                ),
                createSpaceBetweenButtons(15),
                pageSubtitle(),
                Visibility(
                  visible: (widget.videoSelected == false),
                  child: setVideoFromGallery(),
                ),
                Visibility(
                  visible: (widget.videoSelected == false),
                  child: or(),
                ),
                Visibility(
                  visible:(widget.videoSelected == false),
                  child: setVideoFromCamera(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  createSpaceBetweenButtons(double height){
    return SizedBox(
      height: height,
    );
  }

  changeVideo(){
    return CustomRaisedButton(
      child: CustomText(text :'Change Video'),
      onPressed: (){
        setState(() {
          widget.isBazaarWala = false;
          widget.video = null;
          widget.cameraVideo = null;
          widget.videoURL = null;
          widget.videoSelected = false;
        });
      },
    );
  }

  pageSubtitle(){
    return CustomText(text: 'Advertisement : ',);
  }

  or(){
    return Text('or',style: GoogleFonts.openSans());
  }

  setVideoFromGallery(){
    return CustomRaisedButton(
      onPressed: (){
        _pickVideoFromGallery();
      },
      child: Text("Choose a video from Gallery",style: GoogleFonts.openSans()),
    );
  }

  /// used in setVideoFromGallery(),
  _pickVideoFromGallery() async{
    var permission = await ImageVideoPermissionHandler().handleGalleryPermissions(context);
    if(permission == true){
      File _video = await PickVideoFromGallery().pick();
      widget.video = _video;
      String url = await ImagesPickersDisplayPictureURLorFile().getVideoURL(widget.video, widget.userPhoneNo, null);
      setState(() {
        widget.videoURL = url;
        widget.videoSelected = true;
      });
    }

  }

  setVideoFromCamera(){
    return RaisedButton(
      onPressed: (){
        _pickVideoFromCamer();
      },
      child: Text("Record from camera",style: GoogleFonts.openSans()),
    );
  }

  _pickVideoFromCamer() async{
    var permission = await ImageVideoPermissionHandler().handleCameraPermissions(context);
    if(permission == true){
      File _video = await PickVideoFromCamera().pick();
      widget.cameraVideo = _video;
      String url = await ImagesPickersDisplayPictureURLorFile().getVideoURL(widget.cameraVideo, widget.userPhoneNo, null);
      setState(() {
        widget.videoURL = url;
        widget.videoSelected = true;
      });
    }
    }

}
