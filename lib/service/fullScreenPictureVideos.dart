import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/displayPicture.dart';

class FullScreenPictureAndVideos extends StatelessWidget {
  bool isPicture;
  String payLoad;
  bool shouldZoom;

  FullScreenPictureAndVideos({this.isPicture, this.payLoad , this.shouldZoom});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: CustomAppBar(onPressed:(){
           Navigator.pop(context);
        },),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: isPicture ?
        DisplayPicture().pictureFrame(payLoad) :
        Container(
          height: MediaQuery.of(context).size.height,
          child: DisplayPicture().videoFullFrame(payLoad,shouldZoom),
        ),
      ),
    );
  }
}
