import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customNavigators.dart';

class BuildMessageComposer extends StatelessWidget {
  VoidCallback firstOnPressed;
  VoidCallback secondOnPressed;
  VoidCallback onPressedForSendingMessageIcon;
  VoidCallback onPressedForNews;
  ValueChanged<String> onChangedForTextField;
  ScrollController scrollController;
  TextEditingController controller;
  VoidCallback onEditingComplete;

  bool groupExits;
  String friendN;
  String userPhoneNo;
  String userName;
  List<dynamic> listOfFriendNumbers;
  String conversationId;
  String groupName;
  String value;
//  TextEditingController controller;
  ScrollController listScrollController;

  BuildMessageComposer({this.firstOnPressed,this.secondOnPressed, this.onPressedForSendingMessageIcon, this.onChangedForTextField, this.scrollController, this.controller, this.onPressedForNews,
    this.groupExits,
    this.friendN,
    this.userPhoneNo,
    this.userName,
    this.listOfFriendNumbers,
    this.conversationId,
    this.groupName,
    this.value,
    this.listScrollController,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: SvgPicture.asset('images/plus.svg',),
            onPressed: firstOnPressed,
          ),
          Expanded(
            child: TextField(
              onEditingComplete: onEditingComplete,
              maxLines: null,
              onChanged: onChangedForTextField,
              scrollController: scrollController,
              controller: controller,//used to clear text when user hits send button
            ),
          ),
          CustomIconButton(
            onPressed:NavigateToNewsComposer(
              conversationId: conversationId,
              userName: userName,
              userPhoneNo: userPhoneNo,
              groupName: groupName,
              groupExits: groupExits,
              friendN: friendN,
              listOfFriendNumbers: listOfFriendNumbers,
              value: value,
              controller: controller,
              listScrollController: listScrollController,
            ).navigate(context),
            iconNameInImageFolder: 'news',
          ),
          IconButton(
            icon: SvgPicture.asset('images/paperPlane.svg',),///or forward2
            onPressed: onPressedForSendingMessageIcon,
          ),
        ],
      ),
    );
  }
}
