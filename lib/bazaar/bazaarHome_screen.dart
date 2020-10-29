
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/notifications/IRules.dart';
import 'package:gupshop/notifications/NotificationEventType.dart';
import 'package:gupshop/notifications/application/notificationConsumerMethods.dart';
import 'package:gupshop/notifications/notificationSingleton.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/navigatorConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/retriveFromFirebase/conversationMetaData.dart';
import 'package:gupshop/retriveFromFirebase/getFromFriendsCollection.dart';
import 'package:gupshop/retriveFromFirebase/rooms.dart';
import 'package:gupshop/video_call/VideoCallEntryPoint.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/location/usersLocation.dart';
import 'package:gupshop/widgets/CustomFutureBuilder.dart';
import 'package:gupshop/bazaarCategory/bazaarHomeGridView.dart';
import 'package:gupshop/widgets/customFloatingActionButton.dart';

// home.dart =>
// => bazaarProfilePage
class BazaarHomeScreen extends StatefulWidget implements IRules{
  final String userPhoneNo;
  final String userName;

  BazaarHomeScreen({@required this.userPhoneNo, @required this.userName});

  @override
  _BazaarHomeScreenState createState() => _BazaarHomeScreenState(userPhoneNo: userPhoneNo, userName: userName);

  @override
  bool apply(NotificationEventType eventType, String conversationId) {
    /// here all notifications should be shown, so returning true
    /// Notification types:
    /// Video call
    /// text message
    return true;
  }
}

class _BazaarHomeScreenState extends State<BazaarHomeScreen> {

  final String userPhoneNo;
  final String userName;

  _BazaarHomeScreenState({@required this.userPhoneNo, @required this.userName});


  notificationInit(){
    NotificationConsumerMethods().notificationInit(
      runtimeType: this.widget.runtimeType,
      widget: this.widget,
      onSelectNotificationFromConsumer: onSelectNotification
    );

//    NotificationSingleton notificationSingleton = new NotificationSingleton();
//    print("Active ${notificationSingleton.getNotifierObject().getActiveScreen()}");
//    print("Current ${this.widget.runtimeType.toString()}");
//
//    if(notificationSingleton.getNotifierObject().getActiveScreen() != this.widget.runtimeType.toString()) {
//      print("Setting Rule to ${this.widget.runtimeType.toString()}");
//      notificationSingleton.getNotifierObject().configLocalNotification(onSelectNotification: onSelectNotification);
//    }
//    notificationSingleton.getNotifierObject().setRule(this.widget);
//    notificationSingleton.getNotifierObject().setActiveScreen(this.widget.runtimeType.toString());
  }


  /// when the user taps the notification:
  Future<void> onSelectNotification(String payload) async{
    NotificationConsumerMethods(
      userName: widget.userName,
      userPhoneNo: widget.userPhoneNo,
      customContext: context
    ).onSelectNotification(payload);

//    print("onSelectNotification : $payload");
//    /// deserializing our data
//    Map<String, dynamic> map = jsonDecode(payload);
//
//    print("map in onSelectNotification: ${map}");
//
//    String eventType = map[TextConfig.type];
//    print("eventType : $eventType");
//    /// message
//    if(eventType == TextConfig.NEW_CHAT_MESSAGE){
//      /// payload for android and iOS is different
//      String notificationFromNumberIndividual = map[TextConfig.notificationFromNumberIndividual];
//      String notifierConversationId = map[TextConfig.notifierConversationId];
//
//
//      /// get listOfFriendNumbers from firebase
//      ConversationMetaData conversationMetaData = new ConversationMetaData(myNumber: widget.userPhoneNo, conversationId: notifierConversationId);
//
//      List<dynamic> listOfFriendNumbers = await conversationMetaData.listOfNumbersOfConversationExceptMe();
//
//
//      /// get Name:
//      String name = await conversationMetaData.getGroupName();
//      if(name == null ){
//        name = await GetFromFriendsCollection(userNumber: widget.userPhoneNo,friendNumber: notificationFromNumberIndividual).getFriendName();
//      }
//
//      Map<String,dynamic> navigatorMap = new Map();
//      navigatorMap[TextConfig.conversationId] = notifierConversationId;
//      navigatorMap[TextConfig.friendNumberList] = listOfFriendNumbers;
//      navigatorMap[TextConfig.friendName] = name;
//      navigatorMap[TextConfig.userPhoneNo] = widget.userPhoneNo;
//      navigatorMap[TextConfig.userName] = widget.userName;
//
//
//      await Navigator.pushNamed(context, NavigatorConfig.individualChat, arguments: navigatorMap);
//    }
//
//    /// video call:
//    else if(eventType == TextConfig.VIDEO_CALL){
//      String name = map[TextConfig.name];
//
//      bool isActive = await Rooms().getActiveStatus(name);
//      print("isActive : $isActive");
//      if(isActive){
//
//        print("Calling with context $context");
//
//        VideoCallEntryPoint().join(context: context,name: name);
//      }
//
//    }

  }



  @override
  void initState() {
    notificationInit();

    super.initState();

    UsersLocation().setUsersLocationToFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          SizedBox(height: WidgetConfig.sizedBoxHeightTwelve,),
          new BazaarHomeGridView(),
        ],
      ),
      floatingActionButton: CustomFutureBuilderForGetIsBazaarWala(
        createIcon: floatingActionButtonForNewBazaarwala(),
        editIcon: floatingActionButtonForEditBazaarwala(),
      ),
      //_floatingActionButtonForNewBazaarwala(),
    );
  }

  floatingActionButtonForNewBazaarwala(){
    return CustomBigFloatingActionButton(
      child: CustomIconButton(
          iconNameInImageFolder: IconConfig.add,
      ),
      onPressed:(){
        Navigator.pushNamed(context, NavigatorConfig.bazaarWelcome);
      }
    );
  }

  /// futureBuilder for show
  floatingActionButtonForEditBazaarwala(){
    return CustomBigFloatingActionButton(
        child: CustomIconButton(
          iconNameInImageFolder: IconConfig.editIcon,
        ),
        onPressed:(){
          Navigator.pushNamed(context, NavigatorConfig.bazaarWelcome);
        }
    );
  }
}

