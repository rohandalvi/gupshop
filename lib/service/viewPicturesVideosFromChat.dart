import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/displayPicture.dart';

class ViewPicturesVideosFromChat extends StatelessWidget {
  bool isPicture;
  String payLoad;

  ViewPicturesVideosFromChat({this.isPicture, this.payLoad });

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
        DisplayPicture().videoFrame(payLoad, 400, 400),
      ),
    );
  }
}
