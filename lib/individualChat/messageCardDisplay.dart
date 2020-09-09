import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/individualChat/individualChatCache.dart';
import 'package:gupshop/individualChat/showImageDownloadFlushbar.dart';
import 'package:gupshop/individualChat/showVideoThumbnail.dart';
import 'package:gupshop/individualChat/textMessageUI.dart';
import 'package:gupshop/location/locationDisplayAndLaunchInMap.dart';
import 'package:gupshop/news/newsContainerUI.dart';
import 'package:gupshop/location/location_service.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/widgets/customRaisedButton.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:gupshop/widgets/customVideoPlayer.dart';
import 'package:gupshop/image/displayCircularPicture.dart';
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
  Map<String, IndividualChatCache> individualChatCache;
  String messageId;
  IndividualChatCache cache = new IndividualChatCache();


  MessageCardDisplay({this.isMe, this.isNews,this.newsTitle, this.newsLink,
    this.newsBody, this.isLocationMessage,this.fromName,this.latitude,
    this.longitude,this.controller, this.imageURL, this.videoURL, this.messageBody,
    this.newsId, this.mapIsNewsGenerated, this.individualChatCache, this.messageId,
  });

  @override
  Widget build(BuildContext context) {
    Container messageContainer =  Container(
//        width: MediaQuery.of(context).size.width*0.75,
//        height: MediaQuery.of(context).size.height*0.75,
      alignment: isMe? Alignment.centerRight: Alignment.centerLeft,///to align the messages at left and right
      padding: EdgeInsets.symmetric(horizontal: PaddingConfig.fifteen,
          vertical: PaddingConfig.three), ///for the box covering the text, when horizontal is increased, the photo size decreases
      child: isNews == true ? NewsContainerUI(title: newsTitle, link: newsLink,
          newsBody: newsBody, individualChatCache: individualChatCache,
          messageId: messageId, cache: cache) :
      isLocationMessage ==true ? LocationDisplayAndLaunchInMap(textOnButton:
      fromName, latitude: latitude,longitude: longitude, locationName: 'current location',):
      videoURL != null  ? ShowVideoThumbnail(videoURL: videoURL,cache: cache,)
          :imageURL == null?
      TextMessageUI(isMe: isMe, messageBody: messageBody,)
          : ShowImageDownloadFlushbar(imageURL: imageURL,)
    );

    addToCache(messageContainer);
    return messageContainer;
  }

  showVideo(String videoURL,){
    try{
      return Column(
        children: <Widget>[
          SizedBox(
            width: WidgetConfig.sizedBoxHeightTwoForty,
            height: WidgetConfig.sizedBoxHeightOneFifty,
            child: DisplayCircularPicture().videoFrame(videoURL),
          ),

        ],
      );
        //CustomVideoPlayer(videoURL: videoURL);
    }
    catch (e){
      return Icon(Icons.image);}
  }

  addToCache(Container messageContainer){
    cache.messageContainer = messageContainer;
    individualChatCache[messageId] = cache;
  }

}
