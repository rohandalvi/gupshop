import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:gupshop/bazaarCategory/subCategorySearch.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarSubCategorySearch.dart';
import 'package:gupshop/chat_list_page/chatListCache.dart';
import 'package:gupshop/home/home.dart';
import 'package:gupshop/home/homeAppLock.dart';
import 'package:gupshop/individualChat/individual_chat.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/navigators/AddressListRoute.dart';
import 'package:gupshop/navigators/BazaarOnBoardingProfileRoute.dart';
import 'package:gupshop/navigators/bazaarAdvertisementRoute.dart';
import 'package:gupshop/navigators/bazaarLocationRoute.dart';
import 'package:gupshop/navigators/bazaarOnBoradingHomeRoute.dart';
import 'package:gupshop/navigators/bazaarSubCategorySearchRoute.dart';
import 'package:gupshop/navigators/bazaarWelcomeRoute.dart';
import 'package:gupshop/onboarding/helper.dart';
import 'package:gupshop/passcode/customAppLock.dart';
import 'package:gupshop/responsive/navigatorConfig.dart';
import 'package:gupshop/responsive/sizeConfig.dart';
import 'package:gupshop/onboarding/welcomeScreen.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/passcode/unlockPasscode.dart';
import 'package:gupshop/responsive/textConfig.dart';

import 'bazaarOnBoarding/bazaarAdvertisement.dart';
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
                NavigatorConfig.home : (context){return homeRoute(context);},
                NavigatorConfig.individualChat : (context){return individualChatRoute(context);},
                NavigatorConfig.subCategorySearch : (context){return subCategorySearchRoute(context);},
                NavigatorConfig.bazaarAdvertisement : (context){return BazaarAdvertisementRoute.main(context);},
                NavigatorConfig.addressList : (context){return AddressListRoute.main(context);},
                NavigatorConfig.bazaarLocation : (context){return BazaarLocationRoute.main(context);},
                NavigatorConfig.bazaarOnBoardingHome : (context){return BazaarOnBoardingHomeRoute.main(context);},
                NavigatorConfig.bazaarOnBoardingProfile : (context){return BazaarOnBoardingProfileRoute.main(context);},
                NavigatorConfig.bazaarSubCategorySearch : (context){return BazaarSubCategorySearchRoute.main(context);},
                NavigatorConfig.bazaarWelcome : (context){return BazaarWelcomeRoute.main(context);},
              },
              debugShowCheckedModeBanner: false,
              home:WelcomeScreen(lockEnabled: enabled,)
            );
          }
        );
      }
    );
  }


  /// routes
  Widget homeRoute(BuildContext context){
    Map<String,String> map = ModalRoute.of(context).settings.arguments;
    String userPhoneNo = map[TextConfig.userPhoneNo];
    String userName = map[TextConfig.userName];
    return Home(userPhoneNo: userPhoneNo,userName: userName);
  }

  Widget individualChatRoute(BuildContext context){
    Map<String,dynamic> map = ModalRoute.of(context).settings.arguments;

    Map<String, ChatListCache> chatListCache = map[TextConfig.chatListCache];
    String myName = map[TextConfig.userName];
    String myNumber = map[TextConfig.userPhoneNo];
    String friendName = map[TextConfig.friendName];
    String conversationId = map[TextConfig.conversationId];
    List<dynamic> friendNumberList = map[TextConfig.friendNumberList];
    bool notAGroupMemberAnymore = map[TextConfig.notAGroupMemberAnymore];
    bool groupDeleted = map[TextConfig.groupDeleted];
    String imageURL = map[TextConfig.imageURL];
    var forwardMessage =  map[TextConfig.forwardMessage];
//    bool groupExists = map[TextConfig.groupExists];
//    String friendNumber= map[TextConfig.friendNumber];
//    List<dynamic> memberList= map[TextConfig.memberList];
//    String lastMessage= map[TextConfig.lastMessage];
//    bool lastMessageIsImage= map[TextConfig.lastMessageIsImage];
//    String conversationsLatestMessageId= map[TextConfig.conversationsLatestMessageId];
//    double radius= map[TextConfig.radius];
//    double innerRadius= map[TextConfig.innerRadius];

    return IndividualChat(
      chatListCache: chatListCache,
      friendName: friendName,
      conversationId: conversationId,
      userName: myName,
      userPhoneNo: myNumber,
      listOfFriendNumbers: friendNumberList,
      notGroupMemberAnymore: notAGroupMemberAnymore,
      groupDeleted: groupDeleted,
      imageURL: imageURL,
      forwardMessage: forwardMessage,
    );
  }

  Widget subCategorySearchRoute(BuildContext context){
    Map<String,dynamic> map = ModalRoute.of(context).settings.arguments;
    final String category = map[TextConfig.category];
    final String categoryData = map[TextConfig.categoryData];
    final Future<List<DocumentSnapshot>> subCategoriesListFuture = map[TextConfig.subCategoriesListFuture];
    final List<DocumentSnapshot> subCategoriesList= map[TextConfig.subCategoriesList];
    Map<String, String> subCategoryMap= map[TextConfig.subCategoryMap];
    final String bazaarWalaName= map[TextConfig.bazaarWalaName];
    final String bazaarWalaPhoneNo = map[TextConfig.bazaarWalaPhoneNo];


    return SubCategorySearch(
      bazaarWalaPhoneNo: bazaarWalaPhoneNo,
      bazaarWalaName: bazaarWalaName,
      subCategoriesListFuture: subCategoriesListFuture,
      subCategoryMap: subCategoryMap,
      subCategoriesList: subCategoriesList,
      categoryData: categoryData,
      category: category,
    );
  }
}
