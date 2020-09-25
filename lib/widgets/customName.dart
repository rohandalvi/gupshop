import 'package:flutter/material.dart';
import 'package:gupshop/responsive/imageConfig.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:gupshop/widgets/customTextFormField.dart';


class CustomName extends StatelessWidget {
  final String userPhoneNo;
  String userName;
  String imageUrl;
  ValueChanged<String> nameOnChanged;
  ValueChanged<String> onNameSubmitted;
  final VoidCallback onNextPressed;
  String descriptionText;
  bool showDescription;
  bool showImage;


  CustomName({@required this.userPhoneNo, this.userName, this.imageUrl,
    this.nameOnChanged, this.onNameSubmitted, this.onNextPressed,
    this.descriptionText, this.showDescription, this.showImage
  });



  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String isName;

  @override
  Widget build(BuildContext context) {
    return WillPopScope( /// to not let the user go back from name_screen
      onWillPop: () async => false,/// a required for WillPopScope
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: ListView(//to remove renderflex overflow error
              shrinkWrap: true,
              children: <Widget>[
                imageOrTextContainer(),
                Container(
                  child: CustomTextFormField(
                    maxLength: 25, /// name length restricted to 25 letters
                    onChanged: nameOnChanged,
                    formKeyCustomText: formKey,
                    onFieldSubmitted: onNameSubmitted,
                    labelText: TextConfig.enterName,
                  ),
                  padding: EdgeInsets.only(left: PaddingConfig.twenty, top: PaddingConfig.thirtyFive, right: PaddingConfig.twenty),
                ),
                CustomIconButton(
                  iconNameInImageFolder: 'nextArrow',
                  onPressed: onNextPressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  imageOrTextContainer(){
    if(showImage == true) return displayNameBadge();
    if(showDescription == true) return showTextDescription();
  }


  displayNameBadge(){
    return Container(
      width: WidgetConfig.hundredWidth,
      height: WidgetConfig.hundredHeight,
      child:
      Image(
        image: AssetImage(ImageConfig.userDpPlaceholder),
      ),
    );
  }

  showTextDescription(){
    return Container(
      child: CustomText(text: descriptionText,),
    );
  }
}


///Vertically Center & Horizontal Center- Center components of a Listview in a scaffold
///Scaffold(
//  appBar: new AppBar(),
//  body: Center(
//    child: new ListView(
//      shrinkWrap: true,
//        padding: const EdgeInsets.all(20.0),
//        children: [
//          Center(child: new Text('ABC'))
//        ]
//    ),
//  ),
//);

///Only Vertical Center
///Scaffold(
//  appBar: new AppBar(),
//  body: Center(
//    child: new ListView(
//      shrinkWrap: true,
//        padding: const EdgeInsets.all(20.0),
//        children: [
//          new Text('ABC')
//        ]
//    ),
//  ),
//);