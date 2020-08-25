import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaarOnBoarding/onBoardingCategoySelector.dart';
import 'package:gupshop/navigators/navigateToHome.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/customText.dart';

class OnBoardingHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(WidgetConfig.appBarBazaarOnBoarding),
        child: CustomAppBar(
          title: CustomText(text: 'What do you do ?',),
          onPressed:(){
            NavigateToHome(initialIndex: 1).navigateNoBrackets(context);
          },),
      ),
      body: Column(/// to avoid "ParentDataWidgets are providing parent data to the same RenderObject:" error
        children: <Widget>[
          SizedBox(height: WidgetConfig.sizedBoxBazaarOnBoarding,),
          OnBoardingCategorySelector(),
        ],
      ),
    );
  }
}
