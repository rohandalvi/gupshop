import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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

class MessageDisplay extends StatefulWidget {
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

  MessageDisplay({this.conversationId, this.listScrollController, this.documentList, this.controller,
    this.userName, this.isPressed, this.userPhoneNo, this.groupExits, this.scroll, this.value,
    this.friendN, this.groupName, this.listOfFriendNumbers,this.controllerTwo,
  });

  @override
  _MessageDisplayState createState() => _MessageDisplayState();
}

class _MessageDisplayState extends State<MessageDisplay> {
  int limitCounter = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), //to take out the keyboard when tapped on chat screen
      //             onVerticalDragStart: _scrollToBottomButton(),
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection("conversations").document(widget.conversationId).collection("messages").orderBy("timeStamp", descending: true).limit(limitCounter*10).snapshots(),
                //stream,
                builder: (context, snapshot) {
                  if(snapshot.data == null) return CircularProgressIndicator();//to avoid error - "getter document was called on null"

                  /*
                       we are making sure that if the screen has not reached the top then take
                       messages from the stream, else take the messages as added by
                       fetchAdditionalMessages:(code snippet from fetchAdditionalMessages):
                            setState(() {//setting state is essential, or new messages(next batch of old messages) does not get loaded
                              documentList.addAll(newDocumentList);
                            });

                        if documentList== null => use stream
                        else(its not when  new 10 messages are added to the documentList)
                        else => use that documentList
                       */
                  widget.documentList = snapshot.data.documents;
//                      if(additionalList!=null) {
//                        documentList.addAll(additionalList);
//                        additionalList = null;
//                      }
//                      else {
//                        print("In else");
//                      }

                  return NotificationListener<ScrollUpdateNotification>(
                    child: ListView.separated(
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
                                        print("forwardYesOrNo : $forwardYesOrNo");

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



                              /// UI:
                              /// on longPress show a mini snackBar which has the option of forward or copy
                              /// and remove the sendMessage box
                              /// On pressing forward, take the user to the search which is ordered in the
                              /// form of list of users(i.e search with the latest conversation on top)
                              /// On sending the message, take, keep a button of done on the search page
                              ///
                              /// backend:
                              ///
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: isMe? Alignment.centerRight: Alignment.centerLeft,///to align the messages at left and right
                              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 3.0), ///for the box covering the text, when horizontal is increased, the photo size decreases
                              child: isNews == true ? NewsContainerUI(title: newsTitle, link: newsLink, newsBody: newsBody,) : isLocationMessage ==true ? showLocation(fromName,latitude, longitude): videoURL != null  ? showVideo(videoURL, widget.controller) :imageURL == null?
                              CustomText(text: messageBody,): showImage(imageURL),
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
                    ),
                    onNotification: (notification) {
                      /// ScrollUpdateNotification :
                      /// for listining when the user scrolls up
                      /// Show the scrolltobottom button only when the user scrolls up
                      if(notification is ScrollUpdateNotification){

                        //print("notification: $notification");

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
    );
  }

  showVideo(String videoURL, VideoPlayerController controller){
    try{
      return
        CustomVideoPlayer(videoURL: videoURL);
    }
    catch (e){
      return Icon(Icons.image);}
  }


  showImage(String imageURL){
    try{
      return
        DisplayPicture().chatPictureFrame(imageURL);
    }
    catch (e){
      return Icon(Icons.image);}
  }

  showLocation(String senderName,double latitude, double longitude){/// todo - use the same method from GeolocationServiceState
    return CustomRaisedButton(
      child: CustomText(text: '$senderName \nCurrent Location 📍',),/// toDo- very very big name
//      shape:  RoundedRectangleBorder(
//        borderRadius: new BorderRadius.circular(5.0),
//        side: BorderSide(color : Colors.black),
//      ),
      onPressed: (){
        GeolocationServiceState().launchMapsUrl(latitude, longitude);
      },
    );
  }

  _buildMessageComposer() {//the type and send message box
    return StatefulBuilder(
      builder: (context, StateSetter setState){
        return BuildMessageComposer(
          firstOnPressed: () async{
            var data = await sendImage();
            pushMessageDataToFirebase(false,true,null,data);
            setState(() {

            });
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
              SendAndDisplayMessages().pushToFirebaseConversatinCollection(data);

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
