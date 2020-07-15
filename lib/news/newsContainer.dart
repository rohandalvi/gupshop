import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/widgets/customText.dart';

class NewsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 250,
      child: Card(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText(text :'Title'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText(text :'Link'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText(text :'News Introooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo'),
              ),
            ],
          ),
      ),
    );
  }
}
