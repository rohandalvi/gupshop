import 'package:gupshop/chat_list_page/chatListCache.dart';

class Decache{
  Map<String, ChatListCache> chatListCache;

  Decache({this.chatListCache});

  avatar(){
    chatListCache.forEach((key, value) {
      ChatListCache chatListCacheInstance = value;
      chatListCacheInstance.circleAvatar = null;
    });
    print("chatListCache map : $chatListCache");
    return chatListCache;
  }
}