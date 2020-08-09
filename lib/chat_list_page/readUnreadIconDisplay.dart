import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/messageReadUnread/messageReadUnreadData.dart';

class ReadUnreadIcon extends StatelessWidget {
  final String conversationId;
  final String myNumber;
  final Timestamp timeStamp;

  ReadUnreadIcon({this.timeStamp, this.conversationId, this.myNumber});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MessageReadUnreadData(conversationId: conversationId, number: myNumber, conversationsLatestMessageTimestamp: timeStamp).timestampDifference(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          bool read;
          if(snapshot.data == null) read = false;
          else if(snapshot.data < 0) read = false;
          else if(snapshot.data == 0) read = true;
          else read = true;
          print("read in chatlist : $read");

          return Visibility(/// show the new icon only if the message is unread
            visible: read==false,
            child: Expanded(
              child: IconButton(
                icon: SvgPicture.asset('images/new.svg',),
              ),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(white),
          ),
        );
      },
    );
  }
}
