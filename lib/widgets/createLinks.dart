import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class CreateLinks extends StatelessWidget {
  String text;

  CreateLinks({this.text});

  @override
  Widget build(BuildContext context) {
    return Linkify(
      onOpen: (link) async{
        if(await canLaunch(link.url)){
          await launch(link.url);
        }else{
          throw "Could not launch $link";
        }
      },
      text:text,
      style: TextStyle(color: Colors.yellow),
      linkStyle: TextStyle(color: Colors.red),
    );
  }
}
