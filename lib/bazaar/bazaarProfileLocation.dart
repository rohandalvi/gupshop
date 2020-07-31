import 'package:flutter/cupertino.dart';
import 'package:gupshop/widgets/customBottomSheet.dart';
import 'package:gupshop/widgets/customIconButton.dart';

class BazaarProfileLocation extends StatelessWidget {
  final VoidCallback firstIconAndTextOnPressed;
  final VoidCallback secondIconAndTextOnPressed;

  BazaarProfileLocation({this.secondIconAndTextOnPressed, this.firstIconAndTextOnPressed});

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {
          return CustomIconButton(
            iconNameInImageFolder: 'locationPin',
            onPressed: (){
              CustomBottomSheet(
                customContext: context,
                firstIconName: 'home',
                firstIconText: 'Set current location as home location',
                firstIconAndTextOnPressed: firstIconAndTextOnPressed,
                secondIconName: 'locationPin',
                secondIconText: 'Set other location as home location',
                secondIconAndTextOnPressed: secondIconAndTextOnPressed,
              ).showTwo();
            },
          );
        }
    );
  }

}
