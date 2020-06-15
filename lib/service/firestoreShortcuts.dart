import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreShortcuts{
  shortcutToRecentChats(String number) async{
    DocumentSnapshot dc = await Firestore.instance.collection("recentChats").document(number).get();
    print("dc in DocumentSnapshot: ${dc}");
    return dc;
  }
}