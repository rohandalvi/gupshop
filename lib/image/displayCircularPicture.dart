import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/responsive/imageConfig.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/widgets/customVideoPlayer.dart';
import 'package:gupshop/widgets/customVideoPlayerThumbnail.dart';


class DisplayCircularPicture extends StatelessWidget {
  ImageProvider image;
  double height;
  double width;

  DisplayCircularPicture({this.image, this.height, this.width});


  /// ideal height width for full screen profile picture
  /// height: 370,
  /// width: 370,
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: PaddingConfig.twenty),
      padding: EdgeInsets.all(PaddingConfig.two),//controls the border
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


//  chatPictureFrame(String imageURL, context){
//    return Card(
//      child: Padding(
//        padding: const EdgeInsets.all(3.0),
//        child: Container(
//          width: MediaQuery.of(context).size.height / 2.75,
//          height: MediaQuery.of(context).size.width / 2.25,
//            child: Image(
//              image: NetworkImage(imageURL),
//              fit: BoxFit.cover,
//            ),
//            decoration: BoxDecoration(
//            //shape: BoxShape.rectangle,
//        ),
//        ),
//      ),
//    );
//  }

  /// used in fullScreenPicture
  pictureFrame(String imageURL){
    return Container(
      width: ImageConfig.imageFourHundred,
      height: ImageConfig.imageFourHundred,
      /// for zoom:
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

  videoFrame(String videoURL){
    return
       Card(
          child: CustomVideoPlayerThumbnail(videoURL: videoURL,),
        );

  }

  videoFullFrame(String videoURL,bool shouldZoom){
    return
      CustomVideoPlayer(videoURL: videoURL);

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