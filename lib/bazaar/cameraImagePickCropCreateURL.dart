import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/image/createImageURL.dart';
import 'package:gupshop/image/cropImage.dart';
import 'package:gupshop/image/imageVideoPermissionHandler.dart';
import 'package:gupshop/image/pickImageFromCamera.dart';


class CameraImagePickCropCreateURL{
  String userPhoneNo;

  CameraImagePickCropCreateURL({this.userPhoneNo});

  pickCropReturnURL(BuildContext context) async{
    var permission = ImageVideoPermissionHandler().handleCameraPermissions(context);
    if(permission == true){
      File image = await PickImageFromCamera().pick();/// pick
      if(image == null) return null;
      File croppedImage = await CropImage().crop(image);/// crop
      /// create URL:
      String imageURL = await CreateImageURL().create(croppedImage);
      return imageURL;
    }
  }

}