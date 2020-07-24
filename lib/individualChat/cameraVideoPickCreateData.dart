import 'dart:io';
import 'package:gupshop/models/message.dart';
import 'package:gupshop/models/video_message.dart';
import 'package:gupshop/video/createVideoURL.dart';
import 'package:gupshop/video/pickVideoFromCamera.dart';

class CameraVideoPickCreateData{
  String userPhoneNo;
  String userName;
  String conversationId;

  CameraVideoPickCreateData({this.conversationId, this.userPhoneNo, this.userName});

  main() async{
    /// to make the user go to individualChat screen with no bottom bar open
    /// we have to make sure that Navigator.pop(context); is used so that
    /// when the user clicks pick image from camera(or any other option),
    /// he is returned to individualChat with no bottom bar open
    int numberOfImageInConversation= 0;
    numberOfImageInConversation++;

    File video = await PickVideoFromCamera().pick();

    String videoURL = await CreateVideoURL().create(video, userPhoneNo, numberOfImageInConversation);
    IMessage message = new VideoMessage(fromName:userName, fromNumber:userPhoneNo, conversationId:conversationId, timestamp:DateTime.now(), videoURL:videoURL);
    return message.fromJson();
  }
}