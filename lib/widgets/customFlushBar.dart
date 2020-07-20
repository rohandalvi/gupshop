import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomFlushBar extends StatelessWidget {
  final Widget text;
  final BuildContext contextual;

  CustomFlushBar({this.text, this.contextual});

  @override
  Widget build(context) {
    return Flushbar( /// for the flushBar if the user enters wrong verification code
      icon: SvgPicture.asset(
        'images/stopHand.svg',
        width: 30,
        height: 30,
      ),
      backgroundColor: Colors.white,
      duration: Duration(seconds: 5),
      forwardAnimationCurve: Curves.decelerate,
      reverseAnimationCurve: Curves.easeOut,
      titleText: text,
      message: "Please enter your name to move forward",
    )..show(contextual);
  }

  showFlushBar(){
    return Flushbar( /// for the flushBar if the user enters wrong verification code
      icon: SvgPicture.asset(
        'images/stopHand.svg',
        width: 30,
        height: 30,
      ),
      backgroundColor: Colors.white,
      duration: Duration(seconds: 5),
      forwardAnimationCurve: Curves.decelerate,
      reverseAnimationCurve: Curves.easeOut,
      titleText: text,
      message: "Please enter your name to move forward",
    )..show(contextual);
  }
}
