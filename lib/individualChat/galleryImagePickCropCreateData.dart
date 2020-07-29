import 'dart:io';
import 'package:gupshop/image/createImageURL.dart';
import 'package:gupshop/image/cropImage.dart';
import 'package:gupshop/image/pickImageFromGallery.dart';
import 'package:gupshop/models/image_message.dart';
import 'package:gupshop/models/message.dart';

class GalleryImagePickCropCreateData{
  main(String userName, String userPhoneNo, String conversationId) async{
    int numberOfImageInConversation= 0;
    numberOfImageInConversation++;

    File image = await PickImageFromGallery().pick();/// pick
    File croppedImage = await CropImage().crop(image);/// crop
    /// create URL:
    String imageURL = await CreateImageURL().create(croppedImage,);
    /// create data:
    IMessage message = new ImageMessage(fromName:userName, fromNumber: userPhoneNo, conversationId: conversationId, timestamp: DateTime.now(), imageUrl: imageURL, isSaved: false);
    return message.fromJson();
  }
}