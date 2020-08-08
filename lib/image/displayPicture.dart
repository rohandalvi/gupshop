import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/image/imageZoom.dart';

class DisplayPicture extends StatelessWidget {
  final String imageURL;

  DisplayPicture({this.imageURL});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height / 1.25,
        width: MediaQuery.of(context).size.width / 1.25,
        child: Image(
          image: NetworkImage(imageURL),
        )
    );
  }

  zoomableFullScreen(context){
    return Container(
      width: MediaQuery.of(context).size.height / 1.25,
      height: MediaQuery.of(context).size.width / 1.25,
      /// for zoom:
      child: new ImageZoom(
        new NetworkImage(imageURL),
        placeholder: Center(child: CircularProgressIndicator(),),
        //fit: BoxFit.contain,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
    );
  }

  chatPictureFrame(context){
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          width: MediaQuery.of(context).size.height / 2.9,
          height: MediaQuery.of(context).size.width / 2.5,
          child: Image(
            image: NetworkImage(imageURL),
            fit: BoxFit.cover,
          ),
          decoration: BoxDecoration(
            //shape: BoxShape.rectangle,
          ),
        ),
      ),
    );
  }
}
