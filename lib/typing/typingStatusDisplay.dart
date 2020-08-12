import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/retriveFromFirebase/getMessageTypingInfo.dart';
import 'package:gupshop/widgets/customFloatingActionButton.dart';

class TypingStatusDisplay extends StatelessWidget {
  final String conversationId;
  final String userNumber;

  TypingStatusDisplay({this.conversationId, this.userNumber});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: GetMessageTypingInfo(userNumber: userNumber, conversationId: conversationId).messageTypingStream(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.data == null ) return CircularProgressIndicator();
//        print("snapshot.data.data : ${snapshot.data.data[""]}");
        bool hasMembers;

//        List<String> list = snapshot.data.data["members"];

        if(snapshot.data.data == null) {
          print(" null : ${snapshot.data.data}");
          hasMembers = false;
        }
        else if(snapshot.data.data["members"].isEmpty) {
          print("blank : ${snapshot.data.data["members"]}");
          hasMembers = false;
        }
        else if(snapshot.data.data["members"].length == 1 && snapshot.data.data["members"].contains(userNumber)){
          print("is typing in else");
          hasMembers = false;
        }
        else{
          hasMembers = true;
        }
        //bool hasMembers = !(snapshot.data.data == null || snapshot.data.data["members"] == []);
          //print("typing snapshot: ${snapshot.data["members"]}");
          return Visibility(
            visible: hasMembers,
            child: CustomFloatingActionButtonWithIcon(
              iconName: 'typingRed',
              onPressed: (){},
            ),
          );
      },
    );
  }
}
