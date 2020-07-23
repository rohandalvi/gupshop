
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/news/newsStatisticsCollection.dart';
import 'package:gupshop/news/trueFakeVotingIconsUI.dart';
import 'package:gupshop/individualChat/firebaseMethods.dart';
import 'package:gupshop/widgets/customFlushBar.dart';
import 'package:gupshop/widgets/customText.dart';

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

class FromNameAndTimeStampVotingIconsDispaly extends StatefulWidget {
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

  FromNameAndTimeStampVotingIconsDispaly({this.visible, this.fromName, this.isMe, this.timeStamp,
    this.isNews, this.conversationId,this.documentId, this.reportedByCount, this.trueByCount,
    this.fakeByCount, this.newsId});

  @override
  _FromNameAndTimeStampVotingIconsDispalyState createState() => _FromNameAndTimeStampVotingIconsDispalyState();
}

class _FromNameAndTimeStampVotingIconsDispalyState extends State<FromNameAndTimeStampVotingIconsDispaly> {
  @override
  Widget build(BuildContext context) {
    print("fakeByCount FromNameAndTimeStamp : ${widget.fakeByCount}");

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
                    onTap1: () async{
                      /// push to news Collection:
                      /// check voteStatus. If true then the user has already voted up
                      /// else the user has not
                      /// If user has already voted up then make him vote down on
                      /// tapping
                      /// votestatus will be true or false
                      /// if false, the increase reportedByCount
                      /// else decrease reportedByCount
                      String category = 'reportedBy';

                      bool voteStatus = await FirebaseMethods().getVoteTrueOrFalse(widget.newsId, category);

                      if(voteStatus == false){
                        setState(() {
                          widget.reportedByCount++;
                        });
                        FirebaseMethods().updateVoteStatusToNewsStatistics(widget.newsId, category, true);
                      } else{
                        setState(() {
                          widget.reportedByCount--;
                        });
                        FirebaseMethods().updateVoteStatusToNewsStatistics(widget.newsId, category, false);
                      }

                      FirebaseMethods().updateVoteCountToNewsCollection(widget.newsId,category, widget.reportedByCount);
                    },
                    onTap2: () async{
                      String category = 'trueBy';

                      /// first check if the user exists in newsStatistics,
                      /// if not add him
                      /// if yes do nothing
                      String userNumber = await UserDetails().getUserPhoneNoFuture();
                      String userName = await UserDetails().getUserNameFuture();
                      if(await NewsStatisticsCollection().checkIfUserExistsInSubCollection(widget.newsId, userNumber, category) == false){
                        await NewsStatisticsCollection().addToSet(widget.newsId, userNumber, userName, category, false);
                      }

                      bool voteStatus = await FirebaseMethods().getVoteTrueOrFalse(widget.newsId, category);
                      bool isOwner = await FirebaseMethods().getHasCreatedOrForwardedTheNews(widget.newsId, category);

                      if(isOwner == false){
                        if(voteStatus == false){
                          setState(() {
                            widget.trueByCount++;
                          });
                          FirebaseMethods().updateVoteStatusToNewsStatistics(widget.newsId, category, true);
                        } else{
                          setState(() {
                            widget.trueByCount--;
                          });
                          FirebaseMethods().updateVoteStatusToNewsStatistics(widget.newsId, category, false);
                        }

                        FirebaseMethods().updateVoteCountToNewsCollection(widget.newsId,category, widget.trueByCount);
                      }else{
                        Duration duration = new Duration(seconds: 2);
                        CustomFlushBar(text: CustomText(text: 'News creator or forwarder cannot change their up vote',),contextual: context,duration: duration,).showFlushBar();
                      }
                    },
                    onTap3: () async{
                      String category = 'fakeBy';
                      String userNumber = await UserDetails().getUserPhoneNoFuture();
                      String userName = await UserDetails().getUserNameFuture();
                      if(await NewsStatisticsCollection().checkIfUserExistsInSubCollection(widget.newsId, userNumber, category) == false){
                        await NewsStatisticsCollection().addToSet(widget.newsId, userNumber, userName, category, false);
                      }

                      bool voteStatus = await FirebaseMethods().getVoteTrueOrFalse(widget.newsId, category);
                      if(voteStatus == false){
                        setState(() {
                          widget.fakeByCount++;
                        });
                        FirebaseMethods().updateVoteStatusToNewsStatistics(widget.newsId, category, true);
                      } else{
                        setState(() {
                          widget.fakeByCount--;
                        });
                        FirebaseMethods().updateVoteStatusToNewsStatistics(widget.newsId, category, false);
                      }

                      FirebaseMethods().updateVoteCountToNewsCollection(widget.newsId,category, widget.fakeByCount);
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
