import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/navigatorConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/retriveFromFirebase/getFromFriendsCollection.dart';
import 'package:gupshop/widgets/customIconButton.dart';


class ChatWithBazaarwala extends StatelessWidget {
  final String bazaarwalaNumber;
  final String bazaarwalaName;
  final String userName;
  BuildContext customContext;

  ChatWithBazaarwala({this.bazaarwalaNumber, this.bazaarwalaName, this.userName, this.customContext});

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      iconNameInImageFolder: IconConfig.chatBubble,
      onPressed: () async{
        String userNumber = await UserDetails().getUserPhoneNoFuture();
        List<dynamic> listOfFriendsNumbers = new List();
        listOfFriendsNumbers.add(bazaarwalaNumber);

        String conversationId = await GetFromFriendsCollection(userNumber: userNumber, friendNumber: bazaarwalaNumber).getConversationId();
        Map<String,dynamic> map = new Map();
        map[TextConfig.conversationId] = conversationId;
        map[TextConfig.userPhoneNo] = userNumber;
        map[TextConfig.friendNumberList] = listOfFriendsNumbers;
        map[TextConfig.friendName] = bazaarwalaName;
        map[TextConfig.userName] = userName;


        Navigator.pushNamed(context, NavigatorConfig.individualChat, arguments: map);
      },
    );
  }

}
