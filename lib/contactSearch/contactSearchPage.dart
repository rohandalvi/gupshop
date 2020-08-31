import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gupshop/contactSearch/contact_search.dart';
import 'package:gupshop/service/createFriendsCollection.dart';
import 'package:gupshop/widgets/customNavigators.dart';
import 'package:gupshop/widgets/customFloatingActionButton.dart';

class ContactSearchPage extends StatefulWidget {
  final String userPhoneNo;
  final String userName;
  final data;
  final Widget Function(DocumentSnapshot item, int index) onItemFound;
  final Future<List<DocumentSnapshot>> Function(String text) onSearch;

  ContactSearchPage({@required this.userPhoneNo, @required this.userName, this.data, this.onItemFound, this.onSearch});

  @override
  _ContactSearchPageState createState() => _ContactSearchPageState();
}

class _ContactSearchPageState extends State<ContactSearchPage> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ContactSearch(userPhoneNo: widget.userPhoneNo, userName: widget.userName, data: widget.data,),
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
                /// a hack to show refreshed contacts,CreateFriendsCollection refreshes new friends in in the database.
                /// But because, the list that is showing up as suggestion in the display is initiatied  in initState of
                /// contact_search page, it is not called with setState as setState only calls the build and not
                /// the initState. Now this list cannot be initiated in the build itself because the method
                /// that created the list uses setState in it and, setState cannot be called in build method.
                /// So we are left with the option of Navigating to contact_search by which the initState will get
                /// called and we will get a refreshed list.
                /// After navigating to contact_Search we again need to come back to this page, so we are
                /// using another naviagator navigateToContactSearchPage for that
                CreateFriendsCollection(userPhoneNo: widget.userPhoneNo, userName: widget.userName).getUnionContacts();
                CustomNavigator().navigateToContactSearch(context, widget.userName, widget.userPhoneNo, null);
                CustomNavigator().navigateToContactSearchPage(context, widget.userName, widget.userPhoneNo, null);
//               setState(() {
//                 CreateFriendsCollection(userPhoneNo: widget.userPhoneNo, userName: widget.userName).getUnionContacts();
//               });

              },
            ),
          ),
        )
    );
  }
}
