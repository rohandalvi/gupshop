import 'package:cloud_firestore/cloud_firestore.dart';

class GetCategoriesSubscribedTo{
  getCategories(String userNumber, String userName) async{
    /// this will change, because of change in bazaarWalasBasicProfile
    /// this will be used in SelectCategoryToShowInProductDetailsPage
    /// toDo- create seperate method to return the result,
    /// SelectCategoryToShowInProductDetailsPage requires future
    QuerySnapshot qc = await Firestore.instance.collection("bazaarWalasBasicProfile").document(userNumber).collection(userName).getDocuments();
    List<DocumentSnapshot> list = qc.documents;

    List<String> result = new List();
    list.forEach((element) {
      result.add(element.documentID);
    });

    return result;
  }
}