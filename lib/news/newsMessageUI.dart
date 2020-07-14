import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewsMessageUI extends StatelessWidget {
  Widget title;
  Widget link;
  Widget newsDescription;

  NewsMessageUI({this.title, this.link, this.newsDescription});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
       shape: BoxShape.rectangle,
        border: Border(
        ),
      ),
      child: ListView(
        children: <Widget>[
          title,
          link,
          newsDescription,
        ],
      ),
    );
  }
}
