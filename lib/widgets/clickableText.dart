import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/widgets/customText.dart';

class ClickableText extends StatelessWidget {
  final String text;
  final GestureTapCallback onTap;
  final Widget textWidget;

  ClickableText({@required this.text, @required this.onTap, this.textWidget});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: CustomText(text: text,),
      onTap: onTap
    );
  }

  customText(){
    return InkWell(
        child: textWidget,
        onTap: onTap
    );
  }
}
