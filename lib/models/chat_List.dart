import 'package:flutter/material.dart';
import 'package:gupshop/models/message_model.dart';
import 'package:gupshop/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/screens/individual_chat.dart';
import 'package:intl/intl.dart';

import 'dart:ui';


class ChatList extends StatelessWidget {
  final String myNumber;
  final String myName;

  ChatList({@required this.myNumber, @required this.myName});

  Future<String>  getUserName() async {
    await Firestore.instance.collection("users").document(myNumber).get().then((val){
      return val.toString();
    });
  }


  @override
  Widget build(BuildContext context) {
//    print("which snapshot: ${Firestore.instance.collection("recentChats")
//        .document(myNumber).collection("conversations").snapshots()}");
    return Material(
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("recentChats").document(myNumber).collection("conversations").snapshots(),
        builder: (context, snapshot) {
          if(snapshot.data == null) return CircularProgressIndicator();//to avoid error - "getter document was called on null"
          return ListView.separated(//to create the seperated view of each chat, has to be used with separatorBuilder: (context, index) => Divider
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index){
                  String friendName= snapshot.data.documents[index].data["name"];
                  String lastMessage = snapshot.data.documents[index].data["message"]["body"];
                  Timestamp timeStamp = snapshot.data.documents[index].data["message"]["timeStamp"];

                  //for sending to individual_chat.dart:
                  String conversationId = snapshot.data.documents[index].data["message"]["conversationId"];


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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IndividualChat(friendName: friendName,conversationId: conversationId,userName: myName,userPhoneNo: myNumber,),//pass Name() here and pass Home()in name_screen
                        )
                    );
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
