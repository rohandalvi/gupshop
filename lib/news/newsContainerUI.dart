import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/widgets/colorPalette.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customRaisedButton.dart';
import 'package:gupshop/widgets/customText.dart';

class NewsContainerUI extends StatelessWidget {
  String title;
  String link;
  String newsBody;

  NewsContainerUI({this.title, this.link, this.newsBody});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 250,
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
                child: CustomText(text :title).bold(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 3, 8, 3),
                child: CustomText(text :link),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 3, 8, 3),
                child: CustomText(text :newsBody),
              ),
            ],
          ),
      ),
    );
  }
}
