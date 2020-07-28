import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircularContainer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Rs'),
      alignment: Alignment.center,
      width: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
