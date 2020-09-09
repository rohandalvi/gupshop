import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/retriveFromFirebase/getMessageTypingInfo.dart';
import 'package:gupshop/widgets/customText.dart';

class TypingStatusDisplay extends StatelessWidget {
  final String conversationId;
  final String userNumber;
  final String  userName;
  bool groupExits;

  TypingStatusDisplay({this.conversationId, this.userNumber, this.userName, this.groupExits});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: GetMessageTypingInfo(userNumber: userNumber, conversationId: conversationId).messageTypingStream(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.data == null ) return CustomText(text: 'Offline',);

        bool hasMembers;

        if(snapshot.data.data == null) {
          hasMembers = false;
        }
        else if(snapshot.data.data["members"].isEmpty) {
          hasMembers = false;
        }
        else if(snapshot.data.data["members"].length == 1 && snapshot.data.data["members"].contains(userNumber)){
          hasMembers = false;
        }
        else{
          hasMembers = true;
        }

        return hasMembers == true ?
        groupExits == true ? CustomText(text: "$userName typing..",).italic() : CustomText(text: "typing..",).italic()
            : CustomText(text: "",)
        ;

//          return Visibility(
//            visible: hasMembers,
//            child: groupExits == true ? CustomText(text: "$userName typing..",).italic() : CustomText(text: "typing..",).italic(),
//          );
      },
    );
  }
}
