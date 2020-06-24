import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gupshop/service/contact_search.dart';
import 'package:gupshop/service/createFriendsCollection.dart';
import 'package:gupshop/widgets/customFloatingActionButton.dart';

class ContactSearchPage extends StatelessWidget {
  final String userPhoneNo;
  final String userName;
  final data;
  final Widget Function(DocumentSnapshot item, int index) onItemFound;
  final Future<List<DocumentSnapshot>> Function(String text) onSearch;

  ContactSearchPage({@required this.userPhoneNo, @required this.userName, this.data, this.onItemFound, this.onSearch});



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ContactSearch(userPhoneNo: userPhoneNo, userName: userName, data: data),
        showButton() /// would show only if one or more contact is selected
      ],
    );
  }

  showButton(){
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 100,/// to increase the size of floatingActionButton use container along with FittedBox
          width: 100,
          child: FittedBox(
            child: CustomFloatingActionButton(
              child: IconButton(
                  icon: SvgPicture.asset('images/refresh.svg',)
                //SvgPicture.asset('images/downChevron.svg',)
              ),
              tooltip: 'Refresh Contacts',
              /// create a listOfContactsSelected and send it to individualChat
              onPressed: () {
                CreateFriendsCollection(userName: userName, userPhoneNo: userPhoneNo,).getUnionContacts();
              },
            ),
          ),
        )
    );
  }
}
