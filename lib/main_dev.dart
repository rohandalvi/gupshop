
import 'package:flutter/cupertino.dart';
import 'package:gupshop/config/app_config.dart';
import 'package:gupshop/main.dart';

void main() {
  var configuredApp = AppConfig(
    appTitle: "Gupshup - Dev",
    buildFlavor: "Development",
    child: MyApp(enabled: false,),
  );
  return runApp(configuredApp);
}