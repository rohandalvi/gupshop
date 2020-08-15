import 'package:gupshop/individualChat/individualChatCache.dart';

class IndividualChatSingleton{
  static final IndividualChatSingleton _singleton = IndividualChatSingleton._internal();
  factory IndividualChatSingleton() => _singleton;
  IndividualChatSingleton._internal();

  static IndividualChatSingleton get shared => _singleton;

  Map<String, IndividualChatCache> individualChatCache = new Map();

  Map<String, IndividualChatCache> getIndvidualChatCacheMap(){
    return individualChatCache;
  }
}