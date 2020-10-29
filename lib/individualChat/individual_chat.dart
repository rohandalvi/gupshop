import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:gupshop/PushToFirebase/pushToConversationCollection.dart';
import 'package:gupshop/PushToFirebase/pushToMessageTypingCollection.dart';
import 'package:gupshop/PushToFirebase/pushToSaveCollection.dart';
import 'package:gupshop/chat_list_page/chatListCache.dart';
import 'package:gupshop/firebaseDataScaffolds/recentChatsDataScaffolds.dart';
import 'package:gupshop/individualChat/individualChatAppBar.dart';
import 'package:gupshop/individualChat/bodyPlusScrollComposerData.dart';
import 'package:gupshop/individualChat/pushMessagesToConversationAndRecentChatsCollection.dart';
import 'package:gupshop/models/text_message.dart';
import 'package:gupshop/modules/Presence.dart';
import 'package:gupshop/notifications/IRules.dart';
import 'package:gupshop/notifications/NotificationEventType.dart';
import 'package:gupshop/notifications/notificationSingleton.dart';
import 'package:gupshop/responsive/navigatorConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/retriveFromFirebase/conversationMetaData.dart';
import 'package:gupshop/retriveFromFirebase/getFromFriendsCollection.dart';
import 'package:gupshop/retriveFromFirebase/rooms.dart';
import 'package:gupshop/service/addToFriendsCollection.dart';
import 'package:gupshop/service/conversationDetails.dart';
import 'package:gupshop/service/conversation_service.dart';
import 'package:gupshop/video_call/VideoCallEntryPoint.dart';
import 'package:gupshop/service/findFriendNumber.dart';
import 'package:gupshop/service/getConversationId.dart';
import 'package:gupshop/service/recentChats.dart';
import 'package:gupshop/widgets/blankScreen.dart';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';

class IndividualChat extends StatefulWidget implements IRules{
  String conversationId;
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
        @required this.friendName,this.forwardMessage,
        this.listOfFriendNumbers,
        this.notGroupMemberAnymore,
        this.chatListCache, this.groupDeleted, this.imageURL})
      : super(key: key);



  @override
  _IndividualChatState createState() {
    print("in createState");
    print("CID $conversationId");
    return _IndividualChatState(
    );
  }

  @override
  bool apply(NotificationEventType eventType, String convId) {
    print("in apply");
    // TODO: implement apply
    print("Inside apply $eventType and Notifier Conversation id is - $convId and Current conversation id is - $conversationId");
    return eventType != NotificationEventType.NEW_CHAT_MESSAGE || conversationId != convId;
  }


}



class _IndividualChatState extends State<IndividualChat> {
  Presence presence;
  String value = ""; //TODo
  BuildContext currentContext;
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
    bool temp = await CheckIfGroup().ifThisIsAGroup(widget.conversationId);
    String tempGroupName = await CheckIfGroup().getGroupName(widget.conversationId);
    setState(() {
      groupExits = temp;
    });

    if(groupExits == false) {
      setState(() {
        friendN = FindFriendNumber().friendNumber(widget.listOfFriendNumbers, widget.userPhoneNo);
      });
    } else {
      setState(() {
        friendN = widget.conversationId;
        groupName = tempGroupName;
      });
    }
  }

  /// get conversationId required for:
  createConversationId() async{
    print("in getConversationId");

    /// only an individualChat would come here to create a conversationId as groupChat would get its conversationId in createNameForGroup page
    /// an individualChat would always have groupName as null,
    /// only a groupChat would have groupName
    String id = await GetConversationId().createNewConversationId(widget.userPhoneNo, widget.listOfFriendNumbers, null);

    //getListOfFriendNumbers(id);
    setState(() {
      widget.conversationId = id;
    });

    await checkIfGroup();

    ///push to my friends collection here
    List<dynamic> nameListForMe = new List();
    nameListForMe.add(widget.friendName);

    /// as we are in this method, this has to be an individual chat and not a group chat as,
    /// group chat when comes to individualchat page will always have conversationId
    /// and hence would never come to this method
    AddToFriendsCollection().addToFriendsCollection(widget.listOfFriendNumbers, id,
        widget.userPhoneNo,nameListForMe,null,null);///use listOfNumberHere

    ///push to all others friends collection here
    List<dynamic> nameListForOthers = new List();
    nameListForOthers.add(widget.userName);
    AddToFriendsCollection().extractNumbersFromListAndAddToFriendsCollection(widget.listOfFriendNumbers,
        id, widget.userPhoneNo, nameListForOthers, null, null);

    /// also push the conversationId to conversations:
//    Firestore.instance.collection("conversations").document(id).setData({});
    PushToConversationCollection().setBlankData(id);

    /// setData to messageTyping collection:
    PushToMessageTypingCollection(conversationId: widget.conversationId, userNumber: widget.userPhoneNo).pushTypingStatus();

    await forwardMessages(id);
  }

  forwardMessages(String conversationId) async{
    await checkIfGroup();
    if(widget.forwardMessage != null) {

      /// forward messages needs to be given this conversation's conversationId
      widget.forwardMessage[TextConfig.conversationId] = conversationId;
      var data = widget.forwardMessage;

      /// creating data to be pushed to recentChats
      if(data[TextConfig.videoURL] != null) {
        String messageId = await PushToSaveCollection(messageBody: data[TextConfig.videoURL], messageType: TextConfig.videoURL,).
        saveAndGenerateId();
        data[TextConfig.messageId] = messageId;
        Map<String, dynamic> conversationCollectionData = data;
        Map<String, dynamic> recentChatsData = await RecentChatsDataScaffolds(fromName: widget.userName,
            fromNumber: widget.userPhoneNo, conversationId: widget.conversationId, timestamp: Timestamp.now(),
            messageId: messageId).forVideoMessage();
        PushMessagesToConversationAndRecentChatsCollection(listOfFriendNumbers: widget.listOfFriendNumbers,
            conversationId: widget.conversationId, userPhoneNo: widget.userPhoneNo,
            conversationCollectionData: conversationCollectionData,recentChatsData: recentChatsData, userName: widget.userName,
            groupExits: groupExits).push();
      }
      else if(data[TextConfig.imageURL] != null) {
        String messageId = await PushToSaveCollection(messageBody: data[TextConfig.imageURL], messageType: TextConfig.imageURL,).
        saveAndGenerateId();
        data[TextConfig.messageId] = messageId;
        Map<String, dynamic> conversationCollectionData = data;
        Map<String, dynamic> recentChatsData = await RecentChatsDataScaffolds(fromName: widget.userName,
            fromNumber: widget.userPhoneNo, conversationId: widget.conversationId, timestamp: Timestamp.now(),
            messageId: messageId).forImageMessage();
        PushMessagesToConversationAndRecentChatsCollection(listOfFriendNumbers: widget.listOfFriendNumbers,
            conversationId: widget.conversationId, userPhoneNo: widget.userPhoneNo, conversationCollectionData:
            conversationCollectionData,recentChatsData: recentChatsData, userName:widget.userName,
            groupExits: groupExits).push();
      }
      else if(data[TextConfig.news] != null) {
        String messageId = await PushToSaveCollection(messageBody: data[TextConfig.news], messageType: TextConfig.body,).
        saveAndGenerateId();
        data[TextConfig.messageId] = messageId;
        PushToConversationCollection().push(data);
        data = TextMessage(text: TextConfig.newsRecentChats, conversationId: conversationId,fromName: widget.userName,
            fromNumber: widget.userPhoneNo,
            timestamp: Timestamp.now(), messageId: messageId).fromJson();
        RecentChats(message: data, convId: conversationId, userNumber:widget.userPhoneNo,
            userName: widget.userName, listOfOtherNumbers: widget.listOfFriendNumbers,
            groupExists: groupExits).getAllNumbersOfAConversation();
      }else if(data[TextConfig.latitude] != null){
        String messageId = await PushToSaveCollection(messageBody: data[TextConfig.body], messageType: TextConfig.location,).saveAndGenerateId();
        data[TextConfig.messageId] = messageId;
        Map<String, dynamic> conversationCollectionData = data;
        Map<String, dynamic> recentChatsData = await RecentChatsDataScaffolds(fromName: widget.userName,
            fromNumber: widget.userPhoneNo, conversationId: widget.conversationId, timestamp: Timestamp.now(),
            messageId: messageId, longitude: data[TextConfig.longitude], latitude: data[TextConfig.latitude]).forLocationMessage();
        PushMessagesToConversationAndRecentChatsCollection(listOfFriendNumbers: widget.listOfFriendNumbers,
            conversationId: widget.conversationId, userPhoneNo: widget.userPhoneNo,
            conversationCollectionData: conversationCollectionData,recentChatsData: recentChatsData, userName: widget.userName,
            groupExits: groupExits).push();
        }
      else{
        String messageId = await PushToSaveCollection(messageBody: data[TextConfig.body], messageType: TextConfig.body,).saveAndGenerateId();
        data[TextConfig.messageId] = messageId;
        PushToConversationCollection().push(data);
        RecentChats(message: data, convId: conversationId, userNumber:widget.userPhoneNo,
            userName: widget.userName, listOfOtherNumbers: widget.listOfFriendNumbers,
            groupExists: groupExits).getAllNumbersOfAConversation();
      }

    }
  }


  @override
  void initState() {
    print("in individualchat initistate");
    notificationInit();

    /// if new conversation, then conversationId == null
    if(widget.conversationId == null) {
      createConversationId();
      /// also create a conversations_number collection
    }else{
      ///if forwardMessage == true, then initialize that method of sending the message
      ///here in the initstate():
      forwardMessages(widget.conversationId);
    }

    conversationService = new ConversationService(widget.conversationId);
    super.initState();
  }


  notificationInit(){
    NotificationSingleton notificationSingleton = new NotificationSingleton();
    print("Active ${notificationSingleton.getNotifierObject().getActiveScreen()}");
    print("Current ${this.widget.runtimeType.toString()}");

    if(notificationSingleton.getNotifierObject().getActiveScreen() != this.widget.runtimeType.toString()) {
      print("Setting Rule to ${this.widget.runtimeType.toString()}");
      notificationSingleton.getNotifierObject().configLocalNotification(onSelectNotification: onSelectNotification);
    }
    notificationSingleton.getNotifierObject().setRule(this.widget);
    notificationSingleton.getNotifierObject().setActiveScreen(this.widget.runtimeType.toString());
  }


  /// when the user taps the notification:
  Future<void> onSelectNotification(String payload) async{
    print("onSelectNotification : $payload");
    /// deserializing our data
    Map<String, dynamic> map = jsonDecode(payload);

    print("map in onSelectNotification: ${map}");

    String eventType = map[TextConfig.type];
    print("eventType : $eventType");
    /// message
    if(eventType == TextConfig.NEW_CHAT_MESSAGE){
      /// payload for android and iOS is different
      String notificationFromNumberIndividual = map[TextConfig.notificationFromNumberIndividual];
      String notifierConversationId = map[TextConfig.notifierConversationId];


      /// get listOfFriendNumbers from firebase
      ConversationMetaData conversationMetaData = new ConversationMetaData(myNumber: widget.userPhoneNo, conversationId: notifierConversationId);

      List<dynamic> listOfFriendNumbers = await conversationMetaData.listOfNumbersOfConversationExceptMe();


      /// get Name:
      String name = await conversationMetaData.getGroupName();
      if(name == null ){
        name = await GetFromFriendsCollection(userNumber: widget.userPhoneNo,friendNumber: notificationFromNumberIndividual).getFriendName();
      }

      Map<String,dynamic> navigatorMap = new Map();
      navigatorMap[TextConfig.conversationId] = notifierConversationId;
      navigatorMap[TextConfig.friendNumberList] = listOfFriendNumbers;
      navigatorMap[TextConfig.friendName] = name;
      navigatorMap[TextConfig.userPhoneNo] = widget.userPhoneNo;
      navigatorMap[TextConfig.userName] = widget.userName;


      await Navigator.pushNamed(context, NavigatorConfig.individualChat, arguments: navigatorMap);

//      await NavigateToIndividualChat(
//        conversationId:notifierConversationId,
//        listOfFriendNumbers: listOfFriendNumbers,
//        friendName: name,
//
//        userPhoneNo: widget.userPhoneNo,
//        userName: widget.userName,
//      ).navigateNoBrackets(context);
    }

    /// video call:
    else if(eventType == TextConfig.VIDEO_CALL){
      String name = map[TextConfig.name];

      bool isActive = await Rooms().getActiveStatus(name);
      print("isActive : $isActive");
      if(isActive){

        print("Calling with context $currentContext");

        VideoCallEntryPoint().join(context: currentContext,name: name);
      }

    }

  }



  @override
  Widget build(BuildContext context){
    presence = new Presence(widget.userPhoneNo);


    currentContext = context;

//    Notifier().foreGround(
//      currentChatWithNumber: widget.listOfFriendNumbers,
//      currentConversationId: widget.conversationId,
//      customContext: context,
//    );

    return WillPopScope(
      onWillPop: () async {
        Map<String,dynamic> navigatorMap = new Map();
        navigatorMap[TextConfig.userPhoneNo] = widget.userPhoneNo;
        navigatorMap[TextConfig.userName] = widget.userName;

         return Navigator.pushNamed(context, NavigatorConfig.home, arguments: navigatorMap);
      },
      child: Material(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(WidgetConfig.appBarSeventyTwo),/// 72 //the distance between gupShop and tabBars
            child: IndividualChatAppBar(chatListCache : widget.chatListCache,userPhoneNo: widget.userPhoneNo, userName: widget.userName,groupExits: groupExits,friendName: widget.friendName,friendN: friendN, conversationId: widget.conversationId,notGroupMemberAnymore: widget.notGroupMemberAnymore,
              listOfFriendNumbers: widget.listOfFriendNumbers,presence: presence, conversationService: conversationService,
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
          body: buildWidget(),
        ),
      ),
    );
  }


  buildWidget(){
    return widget.groupDeleted == true ?
    BlankScreen(message: TextConfig.groupDeleted,) :
    (widget.notGroupMemberAnymore == false || widget.notGroupMemberAnymore == null) ?
    BodyPlusScrollComposerData(
      conversationService: conversationService,
      friendName: widget.friendName,
      conversationId: widget.conversationId,
      controller: controller,
      controllerTwo: _controller,
      listOfFriendNumbers: widget.listOfFriendNumbers,
      listScrollController: listScrollController,
      friendN: friendN,
      userName: widget.userName,
      userPhoneNo: widget.userPhoneNo,
      isPressed: isPressed,
      groupExits: groupExits,
      groupName: groupName,
      value: value,
      scroll: scroll,
    ): BlankScreen();
  }

}



