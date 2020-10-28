import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:gupshop/bazaarCategory/subCategorySearch.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarSubCategorySearch.dart';
import 'package:gupshop/bazaarOnBoarding/subCategoryCheckBoxData.dart';
import 'package:gupshop/chat_list_page/chatListCache.dart';
import 'package:gupshop/home/home.dart';
import 'package:gupshop/home/homeAppLock.dart';
import 'package:gupshop/image/fullScreenPictureVideos.dart';
import 'package:gupshop/individualChat/individualChatAppBar.dart';
import 'package:gupshop/individualChat/individual_chat.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/navigators/AddressListRoute.dart';
import 'package:gupshop/navigators/BazaarOnBoardingProfileRoute.dart';
import 'package:gupshop/navigators/bazaarAdvertisementRoute.dart';
import 'package:gupshop/navigators/bazaarLocationRoute.dart';
import 'package:gupshop/navigators/bazaarOnBoradingHomeRoute.dart';
import 'package:gupshop/navigators/bazaarSubCategoriesCheckBoxRoute.dart';
import 'package:gupshop/navigators/bazaarSubCategorySearchRoute.dart';
import 'package:gupshop/navigators/bazaarWelcomeRoute.dart';
import 'package:gupshop/navigators/boardRoute.dart';
import 'package:gupshop/navigators/changeBazaarPicturesFetchAndDisplayRoute.dart';
import 'package:gupshop/navigators/changeProfilePictureRoute.dart';
import 'package:gupshop/navigators/customMapRoute.dart';
import 'package:gupshop/navigators/fullScreenPicturesAndVideosRoute.dart';
import 'package:gupshop/navigators/homeRoute.dart';
import 'package:gupshop/navigators/individualChatAppBarRoute.dart';
import 'package:gupshop/navigators/individualChatRoute.dart';
import 'package:gupshop/navigators/nameScreenRoute.dart';
import 'package:gupshop/navigators/productDetailPageRoute.dart';
import 'package:gupshop/navigators/subCategorySearchRoute.dart';
import 'package:gupshop/onboarding/helper.dart';
import 'package:gupshop/passcode/customAppLock.dart';
import 'package:gupshop/responsive/navigatorConfig.dart';
import 'package:gupshop/responsive/sizeConfig.dart';
import 'package:gupshop/onboarding/welcomeScreen.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/passcode/unlockPasscode.dart';
import 'package:gupshop/responsive/textConfig.dart';

import 'bazaarOnBoarding/bazaarAdvertisement.dart';
import 'navigators/subCategoriesCheckBoxDataRoute.dart';
//void main() async{
//  /// making sure that we can use shared_preferences without causing an
//  /// exception use WidgetsFlutterBinding.ensureInitialized()
//  WidgetsFlutterBinding.ensureInitialized();
//  bool enabled = await UserDetails().getPasscodeStatus();
//  runApp(LayoutBuilder(
//    builder: (context, constraints) {
//      return OrientationBuilder(
//        builder: (context, orientation) {
//          SizeConfig().init(constraints, orientation);
//          return MaterialApp(
//            theme: ThemeData(
//              primaryColor: white,
//              accentColor: subtitleGray,
//            ),
//            title: 'home',
//            debugShowCheckedModeBanner: false,
//            home: AppLock(
//              enabled: enabled,
//              lockScreen: UnlockPasscode(),
//              builder: (args) {
//                print("args : $args");
//                return MyApp();
//              },
//            ),
//          );
//        }
//      );
//    }
//  ));
//}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  bool enabled = await UserDetails().getPasscodeStatus();
  runApp(MyApp(enabled: enabled,));
}

class MyApp extends StatelessWidget {
  final bool enabled;

  MyApp({this.enabled});

  static final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();


  @override
  Widget build(BuildContext context) {
    print("enabled : $enabled");

    /// LayoutBuilder is a widget which provides the dimensions of its parent so
    /// we can know how much space we have for the widget and can build it our
    /// child accordingly
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            ///MaterialApp is a widget that introduces many interesting tools such
            /// as Navigator or Theme to help you develop your app.
            ///Material is, on the other hand, a widget used to define a UI
            ///element respecting Material rules. It defines what elevation is,
            ///shape, and stuff. Then reused by many material widgets such as
            ///Appbar or Card or FloatingButton.
            return MaterialApp(
              theme: ThemeData(
                primaryColor: Colors.white,
                accentColor: subtitleGray,
              ),
              title: 'Chat home',
              routes: {
                NavigatorConfig.addressList : (context){return AddressListRoute.main(context);},
                NavigatorConfig.bazaarAdvertisement : (context){return BazaarAdvertisementRoute.main(context);},
                NavigatorConfig.boardRoute : (context){return BoardRoute.main(context);},
                NavigatorConfig.bazaarLocation : (context){return BazaarLocationRoute.main(context);},
                NavigatorConfig.bazaarOnBoardingHome : (context){return BazaarOnBoardingHomeRoute.main(context);},
                NavigatorConfig.bazaarWelcome : (context){return BazaarWelcomeRoute.main(context);},
                NavigatorConfig.bazaarOnBoardingProfile : (context){return BazaarOnBoardingProfileRoute.main(context);},
                NavigatorConfig.bazaarSubCategorySearch : (context){return BazaarSubCategorySearchRoute.main(context);},
                NavigatorConfig.changeBazaarPicturesFetchAndDisplay : (context){return ChangeBazaarPicturesFetchAndDisplayRoute.main(context);},
                NavigatorConfig.changeName : (context){return BazaarSubCategorySearchRoute.main(context);},
                NavigatorConfig.changeProfilePicture : (context){return ChangeProfilePictureRoute.main(context);},
                NavigatorConfig.customMap : (context){return CustomMapRoute.main(context);},
                NavigatorConfig.fullScreenPicturesAndVideosRoute : (context){return FullScreenPicturesAndVideosRoute.main(context);},
                NavigatorConfig.home : (context){return HomeRoute.main(context);},
                NavigatorConfig.individualChat : (context){return IndividualChatRoute.main(context);},
                NavigatorConfig.individualChatAppBar : (context){return IndividualChatAppBarRoute.main(context);},
                NavigatorConfig.nameScreen : (context){return NameScreenRoute.main(context);},
                NavigatorConfig.productDetailPage : (context){return ProductDetailPageRoute.main(context);},
                NavigatorConfig.subCategorySearch : (context){return SubCategorySearchRoute.main(context);},
                NavigatorConfig.subCategoriesCheckBox : (context){return BazaarSubCategoriesCheckBoxRoute.main(context);},
                NavigatorConfig.subCategoriesCheckBoxDataRoute : (context){return SubCategoriesCheckBoxDataRoute.main(context);},
              },
              debugShowCheckedModeBanner: false,
              home:WelcomeScreen(lockEnabled: enabled,)
            );
          }
        );
      }
    );
  }
}
