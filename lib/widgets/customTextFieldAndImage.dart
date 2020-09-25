import 'package:flutter/cupertino.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customTextFormField.dart';

class CustomTextFieldAndImage extends StatelessWidget {
  final ValueChanged<String> nameOnChanged;
  final ValueChanged<String> onNameSubmitted;
  final VoidCallback onNextPressed;
  final String labelText;
  final String nextIcon;

  CustomTextFieldAndImage({this.onNextPressed, this.onNameSubmitted,
    this.nameOnChanged, this.labelText, this.nextIcon});

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Flexible(
            flex: 2,
            fit: FlexFit.loose,
            child: Container(
              child: CustomTextFormField(
                maxLength: TextConfig.textFormFieldLimitFifteen, /// 25 name length restricted to 25 letters
                onChanged: nameOnChanged,
                formKeyCustomText: formKey,
                onFieldSubmitted: onNameSubmitted,
                labelText: labelText,
              ),
              padding: EdgeInsets.only(left: PaddingConfig.fifteen,right: PaddingConfig.fifteen),
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: Container(
              child: CustomIconButton(
                iconNameInImageFolder: nextIcon == null ?IconConfig.forwardIcon : nextIcon,
                onPressed: onNextPressed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
