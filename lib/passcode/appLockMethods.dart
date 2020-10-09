import 'package:flutter/cupertino.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:gupshop/responsive/intConfig.dart';

class AppLockMethods{

  enableAppLock({BuildContext context}){
    /// From the given build context, return the nearest ancestor AppLock
    /// Go and find me the nearest AppLock to the given build context and
    /// then run enable method on it
    print("context in enableAppLock : ${context}");
    AppLock.of(context).enable();
  }

  disableAppLock({BuildContext context}){
    AppLock.of(context).disable();
    setEnabledFalse(context: context);
  }

  setEnabledTrue({BuildContext context}){
    AppLock.of(context).setEnabled(true);
  }

  setEnabledFalse({BuildContext context}){
    AppLock.of(context).setEnabled(false);
  }

  /// once a successful login has occured didUnlock should be called
  didUnlock({BuildContext context, bool unlock}){
    print("context in didUnlock : $context");
    AppLock.of(context).didUnlock(unlock);
  }

  /// app to be in the background for up to 30 seconds without requiring the
  /// lock screen to be shown.
  setBackgroundLatency(){
    return Duration(seconds: IntConfig.latencyThirty);
  }
}