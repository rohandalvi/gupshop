import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/service/VideoCallBackendService.dart';
import 'package:gupshop/video_call/models/twilio/room_update_request.dart';
import 'package:gupshop/video_call/room/room_bloc.dart';
import 'package:gupshop/video_call/room/room_model.dart';
import 'package:gupshop/video_call/widgets/conference_page.dart';

class VideoCallRoomNavigator {

  void startVideoCall(BuildContext context, VideoCallBackendService backendService, String phoneNumber) async{

    RoomBloc roomBloc = new RoomBloc(backendService: backendService);
    RoomModel roomModel = await roomBloc.submit(isCreateRoomEnabled: true);
    String callerNumber = await UserDetails().getUserPhoneNoFuture();
    backendService.pushRoomUpdates(RoomUpdateRequest(name: roomModel.name, token: roomModel.token, identity: roomModel.identity,caller: callerNumber, inviteePhoneNumber: phoneNumber ));
    await Navigator.of(context).push(
      MaterialPageRoute<ConferencePage>(
        fullscreenDialog: true,
        builder: (BuildContext context) => ConferencePage(roomModel: roomModel),
      ),
    );
    roomBloc.dispose();
  }

  void joinVideoCall({BuildContext context, VideoCallBackendService backendService, String name})async {
    RoomBloc roomBloc = new RoomBloc(backendService: backendService);
    roomBloc.updateName(name);
    RoomModel roomModel = await roomBloc.submit();
    print("in joinVideoCall, context: $context");
    await Navigator.of(context).push(
      MaterialPageRoute<ConferencePage>(
        fullscreenDialog: true,
        builder: (BuildContext context) => ConferencePage(roomModel: roomModel),
      ),
    );
    roomBloc.dispose();

  }
}