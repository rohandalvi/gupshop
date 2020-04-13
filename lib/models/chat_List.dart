import 'package:flutter/material.dart';
import 'package:gupshop/models/message_model.dart';
import 'package:gupshop/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'dart:ui';


class ChatList extends StatelessWidget {
  final String myNumber;

  ChatList({@required this.myNumber});


  @override
  Widget build(BuildContext context) {
    print("MyNumber $myNumber");
    return Material(
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("recentChats").document(myNumber).collection("conversations").snapshots(),
        builder: (context, snapshot) {
          return ListView.separated(//to create the seperated view of each chat, has to be used with separatorBuilder: (context, index) => Divider
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index){
                  String friendName= snapshot.data.documents[index].data["name"];
                  String lastMessage = snapshot.data.documents[index].data["message"]["body"];
                  Timestamp timeStamp = snapshot.data.documents[index].data["message"]["timeStamp"];
                return ListTile(//main widget that creates the message box
                  leading: CircleAvatar(
                    radius: 35,
                    //backgroundImage: AssetImage(chats[index].sender.imageUrl),
                  ),
                  title: Text(
                    friendName,
                    //chats[index].sender.name,
                  ),
                  subtitle: Text(
                    lastMessage,
                    //chats[index].text,
                  ),
                  //dense: true,
                  trailing: Text(//time
                    DateFormat("dd MMM kk:mm")
                        .format(DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp.millisecondsSinceEpoch.toString()))),
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  onTap: (){
                    Navigator.pushNamed(context, "individualChat");
                  },
                );
              },
            separatorBuilder: (context, index) => Divider(//to divide the chat list
              color: Colors.white,
            ),
          );
        }
      ),
    );
  }
}
