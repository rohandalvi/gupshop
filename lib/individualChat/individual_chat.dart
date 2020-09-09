import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:gupshop/PushToFirebase/pushToMessageTypingCollection.dart';
import 'package:gupshop/PushToFirebase/pushToSaveCollection.dart';
import 'package:gupshop/chat_list_page/chatListCache.dart';
import 'package:gupshop/firebaseDataScaffolds/recentChatsDataScaffolds.dart';
import 'package:gupshop/individualChat/individualChatAppBar.dart';
import 'package:gupshop/individualChat/bodyPlusScrollComposerData.dart';
import 'package:gupshop/individualChat/locationData.dart';
import 'package:gupshop/individualChat/pushMessagesToConversationAndRecentChatsCollection.dart';
import 'package:gupshop/models/text_message.dart';
import 'package:gupshop/models/video_message.dart';
import 'package:gupshop/modules/Presence.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
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
  Map<String, ChatListCache> chatListCache;
  bool groupDeleted;
  String imageURL;


  IndividualChat(
      {Key key, @required this.conversationId, @required this.userPhoneNo, @required this.userName,
        @required this.friendName,this.forwardMessage, this.listOfFriendNumbers, this.notGroupMemberAnymore,
        this.chatListCache, this.groupDeleted, this.imageURL})
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
  bool groupExits;
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

    print("userPhoneNo before setData to messageTyping : $userPhoneNo");
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

      /// creating data to be pushed to recentChats
      if(data["videoURL"] != null) {
        String messageId = await PushToSaveCollection(messageBody: data["videoURL"], messageType: 'videoURL',).
        saveAndGenerateId();
        data["messageId"] = messageId;
        Map<String, dynamic> conversationCollectionData = data;
        Map<String, dynamic> recentChatsData = await RecentChatsDataScaffolds(fromName: widget.userName,
            fromNumber: widget.userPhoneNo, conversationId: widget.conversationId, timestamp: Timestamp.now(),
            messageId: messageId).forVideoMessage();
        PushMessagesToConversationAndRecentChatsCollection(listOfFriendNumbers: widget.listOfFriendNumbers,
            conversationId: widget.conversationId, userPhoneNo: widget.userPhoneNo,
            conversationCollectionData: conversationCollectionData,recentChatsData: recentChatsData, userName: widget.userName,
            groupExits: groupExits).push();
      }
      else if(data["imageURL"] != null) {
        String messageId = await PushToSaveCollection(messageBody: data["imageURL"], messageType: 'imageURL',).
        saveAndGenerateId();
        data["messageId"] = messageId;
        Map<String, dynamic> conversationCollectionData = data;
        Map<String, dynamic> recentChatsData = await RecentChatsDataScaffolds(fromName: widget.userName,
            fromNumber: widget.userPhoneNo, conversationId: widget.conversationId, timestamp: Timestamp.now(),
            messageId: messageId).forImageMessage();
        PushMessagesToConversationAndRecentChatsCollection(listOfFriendNumbers: widget.listOfFriendNumbers,
            conversationId: widget.conversationId, userPhoneNo: widget.userPhoneNo, conversationCollectionData:
            conversationCollectionData,recentChatsData: recentChatsData, userName:widget.userName,
            groupExits: groupExits).push();
      }
      else if(data["news"] != null) {
        String messageId = await PushToSaveCollection(messageBody: data["news"], messageType: 'body',).
        saveAndGenerateId();
        data["messageId"] = messageId;
        FirebaseMethods().pushToFirebaseConversatinCollection(data);
        data = TextMessage(text: "📰 NEWS", conversationId: conversationId,fromName: userName,fromNumber: userPhoneNo,
            timestamp: Timestamp.now(), messageId: messageId).fromJson();
        RecentChats(message: data, convId: conversationId, userNumber:userPhoneNo,
            userName: userName, listOfOtherNumbers: listOfFriendNumbers,
            groupExists: groupExits).getAllNumbersOfAConversation();
      }else if(data["latitude"] != null){
        String messageId = await PushToSaveCollection(messageBody: data["body"], messageType: 'location',).saveAndGenerateId();
        data["messageId"] = messageId;
        Map<String, dynamic> conversationCollectionData = data;
        Map<String, dynamic> recentChatsData = await RecentChatsDataScaffolds(fromName: widget.userName,
            fromNumber: widget.userPhoneNo, conversationId: widget.conversationId, timestamp: Timestamp.now(),
            messageId: messageId, longitude: data["longitude"], latitude: data["latitude"]).forLocationMessage();
        PushMessagesToConversationAndRecentChatsCollection(listOfFriendNumbers: widget.listOfFriendNumbers,
            conversationId: widget.conversationId, userPhoneNo: widget.userPhoneNo,
            conversationCollectionData: conversationCollectionData,recentChatsData: recentChatsData, userName: widget.userName,
            groupExits: groupExits).push();
        }
      else{
        String messageId = await PushToSaveCollection(messageBody: data["body"], messageType: 'body',).saveAndGenerateId();
        data["messageId"] = messageId;
        FirebaseMethods().pushToFirebaseConversatinCollection(data);
        RecentChats(message: data, convId: conversationId, userNumber:userPhoneNo,
            userName: userName, listOfOtherNumbers: listOfFriendNumbers,
            groupExists: groupExits).getAllNumbersOfAConversation();
      }

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
      forwardMessages(conversationId);
    }

    conversationService = new ConversationService(widget.conversationId);


    super.initState();
  }




  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: () async => CustomNavigator().navigateToHome(context, userName, userPhoneNo),
      child: Material(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(WidgetConfig.appBarSeventyTwo),/// 72 //the distance between gupShop and tabBars
            child: IndividualChatAppBar(chatListCache : widget.chatListCache,userPhoneNo: userPhoneNo, userName: userName,groupExits: groupExits,friendName: friendName,friendN: friendN, conversationId: conversationId,notGroupMemberAnymore: notGroupMemberAnymore,
              listOfFriendNumbers: listOfFriendNumbers,presence: presence, conversationService: conversationService,
              groupDeleted: widget.groupDeleted,imageURL: widget.imageURL,),
          ),
          /// 1st check : check if its a  group and if yes, is it deleted?
          /// yes, then show a deleted group screen
          ///
          /// 2nd check :  if the person is removed from the group
          ///
          /// if a member is removed from the group, then he should not be seeing the conversations
          /// once he enters the individual chat page
          /// So, displaying the conversations only when he is a group member
          body: widget.groupDeleted == true ? BlankScreen(message: 'This group is Deleted !',) :  (notGroupMemberAnymore == false || notGroupMemberAnymore == null) ? BodyPlusScrollComposerData(
            conversationService: conversationService,
            friendName: friendName,
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
}



