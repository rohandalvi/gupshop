
import 'dart:convert';
import 'dart:io';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/notifications/models/NotificationRequest.dart';
import 'package:gupshop/responsive/collectionPaths.dart';
import 'package:gupshop/responsive/textConfig.dart';
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

  NotificationsManager({onMessage, onResume, onLaunch})  {
    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );
    _updateToken();
    _firebaseMessaging.configure(onMessage: onMessage, onResume: onResume, onLaunch: onLaunch);
  }

   Future<String> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  void sendNotification(NotificationRequest notificationRequest, String to) async {
    if(Platform.isAndroid) {
      notificationRequest.notificationData.set('click_action', 'FLUTTER_NOTIFICATION_CLICK');
    }
    notificationRequest.requestHeader.setAuthorization('key=$SERVER_KEY');

    Map<String, String> headers = notificationRequest.requestHeader.serialize();
    Map<String, dynamic> notificationHeaders = notificationRequest.notificationHeader.serialize();
    Map<String, dynamic> notificationData = notificationRequest.notificationData.serialize();

    if(!_isValidHeader(headers)) {
      throw Exception("Invalid header , must contain both Content-type and authorization");
    }

    if(!_isValidNotificationData(notificationHeaders)) {
      throw Exception("Invalid notification data, must contain both body and title");
    }

    if(!_isValidData(notificationData)) {
      throw Exception("Invalid data, must contain type"); // type here refers to 'NotificationEventType'
    }

    print("All valid $headers and then $notificationHeaders and then $notificationData");
    await http.post(FCM_ENDPOINT,
      headers: headers,
      body: jsonEncode(
        <String, dynamic>{
          'notification': notificationHeaders,
          'priority':   'high', // by default, all notifications are sent with high priority.
          'data': notificationData,
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

  void _updateToken() async {
    String myPhoneNumber = await UserDetails().getUserPhoneNoFuture();
    String token = await getToken();
    CollectionPaths.notificationTokenPath.document(myPhoneNumber).setData({TextConfig.token: token});
  }
}