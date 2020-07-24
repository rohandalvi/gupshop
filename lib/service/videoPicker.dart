import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';

class VideoPicker{
  File _video;
  VideoPlayerController _videoPlayerController;

  pickVideoFromGallery() async{
    return await ImagePicker.pickVideo(source: ImageSource.gallery);
  }


  pickVideoFromCamer() async{
    return await ImagePicker.pickVideo(source: ImageSource.camera);
  }
}