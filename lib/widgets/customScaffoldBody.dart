import 'package:flutter/cupertino.dart';

class CustomScaffoldBody extends StatelessWidget {
  Widget body;

  CustomScaffoldBody({this.body});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: body,
    );
  }
}
