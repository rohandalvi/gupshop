import 'dart:io';
import 'package:gupshop/image/createImageURL.dart';
import 'package:gupshop/image/cropImage.dart';
import 'package:gupshop/image/pickImageFromGallery.dart';
import 'package:gupshop/models/image_message.dart';
import 'package:gupshop/models/message.dart';

class GalleryImagePickCropCreateData{
  main(String userName, String userPhoneNo, String conversationId) async{
    /// to make the user go to individualChat screen with no bottom bar open
    /// we have to make sure that Navigator.pop(context); is used so that
    /// when the user clicks pick image from camera(or any other option),
    /// he is returned to individualChat with no bottom bar open
    int numberOfImageInConversation= 0;
    numberOfImageInConversation++;

    File image = await PickImageFromGallery().pick();
    File croppedImage = await CropImage().crop(image);
    String imageURL = await CreateImageURL().create(croppedImage, userPhoneNo, numberOfImageInConversation);
    IMessage message = new ImageMessage(fromName:userName, fromNumber: userPhoneNo, conversationId: conversationId, timestamp: DateTime.now(), imageUrl: imageURL);
    return message.fromJson();
  }
}