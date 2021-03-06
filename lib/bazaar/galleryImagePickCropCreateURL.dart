import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/image/createImageURL.dart';
import 'package:gupshop/image/cropImage.dart';
import 'package:gupshop/image/imageVideoPermissionHandler.dart';
import 'package:gupshop/image/pickImageFromGallery.dart';


class GalleryImagePickCropCreateURL{
  String userPhoneNo;

  GalleryImagePickCropCreateURL({this.userPhoneNo});

  pickCropReturnURL(BuildContext context) async{
    var permission = await ImageVideoPermissionHandler().handleGalleryPermissions(context);
    if(permission == true){
      File image = await PickImageFromGallery().pick();/// pick
      if(image == null) return null;
      File croppedImage = await CropImage().crop(image);/// crop
      /// create URL:
      String imageURL = await CreateImageURL().create(croppedImage);
      return imageURL;
    }
  }

}