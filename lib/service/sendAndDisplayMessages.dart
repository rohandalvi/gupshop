import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/service/recentChats.dart';

class SendAndDisplayMessages extends StatefulWidget {
  @override
  _SendAndDisplayMessagesState createState() => _SendAndDisplayMessagesState();
}

class _SendAndDisplayMessagesState extends State<SendAndDisplayMessages> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  pushToFirebaseAndDisplay(Map data, ){
//    String conversationId = data["conversationId"];
//
//      //var data = {"body":value, "fromName":userName, "fromPhoneNumber":userPhoneNo, "timeStamp":DateTime.now(), "conversationId":conversationId};
//      Firestore.instance.collection("conversations").document(conversationId).collection("messages").add(data);
//
////      setState(() {
////        documentList = null;
////      });
//
//
//      ///Navigating to RecentChats page with pushes the data to firebase
//      RecentChats(message: data, convId: conversationId, userNumber:userPhoneNo, userName: userName ).getAllNumbersOfAConversation();
//
//      _controller.clear();//used to clear text when user hits send button
//      listScrollController.animateTo(//for scrolling to the bottom of the screen when a next text is send
//        0.0,
//        curve: Curves.easeOut,
//        duration: const Duration(milliseconds: 300),
//      );
  }
}
