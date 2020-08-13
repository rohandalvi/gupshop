import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gupshop/models/location_message.dart';
import 'package:gupshop/models/message.dart';
import 'package:gupshop/models/news_message.dart';


class NewsData{
  String userPhoneNo;
  String userName;
  String conversationId;
  String messageId;
  String newsId;

  NewsData({this.conversationId, this.userPhoneNo, this.userName, this.messageId, this.newsId});

  main() async{
    /// to make the user go to individualChat screen with no bottom bar open
    /// we have to make sure that Navigator.pop(context); is used so that
    /// when the user clicks pick image from camera(or any other option),
    /// he is returned to individualChat with no bottom bar open

    IMessage message = new NewsMessage(newsId: newsId, conversationId: conversationId, fromName: userName, fromNumber: userPhoneNo, timestamp: Timestamp.now(), messageId: messageId);
    return message.fromJson();
  }
}