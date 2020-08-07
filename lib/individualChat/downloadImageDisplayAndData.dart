import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/image/displayCircularPicture.dart';
import 'package:gupshop/image/downloadImage.dart';
import 'package:gupshop/widgets/customIconButton.dart';

class DownloadImageDisplayAndData extends StatelessWidget {
  final String imageURL;

  DownloadImageDisplayAndData({this.imageURL});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        DisplayCircularPicture().chatPictureFrame(imageURL),
        CustomIconButton(
          onPressed: (){
            DownloadImage(imageURL: imageURL).download();
          },
          iconNameInImageFolder: 'download',
        ),
      ],
    );

  }
}
