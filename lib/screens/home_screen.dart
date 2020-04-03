import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/widgets/category_selector.dart';
import 'package:gupshop/widgets/message_card.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  int index=0;
  List<String> list = ['Messages', 'Media', 'Online'];

  Widget build(BuildContext context) {
       return Scaffold(
          appBar: AppBar(
            leading: IconButton(//left top side of the app bar
              icon: Icon(Icons.menu),//three lines icon in the leading area
              iconSize: 30.0,
              color: Colors.white,
              onPressed: () {},
            ),
             title: CategorySelector(),
            elevation: 0.0,//to remove the border between the app bar and
            actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              iconSize: 30.0,
              color: Colors.white,
              onPressed: () {},
            ),
            ],
          ),
          body: Column(
            children: <Widget>[
              MessageCard()
            ],
          ),
      );
  }
}
