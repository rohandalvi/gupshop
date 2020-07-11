import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gupshop/bazaar/bazaarHome_screen.dart';
import 'package:gupshop/screens/bazaarProfilePage.dart';
import 'package:gupshop/screens/changeProfilePicture.dart';
import 'package:gupshop/screens/contactSearchPage.dart';
import 'package:gupshop/screens/createGroupName_screen.dart';
import 'package:gupshop/screens/home.dart';
import 'package:gupshop/screens/individual_chat.dart';
import 'package:gupshop/bazaar/productDetail.dart';
import 'package:gupshop/bazaar/selectCategoryToShowInProductDetailsPage.dart';
import 'package:gupshop/screens/showGroupMembers.dart';
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

  navigateToChangeProfilePicture(BuildContext context, String userName, bool viewingFriendsProfile, String userPhoneNo, String groupConversationId){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeProfilePicture(userName: userName, viewingFriendsProfile:viewingFriendsProfile, userPhoneNo: userPhoneNo, groupConversationId: groupConversationId,),//pass Name() here and pass Home()in name_screen
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

  navigateToContactSearchPage(BuildContext context, String userName, String userPhoneNo, var data){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ContactSearchPage(userName: userName, userPhoneNo: userPhoneNo, data: data,),//pass Name() here and pass Home()in name_screen
        )
    );
  }

  navigateToIndividualChat(BuildContext context, String conversationId, String userName, String userPhoneNo, String friendName,List<dynamic> listOfFriendsNumbers,  var data, bool notGroupMemberAnymore ){
    print("listOfFriendsNumbers in navigateToIndividualChat: $listOfFriendsNumbers");
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
          notGroupMemberAnymore: notGroupMemberAnymore,
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

  navigateToCreateGroup(BuildContext context, String userName, String userPhoneNo, bool shouldAddNewGroupMember, String conversationId){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateGroup(userName: userName, userPhoneNo: userPhoneNo, shouldAddNewMemberToTheGroup: shouldAddNewGroupMember, conversationId: conversationId,),//pass Name() here and pass Home()in name_screen
        )
    );
  }

  navigateToShowGroupMembers(BuildContext context, String userNumber, List<dynamic> listOfGroupMemberNumbers){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShowGroupMembers(userNumber: userNumber, listOfGroupMemberNumbers: listOfGroupMemberNumbers,),//pass Name() here and pass Home()in name_screen
        )
    );
  }

  navigateToBazaarHomeScreen(BuildContext context, String userNumber,String userName ){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BazaarHomeScreen(userPhoneNo: userNumber, userName: userName,),//pass Name() here and pass Home()in name_screen
        )
    );
  }
}

class NavigateToProductDetailsPage{
  String productWalaName;
  String productWalaNumber;
  String category;


  NavigateToProductDetailsPage({this.productWalaName, this.productWalaNumber, this.category});

  navigate(BuildContext context){
    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetail(productWalaName: productWalaName, productWalaNumber: productWalaNumber,category: category,),//pass Name() here and pass Home()in name_screen
          )
      );
    };
  }
}

class NavigateToSelectCategoryToShowInProductDetailsPage{
  String productWalaName;
  String productWalaNumber;


  NavigateToSelectCategoryToShowInProductDetailsPage({this.productWalaName, this.productWalaNumber});

  navigate(BuildContext context){
    print("in navigate");
    print("username in navigate : $productWalaName");
    print("userNumber in navigate : $productWalaNumber");
    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectCategoryToShowInProductDetailsPage(productWalaName: productWalaName, productWalaNumber: productWalaNumber,),//pass Name() here and pass Home()in name_screen
          )
      );
    };
  }
}


class NavigateToBazaarProfilePage{
  String userName;
  String userPhoneNo;
  List<String> category;


  NavigateToBazaarProfilePage({this.userName, this.userPhoneNo});

  navigate(BuildContext context){
    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BazaarProfilePage(userPhoneNo: userPhoneNo, userName: userName,),//pass Name() here and pass Home()in name_screen
          )
      );
    };
  }
}

class NavigateToHome{
  String userName;
  String userPhoneNo;


  NavigateToHome({this.userName, this.userPhoneNo});

  navigate(BuildContext context){
    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(userPhoneNo: userPhoneNo, userName: userName,),//pass Name() here and pass Home()in name_screen
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