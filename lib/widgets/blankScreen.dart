import 'package:flutter/cupertino.dart';
import 'package:gupshop/widgets/customText.dart';

class BlankScreen extends StatelessWidget {
  final String message;

  BlankScreen({this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: CustomText(text: message == null ? 'You are not a member anymore !' : message,),
      ),
    );
  }
}
