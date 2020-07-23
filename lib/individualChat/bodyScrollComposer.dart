import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gupshop/image/createImageURL.dart';
import 'package:gupshop/image/cropImage.dart';
import 'package:gupshop/image/pickImageFromGallery.dart';
import 'package:gupshop/individualChat/bodyData.dart';
import 'package:gupshop/individualChat/cameraImagePickCropCreateData.dart';
import 'package:gupshop/individualChat/galleryImagePickCropCreateData.dart';
import 'package:gupshop/individualChat/pushMessagesToConversationAndRecentChatsCollection.dart';
import 'package:gupshop/models/image_message.dart';
import 'package:gupshop/models/location_message.dart';
import 'package:gupshop/models/message.dart';
import 'package:gupshop/models/text_message.dart';
import 'package:gupshop/models/video_message.dart';
import 'package:gupshop/service/addToFriendsCollection.dart';
import 'package:gupshop/location/location_service.dart';
import 'package:gupshop/image/imagePickersDisplayPicturesFromURLorFile.dart';
import 'package:gupshop/service/recentChats.dart';
import 'package:gupshop/individualChat/firebaseMethods.dart';
import 'package:gupshop/service/videoPicker.dart';
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
              firstOnPressed: (){
                return CustomBottomSheet(
                  customContext: context,
                  firstIconName: 'photoGallery',
                  firstIconText: 'Pick image from  Gallery',
                  firstIconAndTextOnPressed: () async{
                    var data = await GalleryImagePickCropCreateData().main(widget.userName, widget.userPhoneNo, widget.conversationId);
                    pushMessageDataToConversationAndRecentChatsCollection(false,true,null,data);
                    setState(() {

                    });
                  },
                  secondIconName: 'image2vector',
                  secondIconText: 'Click image from Camera',
                  secondIconAndTextOnPressed: () async{
                    /// clicking image from camera flowchart:
                    /// pop the bottom bar
                    /// create data to push to conversation and recentchats collection
                    Navigator.pop(context);
                    var conversationCollectionData = await CameraImagePickCropCreateData().main(widget.userName, widget.userPhoneNo, widget.conversationId);
                    var recentChatsData = ImageMessage(fromName: widget.userName, fromNumber: widget.userPhoneNo, conversationId: widget.conversationId, timestamp: DateTime.now(), imageUrl: "📸 Image").fromJson();
                    print("recentChats data : $recentChatsData");
                    PushMessagesToConversationAndRecentChatsCollection(listOfFriendNumbers: widget.listOfFriendNumbers, conversationId: widget.conversationId, userPhoneNo: widget.userPhoneNo, conversationCollectionData: conversationCollectionData,recentChatsData: recentChatsData, userName: widget.userName, groupExits: widget.groupExits).push();
                  },
                  thirdIconName: 'photoGallery',
                  thirdIconText: 'Pick video from Gallery',
                  thirdIconAndTextOnPressed: () async{
                    var data = await galleryVideoPickCreateData();
                    pushMessageDataToConversationAndRecentChatsCollection(true,false,null,data);
                    setState(() {

                    });
                  },
                  fourthIconName: 'videoCamera',
                  fourthIconText: 'Record video from Camera',
                  fourthIconAndTextOnPressed: (){},
                  fifthIconName: 'location',
                  fifthIconText: 'Send Current Location',
                  fifthIconAndTextOnPressed: () async{
                    Navigator.pop(context);
                    Position location  = await LocationServiceState().getLocation();//setting user's location
                    sendLocation(location);
                  },
                  sixthIconName: 'locationPin',
                  sixthIconText: 'Send location from Map',
                  sixthIconAndTextOnPressed: (){},
                ).show();
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

                  await Future.wait(widget.listOfFriendNumbers.map((element) async{
                    var myNumberExistsInFriendsFriendsCollectionWaiting = await Firestore.instance.collection("friends_$element").document(widget.conversationId).get();
                    var myNumberExistsInFriendsFriendsCollection = myNumberExistsInFriendsFriendsCollectionWaiting.data;
                    if(myNumberExistsInFriendsFriendsCollection == null){
                      List<String> nameListForOthers = new List();
                      nameListForOthers.add(widget.groupName);
                      AddToFriendsCollection().extractNumbersFromListAndAddToFriendsCollection(widget.listOfFriendNumbers, widget.conversationId, widget.conversationId, nameListForOthers, widget.groupName, adminNumber);
                    }
                  }));

                }



                if(widget.value!="") {
                  ///if there is not text, then dont send the message
                  IMessage textMessage = TextMessage(fromNumber: widget.userPhoneNo, fromName: widget.userName, text: widget.value,timestamp: DateTime.now(), conversationId: widget.conversationId);
                  FirebaseMethods().pushToFirebaseConversatinCollection(textMessage.fromJson());

                  ///Navigating to RecentChats page with pushes the data to firebase
                  RecentChats(message: textMessage.fromJson(), convId: widget.conversationId, userNumber:widget.userPhoneNo, userName: widget.userName, listOfOtherNumbers: widget.listOfFriendNumbers, groupExists:widget.groupExits).getAllNumbersOfAConversation();

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

//  galleryImagePickCropCreateData() async{
//    /// to make the user go to individualChat screen with no bottom bar open
//    /// we have to make sure that Navigator.pop(context); is used so that
//    /// when the user clicks pick image from camera(or any other option),
//    /// he is returned to individualChat with no bottom bar open
//    Navigator.pop(context);
//    int numberOfImageInConversation= 0;
//    numberOfImageInConversation++;
//
//    File image = await PickImageFromGallery().pick();
//    File croppedImage = await CropImage().crop(image);
//    String imageURL = await CreateImageURL().create(croppedImage, widget.userPhoneNo, numberOfImageInConversation);
//    IMessage message = new ImageMessage(fromName: widget.userName, fromNumber: widget.userPhoneNo, conversationId: widget.conversationId, timestamp: DateTime.now(), imageUrl: imageURL);
//    return message.fromJson();
//  }

  galleryVideoPickCreateData() async{
    /// to make the user go to individualChat screen with no bottom bar open
    /// we have to make sure that Navigator.pop(context); is used so that
    /// when the user clicks pick image from camera(or any other option),
    /// he is returned to individualChat with no bottom bar open
    Navigator.pop(context);
    int numberOfImageInConversation= 0;
    numberOfImageInConversation++;

    File video = await VideoPicker().pickVideoFromGallery();

    String videoURL = await ImagesPickersDisplayPictureURLorFile().getVideoURL(video, widget.userPhoneNo, numberOfImageInConversation);
    IMessage message = new VideoMessage(fromName:widget.userName, fromNumber:widget.userPhoneNo, conversationId:widget.conversationId, timestamp:DateTime.now(), videoURL:videoURL);
    return message.fromJson();
  }

  sendLocation(Position location){
    /// create data and push to conversations collection to display immediately
    IMessage message = new LocationMessage(fromName:widget.userName, fromNumber:widget.userPhoneNo, conversationId:widget.conversationId, timestamp:DateTime.now(), latitude: location.latitude, longitude: location.longitude, text: location.toString());
    pushMessageDataToConversationAndRecentChatsCollection(false,false,location,message.fromJson());
    setState(() {

    });
  }


  pushMessageDataToConversationAndRecentChatsCollection(bool isVideo, bool isImage, Position location, var data){
    Firestore.instance.collection("conversations").document(widget.conversationId).collection("messages").add(data);
    ///Navigating to RecentChats page with pushes the data to firebase
    if(isVideo == true){
      //var data = createMessageDataToPushToConversationCollection(true, false, "📹", widget.userName, widget.userPhoneNo, widget.conversationId, null);
      IMessage data = VideoMessage(fromName: widget.userName, fromNumber:widget.userPhoneNo, conversationId:widget.conversationId, timestamp:DateTime.now(), videoURL:"📹 Video");
      Map<String, dynamic> message = data.fromJson();
      RecentChats(message: message, convId: widget.conversationId, userNumber:widget.userPhoneNo, userName: widget.userName , listOfOtherNumbers: widget.listOfFriendNumbers, groupExists: widget.groupExits).getAllNumbersOfAConversation();
    }

    if(isImage == true){
      //var data = createMessageDataToPushToConversationCollection(false, true, "📸", widget.userName, widget.userPhoneNo, widget.conversationId, null);
      ImageMessage data = ImageMessage(fromName: widget.userName, fromNumber: widget.userPhoneNo, conversationId: widget.conversationId, timestamp: DateTime.now(), imageUrl: "📸 Image");
      Map<String, dynamic> message = data.fromJson();
      RecentChats(message: message, convId: widget.conversationId, userNumber:widget.userPhoneNo, userName: widget.userName, listOfOtherNumbers: widget.listOfFriendNumbers, groupExists: widget.groupExits ).getAllNumbersOfAConversation();
    }

    if(location != null){
      IMessage locationMessage = new LocationMessage(fromName:widget.userName, fromNumber:widget.userPhoneNo, conversationId:widget.conversationId, timestamp:DateTime.now(), text:"📍 Location", latitude:location.latitude, longitude:location.longitude);
      RecentChats(message: locationMessage.fromJson(), convId: widget.conversationId, userNumber:widget.userPhoneNo, userName: widget.userName, listOfOtherNumbers: widget.listOfFriendNumbers, groupExists: widget.groupExits ).getAllNumbersOfAConversation();
    }
  }

}
