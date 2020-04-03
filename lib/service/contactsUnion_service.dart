import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/models/contact_data.dart';

class ContactsUnion{


  List<DummyContact> getContactsUnion(List<int> userPhoneContacts){
    List<DummyContact> result;

    StreamBuilder(
      stream: Firestore.instance.collection("users").snapshots(),
      builder: (context, snapshot){
      for(int eachUserPhoneContacts in userPhoneContacts){
        if(snapshot.data.documentID[eachUserPhoneContacts]){
          DummyContact c = new DummyContact(
              phoneNumbers:snapshot.data.doucment[eachUserPhoneContacts].documentID,
              name:snapshot.data.document[eachUserPhoneContacts].data['Name'],
              email: null,
          );
          result.add(c);
        }
      }

    },
    );
  }
}