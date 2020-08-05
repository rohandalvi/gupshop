import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gupshop/PushToFirebase/pushToMessageReadUnreadCollection.dart';
import 'package:gupshop/individualChat/bodyData.dart';
import 'package:gupshop/individualChat/plusButtonMessageComposerNewsSend.dart';
import 'package:gupshop/retriveFromFirebase/getFromConversationCollection.dart';
import 'package:gupshop/typing/typingStatusData.dart';
import 'package:gupshop/typing/typingStatusDisplay.dart';
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
  int startAfter = 1;
  DocumentSnapshot startAtDocument;
  DocumentSnapshot currentMessageDocumentSnapshot;
  String messageId;

  final myController = TextEditingController();

  @override
  void initState() {
    startAtDocument = null;
    myController.addListener(_printLatestValue);
    
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
    print("startdocument in bodyscroll : $startAtDocument");
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
                    //GetFromConversationCollection(conversationId: widget.conversationId).getConversationStream(limitCounter),
                    builder: (context, snapshot) {
                      if(snapshot.data == null) return CircularProgressIndicator();//to avoid error - "getter document was called on null"
                      widget.documentList = snapshot.data.documents;

                      print("in bodyscroll");
                      /// for message read unread collection:
                      messageId = snapshot.data.documents[0].data["messageId"];
                      currentMessageDocumentSnapshot = snapshot.data.documents[0];
                      PushToMessageReadUnreadCollection(userNumber: widget.userPhoneNo, messageId: messageId, conversationId: widget.conversationId).pushLatestMessageId();

                        return NotificationListener<ScrollUpdateNotification>(
                          child: BodyData(
                            listOfFriendNumbers: widget.listOfFriendNumbers,
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

                            ///onNotification allows us to know when we have reached the limit of the messages
                            ///once the limit is reached, documentList is updated again  with the next 10 messages using
                            ///the fetchAdditionalMesages()
                            if(notification.metrics.atEdge
                                &&  !((notification.metrics.pixels - notification.metrics.minScrollExtent) <
                                    (notification.metrics.maxScrollExtent-notification.metrics.pixels))) {
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

}
