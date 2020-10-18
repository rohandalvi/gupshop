import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

/// unused class

class GetCategoriesSubscribedTo{
  String userNumber;
  String userName;

  GetCategoriesSubscribedTo({@required this.userNumber, @required this.userName});

  Future<List<String>> getCategories(String text) async{
    /// this will change, because of change in bazaarWalasBasicProfile
    /// this will be used in SelectCategoryToShowInProductDetailsPage
    /// toDo- create seperate method to return the result,
    /// SelectCategoryToShowInProductDetailsPage requires future
    DocumentSnapshot dc = await Firestore.instance.collection("bazaarWalasBasicProfile").document(userNumber).get();
    List<String> list = dc.data["categories"].cast<String>();

//    List<String> result = new List();
//    list.forEach((element) {
//      result.add(element.documentID);
//    });

    return list;
  }

  getCategoriesAsSuggestionList() async{
    DocumentSnapshot dc = await Firestore.instance.collection("bazaarWalasBasicProfile").document(userNumber).get();
    List<dynamic> list = dc.data["categories"].cast<String>();
    print("list for suggestions : $list");
    return list;
  }
}