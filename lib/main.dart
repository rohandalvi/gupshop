import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:gupshop/config/app_config.dart';
import 'package:gupshop/home/homeAppLock.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/onboarding/helper.dart';
import 'package:gupshop/passcode/customAppLock.dart';
import 'package:gupshop/responsive/sizeConfig.dart';
import 'package:gupshop/onboarding/welcomeScreen.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/passcode/unlockPasscode.dart';
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

//void main() async{
//  WidgetsFlutterBinding.ensureInitialized();
//  bool enabled = await UserDetails().getPasscodeStatus();
//  runApp(MyApp(enabled: enabled,));
//}

void main() {
  print("No-op");
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
        var appTitle = AppConfig.of(context).appTitle;
        print("TITLE $appTitle");
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
              title: appTitle,
              debugShowCheckedModeBanner: false,
//              navigatorKey: _navigatorKey,
              home:WelcomeScreen(lockEnabled: enabled,)
//              HomeAppLock(enabled: enabled,),
              //WelcomeScreen(lockEnabled: enabled,),
              //UnlockPasscode(),
//              Builder(
//                builder: (context) {
//                  print("context in builder : $context");
//                  return
//                  AppLock(
//                    enabled: enabled,
//                    lockScreen: UnlockPasscode(navigatorKey: _navigatorKey,),
//                    builder: (args) {
////                      print("AppLock state MyApp: ${AppLock.of(context)}");
//                      return WelcomeScreen();
//                    },
//                  )
//                }
//              ),
            );
          }
        );
      }
    );
  }


//  Widget Function(Object) builder(args){
//    return WelcomeScreen();
//  }
//
//  void _didUnlockOnAppLaunch(Object args) {
//    this._didUnlockForAppLaunch = true;
////    this.widget.builder(ModalRoute.of(context).settings.arguments);
////    _navigatorKey.currentState.push(
//    Navigator.push(
//        context,
//        MaterialPageRoute(
//          builder: (context) => builder(ModalRoute.of(context).settings.arguments),//pass Name() here and pass Home()in name_screen
//        )
//    );
////    _navigatorKey.currentState
////        .pushReplacementNamed('/unlocked', arguments: args);
//  }
//
//  Widget get _lockScreen {
//    return WillPopScope(
//      child: UnlockPasscode(),
//      onWillPop: () => Future.value(false),
//    );
//  }
}
