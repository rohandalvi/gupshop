import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/responsive/collectionPaths.dart';
import 'package:gupshop/responsive/textConfig.dart';


class Status{
  String userPhoneNo;

  Status({this.userPhoneNo});

  DocumentReference path({String userPhoneNo}){
    DocumentReference dc = CollectionPaths.statusCollectionPath.document(userPhoneNo);
    return dc;
  }


  ///  If the document does not yet exist, it will be created
  ///  If the document does exist, it will be overwritten
  Future<void> setStatus(String statusName, String iconName){
    DocumentReference dc = path();
    return dc.setData({TextConfig.statusName : statusName, TextConfig.iconName :iconName});
  }

  Future<String> getIconName({String userPhoneNo}) async{
    DocumentReference dc = path();
    DocumentSnapshot documentSnapshot = await dc.get();
    String iconName = documentSnapshot[TextConfig.iconName];
    return iconName;
  }

  Future<String> getStatusName({String userPhoneNo}) async{
    DocumentReference dc = path();
    DocumentSnapshot documentSnapshot = await dc.get();
    String iconName = documentSnapshot[TextConfig.iconName];
    return iconName;
  }
}