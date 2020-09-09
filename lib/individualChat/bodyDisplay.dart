import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/individualChat/firebaseMethods.dart';
import 'package:gupshop/individualChat/heartButton.dart';
import 'package:gupshop/individualChat/individualChatCache.dart';
import 'package:gupshop/news/newsContainerUI.dart';
import 'package:gupshop/news/newsStatisticsCollection.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/retriveFromFirebase/getMessageSavedStatusFromFirebase.dart';
import 'package:gupshop/image/fullScreenPictureVideos.dart';
import 'package:gupshop/widgets/customDialogForConfirmation.dart';
import 'package:gupshop/widgets/customNavigators.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:gupshop/widgets/forwardMessagesSnackBarTitleText.dart';
import 'package:gupshop/individualChat/fromNameAndTimeStampVotingRead.dart';
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
  String messageId;
  List<dynamic> listOfFriendNumbers;
  Map<String, bool> readCache;
  Map<String, IndividualChatCache> individualChatCache;

  BodyDisplay({this.mapIsNewsGenerated, this.newsId, this.newsBody, this.newsLink,
    this.newsTitle, this.isNews, this.controller, this.messageBody, this.videoURL,
    this.longitude, this.latitude, this.fromName, this.isLocationMessage, this.imageURL,
    this.isMe, this.groupExits, this.isPressed, this.userPhoneNo, this.userName,
    this.conversationId, this.trueByCount, this.fakeByCount, this.reportedByCount,
    this.timeStamp, this.fromNameForGroup,this.documentId, this.messageId,this.listOfFriendNumbers,
    this.readCache, this.individualChatCache,
  });

  @override
  _BodyDisplayState createState() => _BodyDisplayState();
}

class _BodyDisplayState extends State<BodyDisplay> {

  @override
  void initState() {
    print("individualchache in bodyDisplay : ${widget.individualChatCache}");
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

          /// here, only the picture message can be opened
          /// video message opening logic is in CustomVideoPlayer because
          /// it needs a controller to control the video to be played or
          /// paused when the user navigates to ViewPicturesVideosFromChat
          /// otherwise the video keeps playing in the background
          if(openMessage != null && isPicture==true){
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenPictureAndVideos(payLoad: openMessage, isPicture: isPicture,),//pass Name() here and pass Home()in name_screen
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
            String forwardLocation;

            ///extract the message in a variable called forwardMessage(ideally there should be
            /// a list of messages and not just one variable..this is a @todo )

            if(widget.newsBody != null){
              forwardNews = widget.newsBody;
            }else if(widget.messageBody != null && widget.latitude != null){
              forwardLocation = widget.messageBody;
            }
            else if(widget.messageBody != null){
              forwardMessage = widget.messageBody;
            }else if(widget.videoURL != null){
              forwardVideo = widget.videoURL;
            }else forwardImage = widget.imageURL;


            ///show snackbar
            return Flushbar(
              flushbarStyle: FlushbarStyle.GROUNDED,
              padding : EdgeInsets.all(PaddingConfig.six),
              borderRadius: WidgetConfig.flushbarBorderRadiusEight,
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
                    data = {"news":widget.newsBody, "link": widget.newsLink,
                      "title": widget.newsTitle, "fromName":widget.userName,
                      "fromPhoneNumber":widget.userPhoneNo, "timeStamp":Timestamp.now(),
                      "conversationId":widget.conversationId,
                      "reportedBy": widget.reportedByCount, "trueBy": widget.trueByCount,
                      "fakeBy":widget.fakeByCount, "newsId": widget.newsId};

                    /// beforing forwarding, ask tell the user that forwarding means agreeing to whatever
                    /// is there in the news. And increase the trueBy count as he agrees to it.
                    bool forwardYesOrNo = await CustomDialogForConfirmation(
                      title: "Forward the NEWS",
                      content: "Forwarding the news means you agree to the content "
                          "to be true.",
                      barrierDismissible: false,
                    ).dialog(context);

                    /// increasing the trueBy count by 1:
                    if(forwardYesOrNo == true){
                      /// increase the count only if the user doesnt exist in newsStatistics trueBy collection
                      /// if the user has not forwarded or created before then his trueby will be false
                      /// if trueBy is false and

                      bool hasForwardedOrCreatedNewsAlready = await NewsStatisticsCollection().checkIfUserExistsInSubCollection(widget.newsId, widget.userPhoneNo, 'trueBy');
                      if(hasForwardedOrCreatedNewsAlready == false){
                        int increaseTrueByCount = data["trueBy"] + 1 ;
                        data["trueBy"]= increaseTrueByCount;
                        await NewsStatisticsCollection().checkIfUserExistsAndAddToSet(widget.newsId,
                            widget.userPhoneNo,widget.userName, 'trueBy', true);
                        await FirebaseMethods().updateVoteCountToNewsCollection(widget.newsId,
                            'trueBy', data["trueBy"]);
                      }
                      CustomNavigator().navigateToContactSearch(context, widget.userName,
                          widget.userPhoneNo, data);
                    }
                  }
                  else{
                    if(forwardLocation != null) data = {"body":forwardLocation,
                      "fromName":widget.userName, "fromPhoneNumber":widget.userPhoneNo,
                      "timeStamp":Timestamp.now(), "conversationId":widget.conversationId,
                      "latitude" : widget.latitude, "longitude" : widget.longitude};
                    else if(forwardMessage != null) data = {"body":forwardMessage,
                      "fromName":widget.userName, "fromPhoneNumber":widget.userPhoneNo,
                      "timeStamp":Timestamp.now(), "conversationId":widget.conversationId};
                    else if(forwardVideo != null) data = {"videoURL":forwardVideo,
                      "fromName":widget.userName, "fromPhoneNumber":widget.userPhoneNo,
                      "timeStamp":Timestamp.now(), "conversationId":widget.conversationId};
                    else data = {"imageURL":forwardImage, "fromName":widget.userName,
                        "fromPhoneNumber":widget.userPhoneNo, "timeStamp":Timestamp.now(),
                        "conversationId":widget.conversationId};
                    CustomNavigator().navigateToContactSearch(context, widget.userName,
                        widget.userPhoneNo, data);
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
        child: messageCached() == false?
        MessageCardDisplay(
          isMe: widget.isMe, isNews: widget.isNews, imageURL: widget.imageURL,
          isLocationMessage: widget.isLocationMessage,
          newsLink: widget.newsLink, newsBody: widget.newsBody,
          newsTitle: widget.newsTitle, fromName: widget.fromName,
          latitude: widget.latitude,longitude: widget.longitude,
          videoURL: widget.videoURL,messageBody: widget.messageBody,
          controller: widget.controller, newsId: widget.newsId,
          mapIsNewsGenerated: widget.mapIsNewsGenerated,
          individualChatCache: widget.individualChatCache,
          messageId: widget.messageId,
        ) : getCachedMessageContainer(),
      ),
      isThreeLine: true,
      subtitle: FromNameAndTimeStampVotingRead(/// three icons are in this class
        messageId: widget.messageId,
        readCache: widget.readCache,
        timestamp: widget.timeStamp,
        listOfFriendNumbers: widget.listOfFriendNumbers,
        newsId: widget.newsId,
        conversationId: widget.conversationId,
        documentId: widget.documentId,
        reportedByCount: widget.reportedByCount,
        trueByCount: widget.trueByCount,
        fakeByCount: widget.fakeByCount,
        isNews: widget.isNews,
        visible: ((widget.groupExits==null? false : widget.groupExits)
            && widget.isMe==false),/// groupExits==null? false : groupExits was showing error because groupExists takes time to calculate as it is a future, so we are just adding a placeholder,
        fromName:  CustomText(text: widget.fromNameForGroup,
          fontSize: TextConfig.fontSizeTwelve,),
        isMe: widget.isMe,
        timeStamp:Text(//time
          DateFormat("dd MMM kk:mm")
              .format(DateTime.fromMillisecondsSinceEpoch(
              int.parse(widget.timeStamp.millisecondsSinceEpoch.toString()))),//converting firebase timestamp to pretty print
          style: TextStyle(
              color: Colors.grey, fontSize: TextConfig.fontSizeTwelve,
              fontStyle: FontStyle.italic
          ),
        ),
      ),
    );
  }

  getCachedMessageContainer(){
    return widget.individualChatCache[widget.messageId].messageContainer;
  }

  messageCached(){
    if(widget.individualChatCache == null) return false;
    return widget.individualChatCache.containsKey(widget.messageId);
  }
}
