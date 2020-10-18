//import 'dart:async';
//
//import 'package:flutter/material.dart';
//
///// A widget which handles app lifecycle events for showing and hiding a lock screen.
///// This should wrap around a `MyApp` widget (or equivalent).
/////
///// [lockScreen] is a [Widget] which should be a screen for handling login logic and
///// calling `AppLock.of(context).didUnlock();` upon a successful login.
/////
///// [builder] is a [Function] taking an [Object] as its argument and should return a
///// [Widget]. The [Object] argument is provided by the [lockScreen] calling
///// `AppLock.of(context).didUnlock();` with an argument. [Object] can then be injected
///// in to your `MyApp` widget (or equivalent).
/////
///// [enabled] determines wether or not the [lockScreen] should be shown on app launch
///// and subsequent app pauses. This can be changed later on using `AppLock.of(context).enable();`,
///// `AppLock.of(context).disable();` or the convenience method `AppLock.of(context).setEnabled(enabled);`
///// using a bool argument.
/////
///// [backgroundLockLatency] determines how much time is allowed to pass when
///// the app is in the background state before the [lockScreen] widget should be
///// shown upon returning. It defaults to instantly.
//class AppLock extends StatefulWidget {
//  final Widget Function(Object) builder;
//  final Widget lockScreen;
//  final bool enabled;
//  final Duration backgroundLockLatency;
//
//  const AppLock({
//    Key key,
//    @required this.builder,
//    @required this.lockScreen,
//    this.enabled = true,
//    this.backgroundLockLatency = const Duration(seconds: 0),
//  }) : super(key: key);
//
//  static _AppLockState of(BuildContext context) =>
//      context.findAncestorStateOfType<_AppLockState>();
////  static _AppLockState of(BuildContext context){
////    print("context in _AppLockState : ${AppLock.of(context)}");
////    print("context in findAncestorStateOfType : ${context.findAncestorStateOfType<_AppLockState>()}");
////
////    return context.findAncestorStateOfType<_AppLockState>();
////  }
//
//
//  @override
//  _AppLockState createState() => _AppLockState();
//}
//
//class _AppLockState extends State<AppLock> with WidgetsBindingObserver {
//  static final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();
//
//  bool _didUnlockForAppLaunch;
//  bool _isLocked;
//  bool _enabled;
//
//  Timer _backgroundLockLatencyTimer;
//  Map<String, WidgetBuilder> routes = new Map();
//
//  @override
//  void initState() {
//    WidgetsBinding.instance.addObserver(this);
//
//    this._didUnlockForAppLaunch = !this.widget.enabled;
//    this._isLocked = false;
//    this._enabled = this.widget.enabled;
//    print("enabled status : ${this._enabled}");
//
//    super.initState();
//  }
//
//  @override
//  void didChangeAppLifecycleState(AppLifecycleState state) {
//    print("in didChangeAppLifecycleState");
//    if (!this._enabled) {
//      print("in !this._enabled");
//      return;
//    }
//
//    if (state == AppLifecycleState.paused &&
//        (!this._isLocked && this._didUnlockForAppLaunch)) {
//      print("state : ${state}");
//      print("AppLifecycleState.paused : ${AppLifecycleState}");
//      this._backgroundLockLatencyTimer =
//          Timer(this.widget.backgroundLockLatency, () => this.showLockScreen());
//    }
//
//    if (state == AppLifecycleState.resumed) {
//      this._backgroundLockLatencyTimer?.cancel();
//    }
//
//    super.didChangeAppLifecycleState(state);
//  }
//
//  @override
//  void dispose() {
//    print("in dispose");
//    WidgetsBinding.instance.removeObserver(this);
//
//    this._backgroundLockLatencyTimer?.cancel();
//
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
////    return main();
//    //return this.widget.enabled ? this._lockScreen : this.widget.builder(null);
//    print("this.widget.enabled in build : ${this.widget.enabled}");
//    return MaterialApp(
//      home: this.widget.enabled ? this._lockScreen : this.widget.builder(null),
//      navigatorKey: _navigatorKey,
//      routes: {
//        '/lock-screen': (context) => this._lockScreen,
//        '/unlocked': (context) =>
//            this.widget.builder(ModalRoute.of(context).settings.arguments)
//      },
//    );
//  }
//
//  main(){
//    return Builder(
//        builder: (context){
//          return this.widget.enabled ? this._lockScreen : this.widget.builder(null);
//        }
//    );
//
//  }
//
//  Widget get _lockScreen {
//    return WillPopScope(
//      child: this.widget.lockScreen,
//      onWillPop: () => Future.value(false),
//    );
//  }
//
//  /// Causes `AppLock` to either pop the [lockScreen] if the app is already running
//  /// or instantiates widget returned from the [builder] method if the app is cold
//  /// launched.
//  ///
//  /// [args] is an optional argument which will get passed to the [builder] method
//  /// when built. Use this when you want to inject objects created from the
//  /// [lockScreen] in to the rest of your app so you can better guarantee that some
//  /// objects, services or databases are already instantiated before using them.
//  void didUnlock([Object args]) {
//    if (this._didUnlockForAppLaunch) {
//      this._didUnlockOnAppPaused();
//    } else {
//      this._didUnlockOnAppLaunch(args);
//    }
//  }
//
//  /// Makes sure that [AppLock] shows the [lockScreen] on subsequent app pauses if
//  /// [enabled] is true of makes sure it isn't shown on subsequent app pauses if
//  /// [enabled] is false.
//  ///
//  /// This is a convenience method for calling the [enable] or [disable] method based
//  /// on [enabled].
//  void setEnabled(bool enabled) {
//    if (enabled) {
//      this.enable();
//    } else {
//      this.disable();
//    }
//  }
//
//  /// Makes sure that [AppLock] shows the [lockScreen] on subsequent app pauses.
//  void enable() {
//    print("in enable appLock");
//    setState(() {
//      this._enabled = true;
//    });
//  }
//
//  /// Makes sure that [AppLock] doesn't show the [lockScreen] on subsequent app pauses.
//  void disable() {
//    setState(() {
//      this._enabled = false;
//    });
//  }
//
//  /// Manually show the [lockScreen].
//  Future<void> showLockScreen() {
//    this._isLocked = true;
//    print("in showLockScreen");
//    return _navigatorKey.currentState.pushNamed('/lock-screen');
//  }
//
//  void _didUnlockOnAppLaunch(Object args) {
//    this._didUnlockForAppLaunch = true;
////    this.widget.builder(ModalRoute.of(context).settings.arguments);
////    _navigatorKey.currentState.push(
//    Navigator.push(
//      context,
//        MaterialPageRoute(
//          builder: (context) => this.widget.builder(ModalRoute.of(context).settings.arguments),//pass Name() here and pass Home()in name_screen
//        )
//    );
////    _navigatorKey.currentState
////        .pushReplacementNamed('/unlocked', arguments: args);
//  }
//
//  void _didUnlockOnAppPaused() {
//    this._isLocked = false;
//    print("in _didUnlockOnAppPaused");
//    _navigatorKey.currentState.pop();
//  }
//}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:passcode_screen/passcode_screen.dart';

class CustomAppLock extends StatefulWidget {
//  final Widget otherScreen;
  final Widget lockScreen;
//  IsValidCallback isValidCallback;
  final Duration backgroundLockLatency;

  CustomAppLock({
    Key key,
//    @required this.otherScreen,
    @required this.lockScreen,
//    this.isValidCallback,
    this.backgroundLockLatency = const Duration(seconds: 0),
  }) : super(key: key);

  static _CustomAppLockState of(BuildContext context) =>
      context.findAncestorStateOfType<_CustomAppLockState>();

  @override
  _CustomAppLockState createState() => _CustomAppLockState();
}

class _CustomAppLockState extends State<CustomAppLock> with WidgetsBindingObserver {

  Timer _backgroundLockLatencyTimer;
  bool passcodeEnabled;
  bool _didUnlockForAppLaunch;

  isEnabled() async{
    bool temp = await UserDetails().getPasscodeStatus();
    setState(() {
      passcodeEnabled = temp;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    //isEnabled();

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    print("in didChangeAppLifecycleState");

    passcodeEnabled = await UserDetails().getPasscodeStatus();

    if (!passcodeEnabled) {
      print("in this._enabled");
      return;
    }

    if (passcodeEnabled && state == AppLifecycleState.paused
//        && this._didUnlockForAppLaunch
    ) {
      print("in if state : $AppLifecycleState");
      print("this._didUnlockForAppLaunch : ${this._didUnlockForAppLaunch}");
      this._backgroundLockLatencyTimer =
          Timer(this.widget.backgroundLockLatency, () => this.showLockScreen());
    }

    if (state == AppLifecycleState.resumed) {
      print("in showLockScreen");
      this._backgroundLockLatencyTimer?.cancel();
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    this._backgroundLockLatencyTimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserDetails().getPasscodeStatus(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.data == true){
            return Scaffold(
              body: this._lockScreen,
            );
          }
        }
        return CircularProgressIndicator();
      }
    );

  }

  Widget get _lockScreen {
    return WillPopScope(
      child: this.widget.lockScreen,
      onWillPop: () => Future.value(false),
    );
  }


  void didUnlock() {
//    return widget.didUnlock();

//    print("customContext in didUnlock : $unLocked");
//
//    if (this._didUnlockForAppLaunch) {
//      print("in didUnlock if");
//      this._didUnlockOnAppPaused();
//    } else {
//      print("in didUnlock else");
//      this._didUnlockOnAppLaunch();
//    }
  }


  showLockScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => _lockScreen,//pass Name() here and pass Home()in name_screen
        )
    );
//    return FutureBuilder(
//        future: UserDetails().getPasscodeStatus(),
//        builder: (context, snapshot) {
//          if(snapshot.connectionState == ConnectionState.done){
//            if(snapshot.data == true){
//              print("in showLockScreen method");
//              return Scaffold(
//                body: this._lockScreen,
//              );
////              Navigator.push(
////                  context,
////                  MaterialPageRoute(
////                    builder: (context) => _lockScreen,//pass Name() here and pass Home()in name_screen
////                  )
////              );
//            }
//          }
//          return CircularProgressIndicator();
//        }
//    );
  }

  _didUnlockOnAppLaunch() {
    this._didUnlockForAppLaunch = true;

    Navigator.pop(context);
  }


  void _didUnlockOnAppPaused() {
    Navigator.pop(context);

  }
}