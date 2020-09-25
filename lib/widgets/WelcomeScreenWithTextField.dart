import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customText.dart';

import 'customTextFormField.dart';

class WelcomeScreenWithTextField extends StatelessWidget {
  final String bodyImage;
  final String bodyTitleText;
  final String bodySubtitleText;
  final String bottomText;
  final VoidCallback nextIconOnPressed;
  String nextIcon;
  final VoidCallback onBackPressed;
  String labelText;

  ValueChanged<String> nameOnChanged;
  ValueChanged<String> onNameSubmitted;
  final VoidCallback onNextPressed;

  WelcomeScreenWithTextField({this.bodyImage, this.bodyTitleText,
    this.nextIconOnPressed, this.bottomText,this.bodySubtitleText,
    this.nameOnChanged, this.onNameSubmitted, this.onNextPressed,
    this.nextIcon,this.onBackPressed, this.labelText
  });

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(WidgetConfig.appBarSeventy),
        child: CustomAppBar(
            onPressed: onBackPressed,
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
              flex: 3,
              child: Align(
                alignment: Alignment.center,
                child: bodyContent(),
              ),
            ),
            Expanded(
              flex: 2,
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

  Widget bottomContent() {
    return Container(
      child: Column(
        children: <Widget>[
          Flexible(
            flex: 2,
            fit: FlexFit.loose,
            child: Container(
              child: CustomTextFormField(
                maxLength: TextConfig.textFormFieldLimitFifteen, /// 25 name length restricted to 25 letters
                onChanged: nameOnChanged,
                formKeyCustomText: formKey,
                onFieldSubmitted: onNameSubmitted,
                labelText: labelText,
              ),
              padding: EdgeInsets.only(left: PaddingConfig.fifteen,right: PaddingConfig.fifteen),
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: Container(
              child: CustomIconButton(
                iconNameInImageFolder: nextIcon == null ?IconConfig.forwardIcon : nextIcon,
                onPressed: onNextPressed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

