import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/screens/individual_chat.dart';
import 'package:gupshop/service/createFriendsCollection.dart';
import 'package:gupshop/service/displayAvatarFromFirebase.dart';
import 'package:gupshop/service/showMessageForFirstConversation.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:intl/intl.dart';


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

//  String conversationId;
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
  getFriendPhoneNo(String conversationId, String myNumber) async {
    DocumentSnapshot temp = await Firestore.instance.collection(
        "conversationMetadata").document(conversationId).get();
    var friendNo = await extractFriendNo(temp, myNumber);
    return friendNo;
  }

  getVideoDetailsFromVideoChat(int index) async{
    QuerySnapshot querySnapshot = await Firestore.instance.collection("recentChats").document(
        myNumber).collection("conversations").getDocuments();

    DocumentSnapshot ds =  querySnapshot.documents[index];
    String videoIcon = ds.data["message"]["videoURL"];
    return videoIcon;

  }

  extractFriendNo(DocumentSnapshot temp, String myNumber) async {
    for (int i = 0; i < 2; i++) {
      if (temp.data["members"][i] != myNumber) {
        return temp.data["members"][i];
      }
    }
    return myNumber;
  }

  @override
  void initState() {
    /// to create the friends collection everytime user starts the app
    /// *** this might be getting triggred everytime the user comes to the
    /// chat_list page. Check it @todo
    CreateFriendsCollection(userName: myName, userPhoneNo: myNumber,).getUnionContacts();
    super.initState();
  }


  /// A display message with a button for the user with no conversation at all.
  /// This button takes user to the contact_search screen
  ifNoConversationSoFar(){
    return Scaffold(
      body: Center(
        child: ShowMessageForFirstConversation().showRaisedButton(context, myName, myNumber, null),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(/// to restrict user to go back to name_screen
      onWillPop: () async => false,/// a required for WillPopScope
      child: Material(
        child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection("recentChats").document(
                myNumber).collection("conversations").orderBy("timeStamp", descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.data == null) return CircularProgressIndicator();///to avoid error - "getter document was called on null"

              if(snapshot.data.documents.length == 0){/// to show new conversation button
                return ifNoConversationSoFar();
              }

              return ListView.separated( ///to create the seperated view of each chat, has to be used with separatorBuilder: (context, index) => Divider
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  bool lastMessageIsVideo=false;
                  bool lastMessageIsImage=false;
                  String lastMessage;

                  String friendName = snapshot.data.documents[index].data["name"];
                  if (snapshot.data.documents[index].data["message"]["videoURL"] != null) {
                    lastMessageIsVideo = true;
                    lastMessage = snapshot.data.documents[index].data["message"]["videoURL"];
                  }
                  else if (snapshot.data.documents[index].data["message"]["imageURL"] != null) {
                    lastMessageIsImage = true;
                    lastMessage = snapshot.data.documents[index].data["message"]["imageURL"];
                  } else {
                    lastMessage = snapshot.data.documents[index].data["message"]["body"];
                    print("lastMessage: $lastMessage");
                  }
                  Timestamp timeStamp = snapshot.data.documents[index]
                      .data["message"]["timeStamp"];

                  String friendNumber;

                  ///for sending to individual_chat.dart:
                  String conversationId = snapshot.data.documents[index].data["message"]["conversationId"];

                  return ListTile( ///main widget that creates the message box
                    leading:
                    //GetFriendPhoneNo(conversationId: conversationId,myNumber: myNumber,),
                    FutureBuilder(
                      future: getFriendPhoneNo(conversationId, myNumber),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          friendNumber = snapshot.data;
                          //return DisplayAvatarFromFirebase().getProfilePicture(friendNumber, 35);
                          return DisplayAvatarFromFirebase()
                              .displayAvatarFromFirebase(friendNumber, 30, 27,
                              false); //ToDo- check is false is right here
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                    title: CustomText(text: friendName),
                    subtitle: lastMessageIsVideo == true ?
                    FutureBuilder(
                      future: getVideoDetailsFromVideoChat(index),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return CustomText(text: lastMessage); //ToDo- check is false is right here
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ): lastMessageIsImage == true ? CustomText(text: lastMessage) :
                    CustomText(text: lastMessage).textWithOverFlow(),/// for dot dot at the end of the message
                    //dense: true,
                    trailing: CustomText( //time
                      text: DateFormat("dd MMM kk:mm").format(
                          DateTime.fromMillisecondsSinceEpoch(int.parse(
                              timeStamp.millisecondsSinceEpoch.toString()))),
                      fontSize: 12,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                IndividualChat(friendName: friendName,
                                  conversationId: conversationId,
                                  userName: myName,
                                  userPhoneNo: myNumber,
                                  friendNumber: friendNumber,), //pass Name() here and pass Home()in name_screen
                          )
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) =>
                    Divider( //to divide the chat list
                      color: Colors.white,
                    ),
              );
            }
        ),
      ),
    );
  }

}


