import 'dart:io';

import 'package:image_cropper/image_cropper.dart';

class CustomImageCropper{
  File imageFile;

  CustomImageCropper({this.imageFile});

  Future cropImage(File imageFile) async{
    File croppedFile =  await ImageCropper.cropImage(
      sourcePath: imageFile.path,
    );

    return croppedFile;
  }
}