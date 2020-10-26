import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/service/VideoCallBackendService.dart';
import 'package:gupshop/video_call/room/join_room_dummy.dart';

class VideoCallEntryPoint {

  void main({BuildContext context, String phoneNumber}) {
    VideoCallRoomNavigator().startVideoCall(context, FirebaseFunctions.instance, phoneNumber);
  }

  join({BuildContext context, String name}){
    print("in join , context: $context");
    VideoCallRoomNavigator().joinVideoCall(context:context,backendService:
    FirebaseFunctions.instance, name: name);
  }
}