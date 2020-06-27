import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/screens/showGroupMembers.dart';

class CustomDialogBox extends StatelessWidget {
  final Widget child;

  CustomDialogBox({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: child,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)
        ),
        backgroundColor: Colors.transparent,
        elevation: 1,
      );
  }
}

class ContainerForDialogBox extends StatelessWidget{
  final Widget child;

  ContainerForDialogBox({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      height: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(12))
      ),
    );
  }
}

class DialogHelper{
  String userNumber;
  List<dynamic> listOfGroupMemberNumbers;
  String conversationId;

  DialogHelper({@required this.userNumber, @required this.listOfGroupMemberNumbers, @required this.conversationId});

  customShowDialog(BuildContext context){
    return showDialog(
        context: context,
        builder: (context) => ShowGroupMembers(userNumber: userNumber, listOfGroupMemberNumbers: listOfGroupMemberNumbers, conversationId: conversationId,)
    );
  }

}
