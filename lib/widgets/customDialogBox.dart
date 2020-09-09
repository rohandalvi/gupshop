import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/group/showGroupMembers.dart';
import 'package:gupshop/responsive/widgetConfig.dart';

class CustomDialogBox extends StatelessWidget {
  final Widget child;

  CustomDialogBox({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: child,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(WidgetConfig.borderRadiusFifteen),
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
      height: WidgetConfig.threeSixtyHeight,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(WidgetConfig.borderRadiusFifteen),
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

  groupMemberDialogHelper({@required this.userNumber,
    @required this.listOfGroupMemberNumbers,
    @required this.conversationId, this.isGroup});

  customShowDialog(BuildContext context){
    return showDialog(
        context: context,
        builder: (context) => ShowGroupMembers(userNumber: userNumber,
          listOfGroupMemberNumbers: listOfGroupMemberNumbers,
          conversationId: conversationId, isGroup: isGroup,)
    );
  }

}

