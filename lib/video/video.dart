import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/service/conversation_service.dart';

class TestScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TestScreenState();
  
}
class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    ConversationService conversationService = new ConversationService("QZ6ox8HygxXR9MTVlb6J");
    // TODO: implement build
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: conversationService.getStream(),
        builder: (BuildContext context, snapshot) {
          if(snapshot.hasData) {
            snapshot.data.documents.forEach((element) {print("El ${element["body"]}");});
            print("Got new snapshot ${snapshot.data.documents}");

            Future.delayed(Duration(seconds: 5), () {
              print("Paginating now");
              conversationService.paginate();
            });

          } else {
            print("Done");
          }
          return Container();
        },
      )
      ,
    );
  }
  
  @override
  void initState() {
    // TODO: implement initState
    print("Init state");
    super.initState();
  }

}