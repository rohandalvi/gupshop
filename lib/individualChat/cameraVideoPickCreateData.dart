import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/image/imageVideoPermissionHandler.dart';
import 'package:gupshop/models/message.dart';
import 'package:gupshop/models/video_message.dart';
import 'package:gupshop/video/createVideoURL.dart';
import 'package:gupshop/video/pickVideoFromCamera.dart';

class CameraVideoPickCreateData{
  String userPhoneNo;
  String userName;
  String conversationId;
  String messageId;

  CameraVideoPickCreateData({this.conversationId, this.userPhoneNo, this.userName, this.messageId});

  main(BuildContext context) async{
    /// to make the user go to individualChat screen with no bottom bar open
    /// we have to make sure that Navigator.pop(context); is used so that
    /// when the user clicks pick image from camera(or any other option),
    /// he is returned to individualChat with no bottom bar open
    int numberOfImageInConversation= 0;
    numberOfImageInConversation++;

    var permission = await ImageVideoPermissionHandler().handleCameraPermissions(context);
    if(permission == true){
      File video = await PickVideoFromCamera().pick();

      String videoURL = await CreateVideoURL().create(context,video, userPhoneNo, numberOfImageInConversation);
      /// if the user cancels uploading the video then videoURL would be null;
      if(videoURL == null ) return null;
      else{
        IMessage message = new VideoMessage(fromName:userName, fromNumber:userPhoneNo, conversationId:conversationId, timestamp:Timestamp.now(), videoURL:videoURL, messageId: messageId);
        return message.fromJson();
      }
    }

  }
}