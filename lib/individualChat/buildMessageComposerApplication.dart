import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gupshop/PushToFirebase/pushToConversationCollection.dart';
import 'package:gupshop/PushToFirebase/pushToSaveCollection.dart';
import 'package:gupshop/chat_list_page/chatListCache.dart';
import 'package:gupshop/dataGathering/logEvent.dart';
import 'package:gupshop/dataGathering/myTrace.dart';
import 'package:gupshop/firebaseDataScaffolds/recentChatsDataScaffolds.dart';
import 'package:gupshop/individualChat/buildMessageComposerWidget.dart';
import 'package:gupshop/individualChat/cameraImagePickCropCreateData.dart';
import 'package:gupshop/individualChat/cameraVideoPickCreateData.dart';
import 'package:gupshop/individualChat/galleryImagePickCropCreateData.dart';
import 'package:gupshop/individualChat/galleryVideoPickCreateData.dart';
import 'package:gupshop/individualChat/locationData.dart';
import 'package:gupshop/individualChat/pushMessagesToConversationAndRecentChatsCollection.dart';
import 'package:gupshop/location/locationPermissionHandler.dart';
import 'package:gupshop/location/location_service.dart';
import 'package:gupshop/models/message.dart';
import 'package:gupshop/models/text_message.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/service/addToFriendsCollection.dart';
import 'package:gupshop/service/recentChats.dart';
import 'package:gupshop/widgets/customBottomSheet.dart';


class buildMessageComposerApplication extends StatefulWidget {
  String conversationId;
  ScrollController listScrollController; //for scrolling the screen
  String userName;
  String userPhoneNo;
  bool groupExits;
  String value;
  String groupName;
  String friendN;
  List<dynamic> listOfFriendNumbers;
  TextEditingController myController;
  DocumentSnapshot startAtDocument;
  DocumentSnapshot currentMessageDocumentSanpshot;
  String messageId;
  Map<String, ChatListCache> chatListCache;
  String friendName;

  buildMessageComposerApplication({this.userPhoneNo, this.conversationId, this.listOfFriendNumbers,
  this.listScrollController,this.userName,
    this.groupExits, this.value, this.groupName, this.friendN,
    this.myController, this.startAtDocument, this.currentMessageDocumentSanpshot,this.chatListCache,
    this.friendName,
  });


  @override
  _buildMessageComposerApplicationState createState() => _buildMessageComposerApplicationState();
}

class _buildMessageComposerApplicationState extends State<buildMessageComposerApplication> {

  @override
  void initState() {
    widget.listScrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return StatefulBuilder(
      builder: (context, StateSetter setState){
        return BuildMessageComposerWidget(
          firstOnPressed: (){
            return CustomBottomSheet(
              customContext: context,

              firstIconName: IconConfig.photoGallery,
              firstIconText: TextConfig.pickGalleryImage,
              firstIconAndTextOnPressed: () async{
                Navigator.pop(context);
                String messageId = await PushToSaveCollection(messageBody: widget.value, messageType: 'imageURL',).saveAndGenerateId();
                Map<String, dynamic> conversationCollectionData = await GalleryImagePickCropCreateData().main(context,widget.userName, widget.userPhoneNo, widget.conversationId, messageId);
                Map<String, dynamic> recentChatsData = await RecentChatsDataScaffolds(fromName: widget.userName, fromNumber: widget.userPhoneNo, conversationId: widget.conversationId, timestamp: Timestamp.now(), messageId: messageId).forImageMessage();
                PushMessagesToConversationAndRecentChatsCollection(listOfFriendNumbers:widget.listOfFriendNumbers,
                    conversationId: widget.conversationId, userPhoneNo: widget.userPhoneNo,
                    conversationCollectionData: conversationCollectionData,recentChatsData: recentChatsData,
                    userName: widget.userName, groupExits: widget.groupExits).push();
              },
              secondIconName: IconConfig.camera,
              secondIconText: TextConfig.pickCameraImage,
              secondIconAndTextOnPressed: () async{
                /// clicking image from camera flowchart:
                /// pop the bottom bar
                /// create data to push to conversation and recentchats collection
                Navigator.pop(context);
                String messageId = await PushToSaveCollection(messageBody: widget.value, messageType: 'imageURL',).saveAndGenerateId();
                Map<String, dynamic> conversationCollectionData = await CameraImagePickCropCreateData().main(context,widget.userName, widget.userPhoneNo, widget.conversationId, messageId);
                Map<String, dynamic> recentChatsData = await RecentChatsDataScaffolds(fromName: widget.userName,
                    fromNumber: widget.userPhoneNo, conversationId: widget.conversationId, timestamp: Timestamp.now(),
                    messageId: messageId).forImageMessage();
                PushMessagesToConversationAndRecentChatsCollection(listOfFriendNumbers: widget.listOfFriendNumbers,
                    conversationId: widget.conversationId, userPhoneNo: widget.userPhoneNo, conversationCollectionData:
                    conversationCollectionData,recentChatsData: recentChatsData, userName:widget.userName,
                    groupExits: widget.groupExits).push();
              },
              thirdIconName: IconConfig.photoGallery,
              thirdIconText: TextConfig.pickGalleryVideo,
              thirdIconAndTextOnPressed: () async{
                Navigator.pop(context);
                String messageId = await PushToSaveCollection(messageBody: widget.value, messageType: 'videoURL',).saveAndGenerateId();
                Map<String, dynamic> conversationCollectionData = await GalleryVideoPickCreateData(userName: widget.userName, userPhoneNo: widget.userPhoneNo, conversationId: widget.conversationId, messageId: messageId).main(context);
                if(conversationCollectionData != null){
                  Map<String, dynamic> recentChatsData = await
                  RecentChatsDataScaffolds(fromName: widget.userName, fromNumber: widget.userPhoneNo,conversationId: widget.conversationId, timestamp: Timestamp.now(), messageId: messageId).forVideoMessage();
                  PushMessagesToConversationAndRecentChatsCollection(listOfFriendNumbers: widget.listOfFriendNumbers, conversationId: widget.conversationId, userPhoneNo: widget.userPhoneNo, conversationCollectionData: conversationCollectionData, recentChatsData: recentChatsData, userName: widget.userName, groupExits: widget.groupExits).push();
                }
              },
              fourthIconName: IconConfig.videoCamera,
              fourthIconText: TextConfig.pickCameraVideo,
              fourthIconAndTextOnPressed: () async{
                Navigator.pop(context);
                String messageId = await PushToSaveCollection(messageBody: widget.value, messageType: 'videoURL',).saveAndGenerateId();
                Map<String, dynamic> conversationCollectionData = await CameraVideoPickCreateData(userName: widget.userName, userPhoneNo: widget.userPhoneNo, conversationId: widget.conversationId, messageId:messageId).main(context);

                /// if the user cancels uploading the video then videoURL would
                /// be null and hence the conversationCollectionData would be null.
                /// if its null then no need to push anything to firebase at all
                if(conversationCollectionData != null){
                  Map<String, dynamic> recentChatsData = await RecentChatsDataScaffolds(fromName: widget.userName,
                      fromNumber: widget.userPhoneNo, conversationId: widget.conversationId, timestamp: Timestamp.now(),
                      messageId: messageId).forVideoMessage();
                  await PushMessagesToConversationAndRecentChatsCollection(listOfFriendNumbers: widget.listOfFriendNumbers, conversationId: widget.conversationId, userPhoneNo: widget.userPhoneNo, conversationCollectionData: conversationCollectionData,recentChatsData: recentChatsData, userName: widget.userName, groupExits: widget.groupExits).push();
                  print("video pushed to firebase");
                }
              },
              fifthIconName: IconConfig.location,
              fifthIconText: TextConfig.currentLocation,
              fifthIconAndTextOnPressed: () async{
                /// first check if user has given permission to access location
                var permission = await LocationPermissionHandler().handlePermissions(context);
                if(permission == true){
                  Navigator.pop(context);
                  String messageId = await PushToSaveCollection(messageBody: widget.value, messageType: 'videoURL',).saveAndGenerateId();
                  Position location  = await LocationService().getLocation();//setting user's location

                  Map<String, dynamic> conversationCollectionData = await LocationData(userName: widget.userName,
                      userPhoneNo: widget.userPhoneNo, conversationId: widget.conversationId, messageId:messageId,
                      location: location).main();
                  Map<String, dynamic> recentChatsData = await RecentChatsDataScaffolds(fromName: widget.userName,
                      fromNumber: widget.userPhoneNo, conversationId: widget.conversationId, timestamp: Timestamp.now(),
                      messageId: messageId, location: location).forLocationMessage();
                  PushMessagesToConversationAndRecentChatsCollection(listOfFriendNumbers: widget.listOfFriendNumbers,
                      conversationId: widget.conversationId, userPhoneNo: widget.userPhoneNo,
                      conversationCollectionData: conversationCollectionData,recentChatsData: recentChatsData, userName: widget.userName,
                      groupExits: widget.groupExits).push();
                }
                //sendLocation(location, messageId);
              },
//              sixthIconName: 'locationPin',
//              sixthIconText: 'Send location from Map',
//              sixthIconAndTextOnPressed: (){},
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
              /// create messageId:
              /// pass that message Id to messageId.
              /// (here):
              /// in save collection - save collection - messageId number- messageBody, isSave
              /// in conversation collection : messageId - messageId number
              ///
              /// display:(bodyDisplay)
              /// from save collection
              ///
              /// change:(heart button)
              /// in save collection

              /// waiting for this messageId creation is causing delay in the display on tapping send button
              String messageId = await PushToSaveCollection(messageBody: widget.value, messageType: 'body',).saveAndGenerateId();

              ///if there is not text, then dont send the message
              IMessage textMessage = TextMessage(fromNumber: widget.userPhoneNo, fromName: widget.userName, text: widget.value,timestamp: Timestamp.now(), conversationId: widget.conversationId,messageId: messageId );
              try{
                PushToConversationCollection().push(textMessage.fromJson());
              }catch(e){
                messageLogEvent(e);
              }

              ///Navigating to RecentChats page with pushes the data to firebase
              RecentChats(message: textMessage.fromJson(), convId: widget.conversationId, userNumber:widget.userPhoneNo, userName: widget.userName, listOfOtherNumbers: widget.listOfFriendNumbers, groupExists:widget.groupExits).getAllNumbersOfAConversation();


              widget.myController.clear();

              /// giving error : ScrollController not attached to any scroll views.

              if(widget.listScrollController.hasClients == false){

              }
              widget.listScrollController.animateTo(//for scrolling to the bottom of the screen when a next text is send
                0.0,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
              );
              widget.value ="";
            }
          },

          scrollController: new ScrollController(),
          controller: widget.myController,
          //widget.controllerTwo,
        );
      },

    );
  }

  messageLogEvent(e){
    LogEvent logEvent = new LogEvent(nameSpace: TextConfig.messageSendError);

    String key = '${widget.userPhoneNo}_${widget.conversationId}';

    /// in line map demo:
    Map<String, dynamic> messageSentErrorMap = {
      key : e
    };
    logEvent.initializeLogEvent(parameters: messageSentErrorMap);
  }



//  sendLocation(Position location, String messageId){
//    /// create data and push to conversations collection to display immediately
//    IMessage message = new LocationMessage(fromName:widget.userName, fromNumber:widget.userPhoneNo, conversationId:widget.conversationId, timestamp:Timestamp.now(), latitude: location.latitude, longitude: location.longitude, text: location.toString(), messageId : messageId);
//    pushMessageDataToConversationAndRecentChatsCollection(false,false,location,message.fromJson());
//    setState(() {
//
//    });
//  }
//
//  pushMessageDataToConversationAndRecentChatsCollection(bool isVideo, bool isImage, Position location, var data) async{
//    Firestore.instance.collection("conversations").document(widget.conversationId).collection("messages").add(data);
//
////    print("DocumentReference : $dr");
////    widget.startAtDocument = await dr.get();
//
//    ///Navigating to RecentChats page with pushes the data to firebase
//    if(isVideo == true){
//      //var data = createMessageDataToPushToConversationCollection(true, false, "📹", widget.userName, widget.userPhoneNo, widget.conversationId, null);
//      IMessage data = VideoMessage(fromName: widget.userName, fromNumber:widget.userPhoneNo, conversationId:widget.conversationId, timestamp:Timestamp.now(), videoURL:"📹 Video");
//      Map<String, dynamic> message = data.fromJson();
//      RecentChats(message: message, convId: widget.conversationId, userNumber:widget.userPhoneNo, userName: widget.userName , listOfOtherNumbers: widget.listOfFriendNumbers, groupExists: widget.groupExits).getAllNumbersOfAConversation();
//    }
//
//    if(isImage == true){
//      //var data = createMessageDataToPushToConversationCollection(false, true, "📸", widget.userName, widget.userPhoneNo, widget.conversationId, null);
//      ImageMessage data = ImageMessage(fromName: widget.userName, fromNumber: widget.userPhoneNo, conversationId: widget.conversationId, timestamp: Timestamp.now(), imageUrl: "📸 Image");
//      Map<String, dynamic> message = data.fromJson();
//      RecentChats(message: message, convId: widget.conversationId, userNumber:widget.userPhoneNo, userName: widget.userName, listOfOtherNumbers: widget.listOfFriendNumbers, groupExists: widget.groupExits ).getAllNumbersOfAConversation();
//    }
//
//    if(location != null){
//      IMessage locationMessage = new LocationMessage(fromName:widget.userName, fromNumber:widget.userPhoneNo, conversationId:widget.conversationId, timestamp:Timestamp.now(), text:"📍 Location", latitude:location.latitude, longitude:location.longitude);
//      RecentChats(message: locationMessage.fromJson(), convId: widget.conversationId, userNumber:widget.userPhoneNo, userName: widget.userName, listOfOtherNumbers: widget.listOfFriendNumbers, groupExists: widget.groupExits ).getAllNumbersOfAConversation();
//    }
//  }
}
