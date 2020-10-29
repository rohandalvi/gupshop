import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/navigatorConfig.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/widgets/customIconButton.dart';

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
              onPressed:(){
                Map<String,dynamic> navigatorMap = new Map();
                navigatorMap[TextConfig.conversationId] = conversationId;
                navigatorMap[TextConfig.userName] = userName;
                navigatorMap[TextConfig.userPhoneNo] = userPhoneNo;
                navigatorMap[TextConfig.groupName] = groupName;
                navigatorMap[TextConfig.groupExists] = groupExits;
                navigatorMap[TextConfig.friendNumber] = friendN;
                navigatorMap[TextConfig.listOfFriendNumbers] = listOfFriendNumbers;
                navigatorMap[TextConfig.value] = value;
                navigatorMap[TextConfig.controller] = controller;
                navigatorMap[TextConfig.listScrollController] = listScrollController;

                Navigator.pushNamed(context, NavigatorConfig.newsComposer, arguments: navigatorMap);
              },
              iconNameInImageFolder: IconConfig.news,
            ),
          ),
          Expanded(
            flex: 1,
            child: CustomIconButton(
              iconNameInImageFolder: IconConfig.send,///or forward2
              onPressed: onPressedForSendingMessageIcon,
            ),
          ),
        ],
      ),
    );
  }
}
