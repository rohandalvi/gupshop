import 'package:flutter/cupertino.dart';
import 'package:gupshop/widgets/customIconButton.dart';

class PlusButton extends StatelessWidget {
  final VoidCallback onRadiusPlus;

  PlusButton({this.onRadiusPlus});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomIconButton(
        iconNameInImageFolder: 'add',
        onPressed: onRadiusPlus,
      ),
    );
  }
}
