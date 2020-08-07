import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gupshop/chat_list_page/avatarData.dart';
import 'package:gupshop/chat_list_page/readUnreadIconDisplay.dart';
import 'package:gupshop/chat_list_page/trailingDisplay.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/individualChat/individual_chat.dart';
import 'package:gupshop/messageReadUnread/messageReadUnreadData.dart';
import 'package:gupshop/service/conversationDetails.dart';
import 'package:gupshop/service/createFriendsCollection.dart';
import 'package:gupshop/deleteFromFirebase/deleteHelper.dart';
import 'package:gupshop/deleteFromFirebase/deleteMembersFromGroup.dart';
import 'package:gupshop/service/displayAvatarFromFirebase.dart';
import 'package:gupshop/service/findFriendNumber.dart';
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
  bool notAGroupMemberAnymore = false;

  /*
  Add photo to users  avatar- 1:
    Taking profile picture from profile picture collection
    But it needs the phone number of the friend.
    In recent chats, we its difficult to understand what the phone number of the friend is.
    So we have to make another query to conversationMetadata where we can search the friends number using the conversationId obtained from recent chats.
    So, we take the phone number which is not ours.
    But this logic will not work when in case of a group.
   */
//  getFriendPhoneNo(String conversationId, String myNumber) async {
//    DocumentSnapshot temp = await Firestore.instance.collection(
//        "conversationMetadata").document(conversationId).get();
//    return temp.data;
//  }


  getVideoDetailsFromVideoChat(int index) async{
    QuerySnapshot querySnapshot = await Firestore.instance.collection("recentChats").document(
        myNumber).collection("conversations").getDocuments();

    DocumentSnapshot ds =  querySnapshot.documents[index];
    String videoIcon = ds.data["message"]["videoURL"];
    return videoIcon;

  }

  extractFriendNo(DocumentSnapshot temp) async {
    return temp.data["listOfOtherNumbers"];
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
                  bool read = snapshot.data.documents[index].data["read"];

                  String friendNumber;
                  List<dynamic> memberList;
                  List<dynamic> friendNumberList;

                  ///for sending to individual_chat.dart:
                  String conversationId = snapshot.data.documents[index].data["message"]["conversationId"];

                  String documentID = snapshot.data.documents[index].documentID;
                  String adminNumber;

                  return CustomDismissible(
                    key: Key(documentID),
                    documentID: documentID,
                    /// onDismissed has all the delete logic:
                    onDismissed: (direction) async{
                      isGroup = await CheckIfGroup().ifThisIsAGroup(documentID);
                      adminNumber = await CheckIfGroup().getAdminNumber(documentID);
                      /// ToDo: not working called from DeleteChats
                        ///for individualChat, only delete from my recentChats
                        DeleteMembersFromGroup().deleteDocumentFromSnapshot(snapshot.data.documents[index].reference);///recentChats
                        if(direction == DismissDirection.startToEnd &&  isGroup == true && adminNumber == myNumber){
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
                    },
                    child: ListTile( ///main widget that creates the message box
                      leading: AvatarData(
                        myNumber: myNumber,
                        conversationId: conversationId,
                        notAGroupMemberAnymore: notAGroupMemberAnymore,
                        groupExists: groupExists,
                        friendNumber: friendNumber,
                        friendNumberList: friendNumberList,
                        memberList: memberList,
                        ),
                      title: CustomText(text: friendName),
                      subtitle: lastMessageIsVideo == true ?
                          ///futurebuilder demo:
                      FutureBuilder(
                        future: getVideoDetailsFromVideoChat(index),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            return CustomText(text: lastMessage, textColor: subtitleGray,);
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ): lastMessageIsImage == true ? CustomText(text: lastMessage, textColor: subtitleGray,) :
                      CustomText(text: lastMessage).textWithOverFlow(),/// for dot dot at the end of the message
                      //dense: true,
                      /// read unread icon display:
                      trailing: TrailingDisplay(
                        conversationId: conversationId,
                        myNumber: myNumber,
                        timeStamp: timeStamp,
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
                                    notGroupMemberAnymore: notAGroupMemberAnymore,
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


