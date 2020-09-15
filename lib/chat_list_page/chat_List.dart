import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/chat_list_page/chatListCache.dart';
import 'package:gupshop/chat_list_page/chatListData.dart';
import 'package:gupshop/chat_list_page/chatListSingleton.dart';
import 'package:gupshop/navigators/navigateToHome.dart';
import 'package:gupshop/service/createFriendsCollection.dart';
import 'package:gupshop/service/showMessageForFirstConversation.dart';
import 'package:gupshop/widgets/customText.dart';


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

  Map<String, ChatListCache> chatListCache;

  /*
  Add photo to users  avatar- 1:
    Taking profile picture from profile picture collection
    But it needs the phone number of the friend.
    In recent chats, we its difficult to understand what the phone number of the friend is.
    So we have to make another query to conversationMetadata where we can search the friends number using the conversationId obtained from recent chats.
    So, we take the phone number which is not ours.
    But this logic will not work when in case of a group.
   */

  extractFriendNo(DocumentSnapshot temp) async {
    return temp.data["listOfOtherNumbers"];
  }

  @override
  void initState() {
    /// to create the friends collection everytime user starts the app
    /// *** this might be getting triggred everytime the user comes to the
    /// chat_list page. Check it @todo
    CreateFriendsCollection(userName: myName, userPhoneNo: myNumber,).getUnionContacts(context);
    chatListCache = ChatListSingleton().getChatListCacheMap();
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
      child: RefreshIndicator(
        onRefresh: (){
          return NavigateToHome().navigateNoBrackets(context);
        },
        child: Material(
          child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection("recentChats").document(
                  myNumber).collection("conversations").orderBy("timeStamp", descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data == null) return Center(child: CircularProgressIndicator());///to avoid error - "getter document was called on null"

                if(snapshot.data.documents.length == 0){/// to show new conversation button
                  return ifNoConversationSoFar();
                }

                return ChatListData(
                  chatListCache: chatListCache,
                  list: snapshot.data.documents,
                  myNumber: myNumber,
                  notAGroupMemberAnymore: notAGroupMemberAnymore,
                  groupExists: groupExists,
                  myName: myName,
                );
              }
          ),
        ),
      ),
    );
  }

}


