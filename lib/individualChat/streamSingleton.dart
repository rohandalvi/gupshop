import 'package:cloud_firestore/cloud_firestore.dart';

class StreamSingleton {

    static final StreamSingleton _singleton = StreamSingleton._internal();
    factory StreamSingleton() => _singleton;
    StreamSingleton._internal();

    static StreamSingleton get shared => _singleton;

    Stream _messageStream;


    Stream getMessageStream(String conversationId) {
      print("messageStream in streamSingleton : $_messageStream");
      _messageStream = Firestore.instance.collection("conversations")
          .document(conversationId).collection("messages")
          .orderBy("timeStamp", descending: true)
          .snapshots();
      return _messageStream;
    }

    void setStream(Stream stream) {
      print("setting stream to : $stream");
      _messageStream = stream;
    }





}