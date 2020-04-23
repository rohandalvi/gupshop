//import 'dart:html';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class BazaarProfilePage extends StatefulWidget {
  @override
  _BazaarProfilePageState createState() => _BazaarProfilePageState();
}

class _BazaarProfilePageState extends State<BazaarProfilePage> {

  File _video;
  VideoPlayerController _videoPlayerController;

  _pickVideoFromGallery() async{
    File video = await ImagePicker.pickVideo(source: ImageSource.gallery);
    _video = video;
//    _videoPlayerController = VideoPlayerController.asset('videos/LevenworthVideo.mp4')..initialize().then((_){;
    _videoPlayerController = VideoPlayerController.file(_video)..initialize().then((_){
      setState(() {});
      _videoPlayerController.play();
    });
  }


  File _cameraVideo;
  VideoPlayerController _cameraVideoPlayerController;

  _pickVideoFromCamer() async{
    File video = await ImagePicker.pickVideo(source: ImageSource.camera);
    _cameraVideo = video;
    _cameraVideoPlayerController = VideoPlayerController.file(_cameraVideo)..initialize().then((_){
      setState(() {});
      _cameraVideoPlayerController.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.fromLTRB(15, 150, 0, 0),
        child: Center(
          child: Column(
            children: <Widget>[
              if(_video != null)
                _videoPlayerController.value.initialized
                ? AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(_videoPlayerController),
                )
                    : Container()
              else
                Text('Lets start by adding your advertisement:',style: GoogleFonts.openSans()),
              RaisedButton(
                onPressed: (){
                  _pickVideoFromGallery();
                },
                child: Text("Choose a video from Gallery",style: GoogleFonts.openSans()),
              ),
              Text('or',style: GoogleFonts.openSans()),
              RaisedButton(
                onPressed: (){
                  _pickVideoFromCamer();
                },
                child: Text("Record from camera",style: GoogleFonts.openSans()),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
