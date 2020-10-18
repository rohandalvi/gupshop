import 'package:flutter/cupertino.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customText.dart';

class CustomWelcomeBottom extends StatelessWidget {
  final String bottomText;
  final VoidCallback nextIconOnPressed;

  CustomWelcomeBottom({this.bottomText, this.nextIconOnPressed});


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        //mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Flexible(
            flex: 2,
            //fit: FlexFit.loose,
            child: CustomText(text: bottomText),
          ),
          Flexible(
            flex: 1,
            //fit: FlexFit.loose,
            child: CustomIconButton(
              onPressed: nextIconOnPressed,
              iconNameInImageFolder: IconConfig.forward,),
          )
        ],
      ),
    );
  }
}
