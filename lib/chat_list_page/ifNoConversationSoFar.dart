import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/widgets/showMessageForFirstConversation.dart';

class IfNoConversationSoFar extends StatelessWidget {
  final String myName;
  final String myNumber;

  IfNoConversationSoFar({this.myNumber, this.myName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ShowMessageForFirstConversation().showRaisedButton(context, myName, myNumber, null),
      ),
    );
  }
}
