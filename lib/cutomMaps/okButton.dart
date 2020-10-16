import 'package:flutter/cupertino.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/widgets/customIconButton.dart';

class OkButton extends StatelessWidget {
  final VoidCallback onOkPressed;

  OkButton({this.onOkPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomIconButton(
        iconNameInImageFolder: IconConfig.tickMarkDark,
        onPressed: onOkPressed,
      ),
    );
  }
}