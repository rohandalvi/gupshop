import 'package:flutter/cupertino.dart';
import 'package:gupshop/widgets/customIconButton.dart';

class ClickableIconButton extends StatefulWidget {
  final String iconName;
  final bool isSaved;

  ClickableIconButton({this.iconName, this.isSaved});

  @override
  _ClickableIconButtonState createState() => _ClickableIconButtonState();
}

class _ClickableIconButtonState extends State<ClickableIconButton> {
  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      iconNameInImageFolder: widget.iconName,
      onPressed: () {
        bool isClicked = widget.isSaved;
        if(isClicked == true){
          setState(() {
            isClicked = false;
          });
        } else setState(() {
          isClicked = true;
        });
      },
    );
  }
}
