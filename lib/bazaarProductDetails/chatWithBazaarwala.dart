import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/retriveFromFirebase/getConversationIdFromConversationMetadataCollection.dart';
import 'package:gupshop/retriveFromFirebase/getFromFriendsCollection.dart';
import 'package:gupshop/widgets/customFloatingActionButton.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customNavigators.dart';

class ChatWithBazaarwala extends StatelessWidget {
  final String bazaarwalaNumber;
  final String bazaarwalaName;
  final String userName;
  BuildContext customContext;

  ChatWithBazaarwala({this.bazaarwalaNumber, this.bazaarwalaName, this.userName, this.customContext});

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      iconNameInImageFolder: 'chatBubble',
      onPressed: () async{
        String userNumber = await UserDetails().getUserPhoneNoFuture();
        print("userNumber in chatWithBazaarwala : $userNumber");
        List<dynamic> listOfFriendsNumbers = new List();
        listOfFriendsNumbers.add(bazaarwalaNumber);

        String conversationId = await GetFromFriendsCollection(userNumber: userNumber, friendNumber: bazaarwalaNumber).getConversationId();
//        await GetConversationIdFromConversationMetadataCollection(userNumber: userNumber,
//            friendNumber: bazaarwalaNumber).getIndividualChatId();
        print("convId in customIconButton :$conversationId");

        NavigateToIndividualChat(conversationId: conversationId, userPhoneNo: userNumber,
            listOfFriendsNumbers: listOfFriendsNumbers, friendName: bazaarwalaName, userName: userName)
            .navigateNoBrackets(customContext);
      },
    );
  }

}
