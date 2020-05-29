import 'package:flutter/material.dart';

class Display{

  appBar(BuildContext context){
    return AppBar(
      title: Material(
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}