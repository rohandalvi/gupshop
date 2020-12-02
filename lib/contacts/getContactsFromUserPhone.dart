/*
2. Access contacts and get contacts using ContactService and put them in a array
 */

import 'package:contacts_service/contacts_service.dart';

class GetContactsFromUserPhone{

  ///Make sure we already have permissions for contacts when we get to this
  ///page, so we can just retrieve it
  Future<Iterable<Contact>> getContacts() async{
    //print("in GetContactsFromUserPhone");
    Iterable<Contact> contacts = await ContactsService.getContacts();
    //print("contacts in getContactFromUserPhone: ${contacts.elementAt(0).phones.elementAt(0).value}");
    return contacts;
  }
}