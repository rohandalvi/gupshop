import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/modules/userDetails.dart';

class DisplaySavedMessages extends StatefulWidget {
  final String boardName;

  DisplaySavedMessages({this.boardName});

  @override
  _DisplaySavedMessagesState createState() => _DisplaySavedMessagesState();
}

class _DisplaySavedMessagesState extends State<DisplaySavedMessages> {
  String userNumber;

  getUserName() async{
    userNumber = await UserDetails().getUserPhoneNoFuture();
  }

  @override
  void initState() {
    getUserName();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("savedMessagedBoard").document(userNumber).collection(widget.boardName).where("isSaved", isEqualTo: true).snapshots(),
        builder: (context, snapshot) {
          return ListView.separated(
              itemBuilder: null,
              itemCount: null,
              separatorBuilder: null,
          );
        }
      ),
    );
  }
}
