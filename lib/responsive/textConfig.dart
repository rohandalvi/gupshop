import 'package:gupshop/responsive/sizeConfig.dart';

class TextConfig{
  static int textFormFieldLimitTwentyFive = 25;
  static int textFormFieldLimitFifteen = 15;
  static int textFormFieldLimitHundred = 100;
  static int textFormFieldLimitOneFifty = 150;

  static double standardFontSize = SizeConfig.textMultiplier * 2;/// 16
  static double bigFontSize = SizeConfig.textMultiplier * 2.5;
  static double fontSizeTwelve = SizeConfig.textMultiplier * 1.47;/// 12/8.16

  /// bazaar:
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
  static String bazaarChangeNameTextTitle = "Add name to your business";
  static String bazaarChangeNameTextSubtitle = "Try keeping the same name for your business throughout, to help the customer identify you";
  static String bazaarChangeNameTextfieldLabel = 'Enter your business name';
  static String bazaarChangeNameFlushbarMessage = "Please enter a name";
  static String bazaarWriteReview = 'Please write your review';

  /// nameScreen :
  static const String enterName = "Enter your Name";


  /// images
  static const String editImage = 'Edit picture';

  /// flushbar:
  static const String showFlushbarStopHandMessage = "Please enter your name to move forward";

  /// trace
  static const String homeTrace = 'home';
  static const String homeHit = 'home_hit';
  static const String userHomeAddress = 'userHomeAddress';
  static const String userHomeAddressUpdated = 'userHomeAdressUpdated';
  static const String groupMemberDeleted = 'groupMemberDeleted';
  static const String newUserRegistered = 'newUserRegistered';
  static const String cachedAvatar = 'cachedAvatar';
  static const String cachedAvatarHit = 'cachedAvatar_Hit';
  static const String nonCachedAvatarHit = 'nonCachedAvatar_Hit';
  static const String profilePictureView = 'profilePictureView';
  static const String myProfilePictureView = 'myProfilePictureView';
  static const String bazaarCategory = 'BazaarCategory';
  static const String bazaarSubCategory = 'BazaarSubCategory';

  /// for plus options in individual chat
  static const String pickGalleryImage = 'Pick image from  Gallery';
  static const String pickCameraImage = 'Click image from Camera';
  static const String pickGalleryVideo = 'Pick video from Gallery';
  static const String pickCameraVideo = 'Record video from Camera';
  static const String currentLocation = 'Send Current Location';


}