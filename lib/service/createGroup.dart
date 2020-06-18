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
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

/// Flow:
/// We get the contact list form contactSearch widget created by us which is
/// also used for contact_search.
///
/// If there is even one contact selected then the create group iconButton appears


class _CreateGroupState extends State<CreateGroup> {
  /// a list to store the state of contacts, i.e the contacts which are
  /// selected would show as true, and not as false.
  List<bool> list = new List<bool>();
  //bool checkBoxChecked = false;

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
      userPhoneNo: '+15857547599',
      userName: 'Rohan Dalvi',
      data: null,
      onItemFound: (DocumentSnapshot doc, int index){
        list.add(false);/// setting all the values as false for first time, because list has 'null' as value right now
        return Container(
          child: CheckboxListTile(
            title: CustomText(text: doc.data["nameList"][0]),
            value: list[index],/// at first all the values would be false
            onChanged: (bool val){
              setState(() {
                list[index] = val;/// if the user changes the value, then the whole widget resets. The values are stored in list
                //checkBoxChecked = val;
              });
            },
          ),
        );
        //title: CustomText(text: doc.data["nameList"][0]),
      },
    );
  }
  void itemChange(bool val, int index){/// changes the value in the list and rebuilts the widget
    setState(() {
      list[index] = val;
    });
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
              child: CustomFloatingActionButton(tooltip: 'Create a new Group',),
            ),
          )
      ),
    );
  }

  bool isNameSelected(){
    for(int i=0; i<list.length; i++){
      if(list[i] == true){
        return true;
      }
    }
    return false;
  }
}
