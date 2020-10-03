import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/cupertino.dart';

class MyTrace{
  final String nameSpace;

  Trace trace;
  FirebasePerformance performance;


  /// initializing variables in constructor
  MyTrace({this.nameSpace}){
    performance = FirebasePerformance.instance;
    trace = performance.newTrace(nameSpace);
  }


  Future<void> metricIncrement({@required String metricName, int incrementBy = 1}) async{
    trace.incrementMetric(metricName, incrementBy);
  }

  Future<void> startTrace() async{
    await trace.start();
  }

  Future<void> stopTrace() async{
    await trace.stop();
  }
}