import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/responsive/collectionPaths.dart';
import 'package:gupshop/responsive/textConfig.dart';

/// used in showing icons and iconNames in status search page
class StatusMap{
  String userPhoneNo;

  StatusMap({this.userPhoneNo});

  CollectionReference path(){
    CollectionReference dc = CollectionPaths.statusMapCollectionPath;
    return dc;
  }


  Future<DocumentSnapshot> getStatusSnapshot(String status) async{
    DocumentSnapshot dc = await path().document(status).get();
    return dc;
  }

  Future<String> getIcon(String status) async{
    DocumentSnapshot dc = await getStatusSnapshot(status);
    String icon = dc[TextConfig.iconName];
    return icon;
  }

  Future<String> getStatusName(String status) async{
    DocumentSnapshot dc = await getStatusSnapshot(status);
    String statusName = dc[TextConfig.statusName];
    return statusName;
  }



  Future<Map<String, String>> getStatusMap() async{
    Map<String, String> statusMap = new SplayTreeMap();
    QuerySnapshot qs = await path().getDocuments();
    List<DocumentSnapshot> list = qs.documents;

    for(int i =0; i<list.length; i++){
      String iconName = list[i].data[TextConfig.iconName];
      String statusName = list[i].data[TextConfig.statusName];
      statusMap[statusName] = iconName;
    }
    return statusMap;
  }

  Future<List<String>> getStatusNameList() async{
    List<String> statusNameList = new List();
    QuerySnapshot qs = await path().getDocuments();
    List<DocumentSnapshot> list = qs.documents;

    for(int i =0; i<list.length; i++){
      String statusName = list[i].data[TextConfig.statusName];
      statusNameList.add(statusName);
    }
    return statusNameList;
  }

}