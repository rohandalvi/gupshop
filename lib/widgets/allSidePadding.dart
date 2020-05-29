import 'package:flutter/cupertino.dart';

class AllSidePadding extends StatelessWidget {
  double verticleHeight;

  AllSidePadding({this.child, @required this.verticleHeight});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.symmetric(vertical: verticleHeight),
      child: child,
    );
  }
}
