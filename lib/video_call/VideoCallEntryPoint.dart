import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/service/VideoCallBackendService.dart';
import 'package:gupshop/video_call/room/join_room_dummy.dart';

class VideoCallEntryPoint {

  void main(BuildContext context) {
    VideoCallRoomNavigator().navigate(context, FirebaseFunctions.instance);
  }
}