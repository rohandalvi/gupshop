import 'dart:async';
import 'dart:collection';

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
    Map<String, DocumentSnapshot> map = new Map();
    ConversationService conversationService = new ConversationService("QZ6ox8HygxXR9MTVlb6J");
    // TODO: implement build
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: conversationService.getStream(),
        builder: (BuildContext context, snapshot) {
          if(snapshot.hasData) {
            snapshot.data.documents.forEach((element) {

              map.putIfAbsent(element.documentID, () => element);
            });
            List<DocumentSnapshot> list = map.values.toList()..sort((e1, e2) {
              Timestamp t1 = e1.data["timeStamp"];
              Timestamp t2 = e2.data["timeStamp"];
              return t1.compareTo(t2);
            });
            list.forEach((element) {print("El ${element["body"]}");});
            print("DONE ==================================");

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