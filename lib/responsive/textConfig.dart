class TextConfig{
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


  /// passcode:
  static String passcodeCancel = 'Cancel';
  static String passcodeDelete = 'Delete';
  static String passcodeSave = 'Save';
  static String diableApplock = 'Disable App lock';
  /// unlockPasscode:
  static String enterAppPasscode = 'Enter App Passcode';
  static String changeAppPasscode = 'Change App Passcode';


  /// nameScreen :
  static const String enterName = "Enter your Name";


  /// images
  static const String editImage = 'Edit picture';

  /// flushbar:
  static const String showFlushbarStopHandMessage = "Please enter your name to move forward";
  static const String nameRequiredText= 'Name required';

  /// trace
  static const String chatListToIndividualChatTrace = 'chatListToIndividualChat';
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

  /// userDetails:
  static const String passcode = 'passcode';

  /// for plus options in individual chat
  static const String pickGalleryImage = 'Pick image from  Gallery';
  static const String pickCameraImage = 'Click image from Camera';
  static const String pickGalleryVideo = 'Pick video from Gallery';
  static const String pickCameraVideo = 'Record video from Camera';
  static const String currentLocation = 'Send Current Location';

  /// ======================================================================== ///

  /// classes ***************************************************************

  /// addressListData:
  static const String addressNameHome = "Home : ";
  static const String addressBook = "Address Book";

  /// ChangeLocationInSearch
  static const String changeLocationInSearchAddressName = "addressName";

  /// bazaarIndividualCategoryListData
  static const String showingResultsFor = 'Showing results for : ';
  static const String no = 'No ';
  static const String nearYou = ' near you';

  /// BazaarIndividualCategoryNameDpBuilder



  /// BazaarProfileSetVideo
  static const String tapToAddVideo = 'Tap to add video';

  /// subCategoriesCheckBox
  static const String speciality = 'What is your speciality ?';

  /// Notifications
  static const String notificationFromNumberIndividual = "notificationFromNumberIndividual";
  static const String notificationFromName = "notificationFromName";
  static const String notificationFromNumber = "notificationFromNumber";
  static const String notifierConversationId = "notifierConversationId";
  static const String messageBody = "messageBody";
  static const String type = "type";
  static const String IndividualChatType = "IndividualChat";
  static const String videoChatType = "VideoChat";
  static const String audioChatType = "AudioChat";
  static const String bazaarRatingAddedType = "bazaarRatingAdded";
  static const String notificationAndroid = "notification";
  static const String iosAps = "aps";
  static const String alert = "alert";
  static const String title = "title";
  static const String body = "body";
  static const String data = "data";


  /// ======================================================================== ///


  /// collection ***************************************************************
  static const String usersLocationCollectionName = 'usersLocation';
  static const String bazaarWalasLocationCollectionName= "bazaarWalasLocation";
  static const String usersCollectionName= "users";
  static const String recentChatsCollectionName= "recentChats";
  static const String profilePicturesCollectionName= "profilePictures";
  //static const String friendsCollectionName= "friends_$userPhoneNo";
  static String getFriendsCollectionName({String userPhoneNo}){
    return "friends_$userPhoneNo";
  }
  static const String conversationMetadataCollectionName = 'conversationMetadata';
  static const String bazaarCategoriesCollectionName = 'bazaarCategories';
  static const String bazaarRatingNumbersCollectionName = 'bazaarRatingNumbers';
  static const String bazaarReviewsCollectionName = 'bazaarReviews';
  static const String reviewsCollectionName = 'reviews';

  /// ======================================================================== ///

  /// database fieldNames ******************************************************

  /// usersLocationCollection
  static const String usersLocationCollectionGeoHashList = 'geoHashList';
  static const String usersLocationCollectionHome = 'home';
  static const String usersLocationCollectionAddress = 'address';
  static const String usersLocationCollectionGeoPoint = 'geoPoint';

  static const String bazaarWalasLocationCollectionGeoHashList = usersLocationCollectionGeoHashList;
  static const String conversationMetadataCollectionAdmin = 'admin';
  static const String conversationMetadataCollectionMembers = 'members';
  static const String conversationMetadataCollectionGroupName = 'groupName';


  /// friendsCollection
  static const String conversationId = 'conversationId';
  static const String nameList = 'nameList';
  static const String phone = 'phone';
  static const String groupName = 'groupName';
  static const String isMe = 'isMe';


  /// bazaarCategories
  static const String nameBazaarCategories = 'name';
  static const String subCategoriesBazaarCategories = 'subCategories';

  /// bazaarRatingNumbers
  static const String dislikesBazaarRatingNumbers = 'dislikes';
  static const String likesBazaarRatingNumbers = 'likes';

  /// bazaawalasBasicProfile
  static const String namebazaawalasBasicProfile = 'name';
  static const String thumbnailPicture = 'thumbnailPicture';
  static const String businessName = 'businessName';
  static const String homeService = 'homeService';

  /// recentChats:
  static const String conversationsRecentChats = 'conversations';
  static const String timeStampRecentChats = 'timeStamp';

  /// reviews:
  static const String timeStampReviews = 'timeStamp';

/// ======================================================================== ///
}