import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/news/trueFakeVotingIcons.dart';
import 'package:gupshop/service/recentChats.dart';
import 'package:gupshop/service/sendAndDisplayMessages.dart';

//class FromNameAndTimeStamp extends StatefulWidget {
//  bool visible;
//  Widget fromName;
//  bool isMe;
//  Widget timeStamp;
//
//  FromNameAndTimeStamp({this.visible, this.fromName, this.isMe, this.timeStamp});
//  @override
//  _FromNameAndTimeStampState createState() => _FromNameAndTimeStampState(visible: visible, fromName: fromName, isMe: isMe, timeStamp: timeStamp);
//}

class FromNameAndTimeStamp extends StatelessWidget {
  bool visible;
  Widget fromName;
  bool isMe;
  Widget timeStamp;
  bool isNews;
  String conversationId;
  String documentId;
  int reportedByCount;
  int trueByCount;
  int fakeByCount;

  FromNameAndTimeStamp({this.visible, this.fromName, this.isMe, this.timeStamp, this.isNews, this.conversationId,this.documentId, this.reportedByCount, this.trueByCount, this.fakeByCount});

  @override
  Widget build(BuildContext context) {
    print("isMe in FromNameAndTimeStamp: $isMe");
        return Column(
          children: <Widget>[
            /// icons for news for voting:
            Visibility(
              visible: isNews,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),
                  child: TrueFakeVotingIcons(
                    isMe: isMe,
                    count1: reportedByCount.toString(),
                    count2: trueByCount.toString(),
                    count3: fakeByCount.toString(),
                    onTap1: (){
                      /// push to conversationCollection:
                      SendAndDisplayMessages().changeIncreaseDecreaseCountInConversationCollection(conversationId, documentId, 'reportedBy', reportedByCount);
                    },
                  ),
                )
            ),
            /// fromName:
            Visibility(
              visible: visible,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  alignment:  Alignment.centerLeft,
                  padding:  EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),
                  child: fromName,
              ),
            ),
            /// timeStamp:
            Container(
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              alignment: isMe? Alignment.centerRight: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),//pretty padding- for some margin from the side of the screen as well as the top of parent message
              child: timeStamp,
            ),
          ],
        );
  }

}
