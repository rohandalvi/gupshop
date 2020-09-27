import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/responsive/collectionPaths.dart';


class FriendsCollection{
  String userPhoneNo;

  FriendsCollection({this.userPhoneNo});

  CollectionReference path(){
    CollectionReference dc =  CollectionPaths.getFriendsCollectionPath(userPhoneNo: userPhoneNo);
    return dc;
  }


  setMeAsFriend(List<String> phoneNumberList, List<String> nameList,){
    DocumentReference dc = path().document(userPhoneNo);
    return dc.setData({'phone': phoneNumberList, 'nameList' : nameList, 'groupName' : null, 'isMe': true});
  }
}