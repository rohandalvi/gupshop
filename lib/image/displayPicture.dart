import 'package:flutter/cupertino.dart';

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
}
