import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/widgets/customText.dart';

class HomeServicePrompt extends StatelessWidget {
  final String text;

  HomeServicePrompt({this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          body: Center(
            child: CustomText(text: text,).welcome(),
          )
      ),
    );
  }
}