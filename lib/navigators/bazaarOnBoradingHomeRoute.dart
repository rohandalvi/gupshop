import 'package:flutter/cupertino.dart';
import 'package:gupshop/bazaarOnBoarding/onBoardingHome.dart';
import 'package:gupshop/responsive/textConfig.dart';

class BazaarOnBoardingHomeRoute{

  static Widget main(BuildContext context){
    Map<String,dynamic> map = ModalRoute.of(context).settings.arguments;
    final String text = map[TextConfig.text];

    return OnBoardingHome(
      text: text,
    );
  }
}