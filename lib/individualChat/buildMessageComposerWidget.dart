import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customNavigators.dart';

class BuildMessageComposerWidget extends StatelessWidget {
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

  BuildMessageComposerWidget({this.firstOnPressed,this.secondOnPressed, this.onPressedForSendingMessageIcon, this.onChangedForTextField, this.scrollController, this.controller, this.onPressedForNews,
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
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: PaddingConfig.eight),
        height: WidgetConfig.buildMessageComposer, /// 70
        color: Colors.white,
        child: Row(/// Area 10
          children: <Widget>[
            Expanded(
              flex: 1,
              child: CustomIconButton(
                iconNameInImageFolder: IconConfig.plus,
                onPressed: firstOnPressed,
              ),
            ),
            Expanded(
              flex: 5,
              child: TextField(
                onEditingComplete: onEditingComplete,
                maxLines: null,
                onChanged: onChangedForTextField,
                scrollController: scrollController,
                controller: controller,//used to clear text when user hits send button
              ),
            ),
            Expanded(
              flex: 1,
              child: CustomIconButton(
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
                iconNameInImageFolder: IconConfig.news,
              ),
            ),
            /// send button
            Expanded(
              flex: 1,
              child: CustomIconButton(
                iconNameInImageFolder: IconConfig.send,///or forward2
                onPressed: onPressedForSendingMessageIcon,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
