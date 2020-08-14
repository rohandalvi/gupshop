import 'package:gupshop/chat_list_page/chatListCache.dart';

class ChatListSingleton{
  static final ChatListSingleton _singleton = ChatListSingleton._internal();
  factory ChatListSingleton() => _singleton;
  ChatListSingleton._internal();

  static ChatListSingleton get shared => _singleton;

  Map<String, ChatListCache> chatListCache = new Map();

  Map<String, ChatListCache> getChatListCacheMap(){
    return chatListCache;
  }
}