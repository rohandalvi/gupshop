import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:gupshop/PushToFirebase/pushToMessageTypingCollection.dart';
import 'package:gupshop/firebaseDataScaffolds/recentChatsDataScaffolds.dart';
import 'package:gupshop/individualChat/individualChatAppBar.dart';
import 'package:gupshop/individualChat/bodyPlusScrollComposerData.dart';
import 'package:gupshop/models/text_message.dart';
import 'package:gupshop/models/video_message.dart';
import 'package:gupshop/modules/Presence.dart';
import 'package:gupshop/retriveFromFirebase/getFromConversationCollection.dart';
import 'package:gupshop/service/addToFriendsCollection.dart';
import 'package:gupshop/service/conversationDetails.dart';
import 'package:gupshop/service/conversation_service.dart';
import 'package:gupshop/widgets/customNavigators.dart';
import 'package:gupshop/service/findFriendNumber.dart';
import 'package:gupshop/service/getConversationId.dart';
import 'package:gupshop/service/recentChats.dart';
import 'package:gupshop/individualChat/firebaseMethods.dart';
import 'package:gupshop/widgets/blankScreen.dart';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';

class IndividualChat extends StatefulWidget {
  final String conversationId;
  final String userPhoneNo;
  final String userName;
  final String friendName;/// this should be a list
  List<dynamic> listOfFriendNumbers;
  final Map forwardMessage;
  final bool notGroupMemberAnymore;


  IndividualChat(
      {Key key, @required this.conversationId, @required this.userPhoneNo, @required this.userName, @required this.friendName,this.forwardMessage, this.listOfFriendNumbers, this.notGroupMemberAnymore})
      : super(key: key);
  @override
  _IndividualChatState createState() => _IndividualChatState(
      conversationId: conversationId,
      userPhoneNo: userPhoneNo,
      userName: userName,
      friendName: friendName,
      forwardMessage: forwardMessage,
      listOfFriendNumbers: listOfFriendNumbers,
      notGroupMemberAnymore: notGroupMemberAnymore,
      presence: new Presence(userPhoneNo)
    );


}



class _IndividualChatState extends State<IndividualChat> {

  String conversationId;
  final String userPhoneNo;
  final String userName;
  final String friendName;/// this should be list
  List<dynamic> listOfFriendNumbers;
  final Map forwardMessage;
  final bool notGroupMemberAnymore;
  final Presence presence;

  static int numberOfImageInConversation = 0;///for giving number to the images sent in conversation for
  ///storing in firebase

  _IndividualChatState(
      {@required this.conversationId, @required this.userPhoneNo, @required this.userName, @required this.friendName, this.forwardMessage, this.listOfFriendNumbers, this.notGroupMemberAnymore, this.presence});

  String value = ""; //TODo

  TextEditingController _controller = new TextEditingController(); //to clear the text  when user hits send button//TODO- for enter
  ScrollController listScrollController = new ScrollController(); //for scrolling the screen
  StreamController streamController= new StreamController();

  List<DocumentSnapshot> additionalList;
  CollectionReference collectionReference;
  Stream<QuerySnapshot> stream;
  int limitCounter = 1;

  ScrollNotification notification;
  bool isLoading = false;
  bool scroll = false;
  bool isPressed = false;
  VideoPlayerController controller;

  String friendN;
  var groupExits;
  String groupName;

  ConversationService conversationService;

  checkIfGroup() async{
    bool temp = await CheckIfGroup().ifThisIsAGroup(conversationId);
    String tempGroupName = await CheckIfGroup().getGroupName(conversationId);
    setState(() {
      groupExits = temp;
    });

    if(groupExits == false) {
      setState(() {
        friendN = FindFriendNumber().friendNumber(listOfFriendNumbers, userPhoneNo);
      });
    } else {
      setState(() {
        friendN = conversationId;
        groupName = tempGroupName;
      });
    }
  }

  /// get conversationId required for:
  ///
  getConversationId() async{

    /// only an individualChat would come here to create a conversationId as groupChat would get its conversationId in createNameForGroup page
    /// an individualChat would always have groupName as null,
    /// only a groupChat would have groupName
    String id = await GetConversationId().createNewConversationId(userPhoneNo, listOfFriendNumbers, null);

    setState(() {
      conversationId = id;
    });

    await checkIfGroup();

    ///push to my friends collection here
    List<dynamic> nameListForMe = new List();
    nameListForMe.add(friendName);

    /// as we are in this method, this has to be an individual chat and not a group chat as,
    /// group chat when comes to individualchat page will always have conversationId
    /// and hence would never come to this method
    AddToFriendsCollection().addToFriendsCollection(listOfFriendNumbers, id,userPhoneNo,nameListForMe,null,null);///use listOfNumberHere

    ///push to all others friends collection here
    List<dynamic> nameListForOthers = new List();
    nameListForOthers.add(userName);
    AddToFriendsCollection().extractNumbersFromListAndAddToFriendsCollection(listOfFriendNumbers, id, userPhoneNo, nameListForOthers, null, null);

    /// also push the conversationId to conversations:
    Firestore.instance.collection("conversations").document(id).setData({});

    /// setData to messageTyping collection:
    PushToMessageTypingCollection(conversationId: conversationId, userNumber: userPhoneNo).pushTypingStatus();

    await forwardMessages(id);
  }

  forwardMessages(String conversationId) async{
    await checkIfGroup();
    if(forwardMessage != null) {

      /// forward messages needs to be given this conversation's conversationId
      forwardMessage["conversationId"] = conversationId;
      var data = forwardMessage;

      DocumentReference forwardedMessageId = await FirebaseMethods().pushToFirebaseConversatinCollection(data);

      /// creating data to be pushed to recentChats
      if(data["videoURL"] != null) data = VideoMessage(videoURL:"📹", conversationId: conversationId,fromName: userName,fromNumber: userPhoneNo,timestamp: DateTime.now()).fromJson();
      else if(data["imageURL"] != null) data = RecentChatsDataScaffolds(conversationId: conversationId,fromName: userName,fromNumber: userPhoneNo,timestamp: DateTime.now()).forImageMessage();
      else if(data["news"] != null) data = TextMessage(text: "📰 NEWS", conversationId: conversationId,fromName: userName,fromNumber: userPhoneNo,timestamp: DateTime.now()).fromJson();
      ///Navigating to RecentChats page with pushes the data to firebase
      /// if group chat:

      RecentChats(message: data, convId: conversationId, userNumber:userPhoneNo, userName: userName, listOfOtherNumbers: listOfFriendNumbers, groupExists: groupExits ).getAllNumbersOfAConversation();
    }
  }


  @override
  void initState() {

    /*
    adding collectionReference and stream in initState() is essential for making the autoscroll when messages hit the limit
    when user scrolls
    update - the above comment might be wrong, because passing the stream directly to
    streambuilder without initializing in initState also paginates alright.
     */

    /// if new conversation, then conversationId == null
    if(conversationId == null) {
      getConversationId();
      /// also create a conversations_number collection
    }else{
      ///if forwardMessage == true, then initialize that method of sending the message
      ///here in the initstate():
      print("conversationId in individualChat in else: $conversationId");
      forwardMessages(conversationId);
    }



    super.initState();
  }




  @override
  Widget build(BuildContext context){
    conversationService = new ConversationService(widget.conversationId);
    return WillPopScope(
      onWillPop: () async => CustomNavigator().navigateToHome(context, userName, userPhoneNo),
      child: Material(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),//the distance between gupShop and tabBars
            child: IndividualChatAppBar(userPhoneNo: userPhoneNo, userName: userName,groupExits: groupExits,friendName: friendName,friendN: friendN, conversationId: conversationId,notGroupMemberAnymore: notGroupMemberAnymore,
              listOfFriendNumbers: listOfFriendNumbers,presence: presence, conversationService: conversationService,),
            //appBar(context, friendName),
          ),
          //appBar(),
          /// if a member is removed from the group, then he should not be seeing the conversations
          /// once he enters the individual chat page
          /// So, displaying the conversations only when he is a group member
          body: (notGroupMemberAnymore == false || notGroupMemberAnymore == null) ? BodyPlusScrollComposerData(
            conversationService: conversationService,
            conversationId: conversationId,
            controller: controller,
            controllerTwo: _controller,
            listOfFriendNumbers: listOfFriendNumbers,
            listScrollController: listScrollController,
            friendN: friendN,
            userName: userName,
            userPhoneNo: userPhoneNo,
            isPressed: isPressed,
            groupExits: groupExits,
            groupName: groupName,
            value: value,
            scroll: scroll,
          ): BlankScreen(),
//              body: notGroupMemberAnymore == false ? showMessagesAndSendMessageBar(context)
//              : BlankScreen(),
        ),
      ),
    );
  }


  ///fetching next batch of messages when user scrolls up for previous messages
//  fetchAdditionalMessages() async {
//    try {
//      print("Fetching ${documentList[documentList.length-1]}");
//      print("Size  ${documentList.length}");
//      List<DocumentSnapshot>  newDocumentList  =  (await Firestore.instance.collection("conversations").document(conversationId).collection("messages")
//          .orderBy("timeStamp", descending: true)
//          .startAfterDocument(documentList[documentList.length-1])
//          .limit(10).getDocuments())
//          .documents;
//
//      print("Got additional messges of size ${newDocumentList.length}");
//      if(newDocumentList.isEmpty) return;
//      additionalList = [];
//
//      setState(() {//setting state is essential, or new messages(next batch of old messages) does not get loaded
//        additionalList.addAll(newDocumentList);
//      });
//    } catch(e) {
//      streamController.sink.addError(e);
//    }
//
//  }


}



