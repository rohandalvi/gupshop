import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/navigators/navigateToBazaarOnBoardingHome.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customText.dart';

class BottomButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          CustomText(text: TextConfig.bazaarBottomButton,),
          CustomIconButton(
            onPressed: NavigateToBazaarOnBoardingHome().navigate(context),
            iconNameInImageFolder: 'forward2',)
        ],
      ),
    );
  }
}
