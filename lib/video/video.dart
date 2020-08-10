import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gupshop/service/conversation_service.dart';

class TestScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TestScreenState();

}
class _TestScreenState extends State<TestScreen> {
  static final channelName = "flutter.native/helper";
  final methodChannel = MethodChannel(channelName);

  @override
  Widget build(BuildContext context) {


    // TODO: implement build
    return new Material(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.all(16.0),
            child: new RaisedButton(
              child: const Text('Push Native View'),
              onPressed: (){
                _pushAndPopNativeView('view');
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    print("Init state");
    super.initState();
  }

  _pushAndPopNativeView(String viewId) async {
    await this.methodChannel.invokeMethod("test");
  }

}