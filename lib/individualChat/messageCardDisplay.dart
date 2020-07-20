import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/news/newsContainerUI.dart';
import 'package:gupshop/service/geolocation_service.dart';
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
      child:
//      isNews == true ? displayNews() :
      isNews == true ? NewsContainerUI(title: newsTitle, link: newsLink, newsBody: newsBody,) :
      isLocationMessage ==true ? showLocation(fromName,latitude, longitude):
      videoURL != null  ? showVideo(videoURL, controller) :imageURL == null?
      CustomText(text: messageBody,): showImage(imageURL),
    );
  }

  displayNews(){
    print("mapIsNewsGenerated : $mapIsNewsGenerated");
    print("mapIsNewsGenerated[newsId] : ${mapIsNewsGenerated[newsId]}");
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
        GeolocationServiceState().launchMapsUrl(latitude, longitude);
      },
    );
  }

  showVideo(String videoURL, VideoPlayerController controller){
    try{
      return
        CustomVideoPlayer(videoURL: videoURL);
    }
    catch (e){
      return Icon(Icons.image);}
  }

  showImage(String imageURL){
    try{
      return
        DisplayPicture().chatPictureFrame(imageURL);
    }
    catch (e){
      return Icon(Icons.image);}
  }

}
