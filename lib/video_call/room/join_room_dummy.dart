import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/service/VideoCallBackendService.dart';
import 'package:gupshop/video_call/room/room_bloc.dart';
import 'package:gupshop/video_call/room/room_model.dart';
import 'package:gupshop/video_call/widgets/conference_page.dart';

class VideoCallRoomNavigator {

  void navigate(BuildContext context, VideoCallBackendService backendService) async{

    RoomBloc roomBloc = new RoomBloc(backendService: backendService);
    RoomModel roomModel = await roomBloc.submit();
    await Navigator.of(context).push(
      MaterialPageRoute<ConferencePage>(
        fullscreenDialog: true,
        builder: (BuildContext context) => ConferencePage(roomModel: roomModel),
      ),
    );
    roomBloc.dispose();
  }
}