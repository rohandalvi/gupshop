import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/chat_list_page/readUnreadIconDisplay.dart';
import 'package:gupshop/chat_list_page/statusData.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/sizeConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/timestamp/timeDisplay.dart';
import 'package:gupshop/widgets/customIcon.dart';

class TrailingDisplay extends StatelessWidget {
  final bool groupExists;
  final String friendNumber;
  final Timestamp timeStamp;
  final String myNumber;
  final String conversationId;
  String conversationsLatestMessageId;

  TrailingDisplay({this.timeStamp, this.myNumber, this.conversationId,
    this.conversationsLatestMessageId, this.friendNumber, this.groupExists});


///  First Rule: use Expanded only within a column, row or flex.
///
///  Second Rule: Parent column that have expanded child column must be wrapped with expanded as well

  @override
  Widget build(BuildContext context) {
    print("$friendNumber groupExists : $groupExists");
    return SizedBox(
      width: WidgetConfig.sizedBoxWidthHundredAndFifteen,
      child: Row(
        children: <Widget>[
          Visibility(
            /// if individualChat
            visible: groupExists == null || groupExists == false,
            child: Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: StatusData(userPhoneNo: friendNumber,)),
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  flex : 2,
                  child: ReadUnreadIconDisplay(
                    conversationId: conversationId,
                    myNumber: myNumber,
                    timeStamp: timeStamp,
                    conversationsLatestMessageId: conversationsLatestMessageId,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: TimeDisplay(timeStamp: timeStamp,)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
