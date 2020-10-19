import 'package:gupshop/notifications/application/notifier.dart';

class NotificationSingleton{
  static final NotificationSingleton _singleton = NotificationSingleton._internal();
  factory NotificationSingleton() => _singleton;

  Notifier notifier = new Notifier();

  NotificationSingleton._internal() {
    notifier.registerNotification();
  }

  static NotificationSingleton get shared => _singleton;

  Notifier getNotifierObject(){
    return notifier;
  }
}