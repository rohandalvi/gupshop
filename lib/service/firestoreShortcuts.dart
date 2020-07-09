import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreShortcuts{
  shortcutToRecentChats(String number) async{
    DocumentSnapshot dc = await Firestore.instance.collection("recentChats").document(number).get();

    return dc;
  }

  getVideoURL(String number) async{
    DocumentSnapshot dc = await Firestore.instance.collection("videos").document(number).get();
    print("dc : ${dc.data}");
    return dc;
  }
}