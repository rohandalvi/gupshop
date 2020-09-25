import 'package:gupshop/responsive/sizeConfig.dart';

class ImageConfig{

  /// storage images:
  static String photoFrame = "https://firebasestorage.googleapis.com/v0/b/gupshop-27dcc.appspot.com/o/photoFrame.png?alt=media&token=f98dca4e-71f4-46ad-90f3-dd9c3d4b7913";
  //"https://firebasestorage.googleapis.com/v0/b/gupshop-27dcc.appspot.com/o/pictureFrame.png?alt=media&token=d1167b50-9af6-4670-84aa-93ea4d55a8d3";
  static String bazaarWalaThumbnailPicture = "https://firebasestorage.googleapis.com/v0/b/gupshop-27dcc.appspot.com/o/bai4.jpg?alt=media&token=459a4e61-bf5b-470f-8e16-d5a8b5bf184b";
  static String gupShupIcon ="https://firebasestorage.googleapis.com/v0/b/gupshop-27dcc.appspot.com/o/gupShupLogo.png?alt=media&token=43951a70-1b0d-4c15-8497-8a81a6812a1d";
  static String newsImage = gupShupIcon;
  static String groupDpPlaceholderStorageImage = "https://firebasestorage.googleapis.com/v0/b/gupshop-27dcc.appspot.com/o/groupManWoman.png?alt=media&token=642a70fb-f47f-4f66-ba36-134a2e629b47";

  /// asset images:
  /// bazaar:
  static String bazaarOnBoardingWelcomeLogo = 'images/connect.png';
  static String bazaarOnBoardingLocationLogo = 'images/locationMobile.png';
  static String bazaarOnBoardingVideoLogo = 'images/onlineAd.png';
  static String bazaarChangeName = 'images/profileData.png';

  /// onBoarding:
  static String userDpPlaceholder = 'images/dpPlaceholderImage.png';
      //'images/user.png';
  /// group:
  static String groupDpPlaceholderImage = 'images/groupManWoman.png';


  /// imageSizeMultiplier = 4.32
  static double radius = SizeConfig.imageSizeMultiplier * 7;/// 30
  static double innerRadius = SizeConfig.imageSizeMultiplier * 6.8;///27

  static double smallRadius = SizeConfig.imageSizeMultiplier * 6;/// 25
  static double smallInnerRadius = SizeConfig.imageSizeMultiplier * 5.8;///23.5

  static double welcomeScreenChatBubble = SizeConfig.imageSizeMultiplier * 46.3; /// 200/4.32

  static double bazaarGridWidth = SizeConfig.widthMultiplier * 1.25;
  static double bazaarGridHeight = SizeConfig.heightMultiplier * 0.13;

  static double bazaarIndividualCategoryWidth = SizeConfig.widthMultiplier * 17;/// 75/4.32
  static double bazaarIndividualCategoryHeight = SizeConfig.heightMultiplier * 17;/// 75/4.32

  static double imageSeventy = SizeConfig.imageSizeMultiplier * 16.2;/// 75/4.32

  static double imageFourHundred = SizeConfig.imageSizeMultiplier * 92.6;/// 400/4.32

}
