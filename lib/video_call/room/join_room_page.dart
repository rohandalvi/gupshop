import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/video_call/room/join_room_form.dart';

class JoinRoomPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Call'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: JoinRoomForm.create(context),
        ),
      ),
    );
  }

}