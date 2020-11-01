import 'package:flutter/cupertino.dart';
import 'package:gupshop/config/app_config.dart';
import 'package:gupshop/main.dart';

void main() {
  var configuredApp = AppConfig(
    appTitle: "Gupshup",
    buildFlavor: "Development",
    child: MyApp(),
  );
  return runApp(configuredApp);
}