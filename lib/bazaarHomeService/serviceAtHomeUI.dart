import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/widgets/customText.dart';

class ServiceAtHome extends StatefulWidget {
  final String text;
  bool value = false;

  ServiceAtHome({this.text});

  @override
  _ServiceAtHomeState createState() => _ServiceAtHomeState();
}

class _ServiceAtHomeState extends State<ServiceAtHome> {

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: CustomText(text: widget.text,),
      value:widget.value,
      //inputs[index],
      //controlAffinity: ListTileControlAffinity.leading,
      onChanged: (bool val){
        setState(() {
          widget.value = val; /// setting the new value as selected by user
        });
      },
    );
  }
}
