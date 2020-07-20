import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/news/trueFakeVotingIconsUI.dart';
import 'package:gupshop/service/recentChats.dart';
import 'package:gupshop/individualChat/firebaseMethods.dart';

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

class FromNameAndTimeStampVotingIcons extends StatefulWidget {
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
  String newsId;

  FromNameAndTimeStampVotingIcons({this.visible, this.fromName, this.isMe, this.timeStamp,
    this.isNews, this.conversationId,this.documentId, this.reportedByCount, this.trueByCount,
    this.fakeByCount, this.newsId});

  @override
  _FromNameAndTimeStampVotingIconsState createState() => _FromNameAndTimeStampVotingIconsState();
}

class _FromNameAndTimeStampVotingIconsState extends State<FromNameAndTimeStampVotingIcons> {
  @override
  Widget build(BuildContext context) {
    print("isMe in FromNameAndTimeStamp: ${widget.isMe}");
        return Column(
          children: <Widget>[
            /// icons for news for voting:
            Visibility(
              visible: widget.isNews,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),
                  child: TrueFakeVotingIconsUI(
                    isMe: widget.isMe,
                    count1: widget.reportedByCount.toString(),
                    count2: widget.trueByCount.toString(),
                    count3: widget.fakeByCount.toString(),
                    onTap1: (){
                      /// push to conversationCollection:
                      setState(() {
                        widget.reportedByCount++;
                      });
                      FirebaseMethods().changeTrueByFakeByReservedByInNewsCollection(widget.newsId,'reportedBy', widget.reportedByCount);
                    },
                  ),
                )
            ),
            /// fromName:
            Visibility(
              visible: widget.visible,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  alignment:  Alignment.centerLeft,
                  padding:  EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),
                  child: widget.fromName,
              ),
            ),
            /// timeStamp:
            Container(
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              alignment: widget.isMe? Alignment.centerRight: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),//pretty padding- for some margin from the side of the screen as well as the top of parent message
              child: widget.timeStamp,
            ),
          ],
        );
  }
}
