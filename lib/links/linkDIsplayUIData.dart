import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/individualChat/individualChatCache.dart';
import 'package:gupshop/responsive/imageConfig.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/widgets/customText.dart';

class LinkDisplayUI extends StatelessWidget {
  String image;
  String title;
  String description;
  String link;
  IndividualChatCache cache = new IndividualChatCache();

  LinkDisplayUI({this.image, this.description, this.title, this.link, this.cache});

  @override
  Widget build(BuildContext context) {

    Container newsContainer =  Container(
      color: linkPreviewColor,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(PaddingConfig.eight),
            child: Image.network(image, height: ImageConfig.imageSeventy,
                width: ImageConfig.imageSeventy, fit: BoxFit.cover),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.all(PaddingConfig.eight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomText(text: title,).bold(),
                  SizedBox(height: WidgetConfig.sizedBoxHeightFour,),
//                  CustomText(text: description,).nonBoldText(),
//                  SizedBox(height: 4,),
                  CustomText(text: link,).graySubtitle(),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if(cache != null){
      cache.newsLinkContainer = newsContainer;
      cache.newsLink = link;
      cache.newsTitle = title;
      cache.newsBody = description;
    }


    return newsContainer;
  }
}
