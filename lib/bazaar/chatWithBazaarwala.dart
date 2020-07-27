import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gupshop/retriveFromFirebase/getConversationIdFromConversationMetadataCollection.dart';
import 'package:gupshop/widgets/customFloatingActionButton.dart';
import 'package:gupshop/widgets/customNavigators.dart';

class ChatWithBazaarwala extends StatelessWidget {
  final String bazaarwalaNumber;
  final String userNumber;
  final String bazaarwalaName;
  final String userName;

  ChatWithBazaarwala({this.bazaarwalaNumber, this.userNumber, this.bazaarwalaName, this.userName,});

  @override
  Widget build(BuildContext context) {
    return CustomBigFloatingActionButton(
      width: 80,
      height: 80,
      heroTag: "chatWithBazaarwalaButton",
      child: IconButton(
          icon: SvgPicture.asset('images/chatBubble.svg',)
      ),
      onPressed: () async{
        List<dynamic> listOfFriendsNumbers = new List();
        listOfFriendsNumbers.add(bazaarwalaNumber);

        String conversationId = await GetConversationIdFromConversationMetadataCollection(userNumber: userNumber, friendNumber: bazaarwalaNumber).getIndividualChatId();

        NavigateToIndividualChat(conversationId: conversationId, userPhoneNo: userNumber, listOfFriendsNumbers: listOfFriendsNumbers, friendName: bazaarwalaName, userName: userName).navigateNoBrackets(context);
      },
    );
  }
}
