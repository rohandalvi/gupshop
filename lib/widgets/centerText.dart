import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/widgets/blankScreen.dart';
import 'package:gupshop/widgets/customText.dart';

class CenterText extends StatelessWidget {
  final String message;

  CenterText({this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlankScreen(message: message,),
    );
  }
}
