import 'package:gupshop/PushToFirebase/pushToMessageTypingCollection.dart';
import 'package:gupshop/deleteFromFirebase/deleteMemberFromMessageTyping.dart';

class TypingStatusData{
  String isTyping;
  String conversationId;
  String userPhoneNo;

  TypingStatusData({this.isTyping, this.conversationId, this.userPhoneNo});

  pushStatus(){
    print("in push");
    if(isTyping == '' || isTyping == null){
      print("not typing");
      /// not typing
      /// delete from messageTyping
      DeleteMemberFromMessageTyping(
        conversationId: conversationId,
        userNumber: userPhoneNo,
      ).delete();
    }else{
      print("typing");
      /// typing
      /// add to messageTyping
      PushToMessageTypingCollection(
        conversationId: conversationId,
        userNumber: userPhoneNo,
      ).pushTypingStatus();
    }
  }

}