import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contact/contacts.dart';
import 'package:gupshop/models/contact_data.dart';
import 'package:gupshop/service/contact_search.dart';

abstract class  ContactService {


  List<DummyContact> getContacts();
  List<DummyContact> getContactsFromFirebase();
}

class MockContactService extends ContactService {
  @override
  List<DummyContact> getContacts() {
    // TODO: implement getContacts
    List p1 = [9194134191];
    List<DummyContact> list  = [
      DummyContact(
          phoneNumbers: p1,
          name: "purva",
          email: ""
      ),
      DummyContact(
          phoneNumbers: [5857547599],
          name: "rohan",
          email: ""
      )

    ];
    return list;

  }

  List<DummyContact> getContactsFromFirebase() {
    Firestore firestore = Firestore.instance;
    firestore.collection("users").getDocuments().then((value) {

      print("Got value ${value.documents.elementAt(0).data["name"]}");
    });
  }


  //contacts common between user and database
//  List<Contact> getCommonContacts(List<Contact> contacts)  {
//    print("Input ${contacts}");
//    List<Contact> list  = [];
//
//
//    for(Contact contact in contacts) {
//      // for each contact
//      for (int i = 0; i < contact.phoneNumbers.length; i++) {
//        int phoneNumber = contact.phoneNumbers[i];
//        DocumentReference documentReference = Firestore.instance.collection("users").document(phoneNumber.toString());
//        print("DocumentRef for ${phoneNumber} is  ${documentReference}");
//        if(documentReference!=null) {
//          documentReference.get().then((value) {
//            if(value.data!=null && value.data.containsKey('Name')) {
//              String name = value.data['Name'];
//              list.add(Contact(phoneNumbers: [phoneNumber],name: name, email: ""  ));
//              print("Added to list ${value}");
//            }
//          });
//        }
//      }
//    }
//    print("Returning list  ${list}");
//    return list;
//  }

  getPhoneContacts() {
    return Contacts.streamContacts();
  }

  Stream<DummyContact> getCommonContacts(List<DummyContact> contacts)  {
    final StreamController<DummyContact> dummyContactController = StreamController<DummyContact>.broadcast();
    Stream<DummyContact> dummyContactStream = dummyContactController.stream;

    print("Input ${contacts}");
    List<Future<DocumentSnapshot>> list  = [];

    for(DummyContact contact in contacts) {
      // for each contact
      for (int i = 0; i < contact.phoneNumbers.length; i++) {
        int phoneNumber = contact.phoneNumbers[i];
        DocumentReference documentReference = Firestore.instance.collection("users").document(phoneNumber.toString());
        print("DocumentRef for ${phoneNumber} is  ${documentReference}");
        if(documentReference!=null) {
          list.add(documentReference.get());
          documentReference.get().then((value) {
            if(value.data!=null && value.data.containsKey('Name')) {
              dummyContactController.sink.add(new DummyContact(phoneNumbers: [phoneNumber], name:  value.data['Name'], email: ""));
              print("Added to list ${value}");
            }
          });
        }
      }
    }
    print("Returning list  ${list}");
    return dummyContactStream;
  }


}

