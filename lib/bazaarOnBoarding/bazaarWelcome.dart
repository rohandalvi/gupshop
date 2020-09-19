import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaarOnBoarding/bottomButton.dart';
import 'package:gupshop/bazaarOnBoarding/welcomeContent.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/widgets/customAppBar.dart';

class BazaarWelcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(WidgetConfig.appBarSeventy),
        child: CustomAppBar(
          onPressed: (){
            Navigator.pop(context);
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
                child: WelcomeContent(),
              ),
            ),
            Expanded(
              flex: 1,
              child: BottomButton(),
            ),
          ],
        ),
      ),
    );
  }
}
