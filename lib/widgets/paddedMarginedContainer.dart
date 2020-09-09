import 'package:flutter/cupertino.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/responsive/paddingConfig.dart';

class PaddedMarginedContainer extends StatelessWidget {
  final Widget child;
  final Color color;

  PaddedMarginedContainer({this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color == null ?fainterGray : color,
      padding: EdgeInsets.all(PaddingConfig.thirty),
      margin: EdgeInsets.all(PaddingConfig.thirty),
      child: child
    );
  }
}
