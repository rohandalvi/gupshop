import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/news/newsCache.dart';
import 'package:gupshop/news/newsContainerUI.dart';
import 'package:gupshop/news/newsStatisticsCollection.dart';
import 'package:gupshop/service/viewPicturesVideosFromChat.dart';
import 'package:gupshop/widgets/customDialogForConfirmation.dart';
import 'package:gupshop/widgets/customNavigators.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:gupshop/widgets/forwardMessagesSnackBarTitleText.dart';
import 'package:gupshop/widgets/fromNameAndTimeStampVotingIcons.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';
import 'messageCardDisplay.dart';

class BodyDisplay extends StatefulWidget {
  String conversationId;
  VideoPlayerController controller;
  String userName;
  bool isPressed;
  String userPhoneNo;
  bool groupExits;
  Map<String,NewsContainerUI> mapIsNewsGenerated;

  var messageBody;
  var imageURL;
  var videoURL;
  String newsBody;
  String newsTitle;
  String newsLink;
  int reportedByCount;
  int trueByCount;
  int fakeByCount;
  String newsId;
  bool isMe;
  double latitude;
  double longitude;
  bool isLocationMessage;
  dynamic fromName;
  bool isNews;
  String fromNameForGroup;
  Timestamp timeStamp;
  String documentId;

  BodyDisplay({this.mapIsNewsGenerated, this.newsId, this.newsBody, this.newsLink,
  this.newsTitle, this.isNews, this.controller, this.messageBody, this.videoURL,
  this.longitude, this.latitude, this.fromName, this.isLocationMessage, this.imageURL,
  this.isMe, this.groupExits, this.isPressed, this.userPhoneNo, this.userName,
  this.conversationId, this.trueByCount, this.fakeByCount, this.reportedByCount,
  this.timeStamp, this.fromNameForGroup,this.documentId});

  @override
  _BodyDisplayState createState() => _BodyDisplayState();
}

class _BodyDisplayState extends State<BodyDisplay> {

  @override
  void initState() {
//    if(widget.isNews){
//      widget.mapIsNewsGenerated = NewsCache().newsValidator(
//          widget.mapIsNewsGenerated,
//          widget.newsId,
//          widget.newsTitle,
//          widget.newsLink,
//          widget.newsBody);
//    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: GestureDetector(
        onTap: (){
          String openMessage;
          bool isPicture;
          // FocusScope.of(context).unfocus();///Not working!!
          if(widget.messageBody != null){
            openMessage = null;
          }else if(widget.videoURL != null){
            openMessage = widget.videoURL;
            isPicture = false;
          }else {
            openMessage = widget.imageURL;
            isPicture = true;
          }

          if(openMessage != null){
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewPicturesVideosFromChat(payLoad: openMessage, isPicture: isPicture,),//pass Name() here and pass Home()in name_screen
                )
            );
          }
        },
        onLongPress: (){
          if(widget.isPressed == false){///show snackbar only once
            widget.isPressed = true;
            String forwardMessage;
            String forwardImage;
            String forwardVideo;
            String forwardNews;

            ///extract the message in a variable called forwardMessage(ideally there should be
            /// a list of messages and not just one variable..this is a @todo )

            if(widget.newsBody != null){
              forwardNews = widget.newsBody;
              print("forwardNews: $forwardNews");
            }else if(widget.messageBody != null){
              forwardMessage = widget.messageBody;
            }else if(widget.videoURL != null){
              forwardVideo = widget.videoURL;
            }else forwardImage = widget.imageURL;


            ///show snackbar
            return Flushbar(
              //showProgressIndicator: true,
              flushbarStyle: FlushbarStyle.GROUNDED,
              padding : EdgeInsets.all(6),
              borderRadius: 8,
              backgroundColor: Colors.white,

              dismissDirection: FlushbarDismissDirection.HORIZONTAL,

              forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
              titleText: ForwardMessagesSnackBarTitleText(
                ///what to do after the user longPresses a message
                onTap: () async{
                  ///open search page
                  ///on selecting a contact, send message to that contact

                  var data;
                  /// for news, we need to show a dialog, and if the dialog returns true then only the user gets
                  /// navigated to contactSearch
                  if(forwardNews != null) {
                    data = {"news":widget.newsBody, "link": widget.newsLink, "title": widget.newsTitle, "fromName":widget.userName, "fromPhoneNumber":widget.userPhoneNo, "timeStamp":DateTime.now(), "conversationId":widget.conversationId, "reportedBy": widget.reportedByCount, "trueBy": widget.trueByCount, "fakeBy":widget.fakeByCount, "newsId": widget.newsId};
                    /// beforing forwarding, ask tell the user that forwarding means agreeing to whatever
                    /// is there in the news. And increase the trueBy count as he agrees to it.
                    bool forwardYesOrNo = await CustomDialogForConfirmation(
                      title: "Forward the NEWS",
                      content: "Forwarding the news means you agree to the content "
                          "to be true.",
                    ).dialog(context);

                    /// increasing the trueBy count by 1:
                    if(forwardYesOrNo == true){
                      /// increase the count only if the user doesnt exist in newsStatistics trueBy collection
                      bool hasForwardedOrCreatedNewsAlready = await NewsStatisticsCollection().checkIfUserExistsInSubCollection(widget.newsId, widget.userPhoneNo, 'trueBy');
                      if(hasForwardedOrCreatedNewsAlready == false){
                        int increaseTrueByCount = data["trueBy"] + 1 ;
                        data["trueBy"]= increaseTrueByCount;
                        await NewsStatisticsCollection().addToSet(widget.newsId, widget.userName, widget.userPhoneNo, 'trueBy', true);
                      }
                      CustomNavigator().navigateToContactSearch(context, widget.userName,  widget.userPhoneNo, data);
                    }
                  }
                  else{
                    if(forwardMessage != null) data = {"body":forwardMessage, "fromName":widget.userName, "fromPhoneNumber":widget.userPhoneNo, "timeStamp":DateTime.now(), "conversationId":widget.conversationId};
                    else if(forwardVideo != null) data = {"videoURL":forwardVideo, "fromName":widget.userName, "fromPhoneNumber":widget.userPhoneNo, "timeStamp":DateTime.now(), "conversationId":widget.conversationId};
                    else data = {"imageURL":forwardImage, "fromName":widget.userName, "fromPhoneNumber":widget.userPhoneNo, "timeStamp":DateTime.now(), "conversationId":widget.conversationId};

                    ;
                    CustomNavigator().navigateToContactSearch(context, widget.userName,  widget.userPhoneNo, data);
                  }
                },
              ),
              message: 'Change',
              onStatusChanged: (val){
                ///if the user longPresses the button once, dismesses it and later presses
                ///it again then the snackbar was not appearing, because isPressed was
                ///set to true. So when the flushbar is dismissed, we are setting isPressed
                ///to false again, so the snackbar can appear again
                if(val == FlushbarStatus.DISMISSED){
                  widget.isPressed = false;
                }
              },

            )..show(context);
          } return Container();

        },
        child: MessageCardDisplay(
          isMe: widget.isMe, isNews: widget.isNews, imageURL: widget.imageURL, isLocationMessage: widget.isLocationMessage,
          newsLink: widget.newsLink, newsBody: widget.newsBody, newsTitle: widget.newsTitle, fromName: widget.fromName,
          latitude: widget.latitude,longitude: widget.longitude,videoURL: widget.videoURL,messageBody: widget.messageBody,
          controller: widget.controller, newsId: widget.newsId, mapIsNewsGenerated: widget.mapIsNewsGenerated,
        ),
      ),
      isThreeLine: true,
      subtitle: FromNameAndTimeStampVotingIcons(/// three icons are in this class
        conversationId: widget.conversationId,
        documentId: widget.documentId,
        reportedByCount: widget.reportedByCount,
        trueByCount: widget.trueByCount,
        fakeByCount: widget.fakeByCount,
        isNews: widget.isNews,
        visible: ((widget.groupExits==null? false : widget.groupExits) && widget.isMe==false),/// groupExits==null? false : groupExits was showing error because groupExists takes time to calculate as it is a future, so we are just adding a placeholder,
        fromName:  CustomText(text: widget.fromNameForGroup,fontSize: 12,),
        isMe: widget.isMe,
        timeStamp:Text(//time
          DateFormat("dd MMM kk:mm")
              .format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.timeStamp.millisecondsSinceEpoch.toString()))),//converting firebase timestamp to pretty print
          style: TextStyle(
              color: Colors.grey, fontSize: 12.0, fontStyle: FontStyle.italic
          ),
        ),
      ),
    );
  }
}