import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/image/displayPicture.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/image/displayCircularPicture.dart';
import 'package:gupshop/widgets/customVideoPlayer.dart';

class FullScreenPictureAndVideos extends StatelessWidget {
  bool isPicture;
  String payLoad;
  bool shouldZoom;

  FullScreenPictureAndVideos({this.isPicture, this.payLoad , this.shouldZoom});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(WidgetConfig.appBarSeventy),
        child: CustomAppBar(onPressed:(){
           Navigator.pop(context);
        },),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: isPicture ?
        Container(
          width: MediaQuery.of(context).size.height,
          height: MediaQuery.of(context).size.width,
            child: DisplayPicture(imageURL: payLoad,).zoom(context),
            //child : DisplayPicture(imageURL: payLoad,).zoomableFullScreen(context)
        ):
        //DisplayCircularPicture().pictureFrame(payLoad) :
        Container(
          height: MediaQuery.of(context).size.height,
          child: CustomVideoPlayer(videoURL: payLoad,),
        ),
      ),
    );
  }

  noAppBar(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: isPicture ?
        Container(
          width: MediaQuery.of(context).size.height,
          height: MediaQuery.of(context).size.width,
          child: DisplayPicture(imageURL: payLoad,).zoom(context),
          //child : DisplayPicture(imageURL: payLoad,).zoomableFullScreen(context)
        ):
        //DisplayCircularPicture().pictureFrame(payLoad) :
        Container(
          height: MediaQuery.of(context).size.height,
          child: DisplayCircularPicture().videoFullFrame(payLoad,shouldZoom),
        ),
      ),
    );
  }
}
