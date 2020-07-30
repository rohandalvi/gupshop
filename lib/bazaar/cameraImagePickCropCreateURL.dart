import 'dart:io';
import 'package:gupshop/image/createImageURL.dart';
import 'package:gupshop/image/cropImage.dart';
import 'package:gupshop/image/pickImageFromCamera.dart';


class CameraImagePickCropCreateURL{
  String userPhoneNo;

  CameraImagePickCropCreateURL({this.userPhoneNo});

  pickCropReturnURL() async{
    File image = await PickImageFromCamera().pick();/// pick
    if(image == null) return null;
    File croppedImage = await CropImage().crop(image);/// crop
    /// create URL:
    String imageURL = await CreateImageURL().create(croppedImage);
    return imageURL;
  }

}