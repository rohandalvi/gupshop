import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/image/fullScreenPictureVideos.dart';


class NavigateToFullScreenPictureAndVideos{
  bool isPicture;
  String payLoad;
  bool shouldZoom;

  NavigateToFullScreenPictureAndVideos({this.isPicture, this.payLoad , this.shouldZoom});

  navigate(BuildContext context){
    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullScreenPictureAndVideos(
              isPicture: isPicture,
              payLoad: payLoad,
              shouldZoom: shouldZoom,
            ),
          )
      );
    };
  }

  navigateNoBrackets(BuildContext context) async{
    bool result =  await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullScreenPictureAndVideos(isPicture: isPicture,payLoad: payLoad,shouldZoom: shouldZoom,),
        )
    );

    return result;
  }
}