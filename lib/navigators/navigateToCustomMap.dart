import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/cutomMaps/customMap.dart';


class NavigateToCustomMap{
  final double latitude;
  final double longitude;
  final bool showRadius;
  final String placeholder;
  final bool showBackButton;

  NavigateToCustomMap({this.showRadius, this.latitude, this.longitude,
    this.placeholder, this.showBackButton});


  navigate(BuildContext context){
    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomMap(showRadius: showRadius,longitude: longitude,
            latitude: latitude, placeholder: placeholder, showBackButton: showBackButton,),
          )
      );
    };
  }

  navigateNoBrackets(BuildContext context) async{
    return await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CustomMap(showRadius: showRadius,longitude: longitude,
            latitude: latitude,placeholder: placeholder,showBackButton: showBackButton,),
        )
    );
  }
}