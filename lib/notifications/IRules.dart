import 'package:gupshop/notifications/NotificationEventType.dart';

abstract class IRules {
  bool apply(NotificationEventType notificationEventType, String conversationId);
}