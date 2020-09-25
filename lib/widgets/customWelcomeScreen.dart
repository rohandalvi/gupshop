import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/widgets/customAppBar.dart';


class CustomWelcomeScreen extends StatelessWidget {
  final int bodyFlex;
  final int bottomFlex;
  final Widget body;
  final Widget bottom;
  final VoidCallback onBackPressed;

  CustomWelcomeScreen({this.onBackPressed,this.bottomFlex,
    this.bodyFlex, this.body,this.bottom
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(WidgetConfig.appBarSeventy),
        child: CustomAppBar(
          onPressed: onBackPressed,
        ),
      ),
      backgroundColor: white,
      body: Column(
        children: <Widget>[
          Expanded(
            flex: bodyFlex == null ? 4 : bodyFlex,
            child: Align(
              alignment: Alignment.center,
              child: body
            ),
          ),
          Expanded(
            flex: bottomFlex == null ? 1 : bottomFlex,
            child: bottom
          ),
        ],
      ),
    );
  }
}

