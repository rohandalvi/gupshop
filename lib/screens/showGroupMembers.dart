import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/service/getGroupMemberNames.dart';
import 'package:gupshop/widgets/customDialogBox.dart';
import 'package:gupshop/widgets/customText.dart';

class ShowGroupMembers extends StatelessWidget {
  String userNumber;
  List<dynamic> listOfGroupMemberNumbers;

  ShowGroupMembers({this.userNumber, this.listOfGroupMemberNumbers});

  @override
  Widget build(BuildContext context) {
    return CustomDialogBox(
      child: ContainerForDialogBox(
        child: FutureBuilder(
          future: GetGroupMemberNames().findTheNamesOfGroupMembers(userNumber, listOfGroupMemberNumbers),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return _showGroupMemberNames(snapshot.data); //ToDo- check is false is right here
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      )
    );
  }



  _showGroupMemberNames(List<dynamic> groupMemberNames){
    return ListView.builder(
        itemCount: groupMemberNames.length,
        itemBuilder: (BuildContext context, int index) {
          if(groupMemberNames == null) return CircularProgressIndicator();
          return ListTile(
            title: CustomText(text:groupMemberNames[index]),
          );
        }
    );
  }
}
