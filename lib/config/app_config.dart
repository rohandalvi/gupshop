import 'package:flutter/cupertino.dart';

class AppConfig extends InheritedWidget{
  AppConfig({this.appTitle, this.buildFlavor, this.child}){
    print("in appconfig");
  }

  static AppConfig of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }
  
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  final String appTitle;
  final String buildFlavor;
  final Widget child;




}