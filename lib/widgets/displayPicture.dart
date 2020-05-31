import 'package:flutter/cupertino.dart';

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
    print("in displayPicture class");
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.all(6),
      height: height,
      width: width,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
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
}
