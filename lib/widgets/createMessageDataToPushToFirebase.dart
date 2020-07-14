import 'package:geolocator/geolocator.dart';

class CreateMessageDataToPushToFirebase{
  String userPhoneNo;
  bool isNews;
  bool isVideo;
  bool isImage;
  String value;
  String userName;
  String fromPhoneNumber;
  String conversationId;
  Position location;

  CreateMessageDataToPushToFirebase({this.userPhoneNo, this.isNews, this.userName, this.conversationId});

  create(){
    if(isNews == true){
      return {"body":"📰 NEWS", "fromName":userName, "fromPhoneNumber":userPhoneNo, "timeStamp":DateTime.now(), "conversationId":conversationId};
    }
    if(location != null){
      return {"body":value, "fromName":userName, "fromPhoneNumber":userPhoneNo, "timeStamp":DateTime.now(), "conversationId":conversationId, "latitude": location.latitude, "longitude": location.longitude};
    }
    if(isVideo == true){
      return {"videoURL":value, "fromName":userName, "fromPhoneNumber":userPhoneNo, "timeStamp":DateTime.now(), "conversationId":conversationId};
    }

    if(isImage == true){
      return {"imageURL":value, "fromName":userName, "fromPhoneNumber":userPhoneNo, "timeStamp":DateTime.now(), "conversationId":conversationId};
    } return {"body":value, "fromName":userName, "fromPhoneNumber":userPhoneNo, "timeStamp":DateTime.now(), "conversationId":conversationId};
  }
}