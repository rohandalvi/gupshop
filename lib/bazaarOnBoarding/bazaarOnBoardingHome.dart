import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaarOnBoarding/categorySelector.dart';
import 'package:gupshop/responsive/navigatorConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/customText.dart';

class BazaarOnBoardingHome extends StatelessWidget {
  final String text;

  BazaarOnBoardingHome({this.text});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(WidgetConfig.appBarSeventy),
          child: CustomAppBar(
            title: CustomText(
              text: text == null ? TextConfig.bazaarOnBoardingQuestion : text,
            ),
            onPressed:(){
              Navigator.pushNamed(context, NavigatorConfig.bazaarWelcome);
              //NavigateToBazaarWelcome().navigateNoBrackets(context);
              //NavigateToHome(initialIndex: 1).navigateNoBrackets(context);
            },),
        ),
        body: Column(/// to avoid "ParentDataWidgets are providing parent data to the same RenderObject:" error
          children: <Widget>[
            SizedBox(height: WidgetConfig.sizedBoxHeightThirty,),
            CategorySelector(),
          ],
        ),
      ),
    );
  }
}