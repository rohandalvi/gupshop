import 'package:flutter/cupertino.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/widgets/customIconButton.dart';

class GalleryCameraIconsDisplay extends StatelessWidget {
  final VoidCallback galleryIconOnPressed;
  final VoidCallback cameraIconOnPressed;

  GalleryCameraIconsDisplay({this.galleryIconOnPressed, this.cameraIconOnPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CustomIconButton(
          iconNameInImageFolder: IconConfig.photoGallery,
          onPressed: galleryIconOnPressed,
        ),

        CustomIconButton(
          iconNameInImageFolder: IconConfig.camera,
          onPressed: cameraIconOnPressed,
        ),
      ],
    );
  }
}
