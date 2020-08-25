import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/responsive/imageConfig.dart';
import 'package:gupshop/responsive/sizeConfig.dart';
import 'package:gupshop/widgets/customText.dart';

class GridViewContainer extends StatelessWidget {
  final GestureTapCallback onPictureTap;
  final String imageURL;
  final String imageName;

  GridViewContainer({this.onPictureTap, this.imageURL, this.imageName});

  @override
  Widget build(BuildContext context) {
      return Container(
        width: SizeConfig.widthMultiplier,/// todo - required?
        height: SizeConfig.heightMultiplier,/// todo - required?
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: onPictureTap,
              child: Container(
              width: MediaQuery.of(context).size.width * 1.25,
              height: MediaQuery.of(context).size.height * 0.13,
//                width: ImageConfig.bazaarGridWidth,
//                height: ImageConfig.bazaarGridHeight,
                child: Image(
                  fit: BoxFit.cover,
                  image: NetworkImage(imageURL),
                ),
              ),
            ),
            Container(
                color: white,
                child: CustomText(text: imageName, fontWeight: FontWeight.bold,)
            ),
          ].toList(),
        )
      );
  }
}
