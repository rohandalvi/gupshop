import 'package:flutter/cupertino.dart';
import 'package:gupshop/responsive/navigatorConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/widgets/customRaisedButton.dart';
import 'package:gupshop/widgets/customText.dart';

import 'customNavigators.dart';

class ShowMessageForFirstConversation{

  showRaisedButton(BuildContext context, String myName, String myNumber, var data){
    return CustomRaisedButton(
      child: CustomText(text: 'Click me to start a new conversation',),
      onPressed: (){
        Map<String,dynamic> navigatorMap = new Map();
        navigatorMap[TextConfig.userName] = myName;
        navigatorMap[TextConfig.userPhoneNo] = myNumber;
        navigatorMap[TextConfig.data] = data;

        Navigator.pushNamed(context, NavigatorConfig.contactSearch, arguments: navigatorMap);// i
        //CustomNavigator().navigateToContactSearch(context, myName, myNumber, data);
      }
    );
  }
}