import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisplayPicture extends StatelessWidget {
  ImageProvider image;
  double height;
  double width;

  DisplayPicture({@required this.image, @required this.height, @required this.width});


  /// ideal height width for full screen profile picture
  /// height: 370,
  /// width: 370,
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.all(8),
      height: height,
      width: width,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
      ),
      child:Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: image,
            fit: BoxFit.cover,
          ),
        ),
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
//      Container(
//      decoration: new BoxDecoration(
//        shape: BoxShape.circle,
//        image: new DecorationImage(
//          image: image,
//          fit: BoxFit.cover,
//          //new AssetImage('images/sampleProfilePicture.jpeg'),
//        ),
//      ),
//    );

//    Container(
//      margin: EdgeInsets.symmetric(vertical: 6),
//      //padding: EdgeInsets.all(8),
//      //height: height,
//      //width: width,
//      decoration: new BoxDecoration(
//        shape: BoxShape.circle,
//        color: Colors.black,
//      ),
//      child:Container(
//        decoration: BoxDecoration(
//          shape: BoxShape.circle,
//          image: DecorationImage(
//            image: image,
//            fit: BoxFit.cover,
//          ),
//        ),
//      ),
//    );
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