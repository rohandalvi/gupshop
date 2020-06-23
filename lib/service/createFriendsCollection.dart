import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/service/getContactsFromUserPhone.dart';
import 'package:gupshop/service/getContactsPermission.dart';
import 'package:permission_handler/permission_handler.dart';


class CreateFriendsCollection{
  final String userPhoneNo;
  final String userName;

  CreateFriendsCollection({@required this.userPhoneNo, @required this.userName});



  /// From Iterable contacts we get a list of user's  phone contacts.
  /// Now  we need to compare those contacts with the users we have for our app and get a union.
  /// Now we need to add that union of users to his friends_number collection
  getUnionContacts()async{
    Iterable<Contact> contacts = await _getContactsFromUserPhone();
    //print("contacts list: $contacts");
    return await _loopThroughEachContactToFindUnion(contacts);
  }





  /// Get permission to access contacts using PermissionStatus
  /// (from GetContactsPermission())
  /// Access contacts and get contacts using ContactService and put them
  /// in a array(from GetContactsFromUserPhone())
  _getContactsFromUserPhone() async{
    PermissionStatus permission = await GetContactsPermission().getPermission();
    //Accessing contacts only if we have permission
    if(permission == PermissionStatus.granted){
      return await GetContactsFromUserPhone().getContacts();
    } else {
      //ToDo
    }
  }

  List<List<String>> listOfNames = new List();

  /// Extract only the common contacts using getCommonContacts and push them in friends_number
  /// collection using pushNumberToFriendsCollection(number)
  _loopThroughEachContactToFindUnion(Iterable<Contact> contacts) async{
    for(Contact contact in contacts) {
      Iterable<Item> phones = contact.phones;///we get each phone number as a list
      String  displayName= contact.displayName;
      ///we have created a list for names here, because we can later add any additional details too
      ///like family name, suffix, etc
      List<String> userNames = new List();
      userNames.add(displayName);
      listOfNames.add(userNames);


      for(Item phoneList in phones){///so we need to iterate through that list too
        String number = phoneList.value;
        String nameInUserPhoneBook = phoneList.label;

        number = number.replaceAll(' ', '');//the format given by Item is => +1 585-754-7599 and we want no spaces and no dash, so => replaceAll
        number = number.replaceAll('-', '');
        if (await _getCommonContacts(number)==true){
          ///add to firebase 'friends_number' collection
//          number = number.replaceAll(' ', '');//the format given by Item is => +1 585-754-7599 and we want no spaces and no dash, so => replaceAll
//          number = number.replaceAll('-', '');

          ///if name only is to be passed to firebase:
          ///_pushNumberToFriendsCollection(number, displayName);
          pushNumberToFriendsCollection(number, userNames);
        }

      }
    }
  }

  /*
  Compare the users we have using users collection with the contacts list we
  got from getContactsFromUserPhone
   */
  _getCommonContacts(String number) async{
    DocumentSnapshot documentSnapshot = await Firestore.instance.collection("users").document(number).get();
    Map isValid = documentSnapshot.data;

//    print("number in _getCommonContacts : $number");
//    String firebaseNumber = Firestore.instance.collection("users").document(number).documentID;
//    print("what is this: ${Firestore.instance.collection("users").document(number).get()}");
//    print("firebaseNumber: $firebaseNumber");

    if(isValid == null) {
      print("not a friend");
      return false;}
    else {
      print("is a friend");
      return true;}
  }


  ///if name only to be passed to firebase:
  ///_pushNumberToFriendsCollection(String number, String displayName)
  /// Firestore.instance.collection("friends_$userPhoneNo").document(number).setData({'phone': number, 'name' : displayName},merge: true);
  pushNumberToFriendsCollection(String number, List<String> userNames){
    List<String> listOfNumbers = new List();
    listOfNumbers.add(number);
    print("number in _pushNumberToFriendsCollection: $number");
    Firestore.instance.collection("friends_$userPhoneNo").document(number).setData({'phone': listOfNumbers, 'nameList' : userNames},merge: true);
  }

//  _pushNumberToFriendsCollection(String number){
//    print("number in _pushNumberToFriendsCollection: $number");
//    Firestore.instance.collection("friends_$userPhoneNo").document(number).setData({'phone': number,},merge: true);
//  }

}
