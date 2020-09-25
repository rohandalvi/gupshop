import 'package:flutter/cupertino.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/widgets/customText.dart';

class CustomWelcomeBody extends StatelessWidget {
  final String bodyImage;
  final String bodyTitleText;
  final String bodySubtitleText;
  final String bottomText;

  CustomWelcomeBody({this.bodySubtitleText, this.bodyTitleText, this.bottomText,
    this.bodyImage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(left: PaddingConfig.five, right:PaddingConfig.five),
                child: CustomText(
                  text: bodyTitleText,
                  textAlign: TextAlign.center,
                ).welcome(),
              ),
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
              child: Padding(
                padding: EdgeInsets.only(left: PaddingConfig.fifteen,right: PaddingConfig.fifteen),
                child: CustomText(
                  text: bodySubtitleText,
                  textAlign: TextAlign.center,
                  textColor: subtitleGray,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
