import 'dart:convert';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gupshop/notifications/IRules.dart';
import 'package:gupshop/notifications/NotificationEventType.dart';
import 'package:gupshop/notifications/NotificationsManager.dart';
import 'package:gupshop/notifications/application/createMessageData.dart';
import 'package:gupshop/responsive/textConfig.dart';

class Notifier{

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  Map<String, dynamic> classMessage = new Map();
  bool notificationFired = false;
  String activeScreen;
  IRules activeRule;

  void setHandler(IRules iRules) {
    activeRule = iRules;
  }
  void setRule(IRules iRules) {
    print("Waste of time");
    activeRule = iRules;
  }

  IRules getHandler() {
    return activeRule;
  }

  IRules getActiveRule() {
    return activeRule;
  }

  void setActiveScreen(String screen) {
    this.activeScreen = screen;
  }

  String getActiveScreen() {
    return activeScreen;
  }


  static initializeLocalNotificationPlugin() {

  }

  /// call this method in initState of the consumer
  Future<void> configLocalNotification({SelectNotificationCallback onSelectNotification}) async{
    print('in configLocalNotification');
//    WidgetsFlutterBinding.ensureInitialized();
    var initializationSettingsAndroid;
    var initializationSettingsIOS;
    Platform.isAndroid ?
     initializationSettingsAndroid = new AndroidInitializationSettings('app_icon') :
     initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: onSelectNotification
    );


    print("notificationFired : $notificationFired");
    /// cancel the notification presented:
//    if(notificationFired == true){
//      flutterLocalNotificationsPlugin.cancelAll();
//    }
    print("flutterLocalNotificationsPlugin : ${flutterLocalNotificationsPlugin}");
  }



  Map<String, dynamic> getMessageData(){
    return classMessage;
  }


  /// call this in intiState of the consumer
  void registerNotification(){
    print('registerNotification');
    new NotificationsManager(
        onMessage: (Map<String, dynamic> message) {
          //classMessage = message;
          print("message in registerNotification : ${message}");

          String eventType = message[TextConfig.data][TextConfig.type];

          NotificationEventType type = getNotificationEventType(eventType);
          print("eventType in registerNotification : ${eventType}");

          if(eventType == TextConfig.NEW_CHAT_MESSAGE){
            Map<String, dynamic> resultMap = new Map();

            String notifierConversationId = message[TextConfig.data][TextConfig.notifierConversationId];

            Platform.isAndroid
                ? resultMap = CreateMessageData().androidChatMessageData(message)
                : resultMap = CreateMessageData().iosChatMessageData(message);
//                ? resultMap = createAndroidChatMessageData(message)
//                : resultMap = createIosChatMessageData(message);

            print("resultMap in NEW_CHAT_MESSAGE: $resultMap");

            if(getActiveRule()!=null && getActiveRule().apply(type, notifierConversationId)) {
              showNotification(resultMap);
            }
          }

          if(eventType == TextConfig.VIDEO_CALL){
            Map<String, dynamic> resultMap = new Map();

            Platform.isAndroid
                ? resultMap = CreateMessageData().androidVideoCallData(message)
                : resultMap = CreateMessageData().iosVideoCallData(message);
            print("resultMap in VIDEO_CALL: $resultMap");

            if(getActiveRule()!=null && getActiveRule().apply(type, null)) {
              showNotification(resultMap);
            }
          }


    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
    });
  }

  NotificationEventType getNotificationEventType(String event) {
    switch(event) {
      case "NEW_CHAT_MESSAGE": return NotificationEventType.NEW_CHAT_MESSAGE;
      default: return NotificationEventType.VIDEO_CALL;
    }
  }



  void showNotification(message){
    print("showNotification : $message");
    String title = message[TextConfig.title];
    String body = message[TextConfig.body];
    String notificationFromNumberIndividual = message[TextConfig.notificationFromNumberIndividual];
    String notificationFromName = message[TextConfig.notificationFromName];
    List<dynamic> notificationFromNumber = message[TextConfig.notificationFromNumber];
    String notifierConversationId = message[TextConfig.notifierConversationId];

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.dfa.flutterchatdemo'
          : 'com.duytq.flutterchatdemo',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    print("json.encode(message) : ${json.encode(message)}");

    flutterLocalNotificationsPlugin.show(0,title.toString(),
        body.toString(), platformChannelSpecifics,
        payload: json.encode(message));

    notificationFired = true;
    print("notificationFired in showNotification: $notificationFired");

  }


  /// when the notification is Pressed


}