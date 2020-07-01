import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/screens/individual_chat.dart';
import 'package:gupshop/service/checkIfGroup.dart';
import 'package:gupshop/service/createFriendsCollection.dart';
import 'package:gupshop/service/deleteChats.dart';
import 'package:gupshop/service/deleteHelper.dart';
import 'package:gupshop/service/deleteMembersFromGroup.dart';
import 'package:gupshop/service/displayAvatarFromFirebase.dart';
import 'package:gupshop/service/findFriendNumber.dart';
import 'package:gupshop/service/getConversationDetails.dart';
import 'package:gupshop/service/showMessageForFirstConversation.dart';
import 'package:gupshop/widgets/customDismissible.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:intl/intl.dart';


//chatList => individualChat
class ChatList extends StatefulWidget {
  final String myNumber;
  final String myName;
  List<String> phoneNumberList;

  ChatList({@required this.myNumber, @required this.myName, @required this.phoneNumberList});

  @override
  ChatListState createState() => ChatListState(myNumber: myNumber,myName: myName, phoneNumberList: phoneNumberList );
}

class ChatListState extends State<ChatList> {
  final String myNumber;
  final String myName;
  List<String> phoneNumberList;

  ChatListState({@required this.myNumber, @required this.myName, @required this.phoneNumberList });

//  String conversationId;
  String friendNo;
  bool groupExists;
  bool isGroup;

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
    String friendName;
    DocumentSnapshot temp = await Firestore.instance.collection(
        "conversationMetadata").document(conversationId).get();
//    if(temp.data.containsKey("groupName")  == false){
//      print("temp.data[] : ${temp.data["listOfOtherNumbers"]}");
//      List<dynamic> friendNoList = temp.data["listOfOtherNumbers"];
//      print("friendNoList : ${friendNoList}");
//      friendName = friendNoList[0];
//    } else{
//      /// for groups, conversationId is used as documentId for
//      /// getting profilePicture
//      /// profile_pictures -> conversationId -> url
//      friendName = conversationId;
//    }
    return temp.data;
  }

  extractFriendListAnd(){

  }

  getVideoDetailsFromVideoChat(int index) async{
    QuerySnapshot querySnapshot = await Firestore.instance.collection("recentChats").document(
        myNumber).collection("conversations").getDocuments();

    DocumentSnapshot ds =  querySnapshot.documents[index];
    String videoIcon = ds.data["message"]["videoURL"];
    return videoIcon;

  }

  extractFriendNo(DocumentSnapshot temp) async {
    return temp.data["listOfOtherNumbers"];
//    for (int i = 0; i < 2; i++) {
//      if (temp.data["members"][i] != myNumber) {
//        return temp.data["members"][i];
//      }
//    }
//    return myNumber;
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
              if (snapshot.data == null) return Center(child: CircularProgressIndicator());///to avoid error - "getter document was called on null"

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
                  }
                  Timestamp timeStamp = snapshot.data.documents[index]
                      .data["message"]["timeStamp"];

                  String friendNumber;
                  List<dynamic> memberList;
                  List<dynamic> friendNumberList;

                  ///for sending to individual_chat.dart:
                  String conversationId = snapshot.data.documents[index].data["message"]["conversationId"];

                  String documentID = snapshot.data.documents[index].documentID;

//                  DocumentReference deleteConversationFromConversationMetadata = Firestore.instance.collection("ConversationMetadata").document(documentID);
//                  DocumentReference deleteConversationFromRecentChats = Firestore.instance.collection("recentChats").document(friendNumber).collection("conversations").document(documentID);

                  return CustomDismissible(
                    key: Key(documentID),
                    documentID: documentID,
                    //snapshot.data.documents[index].data["name"]
                    /// onDismissed has all the delete logic:
                    onDismissed: (direction) async{
                      isGroup = await CheckIfGroup().ifThisIsAGroup(documentID);
                      /// ToDo: not working called from DeleteChats
//                      setState(() {
                        ///for individualChat, only delete from my recentChats
                        DeleteMembersFromGroup().deleteDocumentFromSnapshot(snapshot.data.documents[index].reference);///recentChats
                        if(isGroup == true){
                          /// also delete from profilePictures

                          DeleteMembersFromGroup().deleteConversationMetadata(documentID);///conversationMetadata
                          DeleteHelper().deleteFromFriendsCollection(myNumber, documentID);///friends collection
                          /// delete from the recentChats of all members(memberList, which includes me too)
                          /// delete from the friends collection of all members(memberList, which includes me too)
                          for(int i=0; i<memberList.length; i++){
                            DeleteMembersFromGroup().deleteFromFriendsCollection(memberList[i], documentID);
                            DeleteMembersFromGroup().deleteFromRecentChats(memberList[i], documentID);
                          }
                        }
//                        else{
////                          DeleteChats().deleteIndividualChat(friendNumber, documentID);
//                          ///for individualChat:
//                          ///friends collection:
//                          /// No need to delete from friends collection, as he is still a friend, only
//                          /// the conversation is deleted, so delete only the recentChats. Do not even
//                          /// delete from conversationMetadata
//                          ///recentChats:
//                          DeleteMembersFromGroup().deleteFromRecentChats(myNumber, documentID);
//                        }
//                      });
                    },
                    child: ListTile( ///main widget that creates the message box
                      leading: FutureBuilder(
                        future: getFriendPhoneNo(conversationId, myNumber),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            memberList = snapshot.data["members"];
                            if(snapshot.data["groupName"]  == null){
                              print("groupExists not");
                              groupExists = false;
                              /// 1. extract memberList from conversationMetadata for navigating to individualChat
                              memberList = snapshot.data["members"];
                              /// 2. extract friendNumber for DisplayAvatarFromFirebase
                              friendNumber = FindFriendNumber().friendNumber(memberList, myNumber);
                              /// 3. create friendNumberList to send to individualChat
                              friendNumberList = FindFriendNumber().createListOfFriends(memberList, myNumber);
                            } else{
                              print("groupExists");
                              groupExists = true;
                              /// for groups, conversationId is used as documentId for
                              /// getting profilePicture
                              /// profile_pictures -> conversationId -> url
                              friendNumberList = FindFriendNumber().createListOfFriends(memberList, myNumber);
                              friendNumber = conversationId;
                            }
                            return DisplayAvatarFromFirebase()
                                .displayAvatarFromFirebase(friendNumber, 30, 27,
                                false);
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
                            return CustomText(text: lastMessage);
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
                                  IndividualChat(
                                    friendName: friendName,
                                    conversationId: conversationId,
                                    userName: myName,
                                    userPhoneNo: myNumber,
                                    listOfFriendNumbers: friendNumberList,
                                  ), //pass Name() here and pass Home()in name_screen
                            )
                        );
                      },
                    ),
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


