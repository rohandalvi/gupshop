import 'package:gupshop/responsive/collectionPaths.dart';

class PushToUsersLocationCollection{

  pushUsersLocationToFirebase({String userNumber, String locationName, var dataMap}){
    return CollectionPaths.usersLocationCollectionPath.document(userNumber).setData({locationName: dataMap}, merge:true);//merge true imp for setting multiple locations
  }
}