import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/widgets/colorPalette.dart';
import 'package:gupshop/widgets/customVideoPlayer.dart';
import 'dart:io';

import 'package:video_player/video_player.dart';

class DisplayPicture extends StatelessWidget {
  ImageProvider image;
  double height;
  double width;

  DisplayPicture({this.image, this.height, this.width});


  /// ideal height width for full screen profile picture
  /// height: 370,
  /// width: 370,
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.all(2),//controls the border
      height: height,
      width: width,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        color: ourBlack,
      ),
      child:
//        FadeInImage.assetNetwork(
//            //fit: BoxFit.cover ,
//            placeholder: 'images/kamwali.png',
//            image: "https://firebasestorage.googleapis.com/v0/b/gupshop-27dcc.appspot.com/o/%2B15857547599ProfilePicture?alt=media&token=0a4a79f5-7989-4e14-8927-7b4ca39af7d7",
//        )
      Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          image: DecorationImage(
            image: image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }


  chatPictureFrame(String imageURL){
    return Container(
        width: 240,
        height: 190,
        child: Image(
          image: NetworkImage(imageURL),
          fit: BoxFit.cover,
        ),
        decoration: BoxDecoration(
        //shape: BoxShape.rectangle,
    ),
    );
  }

  pictureFrame(String imageURL){
    return Container(
      width: 400,
      height: 400,
      child: Image(
        image: NetworkImage(imageURL),
        fit: BoxFit.contain,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
    );
  }

//  pictureFrameTwo(String videoURL, double width, double height){
//    return Container(
//      width: width,
//      height: height,
//      child: CustomVideoPlayer(videoURL: videoURL,),
//      //child: CustomVideoPlayer(videoURL: videoURL, width: width, height: height,),
//      decoration: BoxDecoration(
//        color: Colors.white,
//      ),
//    );
//  }

  videoFrame(String videoURL,double width, double height, bool shouldZoom){
    return Container(
      width: width,
      height: height,
      child: CustomVideoPlayer(videoURL: videoURL, shouldZoom: shouldZoom,),
      //child: CustomVideoPlayer(videoURL: videoURL, width: width, height: height,),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
    );
  }

  ///used for sideMenu, chatList, individualchat
  smallSizePicture(double radius){

    double border = radius + 5;
    return
      CircleAvatar(
        radius: (border),
        backgroundColor: Colors.black,
        child: CircleAvatar(
          radius: radius,
          backgroundImage: image,
        ),
      );
  }
}



///reference for MediaQuery.of(context).size.height / 1.25,
//                      height:
//                      MediaQuery.of(context).size.height / 1.25,
//                      width:
//                      MediaQuery.of(context).size.width / 1.25,
//                      child: Image(
//                        image: Image.network(snapshot.data),
//                      ),