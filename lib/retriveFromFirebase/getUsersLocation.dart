import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/responsive/collectionPaths.dart';
import 'package:gupshop/responsive/textConfig.dart';

class GetUsersLocation{
  String userPhoneNo;

  GetUsersLocation({this.userPhoneNo});

  usersLocationPath() async{
    return await CollectionPaths.usersLocationCollectionPath.document(userPhoneNo).get();
  }

  getHomeAddress() async{
    DocumentSnapshot dc = await usersLocationPath();

    return dc.data["home"];
  }


  getAddressFromAddressName(String addressName) async{
    DocumentSnapshot dc = await usersLocationPath();
    print("dc.data addressName : ${dc.data}");
    Map map = dc.data[addressName];
    return map[TextConfig.usersLocationCollectionAddress];
  }
}