import 'dart:async';
import 'dart:io';

import 'package:flutter_contact/generated/i18n.dart';
import 'package:gupshop/models/chat_List.dart';
import 'package:gupshop/widgets/sideMenu.dart';
import 'package:intl/intl.dart';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IndividualChat extends StatefulWidget {
  final String conversationId;
  final String userPhoneNo;
  final String userName;
  final String friendName;
  final String friendNumber;

  IndividualChat(
      {Key key,
      @required this.conversationId,
      @required this.userPhoneNo,
      @required this.userName,
      @required this.friendName,
        @required this.friendNumber,
      })
      : super(key: key);
  @override
  _IndividualChatState createState() => _IndividualChatState(
      conversationId: conversationId,
      userPhoneNo: userPhoneNo,
      userName: userName,
      friendName: friendName,
      friendNumber: friendNumber
  );

}



class _IndividualChatState extends State<IndividualChat> {
  final String conversationId;
  final String userPhoneNo;
  final String userName;
  final String friendName;
  final String friendNumber;

  _IndividualChatState(
      {@required this.conversationId,
      @required this.userPhoneNo,
      @required this.userName,
      @required this.friendName,
        @required this.friendNumber,
      });

  String value = ""; //TODo

  TextEditingController _controller = new TextEditingController(); //to clear the text  when user hits send button//TODO- for enter
  ScrollController listScrollController = new ScrollController(); //for scrolling the screen
  StreamController streamController;
  List<DocumentSnapshot> documentList;//made for getting old batch of messages when the scrolling limit of 10 messages at a time is reached
  CollectionReference collectionReference;
  Stream<QuerySnapshot> stream;

  ScrollNotification notification;


  @override
  void initState() {
    //adding collectionReference and stream in initState() is essential for making the autoscroll when messages hit the limit
    //when user scrolls
    collectionReference = Firestore.instance.collection("conversations").document(conversationId).collection("messages");
    stream = collectionReference.orderBy("timeStamp", descending: true).limit(10).snapshots();

//    listScrollController = ScrollController();//ToDo - here
//    listScrollController.addListener(scrollListener());

    super.initState();
  }


  @override
  Widget build(BuildContext context){
    return Stack(
      children: <Widget>[
        Material(
          child: Scaffold(
            appBar: AppBar(
              title: Material(
                color: Theme.of(context).primaryColor,
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(),
                  leading:
//                  ClipOval(
//                    child: SideMenuState().getProfilePicture(friendNumber),
//                  ),
                  SizedBox(
                    height: 50,
                    width: 35,
                    child : ClipOval(
                          //child: snapshot.data.data,
                      child: SideMenuState().getProfilePicture(friendNumber),
                        ),
                  ),
                  title: Text(
                    friendName,//name of the person with whom we are chatting right now, displayed at the top in the app bar
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    'Put last seen here',
                  ),
                  trailing: Wrap(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.video_call),
                      ),
                      IconButton(
                        icon: Icon(Icons.phone),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(), //to take out the keyboard when tapped on chat screen
 //             onVerticalDragStart: _scrollToBottomButton(),
                child: Flex(
                  direction: Axis.vertical,
                  children: <Widget>[
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: stream,
                          builder: (context, snapshot) {
                            if(snapshot.data == null) return CircularProgressIndicator();//to avoid error - "getter document was called on null"
                            documentList = snapshot.data.documents;
                            return NotificationListener<ScrollUpdateNotification>(
                              child: ListView.separated(
                                controller: listScrollController, //for scrolling messages
                                //shrinkWrap: true,
                                reverse: true,
                                itemCount: documentList.length,
                                itemBuilder: (context, index) {
                                  var messageBody =
                                  documentList[index].data["body"];
                                  var fromName =
                                  documentList[index].data["fromName"];
                                  Timestamp timeStamp =
                                  documentList[index].data["timeStamp"];
                                  bool isMe = false;

                                  if (fromName == userName) isMe = true;

                                  return ListTile(
                                    title: Container(
                                      margin: isMe ? EdgeInsets.only(left: 40.0) : EdgeInsets.only(left: 0),
                                      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0), //for the box covering the text
                                      color: isMe ? Color(0xFFF9FBE7) : Color(0xFFFFEFEE),
                                      child: Text(messageBody,),//message
                                    ),
                                    subtitle: Container(
                                      margin: isMe ? EdgeInsets.only(left: 40.0) : EdgeInsets.only(left: 0),//if not this then the timeStamp gets locked to the left side of the screen. So same logic as the messages above
                                      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),//pretty padding- for some margin from the side of the screen as well as the top of parent message
                                      child: Text(//time
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
                              onNotification: (notification){
                                /*
                                onNotification allows us to know when we have reached the limit of the messages
                                once the limit is reached, documentList is updated again  with the next 20 messages using
                                the fetchAdditionalMesages()
                                 */

                                if(notification.metrics.atEdge
                                    &&  !((notification.metrics.pixels - notification.metrics.minScrollExtent) <
                                        (notification.metrics.maxScrollExtent-notification.metrics.pixels))) {
                                  print("You are at top");
                                  fetchAdditionalMessages();
                                }
                                return true;
                              },
                            );
                          }),
                    ),
                    _buildMessageComposer(),//write and send new message bar
                  ],
                ),
            ), //body
          ),
        ),
                //listScrollController.addListener(scrollListener);
        //scrollListener(),
     //new ScrollController().addListener(scrollListener);
       _scrollToBottomButton(),
      ],
    );
  }

  _buildMessageComposer() {//the type and send message box
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70,
      color: Colors.white,
      child: ListTile(
        leading: IconButton(
          icon: Icon(Icons.photo),
        ),
        title: TextField(
          //textCapitalization: TextCapitalization.sentences,
          maxLines: null,
          onChanged: (value){
            setState(() {
              this.value=value;//by doing this we are setting the value to value globally
            });
//            this.value=value;
            //_controller.clear();
          },
          scrollController: new ScrollController(),
          controller: _controller,//used to clear text when user hits send button
        ),
        trailing: IconButton(
          icon: Icon(Icons.send),
          onPressed: (){
            if(value!="") {//if there is not text, then dont send the message
              var data = {"body":value, "fromName":userName, "fromPhoneNumber":userPhoneNo, "timeStamp":DateTime.now(), "conversationId":conversationId};
              Firestore.instance.collection("conversations").document(conversationId).collection("messages").add(data);
              _controller.clear();//used to clear text when user hits send button
              listScrollController.animateTo(//for scrolling to the bottom of the screen when a next text is send
                0.0,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
              );
            }
//            var data = {"body":value, "fromName":userName, "fromPhoneNumber":userPhoneNo, "timeStamp":DateTime.now(), "conversationId":conversationId};
//            Firestore.instance.collection("conversations").document(conversationId).collection("messages").add(data);
//            _controller.clear();//used to clear text when user hits send button
//            listScrollController.animateTo(//for scrolling to the bottom of the screen when a next text is send
//              0.0,
//              curve: Curves.easeOut,
//              duration: const Duration(milliseconds: 300),
//            );
          },
        ),
      ),
    );
  }

  _scrollToBottomButton(){//the button with down arrow that should appear only when the user scrolls
//    if(notification is ScrollUpdateNotification){
      return Align(
          alignment: Alignment.centerRight,
          child:
          //scrollListener() ?
          FloatingActionButton(
            child: IconButton(
              icon: Icon(Icons.keyboard_arrow_down),
            ),
            onPressed: (){
//          Scrollable.ensureVisible(context);
              listScrollController.animateTo(//for scrolling to the bottom of the screen when a next text is send
                0.0,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
              );
            },
          )
        //: new Align(),
      );
//    } return Align();
  }


//fetching next batch of messages when user scrolls up for previous messages
  fetchAdditionalMessages() async {
    try {
      List<DocumentSnapshot>  newDocumentList  =  (await collectionReference
          .orderBy("timeStamp", descending: true)
          .startAfterDocument(documentList[documentList.length-1])
          .limit(10).getDocuments())
          .documents;

      if(newDocumentList.isEmpty) return;
      setState(() {//setting state is essential, or new messages(next batch of old messages) does not get loaded
        documentList.addAll(newDocumentList);
      });
      print("in try");
    } catch(e) {
      streamController.sink.addError(e);
      print("in catch");
    }

  }
}



