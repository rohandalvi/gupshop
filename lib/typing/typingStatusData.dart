import 'package:gupshop/deleteFromFirebase/deleteMemberFromMessageTyping.dart';
import 'package:gupshop/updateInFirebase/updateTyping.dart';

class TypingStatusData{
  String isTyping;
  String conversationId;
  String userPhoneNo;

  TypingStatusData({this.isTyping, this.conversationId, this.userPhoneNo});

  pushStatus(){
    if(isTyping == '' || isTyping == null){

      /// not typing
      /// delete from messageTyping
      DeleteMemberFromMessageTyping(
        conversationId: conversationId,
        userNumber: userPhoneNo,
      ).delete();
    }else{
      /// typing
      /// add to messageTyping
      UpdateTyping(
        conversationId: conversationId,
        userNumber: userPhoneNo,
      ).update();
      }
  }

}