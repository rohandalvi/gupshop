import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/chat_list_page/readUnreadIconDisplay.dart';
import 'package:gupshop/timestamp/timeDisplay.dart';

class TrailingDisplay extends StatelessWidget {
  final Timestamp timeStamp;
  final String myNumber;
  final String conversationId;

  TrailingDisplay({this.timeStamp, this.myNumber, this.conversationId, });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Flex(/// renderflex overflow by 8 pixels, use flex -> expanded(icon as 1 child) and use text as other child
        mainAxisAlignment: MainAxisAlignment.end,
        direction: Axis.vertical,
        children: <Widget>[
          ReadUnreadIcon(
            conversationId: conversationId,
            myNumber: myNumber,
            timeStamp: timeStamp,
          ),
          TimeDisplay(timeStamp: timeStamp,),
        ],
      ),
    );
  }
}
