import 'dart:convert';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gupshop/notifications/NotificationsManager.dart';
import 'package:gupshop/responsive/textConfig.dart';

class Notifier{

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  Map<String, dynamic> classMessage = new Map();
  bool notificationFired = false;


  /// initializing variables in constructor
  Notifier();


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
    if(notificationFired = true){
      flutterLocalNotificationsPlugin.cancelAll();
    }
    print("flutterLocalNotificationsPlugin : ${flutterLocalNotificationsPlugin}");
  }



  Map<String, dynamic> getMessageData(){
    return classMessage;
  }


  /// call this in intiState of the consumer
  void registerNotification(String currentConversationId, List<dynamic> currentChatWithNumber,String userName, String userNumber){
    print('registerNotification');
    new NotificationsManager(
        onMessage: (Map<String, dynamic> message) {
          //classMessage = message;
          print("message in registerNotification : ${message}");
          String notifierConversationId = message[TextConfig.data][TextConfig.notifierConversationId];
          if(currentConversationId != notifierConversationId){
            Map<String, dynamic> resultMap = new Map();

            Platform.isAndroid
                ? resultMap = createAndroidMessageData(message)
                : resultMap = createIosMessageData(message);

            print("resultMap : $resultMap");
            showNotification(resultMap);

//            Platform.isAndroid
//                ? showNotification(message[TextConfig.notificationAndroid])
//                : showNotification(message[TextConfig.iosAps][TextConfig.alert]);
          }
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });
  }

  createAndroidMessageData(Map<String, dynamic> message){
    Map<String, dynamic> result = new Map();

    var notificationMap = message[TextConfig.notificationAndroid];
    print("in createAndroidMessageData : ${message[TextConfig.notificationAndroid]}");
    //Map<String, dynamic> notificationMap = message[TextConfig.notificationAndroid];
    print("notificationMap : $notificationMap");
    var dataMap = message[TextConfig.data];
    print("dataMap : $dataMap");

    String title = notificationMap[TextConfig.title];
    String body = notificationMap[TextConfig.body];
    String notificationFromNumberIndividual = dataMap[TextConfig.notificationFromNumberIndividual];
    //String notificationFromName = dataMap[TextConfig.notificationFromName];
    print("notificationFromNumberIndividual : $notificationFromNumberIndividual");
    print("message[TextConfig.data][TextConfig.notificationFromNumber] : ${message[TextConfig.data][TextConfig.notificationFromNumber]}");
//    var notificationFromNumber = dataMap[TextConfig.notificationFromNumber];
//    print("notificationFromNumber : $notificationFromNumber");
//    List<dynamic> listOfNotificationFromNumber = jsonDecode(notificationFromNumber);
//    print("list : $listOfNotificationFromNumber");
    String notifierConversationId = dataMap[TextConfig.notifierConversationId];
    print("notifierConversationId : $notifierConversationId");
    String type = dataMap[TextConfig.type];
    print("type : $type");

    result[TextConfig.title] = title;
    print("result : $result");
    result[TextConfig.body] = body;
    result[TextConfig.notificationFromNumberIndividual] = notificationFromNumberIndividual;
    //result[TextConfig.notificationFromName] = notificationFromName;
    //result[TextConfig.notificationFromNumber] = notificationFromNumber;
    result[TextConfig.notifierConversationId] = notifierConversationId;
    result[TextConfig.type] = type;

    return result;
  }

  createIosMessageData(Map<String, dynamic> message){
    /// message[TextConfig.iosAps][TextConfig.alert]
    Map<String, dynamic> result = new Map();

    var alertMap = message[TextConfig.iosAps][TextConfig.alert];

    String title = alertMap[TextConfig.title];
    String body = alertMap[TextConfig.body];
    String notificationFromNumberIndividual = alertMap[TextConfig.notificationFromNumberIndividual];
    //String notificationFromName = alertMap[TextConfig.notificationFromName];
    //List<dynamic> notificationFromNumber = alertMap[TextConfig.notificationFromNumber];
    String notifierConversationId = alertMap[TextConfig.notifierConversationId];
    String type = alertMap[TextConfig.type];

    result[TextConfig.title] = title;
    result[TextConfig.body] = body;
    result[TextConfig.notificationFromNumberIndividual] = notificationFromNumberIndividual;
    //result[TextConfig.notificationFromName] = notificationFromName;
    //result[TextConfig.notificationFromNumber] = notificationFromNumber;
    result[TextConfig.notifierConversationId] = notifierConversationId;
    result[TextConfig.type] = type;

    return result;
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