import 'package:flutter/cupertino.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/savedMessages/displaySavedMessages.dart';

class BoardRoute{


  static Widget main(BuildContext context){
    Map<String,dynamic> map = ModalRoute.of(context).settings.arguments;
    final String boardName = map[TextConfig.boardName];

    return DisplaySavedMessages(boardName: boardName,);
  }
}