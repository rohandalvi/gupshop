import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/individualChat/individualChatCache.dart';
import 'package:gupshop/links/fetchLinkPreview.dart';
import 'package:gupshop/links/linkDIsplayUIData.dart';
import 'package:gupshop/links/openLinks.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/placeholders/imagePlaceholder.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customText.dart';

class NewsContainerUI extends StatelessWidget {
  String title;
  String link;
  String newsBody;

  String linkTitle;
  String linkDescription;
  String linkImage;
  Map<String, IndividualChatCache> individualChatCache;
  String messageId;
  IndividualChatCache cache = new IndividualChatCache();

  NewsContainerUI({this.title, this.link, this.newsBody, this.individualChatCache, this.messageId, this.cache});

  @override
  Widget build(BuildContext context) {
    return Container(
//      height: 250,
      width: MediaQuery.of(context).size.width * 0.7,
      //290,
      child: Card(
//          elevation: 0,
//          shape: RoundedRectangleBorder(
//            borderRadius: new BorderRadius.circular(5.0),
//            side: BorderSide(color : Colors.black),
//          ),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CustomIconButton(iconNameInImageFolder: 'news',onPressed: (){},),
                  CustomText(text: 'NEWS',textColor: primaryColor,),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(PaddingConfig.eight),
                child: CustomText(text :title).nonBoldText(),
              ),
              GestureDetector(
                child: newsCache() == false ? FutureBuilder(
                  future: FetchLinkPreviewData().fetch(link, linkTitle, linkDescription, linkImage),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      linkTitle = snapshot.data[0];/// FetchLinkPreviewData return a list with [0] as title
                      linkDescription = snapshot.data[1];/// [1] as description
                      linkImage = snapshot.data[2];/// [2] as image
                      /// Placeholder if image in URI is null
                      if(linkImage == null || linkImage == "") linkImage = ImagePlaceholder.newsImage;

                      link = snapshot.data[3];/// [3] as link
                      return LinkDisplayUI(link: link, title: linkTitle, description: linkDescription, image: linkImage, cache: cache,);
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ) : getCachedNews(),
                onTap: (){
                  OpenLinks().open(link);
                },
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(PaddingConfig.eight,
                    PaddingConfig.five,
                    PaddingConfig.eight,
                    PaddingConfig.three),
                child: CustomText(text :newsBody),
              ),
            ],
          ),
      ),
    );
  }

  newsCache(){
    if(individualChatCache == null) return false;
    return individualChatCache[messageId].newsLinkContainer != null ;
  }

  getCachedNews(){
    return individualChatCache[messageId].newsLinkContainer;
  }
}
