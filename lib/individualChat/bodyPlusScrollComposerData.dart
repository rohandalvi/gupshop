import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gupshop/PushToFirebase/pushToMessageReadUnreadCollection.dart';
import 'package:gupshop/chat_list_page/chatListCache.dart';
import 'package:gupshop/individualChat/bodyData.dart';
import 'package:gupshop/individualChat/individualChatCache.dart';
import 'package:gupshop/individualChat/individualChatSingleton.dart';
import 'package:gupshop/individualChat/buildMessageComposerApplication.dart';
import 'package:gupshop/messageReadUnread/readSingleton.dart';
import 'package:gupshop/service/conversation_service.dart';
import 'package:gupshop/typing/typingStatusData.dart';
import 'package:gupshop/typing/typingStatusDisplay.dart';
import 'package:video_player/video_player.dart';

class BodyPlusScrollComposerData extends StatefulWidget {
  String conversationId;
  ScrollController listScrollController = new ScrollController(); //for scrolling the screen
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
  ConversationService conversationService;
  Map<String, ChatListCache> chatListCache;
  String friendName;

  BodyPlusScrollComposerData({this.conversationId, this.listScrollController, this.controller,
    this.userName, this.isPressed, this.userPhoneNo, this.groupExits, this.scroll, this.value,
    this.friendN, this.groupName, this.listOfFriendNumbers,this.controllerTwo, this.conversationService,
    this.chatListCache,this.friendName
  });

  @override
  _BodyPlusScrollComposerDataState createState() => _BodyPlusScrollComposerDataState();
}

class _BodyPlusScrollComposerDataState extends State<BodyPlusScrollComposerData> {
  int limitCounter = 1;
  int startAfter = 1;
  DocumentSnapshot startAtDocument;
  DocumentSnapshot currentMessageDocumentSnapshot;
  String messageId;
  Stream stream;
  List<DocumentSnapshot> documentList;
  Map<String, DocumentSnapshot> map = new HashMap();
  Map<String, bool> readCache;/// create singleton here
  Map<String, IndividualChatCache> individualChatCache;

  final myController = TextEditingController();

  @override
  void initState() {
    startAtDocument = null;
    myController.addListener(_printLatestValue);
    documentList = null;

    /// read cache
    readCache = new ReadSingleton().getReadCacheMap();
    /// message display cache
    individualChatCache = new IndividualChatSingleton().getIndvidualChatCacheMap();

    super.initState();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  _printLatestValue(){
   String isTyping = myController.text;
   TypingStatusData(
       isTyping: isTyping,
       conversationId: widget.conversationId,
      userPhoneNo: widget.userPhoneNo,
   ).pushStatus();

  }


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
                    stream: widget.conversationService.getStream(),
                    builder: (context, snapshot) {
                      /// to avoid forever circularProgressIndicator
                      if(snapshot.data == null || widget.conversationService.isValidStream() == false) return Container();

                      snapshot.data.documents.forEach((element) {

                        map.putIfAbsent(element.documentID, () => element);
                      });
                      List<DocumentSnapshot> list = map.values.toList()..sort((e1, e2) {
                        Timestamp t1 = e1.data["timeStamp"];
                        Timestamp t2 = e2.data["timeStamp"];
                        return t1.compareTo(t2);
                      });
                      this.documentList = list.reversed.toList();

                      /// for message read unread collection:
                      if(!(documentList.isEmpty || documentList == null)){
                        messageId = documentList[0].data["messageId"];
                        currentMessageDocumentSnapshot = snapshot.data.documents[0];
                        PushToMessageReadUnreadCollection(userNumber: widget.userPhoneNo, messageId: messageId, conversationId: widget.conversationId).pushLatestMessageId();
                      }


                        return NotificationListener<ScrollUpdateNotification>(
                          child: BodyData(
                            individualChatCache: individualChatCache,
                            readCache: readCache,
                            listOfFriendNumbers: widget.listOfFriendNumbers,
                            conversationId: widget.conversationId,
                            controller: widget.controller,
                            documentList: documentList,
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

                            ///onNotification allows us to know when we have reached the limit of the messages
                            ///once the limit is reached, documentList is updated again  with the next 10 messages using
                            ///the fetchAdditionalMesages()
                            if(notification.metrics.atEdge
                                &&  !((notification.metrics.pixels - notification.metrics.minScrollExtent) <
                                    (notification.metrics.maxScrollExtent-notification.metrics.pixels))) {
                              widget.conversationService.paginate();
                            }
                            return true;
                          },
                        );
                    }),
              ),
              buildMessageComposerApplication(
                  chatListCache: widget.chatListCache,
                  friendName: widget.friendName,
                  currentMessageDocumentSanpshot: currentMessageDocumentSnapshot,
                  conversationId: widget.conversationId,
                  userPhoneNo: widget.userPhoneNo,
                  listOfFriendNumbers: widget.listOfFriendNumbers,
                  listScrollController: widget.listScrollController,
                  userName: widget.userName,
                  groupName: widget.groupName,
                  groupExits: widget.groupExits,
                  value: widget.value,
                  friendN: widget.friendN,
                  myController: myController,
                  startAtDocument : startAtDocument,
              ),
              //_buildMessageComposer(),//write and send new message bar
            ],
          ),
          _scrollToBottomButton(),
//          Align(
////            alignment: Alignment(0.95, 0.85),
//              alignment: Alignment(0.82, 0.77),
//              child: TypingStatusDisplay(conversationId: widget.conversationId, userNumber: widget.userPhoneNo,)
//          ),
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
              widget.listScrollController.animateTo(///for scrolling to the bottom of the screen when a next text is send
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

}
