import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CountryCodeAndFlag extends StatelessWidget {
  final ValueChanged<CountryCode> onChanged;

  CountryCodeAndFlag({this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CountryCodePicker(
      initialSelection: 'IN',
      favorite: ['+1', '+91'],
      onChanged: onChanged,
    );
  }
}

