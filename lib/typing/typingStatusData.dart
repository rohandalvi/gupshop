import 'package:gupshop/PushToFirebase/pushToMessageTypingCollection.dart';
import 'package:gupshop/deleteFromFirebase/deleteMemberFromMessageTyping.dart';
import 'package:gupshop/updateInFirebase/updateTypingStatusToMessageTyping.dart';

class TypingStatusData{
  String isTyping;
  String conversationId;
  String userPhoneNo;

  TypingStatusData({this.isTyping, this.conversationId, this.userPhoneNo});

  pushStatus(){
    if(isTyping == '' || isTyping == null){
      print("not typing");
      /// not typing
      /// delete from messageTyping
      print("userPhoneNo in TypingStatusData : $userPhoneNo");
      DeleteMemberFromMessageTyping(
        conversationId: conversationId,
        userNumber: userPhoneNo,
      ).delete();
    }else{
      /// typing
      /// add to messageTyping
    UpdateTypingStatusToMessageTyping(
      conversationId: conversationId,
      userNumber: userPhoneNo,
    ).update();
    }
  }

}