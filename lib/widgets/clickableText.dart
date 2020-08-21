import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/widgets/customText.dart';

class ClickableText extends StatelessWidget {
  final String text;
  final GestureTapCallback onTap;
  ClickableText({@required this.text, @required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: CustomText(text: text,),
      onTap: onTap
    );
  }
}
