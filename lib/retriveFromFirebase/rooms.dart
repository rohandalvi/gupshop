import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/responsive/collectionPaths.dart';
import 'package:gupshop/responsive/textConfig.dart';

class Rooms{

  CollectionReference path(){
    CollectionReference dc = CollectionPaths.roomsCollectionPath;
    print("dc in path : ${dc}");
    return dc;
  }

  Future<DocumentSnapshot> getDocumentSnapshot({String name}) async{
    DocumentSnapshot ds = await path().document(name).get();
    return ds;
  }

  Future<String> getToken(String name) async{
    DocumentSnapshot ds = await getDocumentSnapshot(name: name);
    String token = ds[TextConfig.token];
    return token;
  }

  Future<String> getIdentity(String name) async{
    DocumentSnapshot ds = await getDocumentSnapshot(name: name);
    String identity = ds[TextConfig.identity];
    return identity;
  }

  Future<bool> getActiveStatus(String name) async{
    DocumentSnapshot ds = await getDocumentSnapshot(name: name);
    bool activeStatus = ds[TextConfig.active];
    return activeStatus;
  }
}