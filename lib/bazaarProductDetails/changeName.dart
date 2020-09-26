import 'package:flutter/cupertino.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/imageConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/widgets/WelcomeScreenWithTextField.dart';
import 'package:gupshop/widgets/customFlushBar.dart';

class ChangeName extends StatefulWidget {
  String businessName;

  ChangeName({this.businessName});

  @override
  _ChangeNameState createState() => _ChangeNameState();
}

class _ChangeNameState extends State<ChangeName> {
  String tempBusinessName;

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
      nameOnChanged: (val){
        widget.businessName = val;
      },
      onNextPressed: (){
        print("businessName : ${widget.businessName}");
        if(widget.businessName == null || widget.businessName == ""){
          CustomFlushBar(
            customContext: context,
            message: TextConfig.bazaarChangeNameFlushbarMessage,
          ).showFlushBarStopHand();
        }

        if(widget.businessName != null && widget.businessName != ""){
          print("widget.businessName in not null : ${widget.businessName}");
          Navigator.pop(context, widget.businessName);

          /// Add Trace :
          //OnBoardingTrace().createNewUser();
        }
      },
    );
  }
}
