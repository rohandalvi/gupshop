
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';


class NotificationsManager {

  static final String FCM_ENDPOINT = 'https://fcm.googleapis.com/fcm/send';
  static final String SERVER_KEY =
      'AAAAU4SlMbE:APA91bFZ34gnyE4UpvdgXQCEsaZfOvHlCDUng9EqwBJf1xYRL4P2CruCrCtCcKIh69N0BhHDGkox4VeqTWrbYtnEljioLIdQ3ZK71iDR15J3mg-TtQWR3clLDaKmp1gE_UoI3JieDbS8';
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  final Set<String> _notificationDataFields = Set.from(['body','title']);
  final Set<String> _headerDataFields = Set.from(['Content-Type','Authorization']);
  final Set<String> _requiredDataFields = Set.from(['type']);

  NotificationsManager(Function onMessage, Function onLaunch, Function onResume)  {
    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );

    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");

    },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      });
  }

   Future<String> getToken() async {
    return _firebaseMessaging.getToken();
  }

  void sendNotification(Map<String, String> headers, Map<String, dynamic> notificationData, Map<String, dynamic> data, String to) async {
    if(Platform.isAndroid) {
      data['click_action'] = 'FLUTTER_NOTIFICATION_CLICK'; // required by firebase for android based notifications.
    }
    headers['Authorization'] = 'key=$SERVER_KEY';
    if(!_isValidHeader(headers)) {
      throw Exception("Invalid header , must contain both Content-type and authorization");
    }

    if(!_isValidNotificationData(notificationData)) {
      throw Exception("Invalid notification data, must contain both body and title");
    }

    if(!_isValidData(data)) {
      throw Exception("Invalid data, must contain type"); // type here refers to 'NotificationEventType'
    }

    await http.post(FCM_ENDPOINT,
      headers: headers,
      body: jsonEncode(
        <String, dynamic>{
          'notification': notificationData,
          'priority':   'high', // by default, all notifications are sent with high priority.
          'data': data,
          'to': to,
        }
      )
    );

    print("Sent notification");


  }

  bool _isValidNotificationData(Map<String, dynamic> notificationData) {
    for(String field in _notificationDataFields) {
      if(!notificationData.containsKey(field)) return false;
    }
    return true;
  }

  bool _isValidHeader(Map<String, String> headers) {
    for(String field in _headerDataFields) {
      if(!headers.containsKey(field)) return false;
    }
    return true;
  }

  bool _isValidData(Map<String, dynamic> data) {
    for(String field in _requiredDataFields) {
      if(!data.containsKey(field)) return false;
    }
    return true;
  }
}