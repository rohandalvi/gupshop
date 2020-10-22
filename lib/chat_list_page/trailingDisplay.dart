import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/chat_list_page/readUnreadIconDisplay.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/timestamp/timeDisplay.dart';
import 'package:gupshop/widgets/customIcon.dart';

class TrailingDisplay extends StatelessWidget {
  final Timestamp timeStamp;
  final String myNumber;
  final String conversationId;
  String conversationsLatestMessageId;

  TrailingDisplay({this.timeStamp, this.myNumber, this.conversationId, this.conversationsLatestMessageId});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 115,
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: CustomIcon(iconName: IconConfig.free,)),
          Flexible(
            flex: 2,
            child: Column(
              children: <Widget>[
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: ReadUnreadIcon(
                    conversationId: conversationId,
                    myNumber: myNumber,
                    timeStamp: timeStamp,
                    conversationsLatestMessageId: conversationsLatestMessageId,
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 2,
                  child: TimeDisplay(timeStamp: timeStamp,)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
