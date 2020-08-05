import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/individualChat/bodyDisplay.dart';
import 'package:gupshop/individualChat/firebaseMethods.dart';
import 'package:gupshop/messageReadUnread/listOfFriendsReadStatus.dart';
import 'package:gupshop/news/newsContainerUI.dart';
import 'package:video_player/video_player.dart';



/// this class's goal is to create all the data that is necessary
/// for the display of body(i.e only the messages including all
/// types- text,image,video,news,location)
/// and pass it to the display class(bodyDisplay)
class BodyData extends StatelessWidget {
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
  Map<String,NewsContainerUI> mapIsNewsGenerated= new Map();
  List<dynamic> listOfFriendNumbers;

  BodyData({this.conversationId, this.listScrollController, this.documentList, this.controller,
    this.userName, this.isPressed, this.userPhoneNo, this.groupExits, this.scroll, this.value,
    this.listOfFriendNumbers,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: listScrollController, //for scrolling messages
      reverse: true,
      itemCount: documentList.length,
      itemBuilder: (context, index) {
        var messageBody;
        var imageURL;
        var videoURL;

        var fromName = documentList[index].data["fromName"];
        Timestamp timeStamp = documentList[index].data["timeStamp"];
        String fromNameForGroup = documentList[index].data["fromName"]; /// for group messages
        bool isMe;

        double latitude = documentList[index].data["latitude"];
        double longitude = documentList[index].data["longitude"];
        bool isLocationMessage= false;
        if(latitude != null && longitude != null) isLocationMessage = true;

        if (fromName == userName) isMe = true;
        else isMe = false;

        String documentId =  documentList[index].documentID;
        String newsId = documentList[index].data["newsId"];
        bool isSaved = documentList[index].data["isSaved"];

        String messageId = documentList[index].data["messageId"];

        /// get news details from firebase news collection:
        /// wrap BodyDisplay with futurebuilder to get from link, title, news from news collection
        /// get fromname, fromnumber and timestamp from conversation collection
          return FutureBuilder(
            future: FirebaseMethods().getNewsDetailsForDisplay(newsId),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.done){
                String newsBody;
                String newsTitle;
                String newsLink;
                int reportedByCount;
                int trueByCount;
                int fakeByCount;

                if(snapshot.data != null){
                  newsBody = snapshot.data["customNewsDescription"];
                  newsTitle = snapshot.data["customTitle"];
                  newsLink = snapshot.data["link"];
                  reportedByCount = snapshot.data["reportedBy"];
                  trueByCount = snapshot.data["trueBy"];
                  fakeByCount = snapshot.data["fakeBy"];
                }


              bool isNews= false;
              if(newsBody != null) {isNews = true;}
              else if(documentList[index].data["videoURL"] != null){
                videoURL = documentList[index].data["videoURL"];
                controller = VideoPlayerController.network(videoURL);
              }
              else if(documentList[index].data["imageURL"] == null){
                messageBody = documentList[index].data["body"];

              }else{
                imageURL = documentList[index].data["imageURL"];
              }

//              if(isNews){
//                mapIsNewsGenerated = NewsCache().newsValidator(
//                    mapIsNewsGenerated,
//                    newsId,
//                    newsTitle,
//                    newsLink,
//                    newsBody);
//              }

                /// messageReadUnread :
                return FutureBuilder(
                  future: ListOfFriendStatusReadStatus(listOfFriends: listOfFriendNumbers, conversationId: conversationId, conversationsLatestMessageTimestamp: timeStamp).readStatus(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      bool isRead = snapshot.data;
                      print("isRead : $isRead");

                      return BodyDisplay(
                        isRead: isRead,
                        conversationId: conversationId,
                        controller: controller,
                        userName: userName,
                        isPressed: isPressed,
                        userPhoneNo: userPhoneNo,
                        groupExits: groupExits,
                        mapIsNewsGenerated: mapIsNewsGenerated,
                        messageBody: messageBody,
                        imageURL:imageURL,
                        videoURL:videoURL,
                        newsBody:newsBody,
                        newsTitle:newsTitle,
                        newsLink:newsLink,
                        reportedByCount:reportedByCount,
                        trueByCount:trueByCount,
                        fakeByCount:fakeByCount,
                        newsId:newsId,
                        isMe:isMe,
                        latitude:latitude,
                        longitude:longitude,
                        isLocationMessage:isLocationMessage,
                        fromName:fromName,
                        isNews:isNews,
                        fromNameForGroup:fromNameForGroup,
                        timeStamp:timeStamp,
                        documentId: documentId,
                        messageId : messageId ,
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );

                }return Center(
                  child: CircularProgressIndicator(),
              );
            }
          );
      },
      separatorBuilder: (context, index) => Divider(
        color: Colors.white,
      ),
    );
  }
}
