import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';

class VideoPicker{
  File _video;
  VideoPlayerController _videoPlayerController;

  pickVideoFromGallery() async{
    return await ImagePicker.pickVideo(source: ImageSource.gallery);
//    _video = video;
//
//    _videoPlayerController = VideoPlayerController.file(_video)..initialize().then((_){
//      setState(() {
//        _videoPlayerController.play();
//      });
//
//    });
  }


  pickVideoFromCamer() async{
    return await ImagePicker.pickVideo(source: ImageSource.camera);
 //   _cameraVideoPlayerController = VideoPlayerController.file(_cameraVideo)..initialize().then((_){
//      setState(() {});
//      _cameraVideoPlayerController.play();
//    });
  }
}