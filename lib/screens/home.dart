//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/models/chat_List.dart';
import 'package:gupshop/screens/bazaarHome_screen.dart';
import 'package:gupshop/screens/empty_chatList.dart';
import 'package:gupshop/models/message_model.dart';
import 'package:gupshop/screens/contacts.dart';
import 'package:gupshop/service/contact_search.dart';
import 'package:gupshop/widgets/sideMenu.dart';

//==>name screen
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
  Widget appBarScaffold(BuildContext context){
    print("userName= $userName");
    
    return PreferredSize(
      preferredSize: Size.fromHeight(85),//for decresing the size of the appbar
      child: AppBar(
        title: Text(
          'GupShop',
          style: TextStyle(
            color: Colors.white,
          ),
        ),//App name
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(//Right side icons
              color: Colors.white,
              icon: Icon(Icons.search),//search icon
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactSearch(userPhoneNo: userPhoneNo, userName: userName),//pass Name() here and pass Home()in name_screen
                    )
                );
//                final result = await showSearch(
//                  context: context,
//                  delegate: ContactSearch(userPhoneNo: userPhoneNo, userName: userName),
//                );
//                Scaffold.of(context)
//                    .showSnackBar(SnackBar(content: Text(result),));
              },//imp for pressing effect. Also gives a sound effect by default
            ),
          ),
//          IconButton(
//            color: Colors.white,
//            icon: Icon(Icons.more_vert),//three dots
//            onPressed: () {
//              Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                    builder: (context) => SideMenu(userName: userName),//pass Name() here and pass Home()in name_screen
//                  )
//              );
//            },
//          ),
        ],
        bottom: TabBar(
          tabs: <Widget>[
            Tab(
              child: Text(
                'Contacts',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Tab(
              child: Text(
                'Chats',
                style: TextStyle(color: Colors.white),
              ),),
            Tab(
              child: Text(
                'Bazaar',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Tab(
              child: Text(
                'Calls',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 1,
      child: Scaffold(
        appBar: appBarScaffold(context),
        body: TabBarView(
          children: <Widget>[
            Contacts(),
            chats.length>0 ? ChatList(myNumber: userPhoneNo, myName: userName,): EmptyChatList(),
            BazaarHomeScreen(),
            Text('Calls',),
          ],
        ),
        drawer: SideMenu(userName: userName,),
      ),
    );
  }
}

