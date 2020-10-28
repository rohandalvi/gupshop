import 'package:flutter/cupertino.dart';
import 'package:gupshop/chat_list_page/chatListCache.dart';
import 'package:gupshop/image/changeProfilePicture.dart';
import 'package:gupshop/responsive/textConfig.dart';

class ChangeProfilePictureRoute{

  static Widget main(BuildContext context) {
    Map<String, dynamic> map = ModalRoute.of(context).settings.arguments;

    String userName =map[TextConfig.userName];
    bool viewingFriendsProfile=map[TextConfig.viewingFriendsProfile];
    String userPhoneNo= map[TextConfig.userPhoneNo];
    String groupConversationId=map[TextConfig.groupConversationId];
    Map<String, ChatListCache> chatListCache=map[TextConfig.chatListCache];
    String conversationId=map[TextConfig];
    String imageURL=map[TextConfig.imageURL];

    return ChangeProfilePicture(
      userName: userName,
      viewingFriendsProfile:viewingFriendsProfile,
      userPhoneNo: userPhoneNo,
      groupConversationId: groupConversationId,
      conversationId: conversationId,
      chatListCache: chatListCache,
      imageURL: imageURL,
    );
  }

}