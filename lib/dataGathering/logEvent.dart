import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';

class LogEvent{
  final String nameSpace;

  FirebaseAnalytics _firebaseAnalytics;

  LogEvent({@required this.nameSpace}){
    _firebaseAnalytics = new FirebaseAnalytics();
  }

  initializeLogEvent({@required Map<String, dynamic> parameters }){
    _firebaseAnalytics.logEvent(
      name: nameSpace,
      parameters: parameters
    );
  }
}