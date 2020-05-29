import 'package:flutter/cupertino.dart';

class CreateContainer extends StatelessWidget {

  CreateContainer({this.child, height, width});
  double height = 400;
  double width = 400;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: child,
    );
  }
}
