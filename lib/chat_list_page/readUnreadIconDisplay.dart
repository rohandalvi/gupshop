import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/messageReadUnread/messageReadUnreadData.dart';
import 'package:gupshop/widgets/customIconButton.dart';

class ReadUnreadIcon extends StatelessWidget {
  final String conversationId;
  final String myNumber;
  final Timestamp timeStamp;
  String conversationsLatestMessageId;

  ReadUnreadIcon({this.timeStamp, this.conversationId, this.myNumber, this.conversationsLatestMessageId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MessageReadUnreadData(conversationId: conversationId, number: myNumber, conversationsLatestMessageTimestamp: timeStamp, conversationsLatestMessageId: conversationsLatestMessageId).timestampDifference(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          bool read = snapshot.data;
          if(read == null) read =false;

          return Visibility(/// show the new icon only if the message is unread
            visible: read==false,
            child: icon('new'),
          );
        }
        return icon('transparent');
      },
    );
  }

  Expanded icon(String iconName) {
    return Expanded(
            child: CustomIconButton(
              iconNameInImageFolder: iconName,
            ),
          );
  }


}
