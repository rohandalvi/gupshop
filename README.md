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