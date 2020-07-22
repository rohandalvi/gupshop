import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gupshop/individualChat/bodyData.dart';
import 'package:gupshop/service/addToFriendsCollection.dart';
import 'package:gupshop/service/geolocation_service.dart';
import 'package:gupshop/service/imagePickersDisplayPicturesFromURLorFile.dart';
import 'package:gupshop/service/recentChats.dart';
import 'package:gupshop/individualChat/firebaseMethods.dart';
import 'package:gupshop/service/videoPicker.dart';
import 'package:gupshop/service/viewPicturesFromChat.dart';
import 'package:gupshop/individualChat/buildMessageComposer.dart';
import 'package:gupshop/widgets/customBottomSheet.dart';
import 'package:video_player/video_player.dart';

class BodyScrollComposer extends StatefulWidget {
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
  String groupName;
  String friendN;
  List<dynamic> listOfFriendNumbers;
  TextEditingController controllerTwo;

  BodyScrollComposer({this.conversationId, this.listScrollController, this.documentList, this.controller,
    this.userName, this.isPressed, this.userPhoneNo, this.groupExits, this.scroll, this.value,
    this.friendN, this.groupName, this.listOfFriendNumbers,this.controllerTwo,
  });

  @override
  _BodyScrollComposerState createState() => _BodyScrollComposerState();
}

class _BodyScrollComposerState extends State<BodyScrollComposer> {
  int limitCounter = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()), //remove focus
      //onTap: () => FocusScope.of(context).unfocus(), //to take out the keyboard when tapped on chat screen
      child: Stack(
        children: <Widget>[
          Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection("conversations").document(widget.conversationId).collection("messages").orderBy("timeStamp", descending: true).limit(limitCounter*10).snapshots(),
                    //stream,
                    builder: (context, snapshot) {
                      if(snapshot.data == null) return CircularProgressIndicator();//to avoid error - "getter document was called on null"
                      widget.documentList = snapshot.data.documents;
                      return NotificationListener<ScrollUpdateNotification>(
                        child: BodyData(
                          conversationId: widget.conversationId,
                          controller: widget.controller,
                          documentList: widget.documentList,
                          listScrollController: widget.listScrollController,
                          userName: widget.userName,
                          userPhoneNo: widget.userPhoneNo,
                          isPressed: widget.isPressed,
                          groupExits: widget.groupExits,
                          value: widget.value,
                          scroll: widget.scroll,
                        ),
                        onNotification: (notification) {
                          /// ScrollUpdateNotification :
                          /// for listining when the user scrolls up
                          /// Show the scrolltobottom button only when the user scrolls up
                          if(notification is ScrollUpdateNotification){
                            /// *** explaintaion of if(notification.scrollDelta > 0):
                            /// The problem we has was, setting the state of scroll to false in
                            /// _scrollToTheBottom methos was making the scroll false, but while
                            /// scrolling down there used to be another update on ScrollUpdateNotification
                            /// and it would again set the scroll to true in setState
                            /// So we had to figure out a way to set the state to true only when the
                            /// user is scrolling up.
                            /// if(notification.scrollDelta > 0):
                            ///if we print notification, then we can note that if the screen scrolls
                            ///down then the scrollDelta shows in minus.
                            //someone from stackoverflow said :
                            //if (scrollNotification.metrics.pixels - scrollNotification.dragDetails.delta.dy > 0)
                            //but this was giving us error that delta was called on null, so i used :
                            //if(notification.scrollDelta > 0)
                            if(notification.scrollDelta > 0){
                              setState(() {
                                widget.scroll = true;
                              });
                            }


                            ///scroll button to disappear when the user goes down manually
                            ///without pressing the scrollDown button
                            if(notification.metrics.atEdge
                                &&  !((notification.metrics.pixels - notification.metrics.maxScrollExtent) >
                                    (notification.metrics.minScrollExtent-notification.metrics.pixels))){
                              setState(() {
                                widget.scroll = false;
                              });
                            }
                          }

                          ///onNotification allows us to know when we have reached the limit of the messages
                          ///once the limit is reached, documentList is updated again  with the next 10 messages using
                          ///the fetchAdditionalMesages()
                          if(notification.metrics.atEdge
                              &&  !((notification.metrics.pixels - notification.metrics.minScrollExtent) <
                                  (notification.metrics.maxScrollExtent-notification.metrics.pixels))) {

//                        if(isLoading == true) {//ToDo- check if this is  working with an actual phone
//                          CircularProgressIndicator();}
                            setState(() {
                              limitCounter++;
                            });
                            //fetchAdditionalMessages();
                          }
                          return true;
                        },
                      );
                    }),
              ),
              _buildMessageComposer(),//write and send new message bar
            ],
          ),
          _scrollToBottomButton(),
        ],
      ),
    );
  }

  _scrollToBottomButton(){///the button with down arrow that should appear only when the user scrolls
    return Visibility(/// a placeholder widget isValid widget
      visible: widget.scroll,
      child: Align(
          alignment: Alignment.centerRight,
          child:
          //scrollListener() ?
          FloatingActionButton(
            tooltip: 'Scroll to the bottom',
            backgroundColor: Colors.transparent,
            elevation: 0,
            highlightElevation: 0,
            child: IconButton(
                icon: SvgPicture.asset('images/downArrow.svg',)
            ),
            onPressed: (){
              setState(() {
                widget.scroll = false;
              });
              widget.listScrollController.animateTo(//for scrolling to the bottom of the screen when a next text is send
                0.0,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
              );
            },
          )
        //: new Align(),
      ),
    );
  }

  _buildMessageComposer() {//the type and send message box
        return StatefulBuilder(
          builder: (context, StateSetter setState){
            return BuildMessageComposer(
              firstOnPressed: () async{
                return CustomBottomSheet(
                  customContext: context,
                  firstIconName: 'image2vector',
                  firstIconText: 'Pick image from  gallery',
                  firstIconAndTextOnPressed: (){},
                  secondIconName: 'videoCamera',
                  secondIconText: 'Pick image from camera',
                  secondIconAndTextOnPressed: (){},
                ).show();
//            var data = await sendImage();
//            pushMessageDataToFirebase(false,true,null,data);
//            setState(() {
//
//            });
              },
              secondOnPressed: () async{
                var data = await sendVideo();
                pushMessageDataToFirebase(true,false,null,data);
                setState(() {

                });
              },
              onChangedForTextField: (value){
                setState(() {
                  this.widget.value=value;///by doing this we are setting the value to value globally
                });
              },
              conversationId: widget.conversationId,
              userName: widget.userName,
              userPhoneNo: widget.userPhoneNo,
              groupName: widget.groupName,
              groupExits: widget.groupExits,
              friendN: widget.friendN,
              listOfFriendNumbers: widget.listOfFriendNumbers,
              value: widget.value,
              listScrollController: widget.listScrollController,
              onPressedForSendingMessageIcon:() async{
                /// when mynumber sends message to a friendNumber in whose friends
                /// collection mynumber does not exist, we have to add that person in
                /// his friends because recent chats wont work then

                ///push to all others friends collection here
                ///this wont ever happen in case of groupchat, because in groupchat all members already have
                ///group as their friend as we have set it this way in createNameForGroup_screen page
                if(widget.groupExits == false){
                  var myNumberExistsInFriendsFriendsCollectionWaiting = await Firestore.instance.collection("friends_${widget.friendN}").document(widget.userPhoneNo).get();
                  var myNumberExistsInFriendsFriendsCollection = myNumberExistsInFriendsFriendsCollectionWaiting.data;
                  if(myNumberExistsInFriendsFriendsCollection == null){
                    List<String> nameListForOthers = new List();
                    nameListForOthers.add(widget.userName);
                    AddToFriendsCollection().extractNumbersFromListAndAddToFriendsCollection(widget.listOfFriendNumbers, widget.conversationId, widget.userPhoneNo, nameListForOthers, null, null);
                  }
                }
                if(widget.groupExits == true){
                  DocumentSnapshot adminNumberFuture = await Firestore.instance.collection("conversationMetadata").document(widget.conversationId).get();
                  String adminNumber = adminNumberFuture.data["admin"];
                  print("adminNumber: $adminNumber");

                  await Future.wait(widget.listOfFriendNumbers.map((element) async{
//              listOfFriendNumbers.forEach((element) async {
                    print("element: $element");
                    var myNumberExistsInFriendsFriendsCollectionWaiting = await Firestore.instance.collection("friends_$element").document(widget.conversationId).get();
                    var myNumberExistsInFriendsFriendsCollection = myNumberExistsInFriendsFriendsCollectionWaiting.data;
                    print("myNumberExistsInFriendsFriendsCollection: $myNumberExistsInFriendsFriendsCollection");
                    if(myNumberExistsInFriendsFriendsCollection == null){
                      List<String> nameListForOthers = new List();
                      nameListForOthers.add(widget.groupName);
                      AddToFriendsCollection().extractNumbersFromListAndAddToFriendsCollection(widget.listOfFriendNumbers, widget.conversationId, widget.conversationId, nameListForOthers, widget.groupName, adminNumber);
//                                                                                        listOfNumbersInAGroup, id, id, nameList, groupName, userPhoneNo
                    }
                  }));

                }



                if(widget.value!="") {
                  ///if there is not text, then dont send the message
                  var data = {"body":widget.value, "fromName":widget.userName, "fromPhoneNumber":widget.userPhoneNo, "timeStamp":DateTime.now(), "conversationId":widget.conversationId};
                  FirebaseMethods().pushToFirebaseConversatinCollection(data);

                  ///Navigating to RecentChats page with pushes the data to firebase
                  RecentChats(message: data, convId: widget.conversationId, userNumber:widget.userPhoneNo, userName: widget.userName, listOfOtherNumbers: widget.listOfFriendNumbers, groupExists:widget.groupExits).getAllNumbersOfAConversation();

                  widget.controllerTwo.clear();//used to clear text when user hits send button
                  widget.listScrollController.animateTo(//for scrolling to the bottom of the screen when a next text is send
                    0.0,
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 300),
                  );
                }
              },

              scrollController: new ScrollController(),
              controller: widget.controllerTwo,
            );
          },

        );
  }

  sendImage() async{
    int numberOfImageInConversation= 0;
    numberOfImageInConversation++;

    File image = await ImagesPickersDisplayPictureURLorFile().pickImageFromGallery();
    File croppedImage = await ImagesPickersDisplayPictureURLorFile().cropImage(image);
    String imageURL = await ImagesPickersDisplayPictureURLorFile().getImageURL(croppedImage, widget.userPhoneNo, numberOfImageInConversation);
    return createDataToPushToFirebase(false, true, imageURL, widget.userName, widget.userPhoneNo, widget.conversationId, null);

  }

  sendVideo() async{
    int numberOfImageInConversation= 0;
    numberOfImageInConversation++;

    File video = await VideoPicker().pickVideoFromGallery();

    String videoURL = await ImagesPickersDisplayPictureURLorFile().getVideoURL(video, widget.userPhoneNo, numberOfImageInConversation);

    return createDataToPushToFirebase(true, false, videoURL, widget.userName, widget.userPhoneNo, widget.conversationId, null);

  }

  pushMessageDataToFirebase(bool isVideo, bool isImage, Position location, var data){
    print("in pushMessageDataToFirebase");
    Firestore.instance.collection("conversations").document(widget.conversationId).collection("messages").add(data);
    ///Navigating to RecentChats page with pushes the data to firebase
    if(isVideo == true){
      var data = createDataToPushToFirebase(true, false, "📹", widget.userName, widget.userPhoneNo, widget.conversationId, null);
      RecentChats(message: data, convId: widget.conversationId, userNumber:widget.userPhoneNo, userName: widget.userName , listOfOtherNumbers: widget.listOfFriendNumbers, groupExists: widget.groupExits).getAllNumbersOfAConversation();
    }

    if(isImage == true){
      var data = createDataToPushToFirebase(false, true, "📸", widget.userName, widget.userPhoneNo, widget.conversationId, null);
      RecentChats(message: data, convId: widget.conversationId, userNumber:widget.userPhoneNo, userName: widget.userName, listOfOtherNumbers: widget.listOfFriendNumbers, groupExists: widget.groupExits ).getAllNumbersOfAConversation();
    }

    if(location != null){
      print("in location!=null");
      var dataRecentChats = createDataToPushToFirebase(false, false, "📍 Location", widget.userName, widget.userPhoneNo, widget.conversationId, location);
      RecentChats(message: dataRecentChats, convId: widget.conversationId, userNumber:widget.userPhoneNo, userName: widget.userName, listOfOtherNumbers: widget.listOfFriendNumbers, groupExists: widget.groupExits ).getAllNumbersOfAConversation();
    }
  }

  createDataToPushToFirebase(bool isVideo, bool isImage, String value, String userName, String fromPhoneNumber, String conversationId, Position location){
    if(location != null){
      return {"body":value, "fromName":userName, "fromPhoneNumber":widget.userPhoneNo, "timeStamp":DateTime.now(), "conversationId":conversationId, "latitude": location.latitude, "longitude": location.longitude};
    }
    if(isVideo == true){
      return {"videoURL":value, "fromName":userName, "fromPhoneNumber":widget.userPhoneNo, "timeStamp":DateTime.now(), "conversationId":conversationId};
    }

    if(isImage == true){
      return {"imageURL":value, "fromName":userName, "fromPhoneNumber":widget.userPhoneNo, "timeStamp":DateTime.now(), "conversationId":conversationId};
    } return {"body":value, "fromName":userName, "fromPhoneNumber":widget.userPhoneNo, "timeStamp":DateTime.now(), "conversationId":conversationId};
  }

}
