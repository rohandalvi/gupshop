import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gupshop/responsive/iconConfig.dart';

class CustomFlushBar extends StatelessWidget {
  final Widget text;
  final BuildContext customContext;
  final Duration duration;
  final String iconName;
  final String message;

  CustomFlushBar({this.text, this.customContext, this.duration, this.iconName, this.message});

  @override
  Widget build(context) {
    return Flushbar( /// for the flushBar if the user enters wrong verification code
      icon: SvgPicture.asset(
        'images/stopHand.svg',
        width: IconConfig.flushbarIconThirty,/// 30
        height: IconConfig.flushbarIconThirty,/// 30
      ),
      backgroundColor: Colors.white,
      duration: Duration(seconds: 5),
      forwardAnimationCurve: Curves.decelerate,
      reverseAnimationCurve: Curves.easeOut,
      titleText: text,
      message: "Please enter your name to move forward",
    )..show(customContext);
  }

  showFlushBarStopHand(){
    print("in showFlushBarStopHand");
    return Flushbar( /// for the flushBar if the user enters wrong verification code
      icon: SvgPicture.asset(
        'images/stopHand.svg',
        width: IconConfig.flushbarIconThirty,/// 30
        height: IconConfig.flushbarIconThirty,/// 30
      ),
      backgroundColor: Colors.white,
      duration: duration == null ? Duration(seconds: 5) : duration,
      forwardAnimationCurve: Curves.decelerate,
      reverseAnimationCurve: Curves.easeOut,
      titleText: text,
      flushbarStyle: FlushbarStyle.GROUNDED,
      message: "Please enter your name to move forward",
    )..show(customContext);
  }

  showFlushBar(){
    return Flushbar( /// for the flushBar if the user enters wrong verification code
      icon: SvgPicture.asset(
        'images/$iconName.svg',
        width: IconConfig.flushbarIconThirty,/// 30
        height: IconConfig.flushbarIconThirty,/// 30
      ),
      backgroundColor: Colors.white,
      duration: duration == null ? Duration(seconds: 5) : duration,
      forwardAnimationCurve: Curves.decelerate,
      reverseAnimationCurve: Curves.easeOut,
      titleText: text,
      message: message,
      flushbarStyle: FlushbarStyle.GROUNDED,
    )..show(customContext);
  }

  dismissible(){
    print("in dismissable flushbar");
    return Flushbar( /// for the flushBar if the user enters wrong verification code
      icon: SvgPicture.asset(
        'images/$iconName.svg',
        width: IconConfig.flushbarIconThirty,/// 30
        height: IconConfig.flushbarIconThirty,/// 30
      ),
      backgroundColor: Colors.white,
      duration: null,
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.decelerate,
      reverseAnimationCurve: Curves.easeOut,
      titleText: text,
      message: message,
      flushbarStyle: FlushbarStyle.GROUNDED,
    )..show(customContext);
  }
}
