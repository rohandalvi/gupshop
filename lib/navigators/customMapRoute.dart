import 'package:flutter/cupertino.dart';
import 'package:gupshop/cutomMaps/customMap.dart';
import 'package:gupshop/responsive/textConfig.dart';

class CustomMapRoute{

  static Widget main(BuildContext context) {
    Map<String, dynamic> map = ModalRoute.of(context).settings.arguments;

    final double latitude=map[TextConfig.latitude];
    final double longitude=map[TextConfig.longitude];
    final bool showRadius=map[TextConfig.showRadius];
    final String placeholder=map[TextConfig.placeholder];
    final bool showBackButton=map[TextConfig.showBackButton];

    return CustomMap(
      showRadius: showRadius,
      longitude: longitude,
      latitude: latitude,
      placeholder: placeholder,
      showBackButton: showBackButton,
    );
  }

}