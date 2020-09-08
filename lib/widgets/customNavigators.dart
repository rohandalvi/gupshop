import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gupshop/bazaar/bazaarHome_screen.dart';
import 'package:gupshop/news/newsComposer.dart';
import 'package:gupshop/bazaarCategory/bazaarIndividualCategoryListData.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarProfilePage.dart';
import 'package:gupshop/screens/changeProfilePicture.dart';
import 'package:gupshop/contactSearch/contactSearchPage.dart';
import 'package:gupshop/group/createGroupName_screen.dart';
import 'package:gupshop/home/home.dart';
import 'package:gupshop/individualChat/individual_chat.dart';
import 'package:gupshop/bazaar/productDetail.dart';
import 'package:gupshop/bazaar/selectCategoryToShowInProductDetailsPage.dart';
import 'package:gupshop/group/showGroupMembers.dart';
import 'package:gupshop/contactSearch/contact_search.dart';
import 'package:gupshop/group/createGroup.dart';

class CustomNavigator{
  navigateToHome(BuildContext context, String userName, String userPhoneNo){
    print("in naviagteToHome");
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(userName: userName,userPhoneNo: userPhoneNo,),//pass Name() here and pass Home()in name_screen
        )
    );
  }

  navigateToChangeProfilePicture(BuildContext context, String userName, bool viewingFriendsProfile, String userPhoneNo,
      String groupConversationId, String imageURL){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeProfilePicture(userName: userName, viewingFriendsProfile:viewingFriendsProfile,
            userPhoneNo: userPhoneNo, groupConversationId: groupConversationId, imageURL: imageURL,),//pass Name() here and pass Home()in name_screen
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
  String subCategoryData;
  String subCategory;


  NavigateToProductDetailsPage({this.productWalaName, this.productWalaNumber,
    this.category, this.subCategoryData, this.subCategory});

  navigate(BuildContext context){
    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetail(
              productWalaName: productWalaName,
              productWalaNumber: productWalaNumber,
              category: category,
              subCategoryData: subCategoryData,
              subCategory: subCategory,
            ),//pass Name() here and pass Home()in name_screen
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

class NavigateToIndividualChat{
  String conversationId;
  String userName;
  String userPhoneNo;
  String friendName;
  List<dynamic> listOfFriendsNumbers;
  var data;
  bool notGroupMemberAnymore;

  NavigateToIndividualChat({this.conversationId, this.userName, this.userPhoneNo, this.friendName, this.data, this.notGroupMemberAnymore, this.listOfFriendsNumbers});

  navigate(BuildContext context){
    print("in navigate NavigateToIndividualChat");
    return (){
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
    };
  }

  navigateNoBrackets(BuildContext context){
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