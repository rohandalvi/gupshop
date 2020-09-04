import 'package:cloud_firestore/cloud_firestore.dart';

class GetUsersLocation{
  String userPhoneNo;

  GetUsersLocation({this.userPhoneNo});

  getAddress() async{
    return await Firestore.instance.collection("usersLocation").document(userPhoneNo).get();
  }

  getHomeAddress() async{
    DocumentSnapshot dc = await getAddress();

    return dc.data["home"];
  }

}