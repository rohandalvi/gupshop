import 'package:gupshop/responsive/sizeConfig.dart';

class TextConfig{
  static double standardFontSize = SizeConfig.textMultiplier * 2;/// 16
  static double bigFontSize = SizeConfig.textMultiplier * 2.5;
  static double fontSizeTwelve = SizeConfig.textMultiplier * 1.47;/// 12/8.16


  static String bazaarOnboardingTitle = 'Welcome to Bazaar Onboarding';
  static String bazaarOnboardingSubTitle = "Anyone can join"
      " our community to earn millions of customers";
  static String bazaarBottomButton = "Get started";
  static String bazaarOnBoardingQuestion = "What is your business ?";
  static String bazaarAdvertisementTitle = "Add your advertisement video :";
  static const String bazaarAdvertisementIntro = '''Advertisements are a great way 
  to attract users 
  and earn business''';
  static String bazaarLocationTitle = "Add your service location area";
  static const String bazaarLocationIntro = '''Service location enables  
  users find you effectively''';


  /// images
  static const String editImage = 'Edit picture';


  /// trace
  static const String homeTrace = 'home';
  static const String homeHit = 'home_hit';


  /// for plus options in individual chat
  static const String pickGalleryImage = 'Pick image from  Gallery';
  static const String pickCameraImage = 'Click image from Camera';
  static const String pickGalleryVideo = 'Pick video from Gallery';
  static const String pickCameraVideo = 'Record video from Camera';
  static const String currentLocation = 'Send Current Location';
}