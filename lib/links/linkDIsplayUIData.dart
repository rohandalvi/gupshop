import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/individualChat/individualChatCache.dart';
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
    print("in non cache news");

    Container newsContainer =  Container(
      color: linkPreviewColor,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(image, height: 70, width: 70, fit: BoxFit.cover),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomText(text: title,).bold(),
                  SizedBox(height: 4,),
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
