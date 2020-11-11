
import 'package:flutter_driver/flutter_driver.dart';
import 'package:screenshots/screenshots.dart';

import 'package:test/test.dart';

void main() async {
  group('Gupshup App', () {


    FlutterDriver driver;

    setUpAll(() async {

      driver = await FlutterDriver.connect();
    });
    
    tearDownAll(() async {
      await driver.close();
    });

    test('should take screenshot', () async {
      final config = Config();
      await screenshot(driver, config, 'first');

    });


  });
}