import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/responsive/collectionPaths.dart';
import 'package:gupshop/responsive/textConfig.dart';

class GetUsersLocation{
  String userPhoneNo;

  GetUsersLocation({this.userPhoneNo});

  path() async{
    return await CollectionPaths.usersLocationCollectionPath.document(userPhoneNo).get();
  }

  getHomeAddress() async{
    DocumentSnapshot dc = await path();

    return dc.data[TextConfig.usersLocationCollectionHome];
  }


  getAddressFromAddressName(String addressName) async{
    DocumentSnapshot dc = await path();
    Map map = dc.data[addressName];
    return map[TextConfig.usersLocationCollectionAddress];
  }
}