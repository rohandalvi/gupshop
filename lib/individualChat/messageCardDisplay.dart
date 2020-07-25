import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/individualChat/textMessageUI.dart';
import 'package:gupshop/location/locationDisplayAndLaunchInMap.dart';
import 'package:gupshop/news/newsContainerUI.dart';
import 'package:gupshop/location/location_service.dart';
import 'package:gupshop/widgets/customRaisedButton.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:gupshop/widgets/customVideoPlayer.dart';
import 'package:gupshop/widgets/displayPicture.dart';
import 'package:video_player/video_player.dart';

class MessageCardDisplay extends StatelessWidget {
  bool isMe;
  bool isNews;
  String newsTitle;
  String newsLink;
  String newsBody;
  bool isLocationMessage;
  dynamic fromName;
  double latitude;
  double longitude;
  dynamic videoURL;
  VideoPlayerController controller;
  dynamic imageURL;
  dynamic messageBody;
  String newsId;
  Map<String,NewsContainerUI> mapIsNewsGenerated;


  MessageCardDisplay({this.isMe, this.isNews,this.newsTitle, this.newsLink,
    this.newsBody, this.isLocationMessage,this.fromName,this.latitude,
    this.longitude,this.controller, this.imageURL, this.videoURL, this.messageBody,
    this.newsId, this.mapIsNewsGenerated
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: isMe? Alignment.centerRight: Alignment.centerLeft,///to align the messages at left and right
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 3.0), ///for the box covering the text, when horizontal is increased, the photo size decreases
      child: isNews == true ? NewsContainerUI(title: newsTitle, link: newsLink, newsBody: newsBody,) :
      isLocationMessage ==true ? LocationDisplayAndLaunchInMap(textOnButton: fromName, latitude: latitude,longitude: longitude, locationName: 'current location',):
      videoURL != null  ? showVideo(videoURL, controller) :imageURL == null?
      TextMessageUI(isMe: isMe, messageBody: messageBody,): showImage(imageURL),
    );
  }

  displayNews(){
    return mapIsNewsGenerated[newsId];
  }

  showLocation(String senderName,double latitude, double longitude){/// todo - use the same method from GeolocationServiceState
    return CustomRaisedButton(
      child: CustomText(text: '$senderName \nCurrent Location 📍',),/// toDo- very very big name
//      shape:  RoundedRectangleBorder(
//        borderRadius: new BorderRadius.circular(5.0),
//        side: BorderSide(color : Colors.black),
//      ),
      onPressed: (){
        LocationServiceState().launchMapsUrl(latitude, longitude);
      },
    );
  }

  showVideo(String videoURL, VideoPlayerController controller){
    try{
      return Column(
        children: <Widget>[
          SizedBox(
            width: 240,
            height: 150,
            child: DisplayPicture().videoFrame(videoURL, 240, 190),
          ),

        ],
      );
        //CustomVideoPlayer(videoURL: videoURL);
    }
    catch (e){
      return Icon(Icons.image);}
  }

  showImage(String imageURL){
    try{
      return DisplayPicture().chatPictureFrame(imageURL);
    }
    catch (e){
      return Icon(Icons.image);}
  }

}
