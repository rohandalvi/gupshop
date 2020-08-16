import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gupshop/group/showGroupMembers.dart';
import 'package:gupshop/widgets/customText.dart';

class CustomDialogBox extends StatelessWidget {
  final Widget child;

  CustomDialogBox({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: child,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
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
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

class groupMemberDialogHelper{
  String userNumber;
  List<dynamic> listOfGroupMemberNumbers;
  String conversationId;
  bool isGroup;

  groupMemberDialogHelper({@required this.userNumber, @required this.listOfGroupMemberNumbers, @required this.conversationId, this.isGroup});

  customShowDialog(BuildContext context){
    return showDialog(
        context: context,
        builder: (context) => ShowGroupMembers(userNumber: userNumber, listOfGroupMemberNumbers: listOfGroupMemberNumbers, conversationId: conversationId, isGroup: isGroup,)
    );
  }

}

