import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/navigators/navigateToHome.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customText.dart';

class DescriptionImage extends StatelessWidget {
  final String bodyImage;
  final String bodyTextTitle;
  final String bodyTextSubtitle;
  final String bottomText;
  final VoidCallback nextIconOnPressed;

  DescriptionImage({this.bodyImage, this.bodyTextTitle,
    this.bodyTextSubtitle,
    this.nextIconOnPressed, this.bottomText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(WidgetConfig.appBarSeventy),
        child: CustomAppBar(
            onPressed: (){
              NavigateToHome(initialIndex: 1).navigateNoBrackets(context);
            }
        ),
      ),
      backgroundColor: white,
      body: SafeArea(
        bottom: false,
        left: false,
        right: false,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Align(
                alignment: Alignment.center,
                child: bodyContent(),
              ),
            ),
            Expanded(
              flex: 1,
              child: bottomContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget bodyContent() {
    return Center(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: CustomText(
                text: bodyTextTitle,
                textAlign: TextAlign.center,
              ).welcome(),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: PaddingConfig.eight),
              child: Image.asset(
                bodyImage,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.topCenter,
              child: CustomText(
                text: bodyTextSubtitle,
                textAlign: TextAlign.center,
                textColor: subtitleGray,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomContent() {
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
              iconNameInImageFolder: 'forward2',),
          )
        ],
      ),
    );
  }
}

