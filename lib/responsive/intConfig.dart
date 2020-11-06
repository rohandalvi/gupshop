import 'package:gupshop/responsive/sizeConfig.dart';

class IntConfig{
  /// widthMultiplier : 4.32

  static int textFormFieldLimitTwentyFive = 25;
  static int textFormFieldLimitFifteen = 15;
  static int textFormFieldLimitHundred = 100;
  static int textFormFieldLimitOneFifty = 150;

  /// location :
//  static const int precision = 7;
//  static double radiusUpperLimit = SizeConfig.widthMultiplier *11574.0740741;/// 50000/4.32
//  static double radiusLowerLimit = SizeConfig.widthMultiplier *115.740740741;/// 500/4.32
//  static double radius = SizeConfig.widthMultiplier *69.4444444444;/// 300/4.32
//  static double radiusChange= SizeConfig.widthMultiplier *23.1481481481;/// 100/4.32
//  static double zoomChange= 0.05;
//      ///SizeConfig.widthMultiplier *0.01157407407;/// 0.05/4.32
//  static const double radiusForUsers = 1;
//  static double zoom= 15;
//      //SizeConfig.widthMultiplier * 3.47222222222 ;/// 15/4.32
//  static double zoomLimit= SizeConfig.widthMultiplier * 2.25694444444 ;/// 9.75/4.32
//  static double radiusHitsScreenFrom= SizeConfig.widthMultiplier * 6944.44444444 ;/// 30000/4.32
//  static double radiusHitsScreenTo= SizeConfig.widthMultiplier * 7175.92592593 ;/// 31000/4.32
//  static double radiusHitsAgainScreenFrom= SizeConfig.widthMultiplier * 8958.33333333 ;/// 38700/4.32
//  static double radiusHitsAgainScreenTo= SizeConfig.widthMultiplier * 9050.92592593 ;/// 39100/4.32

  static const int precision = 7;
  static double radiusUpperLimit = 50000;/// 50000/4.32
  static double radiusLowerLimit = 500;/// 500/4.32
  static double radius = 300;/// 300/4.32
  static double radiusChange= 100;/// 100/4.32
  static double zoomChange= 0.05;
  static const double radiusForUsers = 1;
  static double zoom= 15;
  static double zoomLimit= 9.75 ;/// 9.75/4.32
  static double radiusHitsScreenFrom= 30000 ;/// 30000/4.32
  static double radiusHitsScreenTo= 31000 ;/// 31000/4.32
  static double radiusHitsAgainScreenFrom= 38700 ;/// 38700/4.32
  static double radiusHitsAgainScreenTo= 39100 ;/// 39100/4.32

  /// friends collection
  static int nameOne = 0;

  /// passcode
  static int latencyThirty = 30;
}