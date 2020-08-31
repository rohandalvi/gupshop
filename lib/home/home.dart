
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/chat_list_page/chat_List.dart';
import 'package:gupshop/modules/Presence.dart';
import 'package:gupshop/bazaar/bazaarHome_screen.dart';
import 'package:gupshop/savedMessages/displaySavedMessagedBoardNames.dart';
import 'package:gupshop/savedMessages/displaySavedMessages.dart';
import 'package:gupshop/home/homeAppBar.dart';
import 'package:gupshop/widgets/sideMenu.dart';

// name screen => home
// home  => bazaarHomeScreen
class Home extends StatefulWidget{
  final String userPhoneNo;
  final String userName;
  List<String> phoneNumberList;
  Presence presence;
  final int initialIndex;
  Home({@required this.userPhoneNo, @required this.userName, @required this.phoneNumberList, this.initialIndex});


  @override
  _HomeState createState() {
    presence = new Presence(this.userPhoneNo);
    return _HomeState(userPhoneNo: userPhoneNo, userName: userName, phoneNumberList: phoneNumberList);
  }
}

class _HomeState extends State<Home> {
  final String userPhoneNo;
  final String userName;
  List<String> phoneNumberList;

  _HomeState({@required this.userPhoneNo, @required this.userName,@required this.phoneNumberList });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: DefaultTabController(
        length: 2,
        initialIndex: widget.initialIndex == null ? 0 : widget.initialIndex,
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(120.0),//the distance between gupShop and tabBars
              child: HomeAppBar(userName: userName, userPhoneNo: userPhoneNo,),
          ),
          body: TabBarView(
            children: <Widget>[
              //Contacts(),
              ChatList(myNumber: userPhoneNo, myName: userName,),
              BazaarHomeScreen(userPhoneNo: userPhoneNo, userName: userName,),
              //Text('Calls',),
            ],
          ),
          drawer: SideMenu(userName: userName,),
        ),
      ),
    );
  }
}

