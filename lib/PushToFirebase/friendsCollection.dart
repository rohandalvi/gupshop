import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/responsive/collectionPaths.dart';
import 'package:gupshop/responsive/textConfig.dart';


class FriendsCollection{
  String userPhoneNo;

  FriendsCollection({this.userPhoneNo});

  CollectionReference path(){
    CollectionReference dc =  CollectionPaths.getFriendsCollectionPath(userPhoneNo: userPhoneNo);
    return dc;
  }


  setMeAsFriend(List<String> phoneNumberList, List<String> nameList,){
    DocumentReference dc = path().document(userPhoneNo);
    return dc.setData({TextConfig.phone: phoneNumberList, TextConfig.nameList : nameList, TextConfig.groupName : null, TextConfig.isMe: true});
  }
}