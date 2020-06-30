import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class SearchContactsList extends StatefulBuilder{
  String userPhoneNo;
  List<DocumentSnapshot> list;
  SearchContactsList({@required this.userPhoneNo});
  /// searchList is basically friends_number collection
  Future<List<DocumentSnapshot>> searchList(String text) async {
    var list = await Firestore.instance.collection(
        "friends_${userPhoneNo}").getDocuments();

    ///right now we have a list for names, but I think this can be changed to just name,
    ///because display name includes firstname and lastname
    ///
    /// if name only is to be passed to firebase:
    /// list.documents.where((l) => l.data["name"].toLowerCase().contains(text.toLowerCase()) ||  l.documentID.contains(text)).toList();
    print("list: ${list.documents[0].data}");
    print("name in list: ${list.documents[0].data["nameList"][0]}");

    ///ToDo- here not just 0, but on every index of the list
    print("list after where: ${list.documents.where((l) =>
    l.data["groupName"] == null &&
    l.data["nameList"][0]
        .toLowerCase()
        .contains(text.toLowerCase()) || l.documentID.contains(text))
        .toList()}");

    return list.documents.where((l) =>
    l.data["groupName"] == null && l.data["nameList"][0]
        .toLowerCase()
        .contains(text.toLowerCase()) || l.documentID.contains(text)).toList();
  }

  createListForSuggestions(StateSetter setState) async {
    print("in createListForSuggestions");
    var temp = await Firestore.instance.collection("friends_$userPhoneNo")
//        .where("groupName", isNull: true)
        .orderBy("nameList", descending: false)
        .where("groupName", isEqualTo: null)
        .getDocuments();
    print("temp in createListForSuggestions: ${temp}");
    var tempList = temp.documents;
    print("temp.documents in createListForSuggestions: ${tempList[3]}");
    setState(() {
      print("in stateSet");
      list = tempList;
      print("list after  setstate: $list");
    });
    return list;
  }

//  getList(){
//    createListForSuggestions((fn) {
//      list = fn;
//    });
//    return list;
//  }

}