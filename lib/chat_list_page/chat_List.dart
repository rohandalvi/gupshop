import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/chat_list_page/chatListCache.dart';
import 'package:gupshop/chat_list_page/chatListData.dart';
import 'package:gupshop/chat_list_page/chatListSingleton.dart';
import 'package:gupshop/chat_list_page/ifNoConversationSoFar.dart';
import 'package:gupshop/navigators/navigateToHome.dart';
import 'package:gupshop/notifications/IRules.dart';
import 'package:gupshop/notifications/NotificationEventType.dart';
import 'package:gupshop/notifications/notificationSingleton.dart';
import 'package:gupshop/responsive/navigatorConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/retriveFromFirebase/recentChats.dart';
import 'package:gupshop/retriveFromFirebase/rooms.dart';
import 'package:gupshop/service/createFriendsCollection.dart';
import 'package:gupshop/video_call/VideoCallEntryPoint.dart';
import 'package:gupshop/widgets/showMessageForFirstConversation.dart';


//chatList => individualChat
class ChatList extends StatefulWidget implements IRules {
  final String myNumber;
  final String myName;
  List<String> phoneNumberList;

  ChatList({@required this.myNumber, @required this.myName, @required this.phoneNumberList});

  @override
  ChatListState createState() => ChatListState(myNumber: myNumber,myName: myName, phoneNumberList: phoneNumberList );

  @override
  bool apply(NotificationEventType eventType, String conversationId) {
    // TODO: implement apply
    return eventType != NotificationEventType.NEW_CHAT_MESSAGE;
  }
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
    notificationInit();

    /// to create the friends collection everytime user starts the app
    /// *** this might be getting triggred everytime the user comes to the
    /// chat_list page. Check it @todo

    new NotificationSingleton().getNotifierObject().setRule(this.widget);
    CreateFriendsCollection(userName: myName, userPhoneNo: myNumber,).getUnionContacts(context);
    chatListCache = ChatListSingleton().getChatListCacheMap();
    ///ToDo: analytics here for chatListCache
    super.initState();
  }


  notificationInit(){
    NotificationSingleton notificationSingleton = new NotificationSingleton();
    print("Active ${notificationSingleton.getNotifierObject().getActiveScreen()}");
    print("Current ${this.widget.runtimeType.toString()}");

    if(notificationSingleton.getNotifierObject().getActiveScreen() != this.widget.runtimeType.toString()) {
      print("Setting Rule to ${this.widget.runtimeType.toString()}");
      notificationSingleton.getNotifierObject().configLocalNotification(onSelectNotification: onSelectNotification);
    }
    notificationSingleton.getNotifierObject().setRule(this.widget);
    notificationSingleton.getNotifierObject().setActiveScreen(this.widget.runtimeType.toString());
  }


  /// when the user taps the notification:
  Future<void> onSelectNotification(String payload) async{
    print("onSelectNotification : $payload");
    /// deserializing our data
    Map<String, dynamic> map = jsonDecode(payload);

    print("map in onSelectNotification: ${map}");

    String eventType = map[TextConfig.type];
    print("eventType : $eventType");

    /// video call:
    if(eventType == TextConfig.VIDEO_CALL){
      String name = map[TextConfig.name];

      bool isActive = await Rooms().getActiveStatus(name);
      print("isActive : $isActive");
      if(isActive){

        print("Calling with context $context");

        VideoCallEntryPoint().join(context: context,name: name);
      }

    }

  }


  /// A display message with a button for the user with no conversation at all.
  /// This button takes user to the contact_search screen
  ifNoConversationSoFar(){
    return IfNoConversationSoFar(myName: myName,myNumber: myNumber,);
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(/// to restrict user to go back to name_screen
      onWillPop: () async => false,/// a required for WillPopScope
      child: RefreshIndicator(
        onRefresh: (){
           ChatListSingleton().resetCache();
           Map<String,String> map = new Map();
           map[TextConfig.userPhoneNo] = myNumber;
           map[TextConfig.userName] = myName;
           return Navigator.pushNamed(context, NavigatorConfig.home, arguments:map );
        },
        child: Material(
          child: StreamBuilder<QuerySnapshot>(
              stream: RecentChats().orderedStream(userNumber: myNumber),
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


