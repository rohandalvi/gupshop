import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final String tooltip;
  final Widget child;
  final VoidCallback onPressed;
  final Object heroTag;

  CustomFloatingActionButton({this.tooltip, this.child, this.onPressed, this.heroTag});
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: heroTag,
      tooltip: tooltip==null?'Scroll to the bottom':tooltip,
      backgroundColor: Colors.transparent,
      elevation: 0,
//              hoverColor: Colors.transparent,

      highlightElevation: 0,
      child: child == null ? IconButton(
          icon: SvgPicture.asset('images/groupManWoman.svg',)
        //SvgPicture.asset('images/downChevron.svg',)
      ): child,
      onPressed: onPressed,
    );
  }
}


class CustomBigFloatingActionButton extends StatelessWidget {
  final String tooltip;
  final Widget child;
  final VoidCallback onPressed;
  final Object heroTag;
  final double height;
  final double width;

  CustomBigFloatingActionButton({this.tooltip, this.child, this.onPressed, this.heroTag, this.width, this.height,});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height == null ? 100 : height,/// to increase the size of floatingActionButton use container along with FittedBox
      width: width == null ? 100 : width,
      child: FittedBox(
        child: CustomFloatingActionButton(
          heroTag: heroTag,
          tooltip: tooltip,
          child: child,
          onPressed: onPressed,
        ),
      ),
    );
  }
}


//child: Container(
//height: 100,/// to increase the size of floatingActionButton use container along with FittedBox
//width: 100,
//child: FittedBox(
//child: CustomFloatingActionButton(
//tooltip: 'Create a new Group',
///// create a listOfContactsSelected and send it to individualChat
//onPressed: () {
//createListOfContactsSelected();
//
/////navigate to creatGroupName_Screen:
//if(shouldAddNewMemberToTheGroup){
//print("new list in createGroup: $listOfNumbersInAGroup");
//CustomNavigator().navigateToHome(context, userName, userPhoneNo);
//AddNewGroupMember().addToConversationMetadata(conversationId, listOfNumbersInAGroup);
//}
//else CustomNavigator().navigateToCreateGroupName_Screen(context, userName, userPhoneNo, listOfNumbersInAGroup);
//}
//),
//),
//)