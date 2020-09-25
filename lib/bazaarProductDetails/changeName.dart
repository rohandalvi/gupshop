import 'package:flutter/cupertino.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/imageConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/widgets/WelcomeScreenWithTextField.dart';

class ChangeName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WelcomeScreenWithTextField(
      onBackPressed: (){
        Navigator.pop(context);
      },
      labelText: TextConfig.bazaarChangeNameTextfieldLabel,
      bodyTitleText: TextConfig.bazaarChangeNameTextTitle,
      bodyImage: ImageConfig.bazaarChangeName,
      bodySubtitleText: TextConfig.bazaarChangeNameTextSubtitle,
      nextIcon: IconConfig.tickMarkIcon,
      nextIconOnPressed: (){},
    );
  }
}
