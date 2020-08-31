import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/contactSearch/contact_search.dart';
import 'package:gupshop/widgets/customTextFormField.dart';

class LocationRadiusUI extends StatefulWidget {
  @override
  _LocationRadiusUIState createState() => _LocationRadiusUIState();
}

class _LocationRadiusUIState extends State<LocationRadiusUI> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      //margin: EdgeInsets.only(right: 300),
      padding: EdgeInsets.only(left: 15,right: 300),
      child: CustomTextFormField(
        labelText: "eg 5 (in km)",
        keyboardType: TextInputType.number,
        maxLength: 2,
        //expands: true,
      ),
    );
  }
}
