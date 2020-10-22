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
import 'package:gupshop/navigators/navigateToIndividualChat.dart';
import 'package:gupshop/notifications/application/notifier.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/retriveFromFirebase/conversationMetaData.dart';
import 'package:gupshop/retriveFromFirebase/getFromFriendsCollection.dart';
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
import 'package:gupshop/widgets/customText.dart';
import 'package:video_player/video_player.dart';

class IndividualChat extends StatefulWidget {
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
  _IndividualChatState createState() => _IndividualChatState(
    );


}



class _IndividualChatState extends State<IndividualChat> {
  Presence presence;
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
  ///
  getConversationId() async{

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
      widget.forwardMessage["conversationId"] = conversationId;
      var data = widget.forwardMessage;

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
        PushToConversationCollection().push(data);
//        FirebaseMethods().pushToConversatinCollection(data);
        data = TextMessage(text: "📰 NEWS", conversationId: conversationId,fromName: widget.userName,
            fromNumber: widget.userPhoneNo,
            timestamp: Timestamp.now(), messageId: messageId).fromJson();
        RecentChats(message: data, convId: conversationId, userNumber:widget.userPhoneNo,
            userName: widget.userName, listOfOtherNumbers: widget.listOfFriendNumbers,
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
        PushToConversationCollection().push(data);
//        FirebaseMethods().pushToConversatinCollection(data);
        RecentChats(message: data, convId: conversationId, userNumber:widget.userPhoneNo,
            userName: widget.userName, listOfOtherNumbers: widget.listOfFriendNumbers,
            groupExists: groupExits).getAllNumbersOfAConversation();
      }

    }
  }


  @override
  void initState() {

    notificationInit();

    /// if new conversation, then conversationId == null
    if(widget.conversationId == null) {
      getConversationId();
      /// also create a conversations_number collection
    }else{
      ///if forwardMessage == true, then initialize that method of sending the message
      ///here in the initstate():
      //getListOfFriendNumbers(conversationId);
      forwardMessages(widget.conversationId);
    }

    conversationService = new ConversationService(widget.conversationId);


    super.initState();
  }


  notificationInit(){
    Notifier notifier = new Notifier();
    print("notificationInit");
    notifier.registerNotification(widget.conversationId, widget.listOfFriendNumbers, widget.userName, widget.userPhoneNo);
    notifier.configLocalNotification(
        onSelectNotification: onSelectNotification
    );
  }

  Future<void> onSelectNotification(String payload) async{
    print("onSelectNotification : $payload");
    /// deserializing our data
    Map<String, dynamic> map = jsonDecode(payload);


    /// payload for android and iOS is different
    String notificationFromNumberIndividual = map[TextConfig.notificationFromNumberIndividual];
    //String notificationFromName = map[TextConfig.notificationFromName];
//   List<dynamic> notificationFromNumber = map[TextConfig.notificationFromNumber];
//    print("payload in onSelectNotification : ${notificationFromNumber}");
    String notifierConversationId = map[TextConfig.notifierConversationId];
    print("notifierConversationId in onSelectNotification: $notifierConversationId");
    //print("notificationFromNumber : $notificationFromNumber");
    //print("notificationFromName : $notificationFromName");


    /// get listOfFriendNumbers from firebase
    ConversationMetaData conversationMetaData = new ConversationMetaData(myNumber: widget.userPhoneNo, conversationId: notifierConversationId);
    List<dynamic> listOfFriendNumbers = await conversationMetaData.listOfNumbersOfConversationExceptMe();
    print("listOfFriendNumbers from firebase : $listOfFriendNumbers");

    /// get Name:
    String name = await conversationMetaData.getGroupName();
    print("groupName : $name");
    if(name == null ){
      print("widget.userPhoneNo in onSelectNotification : ${widget.userPhoneNo}");
      print("widget.userPhoneNo in notificationFromNumberIndividual : ${notificationFromNumberIndividual}");
      name = await GetFromFriendsCollection(userNumber: widget.userPhoneNo,friendNumber: notificationFromNumberIndividual).getFriendName();
      print("individual name : $name");
    }

    await NavigateToIndividualChat(
      conversationId:notifierConversationId,
      listOfFriendNumbers: listOfFriendNumbers,
      friendName: name,

      userPhoneNo: widget.userPhoneNo,
      userName: widget.userName,
    ).navigateNoBrackets(context);



  }

  @override
  Widget build(BuildContext context){
    presence = new Presence(widget.userPhoneNo);


//    Notifier().foreGround(
//      currentChatWithNumber: widget.listOfFriendNumbers,
//      currentConversationId: widget.conversationId,
//      customContext: context,
//    );

    return WillPopScope(
      onWillPop: () async => CustomNavigator().navigateToHome(context,
          widget.userName, widget.userPhoneNo),
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
    BlankScreen(message: 'This group is Deleted !',) :
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



