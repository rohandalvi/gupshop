import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/links/fetchLinkPreview.dart';
import 'package:gupshop/links/linkDIsplayUIData.dart';
import 'package:gupshop/links/openLinks.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customRaisedButton.dart';
import 'package:gupshop/widgets/customText.dart';

class NewsContainerUI extends StatelessWidget {
  String title;
  String link;
  String newsBody;

  String linkTitle;
  String linkDescription;
  String linkImage;

  NewsContainerUI({this.title, this.link, this.newsBody});

  @override
  Widget build(BuildContext context) {
    return Container(
//      height: 250,
      width: 290,
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
                padding: const EdgeInsets.all(8.0),
                child: CustomText(text :title).nonBoldText(),
              ),
              GestureDetector(
                child: FutureBuilder(
                  future: FetchLinkPreviewData().fetch(link, linkTitle, linkDescription, linkImage),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      linkTitle = snapshot.data[0];/// FetchLinkPreviewData return a list with [0] as title
                      linkDescription = snapshot.data[1];/// [1] as description
                      linkImage = snapshot.data[2];/// [2] as image
                      link = snapshot.data[3];/// [3] as link
                      return LinkDisplayUI(link: link, title: linkTitle, description: linkDescription, image: linkImage,);
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
                onTap: (){
                  OpenLinks().open(link);
                },
              ),
//              Padding(
//                padding: const EdgeInsets.fromLTRB(8, 3, 8, 3),
//                child: GestureDetector(
//                    child: CustomText(text :link).hyperLink(),
//                    onTap: (){
//                      OpenLinks().open(link);
//                    },
//                ),
//              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 5, 8, 3),
                child: CustomText(text :newsBody),
              ),
            ],
          ),
      ),
    );
  }
}
