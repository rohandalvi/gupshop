import 'package:flutter/cupertino.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/navigators/navigateToIndividualChat.dart';
import 'package:gupshop/notifications/application/notifier.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/widgets/customFlushBar.dart';

class IndividualChatNotifier{
  ///conversationId would come from receiver
  ///

  foreGroundHandler({
    BuildContext customContext,
    List<dynamic> notificationFromNumber,
    String notificationFromName,
    String notificationFromNumberIndividual,
    String notifierConversationId,

    String currentConversationId,
    List<dynamic> currentChatWithNumber,
    var data,
  }){
    GestureDetector(
      child: CustomFlushBar(customContext: customContext,iconName: IconConfig.appIcon,).showTopFlushBar(),
      onTap: (){
        forGroundHandlerHelper(notifierConversationId: notifierConversationId,
            notificationFromNumber: notificationFromNumber,
            notificationFromName: notificationFromName,
            notificationFromNumberIndividual: notificationFromNumberIndividual,
            currentConversationId: currentConversationId,
            currentChatWithNumber: currentChatWithNumber, context: customContext);
      }
    );
  }

  forGroundHandlerHelper({
    List<dynamic> notificationFromNumber,
    String notificationFromName,
    String notificationFromNumberIndividual,
    String notifierConversationId,

    BuildContext context,
    String currentConversationId,
    List<dynamic> currentChatWithNumber,
    var data,

    String userNumber,
    String userName,
  }) {

    print("in forGroundHandlerHelper");
    /// if the message is from anyone except with whom current conversation
    /// is being made, then navigateToIndividualChat
    if(notifierConversationId != currentConversationId){
      NavigateToIndividualChat(
        conversationId:notifierConversationId,
        listOfFriendNumbers: notificationFromNumber,
        friendName: notificationFromName,
        data: data,

        userPhoneNo: userNumber,
        userName: userName,
      ).navigate(context);
    }
  }


//  main({
//    BuildContext customContext,
//    List<dynamic> notificationFromNumber,
//    String notificationFromName,
//    String notificationFromNumberIndividual,
//    String notifierConversationId,
//
//    BuildContext context,
//    String currentConversationId,
//    List<dynamic> currentChatWithNumber,
//    var data,
//  }){
//    return Notifier().foreGround(
//      foreGroundHandler: IndividualChatNotifier().foreGroundHandlerUI(
//          notifierConversationId: notifierConversationId,
//          notificationFromNumber: notificationFromNumber,
//          notificationFromName: notificationFromName,
//          notificationFromNumberIndividual: notificationFromNumberIndividual,
//          currentConversationId: currentConversationId,
//          currentChatWithNumber: currentChatWithNumber, context: customContext
//      ),
//    );
//  }
}

//
///// get List<dynamic> notificationFromNumber from conversationMetadata
///// collection in both cases individual and group chat
//List<dynamic> notificationFromNumber = await ConversationMetaData(conversationId: notifierConversationId).listOfNumbersOfConversationExceptMe();
//
///// get name for group from conversationMetadata
///// and name for individual from friends_userNumber collection
///// first try and find if the conversation is a group chat by calling the
///// getGroupName method from conversationMetaData
///// if the getGroupName returns null then it is an individual chat, then
///// find the name from friends collection using the notificationFromNumberIndividual
//String notificationFromName = await ConversationMetaData(conversationId: notifierConversationId).getGroupName();
//if(notificationFromName == null){
//
//}