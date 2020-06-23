import 'package:flutter/material.dart';
import 'package:gupshop/screens/changeProfilePicture.dart';
import 'package:gupshop/screens/createGroupName_screen.dart';
import 'package:gupshop/screens/home.dart';
import 'package:gupshop/screens/individual_chat.dart';
import 'package:gupshop/service/contact_search.dart';
import 'package:gupshop/service/createGroup.dart';

class CustomNavigator{
  navigateToHome(BuildContext context, String userName, String userPhoneNo){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(userName: userName,userPhoneNo: userPhoneNo,),//pass Name() here and pass Home()in name_screen
        )
    );
  }

  navigateToChangeProfilePicture(BuildContext context, String userName, bool viewingFriendsProfile, String userPhoneNo){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeProfilePicture(userName: userName, viewingFriendsProfile:viewingFriendsProfile, userPhoneNo: userPhoneNo,),//pass Name() here and pass Home()in name_screen
        )
    );
  }

  navigateToContactSearch(BuildContext context, String userName, String userPhoneNo, var data){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ContactSearch(userName: userName, userPhoneNo: userPhoneNo, data: data,),//pass Name() here and pass Home()in name_screen
        )
    );
  }

  navigateToIndividualChat(BuildContext context, String conversationId, String userName, String userPhoneNo, String friendName,List<dynamic> listOfFriendsNumbers,  var data ){
    Navigator.push(
      context,
      MaterialPageRoute(//to send conversationId along with the navigator to the next page
        builder: (context) => IndividualChat(
          conversationId: conversationId,
          userPhoneNo: userPhoneNo,
          userName: userName,
          friendName:friendName,
          forwardMessage: data,
          listOfFriendNumbers: listOfFriendsNumbers,
        ),
      ),
    );
  }

  navigateToCreateGroupName_Screen(BuildContext context, String userName, String userPhoneNo, List<String> listOfNumbersInAGroup){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateGroupName_Screen(userName: userName, userPhoneNo: userPhoneNo, listOfNumbersInAGroup: listOfNumbersInAGroup,),//pass Name() here and pass Home()in name_screen
        )
    );
  }

  navigateToCreateGroup(BuildContext context, String userName, String userPhoneNo){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateGroup(userName: userName, userPhoneNo: userPhoneNo),//pass Name() here and pass Home()in name_screen
        )
    );
  }
}

//an If else in a navigation example:
///return Scaffold(
///        appBar: PreferredSize(
///         preferredSize: Size.fromHeight(70.0),
///           child: CustomAppBar(onPressed:(){
///              Navigator.pop(context);
///
///           if(viewingFriendsProfile == true){
///              Navigator.pop(context);
///            } else{
///              Navigator.push(
///                  context,
///                  MaterialPageRoute(
///                    builder: (context) => Home(userName: "Purva Dalvi",userPhoneNo: userPhoneNo,),//routing to home screen for now, but should be routed to sideMenu
///                  )
///              );
///            }
//           },),