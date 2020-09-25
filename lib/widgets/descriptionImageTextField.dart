import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/navigators/navigateToHome.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customText.dart';

import 'customTextFormField.dart';

class DescriptionImageTextField extends StatelessWidget {
  final String bodyImage;
  final String bodyText;
  final String bottomText;
  final VoidCallback nextIconOnPressed;

  ValueChanged<String> nameOnChanged;
  ValueChanged<String> onNameSubmitted;
  final VoidCallback onNextPressed;

  DescriptionImageTextField({this.bodyImage, this.bodyText,
    this.nextIconOnPressed, this.bottomText,
    this.nameOnChanged, this.onNameSubmitted, this.onNextPressed,
  });

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

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
                text: TextConfig.bazaarOnboardingTitle,
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
                text: bodyText,
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
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          CustomText(text: bottomText),
          Container(
            child: CustomTextFormField(
              maxLength: 25, /// name length restricted to 25 letters
              onChanged: nameOnChanged,
              formKeyCustomText: formKey,
              onFieldSubmitted: onNameSubmitted,
              labelText: TextConfig.enterName,
            ),
            padding: EdgeInsets.only(left: PaddingConfig.twenty, top: PaddingConfig.thirtyFive, right: PaddingConfig.twenty),
          ),
          CustomIconButton(
            iconNameInImageFolder: 'nextArrow',
            onPressed: onNextPressed,
          ),
        ],
      ),
    );
  }
}

