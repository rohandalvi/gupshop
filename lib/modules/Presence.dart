import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:timeago/timeago.dart' as timeago;

class Presence {

  static final String PRESENCE = 'presence';

  FirebaseDatabase database;
  String userPhone;
  Presence(String userPhone) {
    database = FirebaseDatabase(app: FirebaseApp.instance, databaseURL: 'https://gupshop-27dcc.firebaseio.com/');
    this.userPhone = userPhone;
    init();
  }

  Future<String> getStatus(String number) async{
    DataSnapshot once = await database.reference().child(PRESENCE).child(number).once();
    try {
      DateTime.parse(once.toString());
      return 'Last Seen '+timeago.format(DateTime.parse(once.toString()));
    } catch(e) {
      return once.toString();
    }
  }

  void init() {
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    setupOnlinePresence();
    setupOnDisconnect();
  }

  void setupOnlinePresence() {
    database.reference().child(PRESENCE).child(userPhone).set('Online');
  }

  void setupOnDisconnect() {
    database.reference().child(PRESENCE).child(userPhone).onDisconnect().set(Timestamp.now().toDate().toString());
  }


}