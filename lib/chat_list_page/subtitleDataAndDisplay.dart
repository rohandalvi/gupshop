import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/widgets/customText.dart';

class SubtitleDataAndDisplay extends StatelessWidget {
  final bool lastMessageIsVideo;
  final int index;
  String lastMessage;
  bool lastMessageIsImage;
  String myNumber;

  SubtitleDataAndDisplay({this.lastMessageIsVideo, this.index, this.lastMessage,
    this.lastMessageIsImage, this.myNumber,
  });

  @override
  Widget build(BuildContext context) {
    return lastMessageIsVideo == true ?
    ///futurebuilder demo:
    FutureBuilder(
      future: getVideoDetailsFromVideoChat(index),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CustomText(text: lastMessage, textColor: subtitleGray,);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    ): lastMessageIsImage == true ? CustomText(text: lastMessage, textColor: subtitleGray,) :
    CustomText(text: lastMessage).textWithOverFlow();/// for dot dot at the end of the message
  }

  getVideoDetailsFromVideoChat(int index) async{
    QuerySnapshot querySnapshot = await Firestore.instance.collection("recentChats").document(
        myNumber).collection("conversations").getDocuments();

    DocumentSnapshot ds =  querySnapshot.documents[index];
    String videoIcon = ds.data["message"]["videoURL"];
    return videoIcon;

  }
}

