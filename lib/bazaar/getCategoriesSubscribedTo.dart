import 'package:cloud_firestore/cloud_firestore.dart';

class GetCategoriesSubscribedTo{
  getCategories(String userNumber, String userName) async{
    QuerySnapshot qc = await Firestore.instance.collection("bazaarWalasBasicProfile").document(userNumber).collection(userName).getDocuments();
    List<DocumentSnapshot> list = qc.documents;

    List<String> result = new List();
    list.forEach((element) {
      result.add(element.documentID);
    });
    print("result : ${result}");

    return result;
  }
}