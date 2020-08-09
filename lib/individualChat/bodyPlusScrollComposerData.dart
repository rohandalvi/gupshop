import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gupshop/PushToFirebase/pushToMessageReadUnreadCollection.dart';
import 'package:gupshop/individualChat/bodyData.dart';
import 'package:gupshop/individualChat/plusButtonMessageComposerNewsSend.dart';
import 'package:gupshop/individualChat/streamSingleton.dart';
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

  BodyPlusScrollComposerData({this.conversationId, this.listScrollController, this.controller,
    this.userName, this.isPressed, this.userPhoneNo, this.groupExits, this.scroll, this.value,
    this.friendN, this.groupName, this.listOfFriendNumbers,this.controllerTwo, this.conversationService
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
//  ConversationService conversationService;

  final myController = TextEditingController();

  @override
  void initState() {
    startAtDocument = null;
    myController.addListener(_printLatestValue);
    documentList = null;
    //conversationService = new ConversationService(widget.conversationId);
//    stream = widget.conversationService.getStream();
    //stream = new StreamSingleton().getMessageStream(widget.conversationId);//GetFromConversationCollection(conversationId: widget.conversationId).getConversationStream(limitCounter);


    super.initState();
  }

  @override
  void dispose() {
    myController.dispose();
    print("Disposing  stream to null");
    stream  = null;
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
                      //Firestore.instance.collection("conversations").document(widget.conversationId).collection("messages").orderBy("timeStamp", descending: true).limit(limitCounter*10).snapshots(),
//                    GetFromConversationCollection(conversationId: widget.conversationId).getConversationStream(limitCounter),
                    builder: (context, snapshot) {
                      print("connection state before : ${snapshot.connectionState}");
                      if(snapshot.data == null) return CircularProgressIndicator();//to avoid error - "getter document was called on null"
                      print("DocumentList $documentList");

                      snapshot.data.documents.forEach((element) {

                        map.putIfAbsent(element.documentID, () => element);
                      });
                      List<DocumentSnapshot> list = map.values.toList()..sort((e1, e2) {
                        Timestamp t1 = e1.data["timeStamp"];
                        Timestamp t2 = e2.data["timeStamp"];
                        return t1.compareTo(t2);
                      });
                      this.documentList = list.reversed.toList();

                      print("new docs : ${snapshot.data.documents}");
                      print("connection state : ${snapshot.connectionState}");

                      print("in bodyscroll");
                      /// for message read unread collection:
                      if(!(documentList.isEmpty || documentList == null)){
                        messageId = snapshot.data.documents[0].data["messageId"];
                        currentMessageDocumentSnapshot = snapshot.data.documents[0];
                        PushToMessageReadUnreadCollection(userNumber: widget.userPhoneNo, messageId: messageId, conversationId: widget.conversationId).pushLatestMessageId();
                      }

                        return NotificationListener<ScrollUpdateNotification>(
                          child: BodyData(
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
//                            w  setState(() {
//                                limitCounter++;
//                              });
                              //fetchAdditionalMessages();
                            }
                            return true;
                          },
                        );
                    }),
              ),
              PlusButtonMessageComposerNewsSend(
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
          Align(
            alignment: Alignment(0.95, 0.85),
              child: TypingStatusDisplay(conversationId: widget.conversationId, userNumber: widget.userPhoneNo,)
          ),
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
