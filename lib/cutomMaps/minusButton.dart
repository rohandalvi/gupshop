import 'package:flutter/cupertino.dart';
import 'package:gupshop/widgets/clickableText.dart';
import 'package:gupshop/widgets/customIconButton.dart';

class MinusButton extends StatelessWidget {
  final VoidCallback onRadiusMinus;

  MinusButton({this.onRadiusMinus});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomIconButton(
        iconNameInImageFolder: 'minus',
        onPressed: onRadiusMinus,
      ),
    );
  }
}