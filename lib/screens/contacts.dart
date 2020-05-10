import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contact/contacts.dart';
import 'package:gupshop/models/contact_data.dart';
import 'package:gupshop/service/contact_service.dart';
import 'package:gupshop/service/contact_search.dart';

import 'package:cloud_firestore/cloud_firestore.dart';



class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
//    MockContactService contactService = MockContactService();
//    Stream<DummyContact> stream  = contactService.getCommonContacts(contactService.getContacts());

//    List<Contact> userPhoneContacts = contactService.getContacts();

//    List<Contact> contacts =  contactService.getCommonContacts(userPhoneContacts);
    //print("Printing contacts ${contacts.toString()}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            //Right side icons
            icon: Icon(Icons.search), //search icon
            onPressed: () {
              showSearch(
                context: context,
                //delegate: ContactSearch(),
              );
            }, //imp for pressing effect. Also gives a sound effect by default
          ),
        ],
      ),
    );
  }

}


//StreamBuilder(
//stream: Firestore.instance.collection('users').snapshots(),
//builder: (context, snapshot){
////print("Snap ${snapshot.data.documents[0].data['Name']}");
//if(!snapshot.hasData) return const Text('No contacts to show');
//
//return ListView.separated(
//itemCount: snapshot.data.documents.length,
////contacts.length,
//itemBuilder: (context, index) {
//return Card(
//child: Column(
//children: <Widget>[
//ListTile(
//leading: Icon(
//Icons.account_box,
//color: Theme.of(context).primaryColor,
//size: 26,
//),
//title: Text(snapshot.data.documents[index].data['Name']),
////contacts[index].name
//),
//],
//),
//);
//},
//separatorBuilder: (context, index) => Divider(
//color: Colors.white,
//),
//);
//}
////
//),


//return ListView.separated(
//itemCount: snapshot.,
//itemBuilder: (context,index){
//return Card(
//child: Column(
//children: <Widget>[
//ListTile(
//leading: Icon(
//Icons.account_box,
//color: Theme.of(context).primaryColor,
//size: 26,
//),
//title: Text(snapshot.data.name),
//),
//],
//),
//);
//},
//separatorBuilder: (context,index) => Divider(
//color: Colors.white,
//),
//);