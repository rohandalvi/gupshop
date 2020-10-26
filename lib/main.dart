import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:gupshop/home/home.dart';
import 'package:gupshop/home/homeAppLock.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/onboarding/helper.dart';
import 'package:gupshop/passcode/customAppLock.dart';
import 'package:gupshop/responsive/navigatorConfig.dart';
import 'package:gupshop/responsive/sizeConfig.dart';
import 'package:gupshop/onboarding/welcomeScreen.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/passcode/unlockPasscode.dart';
import 'package:gupshop/responsive/textConfig.dart';
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
                NavigatorConfig.home : (context){return homeRoute(context);}
              },
              debugShowCheckedModeBanner: false,
              home:WelcomeScreen(lockEnabled: enabled,)
            );
          }
        );
      }
    );
  }

  Widget homeRoute(BuildContext context){
    Map<String,String> map = ModalRoute.of(context).settings.arguments;
    String userPhoneNo = map[TextConfig.userPhoneNo];
    String userName = map[TextConfig.userName];
    return Home(userPhoneNo: userPhoneNo,userName: userName);
  }
}
