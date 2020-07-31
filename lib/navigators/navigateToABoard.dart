import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/savedMessages/displaySavedMessages.dart';

class NavigateToABoard{
  String boardName;

  NavigateToABoard({this.boardName});

  navigate(BuildContext context){
    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisplaySavedMessages(boardName: boardName,),//pass Name() here and pass Home()in name_screen
          )
      );
    };
  }
}