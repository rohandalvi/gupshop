import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/modules/userDetails.dart';

class GetCategoriesFromCategoriesMetadata{

  Future<Map<String, List>> main() async{
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    DocumentSnapshot dc = await Firestore.instance.collection("bazaarCategoriesMetadata").document(userNumber).get();
    print("dc.data : ${dc.data}");
    return dc.data;
  }

  getCategoriesLength() async{
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    DocumentSnapshot dc = await Firestore.instance.collection("bazaarCategoriesMetadata").document(userNumber).get();
    Map<String, dynamic> listOfCategories = dc.data;
    print("listOfCategories : $listOfCategories");
    return dc.data;
  }

}