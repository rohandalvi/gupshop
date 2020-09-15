import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/image/createImageURL.dart';
import 'package:gupshop/image/cropImage.dart';
import 'package:gupshop/image/imageVideoPermissionHandler.dart';
import 'package:gupshop/image/pickImageFromCamera.dart';
import 'package:gupshop/models/image_message.dart';
import 'package:gupshop/models/message.dart';

class CameraImagePickCropCreateData{
    main(BuildContext context, String userName, String userPhoneNo, String conversationId, String messageId) async{
    /// to make the user go to individualChat screen with no bottom bar open
    /// we have to make sure that Navigator.pop(context); is used so that
    /// when the user clicks pick image from camera(or any other option),
    /// he is returned to individualChat with no bottom bar open

    var permission = await ImageVideoPermissionHandler().handleCameraPermissions(context);
    if(permission == true){
        File image = await PickImageFromCamera().pick();
        File croppedImage = await CropImage().crop(image);
        String imageURL = await CreateImageURL().create(croppedImage, );
        IMessage message = new ImageMessage(fromName:userName, fromNumber: userPhoneNo, conversationId: conversationId, timestamp: Timestamp.now(), imageUrl: imageURL, isSaved: false, messageId: messageId);
        return message.fromJson();
    }

  }
}