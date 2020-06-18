import 'package:flutter/cupertino.dart';
import 'package:gupshop/widgets/customRaisedButton.dart';
import 'package:gupshop/widgets/customText.dart';

import 'customNavigators.dart';

class ShowMessageForFirstConversation{

  showRaisedButton(BuildContext context, String myName, String myNumber, var data){
    return CustomRaisedButton(
      child: CustomText(text: 'Click me to start a new conversation',),
      onPressed: (){
        CustomNavigator().navigateToContactSearch(context, myName, myNumber, data);
      }
    );
  }
}