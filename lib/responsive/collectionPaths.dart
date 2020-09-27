import 'package:gupshop/responsive/textConfig.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionPaths{

  static CollectionReference usersLocationCollectionPath = Firestore.instance.collection(TextConfig.usersLocationCollectionName);
  static CollectionReference bazaarWalasLocationCollectionPath =  Firestore.instance.collection(TextConfig.bazaarWalasLocationCollectionName);
}