import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/cutomMaps/customMap.dart';


class NavigateToCustomMap{
  final double latitude;
  final double longitude;
  final bool showRadius;
  final String placeholder;

  NavigateToCustomMap({this.showRadius, this.latitude, this.longitude,this.placeholder});


  navigate(BuildContext context){
    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomMap(showRadius: showRadius,longitude: longitude,
            latitude: latitude, placeholder: placeholder,),
          )
      );
    };
  }

  navigateNoBrackets(BuildContext context) async{
    print("lat in navigateNoBrackets : $latitude");
    return await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CustomMap(showRadius: showRadius,longitude: longitude,
            latitude: latitude,placeholder: placeholder,),
        )
    );
  }
}