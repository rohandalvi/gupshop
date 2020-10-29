import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gupshop/notifications/IRules.dart';
import 'package:gupshop/notifications/notificationSingleton.dart';
import 'package:gupshop/responsive/navigatorConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/retriveFromFirebase/conversationMetaData.dart';
import 'package:gupshop/retriveFromFirebase/getFromFriendsCollection.dart';
import 'package:gupshop/retriveFromFirebase/rooms.dart';
import 'package:gupshop/video_call/VideoCallEntryPoint.dart';

class NotificationConsumerMethods{
  final String userName;
  final String userPhoneNo;
  final BuildContext customContext;

  NotificationConsumerMethods({this.userName, this.userPhoneNo, this.customContext});


  notificationInit({Type runtimeType, IRules widget, SelectNotificationCallback onSelectNotificationFromConsumer}){
    NotificationSingleton notificationSingleton = new NotificationSingleton();
    print("Active ${notificationSingleton.getNotifierObject().getActiveScreen()}");
    print("Current ${runtimeType.toString()}");

    if(notificationSingleton.getNotifierObject().getActiveScreen() != runtimeType.toString()) {
//      print("Setting Rule to ${this.widget.runtimeType.toString()}");
      notificationSingleton.getNotifierObject().configLocalNotification(onSelectNotification: onSelectNotificationFromConsumer);
    }
    notificationSingleton.getNotifierObject().setRule(widget);
    notificationSingleton.getNotifierObject().setActiveScreen(runtimeType.toString());
  }


  /// when the user taps the notification:
  Future<void> onSelectNotification(String payload) async{
    print("onSelectNotification : $payload");
    /// deserializing our data
    Map<String, dynamic> map = jsonDecode(payload);

    print("map in onSelectNotification: ${map}");

    String eventType = map[TextConfig.type];
    print("eventType : $eventType");
    /// message
    if(eventType == TextConfig.NEW_CHAT_MESSAGE){
      /// payload for android and iOS is different
      String notificationFromNumberIndividual = map[TextConfig.notificationFromNumberIndividual];
      String notifierConversationId = map[TextConfig.notifierConversationId];


      /// get listOfFriendNumbers from firebase
      ConversationMetaData conversationMetaData = new ConversationMetaData(myNumber: userPhoneNo, conversationId: notifierConversationId);

      List<dynamic> listOfFriendNumbers = await conversationMetaData.listOfNumbersOfConversationExceptMe();


      /// get Name:
      String name = await conversationMetaData.getGroupName();
      if(name == null ){
        name = await GetFromFriendsCollection(userNumber: userPhoneNo,friendNumber: notificationFromNumberIndividual).getFriendName();
      }

      Map<String,dynamic> navigatorMap = new Map();
      navigatorMap[TextConfig.conversationId] = notifierConversationId;
      navigatorMap[TextConfig.friendNumberList] = listOfFriendNumbers;
      navigatorMap[TextConfig.friendName] = name;
      navigatorMap[TextConfig.userPhoneNo] = userPhoneNo;
      navigatorMap[TextConfig.userName] = userName;


      await Navigator.pushNamed(customContext, NavigatorConfig.individualChat, arguments: navigatorMap);
    }

    /// video call:
    else if(eventType == TextConfig.VIDEO_CALL){
      String name = map[TextConfig.name];

      bool isActive = await Rooms().getActiveStatus(name);
      print("isActive : $isActive");
      if(isActive){

        print("Calling with context $customContext");

        VideoCallEntryPoint().join(context: customContext,name: name);
      }

    }

  }
}