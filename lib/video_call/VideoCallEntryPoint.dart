import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/service/VideoCallBackendService.dart';
import 'package:gupshop/video_call/room/join_room_page.dart';
import 'package:provider/provider.dart';

class VideoCallEntryPoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<VideoCallBackendService>(
      create: (_) => FirebaseFunctions.instance,
      child: MaterialApp(
        title: 'Video Call',
        theme: ThemeData(
          primarySwatch: Colors.green,
          appBarTheme: AppBarTheme(
            color: Colors.white,
            textTheme: TextTheme(
              headline6: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white
              )
            )
          )
        ),
        home: JoinRoomPage(),
      ),
    );
  }

}