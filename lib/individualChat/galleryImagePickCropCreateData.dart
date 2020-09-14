import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/image/createImageURL.dart';
import 'package:gupshop/image/cropImage.dart';
import 'package:gupshop/image/imageVideoPermissionHandler.dart';
import 'package:gupshop/image/pickImageFromGallery.dart';
import 'package:gupshop/models/image_message.dart';
import 'package:gupshop/models/message.dart';

class GalleryImagePickCropCreateData{

  main(BuildContext context,String userName, String userPhoneNo, String conversationId, String messageId) async{
    var permission = ImageVideoPermissionHandler().handleGalleryPermissions(context);
    if(permission == true){
      File image = await PickImageFromGallery().pick();/// pick
      File croppedImage = await CropImage().crop(image);/// crop
      /// create URL:
      String imageURL = await CreateImageURL().create(croppedImage,);
      /// create data:
      IMessage message = new ImageMessage(fromName:userName, fromNumber: userPhoneNo, conversationId: conversationId, timestamp: Timestamp.now(), imageUrl: imageURL, isSaved: false, messageId : messageId);
      return message.fromJson();
    }
  }

}