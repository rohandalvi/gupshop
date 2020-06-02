//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/models/chat_List.dart';
import 'package:gupshop/screens/bazaarHome_screen.dart';
import 'package:gupshop/screens/empty_chatList.dart';
import 'package:gupshop/models/message_model.dart';
import 'package:gupshop/screens/contacts.dart';
import 'package:gupshop/service/contact_search.dart';
import 'package:gupshop/widgets/homeAppBar.dart';
import 'package:gupshop/widgets/sideMenu.dart';

// name screen => home
// home  => bazaarHomeScreen
class Home extends StatefulWidget{
  final String userPhoneNo;
  final String userName;

  Home({@required this.userPhoneNo, @required this.userName});


  @override
  _HomeState createState() => _HomeState(userPhoneNo: userPhoneNo, userName: userName);
}

class _HomeState extends State<Home> {
  final String userPhoneNo;
  final String userName;

  _HomeState({@required this.userPhoneNo, @required this.userName});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.0),//the distance between gupShop and tabBars
            child: HomeAppBar(userName: userName, userPhoneNo: userPhoneNo,),
        ),
        body: TabBarView(
          children: <Widget>[
            //Contacts(),
            chats.length>0 ? ChatList(myNumber: userPhoneNo, myName: userName,): EmptyChatList(),
            BazaarHomeScreen(userPhoneNo: userPhoneNo, userName: userName,),
            //Text('Calls',),
          ],
        ),
        drawer: SideMenu(userName: userName,),
      ),
    );
  }
}

