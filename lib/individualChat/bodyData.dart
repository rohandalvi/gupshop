import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/PushToFirebase/newsCollection.dart';
import 'package:gupshop/individualChat/bodyDisplay.dart';
import 'package:gupshop/individualChat/firebaseMethods.dart';
import 'package:gupshop/individualChat/individualChatCache.dart';
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
  Map<String, bool> readCache;
  Map<String, IndividualChatCache> individualChatCache;

  BodyData({this.conversationId, this.listScrollController, this.documentList, this.controller,
    this.userName, this.isPressed, this.userPhoneNo, this.groupExits, this.scroll, this.value,
    this.listOfFriendNumbers, this.readCache, this.individualChatCache
  });


  @override
  Widget build(BuildContext context) {
    ///If you use a shrink-wrapped ListView with reverse: true, scrolling it to 0.0,
    ///then the user scrolls down to the latest message of the screen
    ///when he enters the screen
    return ListView.separated(
      shrinkWrap: true, /// for scrolling to the end of the screen when the user enters the screen
      controller: listScrollController, //for scrolling messages
      reverse: true,/// for scrolling to the end of the screen when the user enters the screen
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
//        String messageId = documentList[index].documentID;


        /// readUnread cache:
        /// first time when individual chat screen is loaded, all the
        /// messages will be stored as false in the map(readCache).
        /// Then at the fromNameTimeStamp page, the actual futurebuilder will
        /// be called which will check the status of the message from
        /// messageReadUnread collection. If the message is read, then it gets
        /// stored as true in the map and next time when this screen is called
        /// if the message is true then the future call for messageReadUnread
        /// collection will not be made.

        if(newsId == null){
          if(documentList[index].data["videoURL"] != null){
            videoURL = documentList[index].data["videoURL"];
            controller = VideoPlayerController.network(videoURL);
            print("video fetched for display");
          }
          else if(documentList[index].data["imageURL"] == null){
            messageBody = documentList[index].data["body"];

          }else{
            imageURL = documentList[index].data["imageURL"];
          }

          /// readUnread cache:
          /// first time when individual chat screen is loaded, all the
          /// messages will be stored as false in the map(readCache).
          /// Then at the fromNameTimeStamp page, the actual futurebuilder will
          /// be called which will check the status of the message from
          /// messageReadUnread collection. If the message is read, then it gets
          /// stored as true in the map and next time when this screen is called
          /// if the message is true then the future call for messageReadUnread
          /// collection will not be made.
          return BodyDisplay(
            individualChatCache: individualChatCache,
            readCache: readCache,
            listOfFriendNumbers: listOfFriendNumbers,
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
            newsId:newsId,
            isMe:isMe,
            latitude:latitude,
            longitude:longitude,
            isLocationMessage:isLocationMessage,
            fromName:fromName,
            isNews:false,
            fromNameForGroup:fromNameForGroup,
            timeStamp:timeStamp,
            documentId: documentId,
            messageId : messageId ,
                );
        }else{
          /// get news details from firebase news collection:
          /// wrap BodyDisplay with futurebuilder to get from link, title, news from news collection
          /// get fromname, fromnumber and timestamp from conversation collection
           return helper(messageId, messageBody, imageURL, videoURL, null, null, null, newsId,
             isMe, latitude, longitude, isLocationMessage, fromName, true, fromNameForGroup, timeStamp,
             documentId, index
           );
        }
      },
      separatorBuilder: (context, index) => Divider(
        color: Colors.white,
      ),
    );
  }


  helper(String messageId,String messageBody,String imageURL, String videoURL, int reportedByCount,
      int trueByCount, int fakeByCount, String newsId, bool isMe,
      double latitude, double longitude, bool isLocationMessage,
      String fromName, bool isNews, String fromNameForGroup, Timestamp timeStamp, String documentId,
      int index,
      ){
    if(individualChatCache.containsKey(messageId)){
      String newsBody = individualChatCache[messageId].newsBody;
      String newsTitle = individualChatCache[messageId].newsTitle;
      String newsLink = individualChatCache[messageId].newsLink;

      return BodyDisplay(
        individualChatCache: individualChatCache,
        readCache: readCache,
        listOfFriendNumbers: listOfFriendNumbers,
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
    } else{
      return FutureBuilder(
          future: NewsCollection().getNewsDetailsForDisplay(newsId),
          //FirebaseMethods().getNewsDetailsForDisplay(newsId),
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

              return BodyDisplay(
                individualChatCache: individualChatCache,
                readCache: readCache,
                listOfFriendNumbers: listOfFriendNumbers,
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

            }return
              Center(
                child: CircularProgressIndicator(),
              );
          }
      );
    }
  }
}
