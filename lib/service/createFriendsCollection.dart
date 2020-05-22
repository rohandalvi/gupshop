/*
3. Compare the users we have using users collection with the contacts array we got from step 2
4. Extract only the common contacts and push them in friends_number collection
 */


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


  /*
  From Iterable contacts we get a list of user's  phone contacts.
  Now  we need to compare those contacts with the users we have for our app and get a union.
  Now we need to add that union of users to his friends_number collection
   */
  getUnionContacts()async{
    Iterable<Contact> contacts = await getContactsFromUserPhone();
    await loopThroughEachContact(contacts);
  }




  /*
  Get permission to access contacts using PermissionStatus(from GetContactsPermission())
  Access contacts and get contacts using ContactService and put them in a array(from GetContactsFromUserPhone())
   */
  getContactsFromUserPhone() async{
    PermissionStatus permission = await GetContactsPermission().getPermission();
    //Accessing contacts only if we have permission
    if(permission == PermissionStatus.granted){
      return await GetContactsFromUserPhone().getContacts();
    }
  }


  loopThroughEachContact(Iterable<Contact> contacts) async{
    for(Contact contact in contacts) {
      Iterable<Item> phones = contact.phones;//we get each phone number as a list

      for(Item phoneList in phones){//so we need to iterate through that list too
        String number = phoneList.value;//ToDo- correct??
        if (await getCommonContacts(number)==true){
          //add to firebase 'friends_number' collection
          number = number.replaceAll(' ', '');//the format given by Item is => +1 585-754-7599 and we want no spaces and no dash, so => replaceAll
          number = number.replaceAll('-', '');

          pushNumberToFriendsCollection(number);
        }
      }
    }
  }

  getCommonContacts(String number) async{
    String firebaseNumber = Firestore.instance.collection("users").document(number).documentID;
    if(number == firebaseNumber) return true;
    else return false;
  }

  pushNumberToFriendsCollection(String number){
    Firestore.instance.collection("friends_$userPhoneNo").document(number).setData({'phone': number},merge: true);
  }

}
