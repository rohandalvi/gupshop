import 'package:flutter/material.dart';
import 'package:gupshop/modules/userDetails.dart';
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
import 'package:gupshop/navigators/navigatorMap.dart';
import 'package:gupshop/navigators/newsComposerRoute.dart';
import 'package:gupshop/navigators/productDetailPageRoute.dart';
import 'package:gupshop/navigators/subCategorySearchRoute.dart';
import 'package:gupshop/responsive/navigatorConfig.dart';
import 'package:gupshop/responsive/sizeConfig.dart';
import 'package:gupshop/onboarding/welcomeScreen.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'navigators/subCategoriesCheckBoxDataRoute.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  bool enabled = await UserDetails().getPasscodeStatus();
  runApp(MyApp(enabled: enabled,));
}

class MyApp extends StatelessWidget {
  final bool enabled;

  MyApp({this.enabled});



  @override
  Widget build(BuildContext context) {

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
              /// The application's top-level routing table.
              ///
              /// When a named route is pushed with [Navigator.pushNamed], the route name is
              /// looked up in this map. If the name is present, the associated
              /// [WidgetBuilder] is used to construct a [MaterialPageRoute] that performs
              /// an appropriate transition, including [Hero] animations, to the new route.
              routes: {
                NavigatorConfig.addressList : (context){return AddressListRoute.main(context);},
                NavigatorConfig.bazaarAdvertisement : (context){return BazaarAdvertisementRoute.main(context);},
                NavigatorConfig.bazaarIndividualCategoryListData : (context){return BazaarIndividualCategoryDataRoute.main(context);},
                NavigatorConfig.bazaarLocation : (context){return BazaarLocationRoute.main(context);},
                NavigatorConfig.bazaarOnBoardingProfile : (context){return BazaarOnBoardingProfileRoute.main(context);},
//                NavigatorConfig.bazaarOnBoardingHome : (context){return BazaarOnBoardingHomeRoute.main(context);},
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
