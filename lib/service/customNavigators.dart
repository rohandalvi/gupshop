import 'package:flutter/material.dart';
import 'package:gupshop/screens/changeProfilePicture.dart';
import 'package:gupshop/screens/home.dart';

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