import 'package:flutter/cupertino.dart';
import 'package:gupshop/widgets/customText.dart';

class BlankScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: CustomText(text: 'You are not a member anymore !',),
      ),
    );
  }
}
