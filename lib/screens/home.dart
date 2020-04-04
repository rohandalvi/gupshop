//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/models/chat_List.dart';
import 'package:gupshop/screens/empty_chatList.dart';
import 'package:gupshop/models/message_model.dart';
import 'package:gupshop/screens/contacts.dart';
import 'package:gupshop/service/contact_search.dart';

class Home extends StatelessWidget{

  Widget appBarScaffold(BuildContext context){
    return AppBar(
      title: Text(
        'GupShop',
        style: TextStyle(
          color: Colors.white,
        ),
      ),//App name
//      actions: <Widget>[
//        IconButton(//Right side icons
//          icon: Icon(Icons.search),//search icon
//          onPressed: () {
//            showSearch(
//              context: context,
//              delegate: ContactSearch(Stream.empty()),
//            );
//          },//imp for pressing effect. Also gives a sound effect by default
//        ),
//        IconButton(
//          icon: Icon(Icons.more_vert),//three dots
//          onPressed: () {},
//        ),
//      ],
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
            chats.length>0 ? ChatList(): EmptyChatList(),
            Text('Bazaar',),
            Text('Calls',),
          ],
        ),
      ),
    );
  }
}

