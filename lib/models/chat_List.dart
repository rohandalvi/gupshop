import 'package:flutter/material.dart';
import 'package:gupshop/models/message_model.dart';
import 'package:gupshop/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/screens/individual_chat.dart';
import 'package:gupshop/service/displayAvatarFromFirebase.dart';
import 'package:gupshop/widgets/sideMenu.dart';
import 'package:intl/intl.dart';

import 'dart:ui';

//chatList => individualChat
class ChatList extends StatefulWidget {
  final String myNumber;
  final String myName;


  ChatList({@required this.myNumber, @required this.myName});

  @override
  ChatListState createState() => ChatListState(myNumber: myNumber,myName: myName );
}

class ChatListState extends State<ChatList> {
  final String myNumber;
  final String myName;


  ChatListState({@required this.myNumber, @required this.myName });

  String conversationId;

  String friendNo;

  /*
  Add photo to users  avatar- 1:
    Taking profile picture from profile picture collection
    But it needs the phone number of the friend.
    In recent chats, we its difficult to understand what the phone number of the friend is.
    So we have to make another query to conversationMetadata where we can search the friends number using the conversationId obtained from recent chats.
    So, we take the phone number which is not ours.
    But this logic will not work when in case of a group.
   */
//  getFriendPhoneNo(String conversationId) async {
//    print("mynumber: $myNumber");
//    await Firestore.instance.collection("conversationMetadata").document(
//        conversationId).get().then((val) {
//      for (int i = 0; i < 2; i++) {
//        if (val.data["members"][i] != myNumber) {
//          friendNo=val.data["members"][i];
//          break;
//        }
//      }
//      print("friendNo: $friendNo");
//    });
//  }

  getFriendPhoneNo(String conversationId, String myNumber) async {
    print("mynumber in getfriend2 : $myNumber");
   DocumentSnapshot temp = await Firestore.instance.collection("conversationMetadata").document(conversationId).get();
   var friendNo = await extractFriendNo(temp , myNumber);
   return friendNo;
  }

  extractFriendNo(DocumentSnapshot temp, String myNumber) async{
    print("mynumber in extractfriendNo : $myNumber");
    for (int i = 0; i < 2; i++) {
      if (temp.data["members"][i] != myNumber) {
        return temp.data["members"][i];
      }
    }
    return myNumber;
  }


  @override
  Widget build(BuildContext context) {
    print("userphoneno in chatlist : $myNumber");
    print("username in chatlist :$myName");
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
                String lastMessage;
                  String friendName= snapshot.data.documents[index].data["name"];
                  if(snapshot.data.documents[index].data["message"]["body"] == null){
                    lastMessage = snapshot.data.documents[index].data["message"]["imageURL"];
                  }else{
                    lastMessage = snapshot.data.documents[index].data["message"]["body"];
                  }
                  Timestamp timeStamp = snapshot.data.documents[index].data["message"]["timeStamp"];
                  print("friendName: $friendName");

                  String friendNumber;



                  //for sending to individual_chat.dart:
                    conversationId = snapshot.data.documents[index].data["message"]["conversationId"];

                return ListTile(//main widget that creates the message box
                  leading:
//                  FutureBuilder(
//                    future: getFriendPhoneNo(conversationId, myNumber),
//                    builder: (BuildContext context, AsyncSnapshot snapshot) {
//                      print("Dat $snapshot");
//                      if(snapshot.connectionState == ConnectionState.done) {
//                        friendNumber = snapshot.data;
//                        return GetProfilePictureFromFirebase().getProfilePicture(friendNumber, 35);
//                        //SideMenuState().getProfilePicture(
//                        //friendNumber);
//                      }
//                      return CircularProgressIndicator();
//                    },
//                  ),
                  FutureBuilder(
                    future: getFriendPhoneNo(conversationId, myNumber),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      print("Dat $snapshot");
                      if(snapshot.connectionState == ConnectionState.done) {
                        friendNumber = snapshot.data;
                        //return DisplayAvatarFromFirebase().getProfilePicture(friendNumber, 35);
                        return DisplayAvatarFromFirebase().displayAvatarFromFirebase(friendNumber, 30);
                          //SideMenuState().getProfilePicture(
                            //friendNumber);
                      }
                      return CircularProgressIndicator();
                    },
                  ),
//                  DisplayAvatarFromFirebase().displayAvatarFromFirebase(friendNo, 35),
//                  CircleAvatar(//profile picture
//                    radius: 35,
//                    //backgroundImage: SideMenuState().getProfilePicture(),
//                    //AssetImage(chats[index].sender.imageUrl)
//                  ),
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
                    print("friendNo in chatlist: $friendNumber");//friendNo is for outside of widget build, so use friendNumber insted of friendNo
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IndividualChat(friendName: friendName,conversationId: conversationId,userName:myName,userPhoneNo: myNumber, friendNumber: friendNumber,),//pass Name() here and pass Home()in name_screen
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


