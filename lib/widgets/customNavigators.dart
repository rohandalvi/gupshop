import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gupshop/bazaar/bazaarHome_screen.dart';
import 'package:gupshop/news/newsComposer.dart';
import 'package:gupshop/bazaarCategory/bazaarIndividualCategoryListData.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarProfilePage.dart';
import 'package:gupshop/image/changeProfilePicture.dart';
import 'package:gupshop/contactSearch/contactSearchPage.dart';
import 'package:gupshop/group/createGroupName_screen.dart';
import 'package:gupshop/home/home.dart';
import 'package:gupshop/individualChat/individual_chat.dart';
import 'package:gupshop/bazaarProductDetails/productDetail.dart';
import 'package:gupshop/bazaar/selectCategoryToShowInProductDetailsPage.dart';
import 'package:gupshop/group/showGroupMembers.dart';
import 'package:gupshop/contactSearch/contact_search.dart';
import 'package:gupshop/group/createGroup.dart';

class CustomNavigator {
}
class NavigateToNewsComposer{
  bool groupExits;
  String friendN;
  String userPhoneNo;
  String userName;
  List<dynamic> listOfFriendNumbers;
  String conversationId;
  String groupName;
  String value;
  TextEditingController controller;
  ScrollController listScrollController;

  NavigateToNewsComposer({
    this.groupExits,
    this.friendN,
    this.userPhoneNo,
    this.userName,
    this.listOfFriendNumbers,
    this.conversationId,
    this.groupName,
    this.value,
    this.controller,
    this.listScrollController,
  });

  navigate(BuildContext context){
    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsComposer(
              groupExits : groupExits,
              friendN : friendN,
              userPhoneNo : userPhoneNo,
              userName : userName,
              listOfFriendNumbers : listOfFriendNumbers,
              conversationId : conversationId,
              groupName : groupName,
              value : value,
              controller : controller,
              listScrollController : listScrollController,
            ),//pass Name() here and pass Home()in name_screen
          )
      );
    };
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