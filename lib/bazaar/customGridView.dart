import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/image/gridViewContainer.dart';
import 'package:gupshop/responsive/imageConfig.dart';
import 'package:gupshop/responsive/sizeConfig.dart';
import 'package:gupshop/widgets/customText.dart';

class CustomGridView extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  CustomGridView({this.itemCount, this.itemBuilder});


  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 2,///spaces between the boxes verically
          mainAxisSpacing: 2,///spaces between the boxes horizaontally
          //childAspectRatio: 0.9,///size of the box 1.3, 0.85
        ),
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      ),
    );
  }
}
