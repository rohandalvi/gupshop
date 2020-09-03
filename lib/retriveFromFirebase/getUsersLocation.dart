import 'package:cloud_firestore/cloud_firestore.dart';

class GetUsersLocation{
  String userPhoneNo;

  GetUsersLocation({this.userPhoneNo});

  getAddress() async{
    return await Firestore.instance.collection("usersLocation").document(userPhoneNo).get();
  }

  getHomeAddress() async{
    DocumentSnapshot dc = await getAddress();

    print("dc in getHomeAddress : ${dc.data}");
    print("dc.data[home]: ${dc.data["home"]}");
    return dc.data["home"];
  }

}