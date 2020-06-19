import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/service/contact_search.dart';
import 'package:gupshop/widgets/colorPalette.dart';
import 'package:gupshop/widgets/customFloatingActionButton.dart';
import 'package:gupshop/widgets/customRaisedButton.dart';
import 'package:gupshop/widgets/customText.dart';

class CreateGroup extends StatefulWidget {
  String userPhoneNo;
  String userName;

  CreateGroup({@required this.userPhoneNo, @required this.userName});

  @override
  _CreateGroupState createState() => _CreateGroupState(userPhoneNo:userPhoneNo, userName:userName);
}

/// Flow:
/// We get the contact list form contactSearch widget created by us which is
/// also used for contact_search.
///
/// If there is even one contact selected then the create group iconButton appears


class _CreateGroupState extends State<CreateGroup> {
  String userPhoneNo;
  String userName;

  _CreateGroupState({@required this.userPhoneNo, @required this.userName});
  /// a map to store the state of contacts and their names, i.e the contacts which are
  /// selected would show as true, and not as false.
  Map<String, bool > map = new HashMap();

  List<String> listOfNamesInAGroup = new List();

  getCategorySizeFuture() async{
    QuerySnapshot querySnapshot = await Firestore.instance.collection("friends_+15857547599").getDocuments();
    if(querySnapshot == null) return CircularProgressIndicator();//to avoid red screen(error)

    Map mapOfDocumentSnapshots = querySnapshot.documents.asMap();

    /// initializing 'map' with false values
    mapOfDocumentSnapshots.forEach((key, value) {
      String name = mapOfDocumentSnapshots[key].data["nameList"][0];
      map.putIfAbsent(name, () => false);
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
      userPhoneNo: '+15857547599',//@todo change this
      userName: 'Rohan Dalvi',
      data: null,
      onItemFound: (DocumentSnapshot doc, int index){
        return Container(
          child: CheckboxListTile(
            title: CustomText(text: doc.data["nameList"][0]),
            value: map[doc.data["nameList"][0]],/// ***
            //list[index],/// at first all the values would be false
            onChanged: (bool val){
              setState(() {
                map[doc.data["nameList"][0]] = val; /// ***
                //list[index] = val;/// if the user changes the value, then the whole widget resets. The values are stored in list
                //checkBoxChecked = val;
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
      visible: isNameSelected(),/// if there is even contact selected, the group icon would show
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 100,/// to increase the size of floatingActionButton use container along with FittedBox
            width: 100,
            child: FittedBox(
              child: CustomFloatingActionButton(
                tooltip: 'Create a new Group',
                /// create a listOfContactsSelected and send it to individualChat
                onPressed: (){
                  createListOfContactsSelected();

                  ///navigate to individualchat:

                },
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

  createListOfContactsSelected(){
    map.forEach((key, value) {
      if(value == true){
        listOfNamesInAGroup.add(key);
      }
    });
    print("listOfNamesInAGroup : $listOfNamesInAGroup");
  }

}
