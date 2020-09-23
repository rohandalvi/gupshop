import 'package:flutter/cupertino.dart';
import 'package:gupshop/responsive/sizeConfig.dart';

class WidgetConfig{
  /// heightMultiplier = 8.16
  /// widthMultiplier = 4.32
  static double buildMessageComposer = SizeConfig.heightMultiplier * 9;
  static double groupIconHeight = SizeConfig.heightMultiplier * 12.5;/// 100
  static double groupIconWidth = SizeConfig.widthMultiplier * 23.15;/// 100
  static double categoriesHeight = SizeConfig.heightMultiplier * 36.5; /// 300
  static double categoriesWidth = SizeConfig.widthMultiplier * 70; /// 300
  static double sliverHeight = SizeConfig.heightMultiplier * 32;/// 260/8.16
  static double productDetailImageHeight = SizeConfig.heightMultiplier * 30.5;/// 250/8.16
  static double reviewWidth = SizeConfig.widthMultiplier * 64.8; /// 280/4.32
  static double likeDislikeContainer = SizeConfig.widthMultiplier * 4.63; /// 20/4.32

  /// appBarHeight
  static double appBarSeventy = SizeConfig.heightMultiplier * 8.5;/// 70/8.16
  static double appBarSeventyTwo = SizeConfig.heightMultiplier * 8.82352941176;/// 72/8.16
  static double appBarOneTwenty = SizeConfig.heightMultiplier * 14.7058823529;/// 120/8.16

  /// sizedBox
  static double sizedBoxHeightThirty = SizeConfig.heightMultiplier * 3.8;/// 30/8.16
  static double sizedBoxHeightTwelve = SizeConfig.heightMultiplier * 1.5;/// 12/8.16
  static double sizedBoxHeightFour = SizeConfig.heightMultiplier * 0.5;/// 4
  static double sizedBoxHeightTen = SizeConfig.heightMultiplier * 1.25;/// 10/8.16
  static double sizedBoxHeightTwoForty = SizeConfig.heightMultiplier * 29.4;/// 240/8.16
  static double sizedBoxHeightOneFifty = SizeConfig.widthMultiplier * 34.7;/// 150/4.32
  static double sizedBoxWidthFiveHundred = SizeConfig.heightMultiplier * 115.740740741;/// 500/4.32
  static double sizedBoxHeightThreeHundred = SizeConfig.widthMultiplier * 36.7647058824;/// 300/8.16

  /// floatingActionButton
  static double floatingActionButtonBigHeight = SizeConfig.heightMultiplier * 12;/// 100/8.16
  static double floatingActionButtonBigWidth = SizeConfig.widthMultiplier * 23;/// 100/4.32
  static double floatingActionButtonSmallHeight = SizeConfig.heightMultiplier * 10;/// 80/8.16
  static double floatingActionButtonSmallWidth = SizeConfig.widthMultiplier * 18;/// 80/4.32

  /// fractional offset
  static double pointFive = SizeConfig.widthMultiplier/8.64;/// 4.32/8.64 = 0.5
  static double pointNinetyFive = SizeConfig.widthMultiplier/4.55;/// 4.32/4.55 = 0.95


  ///container
  static double seventyFiveWidth = SizeConfig.widthMultiplier * 17;/// 75/4.32
  static double seventyFiveHeight = SizeConfig.heightMultiplier * 9.19;/// 75/8.16
  static double hundredHeight = SizeConfig.heightMultiplier * 12;/// 100/8.16
  static double hundredWidth = SizeConfig.widthMultiplier * 23;/// 100/4.32
  static double twoFiftyWidth = SizeConfig.widthMultiplier * 46.2962962963;/// 200/4.32
  static double twoHundredWidth = SizeConfig.widthMultiplier * 57.8703703704;/// 250/4.32
  static double twoFiftyHeight = SizeConfig.widthMultiplier * 30.637254902;/// 250/8.16
  static double threeSixtyHeight = SizeConfig.heightMultiplier * 44;/// 360/8.16
  static double threeSixtyWidth = SizeConfig.widthMultiplier * 84;/// 360/4.32


  /// int values
  static int fiveHundredTwelveWidth = (SizeConfig.widthMultiplier * 118.518518519).toInt();/// 512/4.32
  static int fiveHundredTwelveHeight = (SizeConfig.widthMultiplier * 62.7450980392).toInt();/// 512/8.16



  /// flushbar
  static double flushbarBorderRadiusEight = SizeConfig.widthMultiplier * 1.85;/// 8/4.32

  /// aspectRatio
  static double aspectRatioOnePointSix = SizeConfig.widthMultiplier * 0.37037037037;/// 1.6/4.32

  /// BorderRadius
  static double borderRadiusFifteen = SizeConfig.widthMultiplier * 3.47;/// 15/4.32
  static double borderRadiusOne = SizeConfig.widthMultiplier * 0.23148148148;/// 1/4.32


  /// videoThumbnail
  getChatMessageWidth(BuildContext context){
    return MediaQuery.of(context).size.height / 2.9;
  }
  getChatMessageHeight(BuildContext context){
    return MediaQuery.of(context).size.width / 2.5;
  }
  getOnBoardingWidth(BuildContext context){
    return MediaQuery.of(context).size.height;
  }
  getOnBoradingHeight(BuildContext context){
    return MediaQuery.of(context).size.width;
  }
  getChatMessageOuterFrameWidth(BuildContext context){
    return MediaQuery.of(context).size.height / 2.75;
  }
  getChatMessageOuterFrameHeight(BuildContext context){
    return MediaQuery.of(context).size.width / 2.25;
  }
  getProductDetailImageContainerWidth(BuildContext context){
    return getChatMessageOuterFrameWidth(context);
  }
}