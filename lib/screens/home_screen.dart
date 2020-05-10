import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/widgets/category_selector.dart';
import 'package:gupshop/widgets/message_card.dart';

import 'package:gupshop/models/chat_List.dart';
import 'package:gupshop/screens/bazaarHome_screen.dart';
import 'package:gupshop/screens/empty_chatList.dart';
import 'package:gupshop/models/message_model.dart';
import 'package:gupshop/screens/contacts.dart';
import 'package:gupshop/service/contact_search.dart';
import 'package:gupshop/widgets/sideMenu.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {

  String userPhoneNo;
  String userName;

  Widget appBarScaffold(BuildContext context){
    print("Gupshop");
       return Scaffold(
         appBar: AppBar(
           title: Text(
           'GupShop',
           style: TextStyle(
             color: Colors.white,
           ),
         ),
           actions: <Widget>[
             Builder(
               builder: (context) => IconButton(//Right side icons
                 color: Colors.white,
                 icon: Icon(Icons.search),//search icon
                 onPressed: () async {
                   final result = await showSearch(
                     context: context,
                    // delegate: ContactSearch(userPhoneNo: userPhoneNo, userName: userName),
                   );
                   Scaffold.of(context)
                       .showSnackBar(SnackBar(content: Text(result),));
                 },//imp for pressing effect. Also gives a sound effect by default
               ),
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
         ),
         drawer: Drawer(),

      );
  }


  @override
  Widget build(BuildContext context) {
    print("insiide build");
    return DefaultTabController(
      length: 4,
      initialIndex: 1,
      child: Scaffold(
        //appBar: appBarScaffold(context),
        body: TabBarView(
          children: <Widget>[
            Contacts(),
            chats.length>0 ? ChatList(myNumber: userPhoneNo, myName: userName,): EmptyChatList(),
            BazaarHomeScreen(),
            Text('Calls',),
          ],
        ),
      ),
    );
  }


}


