import 'package:flutter/material.dart';
import 'package:gupshop/responsive/sizeConfig.dart';
import 'package:gupshop/onboarding/welcomeScreen.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/passcode/unlockPasscode.dart';
import 'package:passcode_screen/passcode_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("in MyApp");
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
              //UnlockPasscode(),
              WelcomeScreen(),
            );
          }
        );
      }
    );
  }
}
