import 'package:intl/intl.dart';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IndividualChat extends StatefulWidget {
  final String conversationId;
  final String userPhoneNo;
  final String userName;
  final String friendName;
  IndividualChat(
      {Key key,
      @required this.conversationId,
      @required this.userPhoneNo,
      @required this.userName,
      @required this.friendName})
      : super(key: key);
  @override
  _IndividualChatState createState() => _IndividualChatState(
      conversationId: conversationId,
      userPhoneNo: userPhoneNo,
      userName: userName,
      friendName: friendName);
}



class _IndividualChatState extends State<IndividualChat> {
  final String conversationId;
  final String userPhoneNo;
  final String userName;
  final String friendName;
  _IndividualChatState(
      {@required this.conversationId,
      @required this.userPhoneNo,
      @required this.userName,
      @required this.friendName});

  String value = ""; //TODo

  TextEditingController _controller =
  new TextEditingController(); //to clear the text  when user hits send button//TODO- for enter
  ScrollController listScrollController =
  new ScrollController(); //for scrolling the screen

  @override
  Widget build(BuildContext context) {
    CollectionReference collectionReference =
        Firestore.instance.collection("conversations").document(conversationId).collection("messages");

    return Stack(
      children: <Widget>[
        Material(
          child: Scaffold(
            appBar: AppBar(
              title: Material(
                color: Theme.of(context).primaryColor,
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(),
                  leading: CircleAvatar(),
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
                child: Flex(
                  direction: Axis.vertical,
                  children: <Widget>[
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: collectionReference.orderBy("timeStamp", descending: true).limit(30).snapshots(),
                          builder: (context, snapshot) {

                            return ListView.separated(
                              controller: listScrollController, //for scrolling messages
                              //shrinkWrap: true,
                              reverse: true,
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                var messageBody =
                                    snapshot.data.documents[index].data["body"];
                                var fromName =
                                    snapshot.data.documents[index].data["fromName"];
                                Timestamp timeStamp =
                                    snapshot.data.documents[index].data["timeStamp"];
                                bool isMe = false;

                                if (fromName == userName) isMe = true;

                                return ListTile(
                                  title: Container(
                                    //fromName:userName? use following widget ToDo
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
                            );
                          }),
                    ),
                    //_scrollToBottomButton(),
                    _buildMessageComposer(),//write and send new message bar
                  ],
                ),
            ), //body
          ),
        ),
        _scrollToBottomButton(),
      ],
    );
  }

  _buildMessageComposer() {
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
          onChanged: (value){
            this.value=value;
            //_controller.clear();
          },
          scrollController: listScrollController,
          controller: _controller,//used to clear text when user hits send button
        ),
        trailing: IconButton(
          icon: Icon(Icons.send),
          onPressed: (){
            listScrollController.animateTo(//for scrolling to the bottom of the screen when a next text is send
              0.0,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 300),
            );
            var data = {"body":value, "fromName":userName, "fromPhoneNumber":userPhoneNo, "timeStamp":DateTime.now()};
            Firestore.instance.collection("conversations").document(conversationId).collection("messages").add(data);
            _controller.clear();//used to clear text when user hits send button
          },
        ),
      ),
    );
  }

  _scrollToBottomButton(){
    return Align(
      alignment: Alignment.centerRight,
      child: FloatingActionButton(
        child: IconButton(
          icon: Icon(Icons.keyboard_arrow_down),
        ),
        onPressed: (){
          listScrollController.animateTo(//for scrolling to the bottom of the screen when a next text is send
            0.0,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
        },
      ),
    );
  }
}


