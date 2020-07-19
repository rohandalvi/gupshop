import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gupshop/individualChat/messageCardDisplay.dart';
import 'package:gupshop/news/newsContainerUI.dart';
import 'package:gupshop/news/newsUsersCollection.dart';
import 'package:gupshop/service/addToFriendsCollection.dart';
import 'package:gupshop/service/geolocation_service.dart';
import 'package:gupshop/service/imagePickersDisplayPicturesFromURLorFile.dart';
import 'package:gupshop/service/recentChats.dart';
import 'package:gupshop/service/sendAndDisplayMessages.dart';
import 'package:gupshop/service/videoPicker.dart';
import 'package:gupshop/service/viewPicturesVideosFromChat.dart';
import 'package:gupshop/widgets/buildMessageComposer.dart';
import 'package:gupshop/widgets/customDialogForConfirmation.dart';
import 'package:gupshop/widgets/customNavigators.dart';
import 'package:gupshop/widgets/customRaisedButton.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:gupshop/widgets/customVideoPlayer.dart';
import 'package:gupshop/widgets/displayPicture.dart';
import 'package:gupshop/widgets/forwardMessagesSnackBarTitleText.dart';
import 'package:gupshop/widgets/fromNameAndTimeStamp.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';

class Body extends StatefulWidget {
  String conversationId;
  ScrollController listScrollController = new ScrollController(); //for scrolling the screen
  List<DocumentSnapshot> documentList;
  VideoPlayerController controller;
  String userName;
  bool isPressed;
  String userPhoneNo;
  bool groupExits;
  bool scroll = false;
  String value;
  Body({this.conversationId, this.listScrollController, this.documentList, this.controller,
    this.userName, this.isPressed, this.userPhoneNo, this.groupExits, this.scroll, this.value,
  });

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: widget.listScrollController, //for scrolling messages
      //shrinkWrap: true,
      reverse: true,
      itemCount: widget.documentList.length,
      itemBuilder: (context, index) {
        var messageBody;
        var imageURL;
        var videoURL;

        String newsBody = widget.documentList[index].data["news"];
        String newsTitle = widget.documentList[index].data["title"];
        String newsLink = widget.documentList[index].data["link"];
        int reportedByCount = widget.documentList[index].data["reportedBy"];
        int trueByCount = widget.documentList[index].data["trueBy"];
        int fakeByCount = widget.documentList[index].data["fakeBy"];

        bool isNews= false;
        if(newsBody != null) {isNews = true;}
        else if(widget.documentList[index].data["videoURL"] != null){
          videoURL = widget.documentList[index].data["videoURL"];
          widget.controller = VideoPlayerController.network(videoURL);
        }
        else if(widget.documentList[index].data["imageURL"] == null){
          messageBody = widget.documentList[index].data["body"];

        }else{
          imageURL = widget.documentList[index].data["imageURL"];
        }
        //var messageBody = documentList[index].data["body"];
        var fromName = widget.documentList[index].data["fromName"];
        Timestamp timeStamp = widget.documentList[index].data["timeStamp"];
        String fromNameForGroup = widget.documentList[index].data["fromName"]; /// for group messages
//                            bool isMe = false;
        bool isMe;

        double latitude = widget.documentList[index].data["latitude"];
        double longitude = widget.documentList[index].data["longitude"];
        bool isLocationMessage= false;
        if(latitude != null && longitude != null) isLocationMessage = true;

        if (fromName == widget.userName) isMe = true;
        else isMe = false;

        String documentId =  widget.documentList[index].documentID;
        String newsId = widget.documentList[index].data["newsId"];

        print("isMe : $isMe");

        return ListTile(
          title: GestureDetector(
            onTap: (){
              String openMessage;
              bool isPicture;
              // FocusScope.of(context).unfocus();///Not working!!
              if(messageBody != null){
                openMessage = null;
              }else if(videoURL != null){
                openMessage = videoURL;
                isPicture = false;
              }else {
                openMessage = imageURL;
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
//                                onDoubleTap: (){
//                                if(isLocationMessage == true){
//                                  GeolocationServiceState().launchMapsUrl(latitude, longitude);
//                                }
//                                },
            onLongPress: (){
              if(widget.isPressed == false){///show snackbar only once
                widget.isPressed = true;
                String forwardMessage;
                String forwardImage;
                String forwardVideo;
                String forwardNews;

                ///extract the message in a variable called forwardMessage(ideally there should be
                /// a list of messages and not just one variable..this is a @todo )

                if(newsBody != null){
                  forwardNews = newsBody;
                  print("forwardNews: $forwardNews");
                }else if(messageBody != null){
                  forwardMessage = messageBody;
                }else if(videoURL != null){
                  forwardVideo = videoURL;
                }else forwardImage = imageURL;


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
                        data = {"news":newsBody, "link": newsLink, "title": newsTitle, "fromName":widget.userName, "fromPhoneNumber":widget.userPhoneNo, "timeStamp":DateTime.now(), "conversationId":widget.conversationId, "reportedBy": reportedByCount, "trueBy": trueByCount, "fakeBy":fakeByCount, "newsId": newsId};
                        /// beforing forwarding, ask tell the user that forwarding means agreeing to whatever
                        /// is there in the news. And increase the trueBy count as he agrees to it.
                        bool forwardYesOrNo = await CustomDialogForConfirmation(
                          title: "Forward the NEWS",
                          content: "Forwarding the news means you agree to the content "
                              "to be true.",
                        ).dialog(context);

                        /// increasing the trueBy count by 1:
                        if(forwardYesOrNo == true){
                          /// increase the count only if the user doesnt exist in forwardNewsUsers collection
                          bool hasForwardedOrCreatedNewsAlready = await NewsUsersCollection().addToSet(newsId, widget.userPhoneNo, widget.userName);
                          if(hasForwardedOrCreatedNewsAlready == false){
                            int increaseTrueByCount = data["trueBy"] + 1 ;
                            data["trueBy"]= increaseTrueByCount;
                          }
                          CustomNavigator().navigateToContactSearch(context, widget.userName,  widget.userPhoneNo, data);
                        }
                      }
                      else{
                        if(forwardMessage != null) data = {"body":forwardMessage, "fromName":widget.userName, "fromPhoneNumber":widget.userPhoneNo, "timeStamp":DateTime.now(), "conversationId":widget.conversationId};
                        else if(forwardVideo != null) data = {"videoURL":forwardVideo, "fromName":widget.userName, "fromPhoneNumber":widget.userPhoneNo, "timeStamp":DateTime.now(), "conversationId":widget.conversationId};
                        else data = {"imageURL":forwardImage, "fromName":widget.userName, "fromPhoneNumber":widget.userPhoneNo, "timeStamp":DateTime.now(), "conversationId":widget.conversationId};


                        print("data in flushbar: $data");
                        print("userName: $widget.userName");
                        print("userPhoneNo: $widget.userPhoneNo");
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
              isMe: isMe, isNews: isNews, imageURL: imageURL, isLocationMessage: isLocationMessage,
              newsLink: newsLink, newsBody: newsBody, newsTitle: newsTitle, fromName: fromName,
              latitude: latitude,longitude: longitude,videoURL: videoURL,messageBody: messageBody,
              controller: widget.controller, newsId: newsId,
            ),
          ),
          isThreeLine: true,
          subtitle: FromNameAndTimeStamp(/// three icons are in this class
            reportedByCount: reportedByCount,
            trueByCount: trueByCount,
            fakeByCount: fakeByCount,
            isNews: isNews,
            visible: ((widget.groupExits==null? false : widget.groupExits) && isMe==false),/// groupExits==null? false : groupExits was showing error because groupExists takes time to calculate as it is a future, so we are just adding a placeholder,
            fromName:  CustomText(text: fromNameForGroup,fontSize: 12,),
            isMe: isMe,
            timeStamp:Text(//time
              DateFormat("dd MMM kk:mm")
                  .format(DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp.millisecondsSinceEpoch.toString()))),//converting firebase timestamp to pretty print
              style: TextStyle(
                  color: Colors.grey, fontSize: 12.0, fontStyle: FontStyle.italic
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(
        color: Colors.white,
      ),
    );
  }
}
