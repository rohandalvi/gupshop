import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/responsive/sizeConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
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
        padding: EdgeInsets.all(PaddingConfig.sixteen),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(WidgetConfig.borderRadiusTen),
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: onPictureTap,
              child: Container(
              width: WidgetConfig().getGridViewImageWidth(context),
              height: WidgetConfig().getGridViewImageHeight(context),
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
