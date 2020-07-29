import 'package:flutter/cupertino.dart';
import 'package:gupshop/bazaar/galleryAndCameraButtonsOnPressed.dart';

class TabOne extends StatelessWidget {
  String thumbnailPicture;

  TabOne({this.thumbnailPicture});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Image(
          image: NetworkImage(thumbnailPicture),
        ),
        GalleryAndCameraButtonsOnPressed(),
      ],
    );
  }
}
