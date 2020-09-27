# gupshop

The instant way to achieve all!

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

1. image_downloader plugin settings required to be made to ios

2. zoomable_image: ^1.3.1 # no seperate ios setting

3. dio # no seperate ios setting

4. photo_view: ^0.10.1 # no seperate ios setting

5. googleMaps :
<key>NSLocationWhenInUseUsageDescription</key>
    <string>Application needs to access your current location</string>
    <key>NSLocationAlwaysUsageDescription</key>
    <string>Application needs to access your current location</string>



Specify your API key in the application delegate ios/Runner/AppDelegate.m:

```
#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GMSServices provideAPIKey:@"YOUR KEY HERE"];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
@end

6. photo_view: ^0.10.1 # 20/8/20
7. great_circle_distance: ^1.0.1 # 25/8/20
8. google_maps_flutter: ^0.5.30 # 25/8/20
9. flutter_bloc: ^6.0.1 #25/8/20
10. search_map_place: ^0.3.0 # 27/8/20
11. gallery_saver: ^2.0.1
12. thumbnails: ^1.0.1 =  no seperate iOS settings
13. firebase_performance: ^0.4.0 # 22/9/20 No seperate iOS settings
```

## Using NotificationsManager

* Class can be found in - notifications/NotificationsManager.dart

### Description

NotificationsManager acts as a component to handle sending and receiving notifications. 

>Notification Behavior on Android/iOS: 

Message Type | App in Foreground | App in Background | App Terminated
------------ | ------------- | --------- | --------
Notification on Android | `onMessage` | Notification is delivered to system tray. When the user clicks on it to open app onResume fires if click_action: FLUTTER_NOTIFICATION_CLICK is set (see below). | Notification is delivered to system tray. When the user clicks on it to open app onLaunch fires if click_action: FLUTTER_NOTIFICATION_CLICK is set (see below).
Notification on iOS | `onMessage` | Notification is delivered to system tray. When the user clicks on it to open app `onResume` fires. | Notification is delivered to system tray. When the user clicks on it to open app `onLaunch` fires.
Data Message on Android | `onMessage` | `onMessage` while app stays in the background. | not supported by `firebase_messaging` plugin, message is lost.
Data Message on iOS | `onMessage` | Message is stored by FCM and delivered to app via `onMessage` when the app is brought back to foreground. | Message is stored by FCM and delivered to app via `onMessage` when the app is brought back to foreground.

> Sending a notification

Use `sendNotification` API to send a notification, the request is as follows:

1. `headers` - Headers passed as part of the http request. Caller is required to pass `Content-Type` , failure to pass throws Exception. The other required field `Authorization` is auto-appended to the header payload from within the API.

2. `notificationData` - This comprises of the details displayed in the notification-popup. This payload must contain both `body` and `title` , api throws exception otherwise.

3. `data` - This is the main payload that you wish to send as part of notification. This payload MUST include `type` which describes the `NotificationEventType`. This event type should be used for routing the notification to appropriate page in the `onMessage`, `onResume` and `onLaunch` handlers.

4. `to` - The FCM token belonging to recipient of this notification. This should be queried from firebase for the phone number of th user we are trying to send this notification to.     

This API is async and has `void` return type.
