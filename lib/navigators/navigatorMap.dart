import 'package:flutter/cupertino.dart';
import 'package:gupshop/navigators/subCategoriesCheckBoxDataRoute.dart';
import 'package:gupshop/responsive/navigatorConfig.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/navigators/AddressListRoute.dart';
import 'package:gupshop/navigators/BazaarOnBoardingProfileRoute.dart';
import 'package:gupshop/navigators/bazaarAdvertisementRoute.dart';
import 'package:gupshop/navigators/bazaarIndividualCategoryDataRoute.dart';
import 'package:gupshop/navigators/bazaarLocationRoute.dart';
//import 'package:gupshop/navigators/bazaarOnBoradingHomeRoute.dart';
import 'package:gupshop/navigators/bazaarSubCategoriesCheckBoxRoute.dart';
import 'package:gupshop/navigators/bazaarSubCategorySearchRoute.dart';
import 'package:gupshop/navigators/bazaarWelcomeRoute.dart';
import 'package:gupshop/navigators/boardRoute.dart';
import 'package:gupshop/navigators/changeBazaarPicturesFetchAndDisplayRoute.dart';
import 'package:gupshop/navigators/changeNameRoute.dart';
import 'package:gupshop/navigators/changeProfilePictureRoute.dart';
import 'package:gupshop/navigators/contactSearch.dart';
import 'package:gupshop/navigators/contactSearchPageRoute.dart';
import 'package:gupshop/navigators/createGroupNameScreenRoute.dart';
import 'package:gupshop/navigators/createGroupRoute.dart';
import 'package:gupshop/navigators/customMapRoute.dart';
import 'package:gupshop/navigators/customVideoPlayerRoute.dart';
import 'package:gupshop/navigators/fullScreenPicturesAndVideosRoute.dart';
import 'package:gupshop/navigators/homeRoute.dart';
import 'package:gupshop/navigators/individualChatAppBarRoute.dart';
import 'package:gupshop/navigators/individualChatRoute.dart';
import 'package:gupshop/navigators/nameScreenRoute.dart';
import 'package:gupshop/navigators/newsComposerRoute.dart';
import 'package:gupshop/navigators/productDetailPageRoute.dart';
import 'package:gupshop/navigators/subCategorySearchRoute.dart';

class NavigatorMap{

  static final Map<String, WidgetBuilder> customRoutes = {
    NavigatorConfig.addressList : (context){return AddressListRoute.main(context);},
    NavigatorConfig.bazaarAdvertisement : (context){return BazaarAdvertisementRoute.main(context);},
    NavigatorConfig.bazaarIndividualCategoryListData : (context){return BazaarIndividualCategoryDataRoute.main(context);},
    NavigatorConfig.bazaarLocation : (context){return BazaarLocationRoute.main(context);},
    NavigatorConfig.bazaarOnBoardingProfile : (context){return BazaarOnBoardingProfileRoute.main(context);},
//    NavigatorConfig.bazaarOnBoardingHome : (context){return BazaarOnBoardingHomeRoute.main(context);},
    NavigatorConfig.bazaarSubCategoriesCheckBox : (context){return BazaarSubCategoriesCheckBoxRoute.main(context);},
    NavigatorConfig.bazaarSubCategorySearch : (context){return BazaarSubCategorySearchRoute.main(context);},
    NavigatorConfig.bazaarWelcome : (context){return BazaarWelcomeRoute.main(context);},
    NavigatorConfig.boardRoute : (context){return BoardRoute.main(context);},
    NavigatorConfig.changeBazaarPicturesFetchAndDisplay : (context){return ChangeBazaarPicturesFetchAndDisplayRoute.main(context);},
    NavigatorConfig.changeName : (context){return ChangeNameRoute.main(context);},
    NavigatorConfig.changeProfilePicture : (context){return ChangeProfilePictureRoute.main(context);},
    NavigatorConfig.contactSearch : (context){return ContactSearchRoute.main(context);},
    NavigatorConfig.contactSearchPage : (context){return ContactSearchPageRoute.main(context);},
    NavigatorConfig.createGroupNameScreen : (context){return CreateGroupNameScreenRoute.main(context);},
    NavigatorConfig.createGroup : (context){return CreateGroupRoute.main(context);},
    NavigatorConfig.customMap : (context){return CustomMapRoute.main(context);},
    NavigatorConfig.customVideoPlayer : (context){return CustomVideoPlayerRoute.main(context);},
    NavigatorConfig.fullScreenPicturesAndVideos : (context){return FullScreenPicturesAndVideosRoute.main(context);},
    NavigatorConfig.home : (context){return HomeRoute.main(context);},
    NavigatorConfig.individualChatAppBar : (context){return IndividualChatAppBarRoute.main(context);},
    NavigatorConfig.individualChat : (context){return IndividualChatRoute.main(context);},
    NavigatorConfig.nameScreen : (context){return NameScreenRoute.main(context);},
    NavigatorConfig.newsComposer : (context){return NewsComposerRoute.main(context);},
    NavigatorConfig.productDetailPage : (context){return ProductDetailPageRoute.main(context);},
    NavigatorConfig.subCategoriesCheckBoxDataRoute : (context){return SubCategoriesCheckBoxDataRoute.main(context);},
    NavigatorConfig.subCategorySearch : (context){return SubCategorySearchRoute.main(context);},
  };

}