import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/responsive/collectionPaths.dart';
import 'package:gupshop/responsive/textConfig.dart';

class UsersCollection{
  String userPhoneNo;

  UsersCollection({this.userPhoneNo});

  DocumentReference path(){
    DocumentReference dc = CollectionPaths.usersCollectionPath.document(userPhoneNo);
    return dc;
  }

  setName({String userName}){
    DocumentReference dc = path();
    return dc.setData({TextConfig.name:userName});
  }

  Future<String> getName() async{
    DocumentReference dc = path();
    DocumentSnapshot documentSnapshot = await dc.get();
    String name = documentSnapshot[TextConfig.name];
    return name;
  }
}