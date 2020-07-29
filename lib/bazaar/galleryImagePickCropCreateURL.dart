import 'dart:io';
import 'package:gupshop/image/createImageURL.dart';
import 'package:gupshop/image/cropImage.dart';
import 'package:gupshop/image/pickImageFromGallery.dart';


class GalleryImagePickCropCreateURL{
  String userPhoneNo;

  GalleryImagePickCropCreateURL({this.userPhoneNo});

  pickCropReturnURL() async{
    File image = await PickImageFromGallery().pick();/// pick
    File croppedImage = await CropImage().crop(image);/// crop
    /// create URL:
    String imageURL = await CreateImageURL().create(croppedImage);
    return imageURL;
  }

}