import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:gupshop/modules/userDetails.dart';
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

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("primaryColor in MyApp: ${Theme.of(context).primaryColor}");

    /// LayoutBuilder is a widget which provides the dimensions of its parent so
    /// we can know how much space we have for the widget and can build it our
    /// child accordingly
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return MaterialApp(
              theme: ThemeData(
                primaryColor: Colors.white,
                accentColor: subtitleGray,
              ),
              title: 'Chat home',
              debugShowCheckedModeBanner: false,
              home:
              //WelcomeScreen(),
              //UnlockPasscode(),
              AppLock(
                builder: (args) {
                  return WelcomeScreen();
                },
                lockScreen: UnlockPasscode(),
                enabled: true,
              ),
            );
          }
        );
      }
    );

//    return LayoutBuilder(
//        builder: (context, constraints) {
//          return OrientationBuilder(
//              builder: (context, orientation) {
//                SizeConfig().init(constraints, orientation);
//                return MaterialApp(
//                  theme: ThemeData(
//                    primaryColor: white,
//                    accentColor: subtitleGray,
//                  ),
//                  title: 'Chat home',
//                  debugShowCheckedModeBanner: false,
//                  home:
//                  WelcomeScreen(),
//                  //UnlockPasscode(),
//              AppLock(
//                builder: (args) {
//                  return WelcomeScreen();
//                },
//                lockScreen: UnlockPasscode(),
//                enabled: false,
//              ),
//                );
//              }
//          );
//        }
//    );
  }
}
