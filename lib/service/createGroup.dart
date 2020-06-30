import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/service/addNewGroupMember.dart';
import 'package:gupshop/service/contact_search.dart';
import 'package:gupshop/widgets/colorPalette.dart';
import 'package:gupshop/widgets/customFloatingActionButton.dart';
import 'package:gupshop/widgets/customRaisedButton.dart';
import 'package:gupshop/widgets/customText.dart';

import 'customNavigators.dart';

class CreateGroup extends StatefulWidget {
  String userPhoneNo;
  String userName;
  bool shouldAddNewMemberToTheGroup;
  String conversationId;///required for adding new member to the group

  CreateGroup({@required this.userPhoneNo, @required this.userName,this.shouldAddNewMemberToTheGroup, this.conversationId});

  @override
  _CreateGroupState createState() => _CreateGroupState(userPhoneNo:userPhoneNo, userName:userName, shouldAddNewMemberToTheGroup: shouldAddNewMemberToTheGroup, conversationId:conversationId);
}

/// Flow:
/// We get the contact list form contactSearch widget created by us which is
/// also used for contact_search.
///
/// If there is even one contact selected then the create group iconButton appears


class _CreateGroupState extends State<CreateGroup> {
  String userPhoneNo;
  String userName;
  bool shouldAddNewMemberToTheGroup;
  String conversationId;

  _CreateGroupState({@required this.userPhoneNo, @required this.userName,this.shouldAddNewMemberToTheGroup, this.conversationId});
  /// a map to store the state of contacts and their numbers, i.e the contacts which are
  /// selected would show as true, and not as false.
  Map<String, bool > map = new HashMap();

  List<String> listOfNumbersInAGroup = new List();
  Set tempSet = new HashSet();

  getCategorySizeFuture() async{
    QuerySnapshot querySnapshot = await Firestore.instance.collection("friends_$userPhoneNo").getDocuments();
    if(querySnapshot == null) return CircularProgressIndicator();//to avoid red screen(error)

    Map mapOfDocumentSnapshots = querySnapshot.documents.asMap();

    /// initializing 'map' with false values
    mapOfDocumentSnapshots.forEach((key, value) {
      var temp = mapOfDocumentSnapshots[key].data["phone"];
      var number =  temp[0];///would work even in groups because group will have conversationId in their "phone"
      map.putIfAbsent(number, () => false);
    });
  }


  @override
  void initState() {
    getCategorySizeFuture();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        contactList(context),
        showButton(), /// would show only if one or more contact is selected
      ],
    );
  }

  /// ContactSearch is using friends collection
  /// name is displayed from that list.
  ///
  contactList(BuildContext context){
    return ContactSearch(
      createGroupSearch: true,
      userName: userName,
      userPhoneNo: userPhoneNo,
      data: null,
      onItemFound: (DocumentSnapshot doc, int index){
        return Container(
          child: CheckboxListTile(
//            secondary: map[doc.data["nameList"][0]] == true ?IconButton(
//                icon: SvgPicture.asset('images/done.svg',)
//            ) : null,
            controlAffinity:ListTileControlAffinity.leading ,
            title: CustomText(text: doc.data["nameList"][0]) == null ? CustomText(text: 'loading',):CustomText(text: doc.data["nameList"][0]),
            activeColor: primaryColor,
            value: map[doc.data["phone"][0]],/// if value of a key in map(a phonenumber) is false or true
            //list[index],/// at first all the values would be false
            onChanged: (bool val){
              setState(() {
                map[doc.data["phone"][0]] = val; /// setting the new value as selected by user
              });
            },
          ),
        );
        //title: CustomText(text: doc.data["nameList"][0]),
      },
    );
  }


  showButton(){
    return Visibility(
      visible: shouldAddNewMemberToTheGroup == false ? isNameSelected() : shouldAddNewMemberToTheGroup,/// if there is even contact selected, the group icon would show
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 100,/// to increase the size of floatingActionButton use container along with FittedBox
            width: 100,
            child: FittedBox(
              child: CustomFloatingActionButton(
                tooltip: 'Create a new Group',
                /// create a listOfContactsSelected and send it to individualChat
                onPressed: () {
                  createListOfContactsSelected();

                  ///navigate to creatGroupName_Screen:
                  if(shouldAddNewMemberToTheGroup){
                    print("new list in createGroup: $listOfNumbersInAGroup");
                    CustomNavigator().navigateToHome(context, userName, userPhoneNo);
                    AddNewGroupMember().addToConversationMetadata(conversationId, listOfNumbersInAGroup);
                  }
                  else CustomNavigator().navigateToCreateGroupName_Screen(context, userName, userPhoneNo, listOfNumbersInAGroup);
                }
              ),
            ),
          )
      ),
    );
  }

  bool isNameSelected(){
    if(map.containsValue(true)) return true;
    return false;
  }

  createListOfContactsSelected() {
    bool isAdded;

    map.forEach((key, value) {
      if(value == true){
        isAdded = tempSet.add(key);/// adding the numbers in a set because, if the user comes back from the nameScreen then the numbers shouldnt duplicate in the list, using set ensures that.
        if(isAdded == true){/// if the set already has the number added then dont add it again in the list
          listOfNumbersInAGroup.add(key);
        }
      }
    });

    print("listOfNamesInAGroup : $listOfNumbersInAGroup");
  }




}
