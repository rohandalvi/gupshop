import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gupshop/models/location_message.dart';
import 'package:gupshop/models/message.dart';


class LocationData{
  String userPhoneNo;
  String userName;
  String conversationId;
  String messageId;
  Position location;

  LocationData({this.conversationId, this.userPhoneNo, this.userName, this.messageId, this.location});

  main() async{
    /// to make the user go to individualChat screen with no bottom bar open
    /// we have to make sure that Navigator.pop(context); is used so that
    /// when the user clicks pick image from camera(or any other option),
    /// he is returned to individualChat with no bottom bar open

    IMessage message = new LocationMessage(fromName:userName, fromNumber:userPhoneNo, conversationId:conversationId, timestamp:Timestamp.now(), latitude: location.latitude, longitude: location.longitude, text: location.toString(), messageId : messageId);
    return message.fromJson();
  }
}