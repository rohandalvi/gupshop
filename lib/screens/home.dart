//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/models/chat_List.dart';
import 'package:gupshop/screens/empty_chatList.dart';
import 'package:gupshop/models/message_model.dart';
import 'package:gupshop/screens/contacts.dart';
import 'package:gupshop/service/contact_search.dart';

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
    return AppBar(
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
            onPressed: () async {
              final result = await showSearch(
                context: context,
                delegate: ContactSearch(userPhoneNo: userPhoneNo, userName: userName),
              );
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text(result),));
            },//imp for pressing effect. Also gives a sound effect by default
          ),
        ),
        IconButton(
          color: Colors.white,
          icon: Icon(Icons.more_vert),//three dots
          onPressed: () {},
        ),
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
            chats.length>0 ? ChatList(myNumber: userPhoneNo): EmptyChatList(),
            Text('Bazaar',),
            Text('Calls',),
          ],
        ),
      ),
    );
  }
}

