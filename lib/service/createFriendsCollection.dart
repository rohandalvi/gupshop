import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/PushToFirebase/usersCollection.dart';
import 'package:gupshop/contacts/contactsPermissionHandler.dart';
import 'package:gupshop/contacts/getContactsFromUserPhone.dart';
import 'package:gupshop/PushToFirebase/friendsCollection.dart';
import 'package:gupshop/responsive/textConfig.dart';

class CreateFriendsCollection {
  final String userPhoneNo;
  final String userName;

  CreateFriendsCollection(
      {@required this.userPhoneNo, @required this.userName});

  /// From Iterable contacts we get a list of user's  phone contacts.
  /// Now  we need to compare those contacts with the users we have for our app and get a union.
  /// Now we need to add that union of users to his friends_number collection
  getUnionContacts(BuildContext context) async {
    /// 1st check if the user has granted the permission:
    bool permissionGranted =
        await ContactsPermissionHandler().handlePermissons(context);

    /// if the persmission is granted, then only do the further work
    if (permissionGranted == true) {
      Iterable<Contact> contacts = await _getContactsFromUserPhone();
      return await _loopThroughEachContactToFindUnion(contacts);
    }
  }

  /// Get permission to access contacts using PermissionStatus
  /// (from GetContactsPermission())
  /// Access contacts and get contacts using ContactService and put them
  /// in a array(from GetContactsFromUserPhone())
  Future<Iterable<Contact>> _getContactsFromUserPhone() async {
    Iterable<Contact> result = await GetContactsFromUserPhone().getContacts();
    return result;
  }

  List<List<String>> listOfNames = new List();

  /// Extract only the common contacts using getCommonContacts and push them in friends_number
  /// collection using pushNumberToFriendsCollection(number)
  _loopThroughEachContactToFindUnion(Iterable<Contact> contacts) async {
    List<Future> futures = [];
    for (Contact contact in contacts) {
      Iterable<Item> phones = contact.phones;

      ///we get each phone number as a list
      String displayName = contact.displayName;

      ///we have created a list for names here, because we can later add any additional details too
      ///like family name, suffix, etc
      List<String> userNames = new List();
      userNames.add(displayName);
      listOfNames.add(userNames);

      for (Item phoneList in phones) {
        ///so we need to iterate through that list too
        String number = phoneList.value;
        String nameInUserPhoneBook = phoneList.label;

        ///the format given by Item is => +1 585-754-7599 and we want no spaces and no dash, so => replaceAll
        number = number.replaceAll(' ', '');
        number = number.replaceAll('-', '');
        futures.add(_getCommonContacts(number, displayName));
      }
    }
    Future.wait(futures, eagerError: false, cleanUp: null).then((value){
      for(dynamic val in value) {
        if(val != null) {
          List<String> userNameList = [val[TextConfig.name]];
          pushNumberToFriendsCollection(val[TextConfig.number], userNameList);
        }
      }
    });
  }


  /// Compare the users we have using users collection with the contacts list we
  /// got from getContactsFromUserPhone
  _getCommonContacts(String number, String displayName) async {
    DocumentSnapshot documentSnapshot = await UsersCollection(userPhoneNo: userPhoneNo).path().get();
        //await Firestore.instance.collection("users").document(number).get();
    Map isValid = documentSnapshot.data;

    if(documentSnapshot.exists) {
      if(isValid!=null) {
        return {TextConfig.name: displayName, TextConfig.number: number};
      } else {
        return isValid;
      }
    }
    return isValid;
  }

  ///if name only to be passed to firebase:
  ///_pushNumberToFriendsCollection(String number, String displayName)
  /// Firestore.instance.collection("friends_$userPhoneNo").document(number).setData({'phone': number, 'name' : displayName},merge: true);
  pushNumberToFriendsCollection(String number, List<String> userNames) {
    List<String> listOfNumbers = new List();
    listOfNumbers.add(number);
    FriendsCollection(userPhoneNo: userPhoneNo).addFriend(userNames: userNames, friendNumber: number, listOfNumbers: listOfNumbers);
    // Firestore.instance
    //     .collection("friends_$userPhoneNo")
    //     .document(number)
    //     .setData({
    //   'phone': listOfNumbers,
    //   'nameList': userNames,
    //   'groupName': null,
    //   'isMe': null
    // }, merge: true);
    /// removed merge:true from here
  }
}
