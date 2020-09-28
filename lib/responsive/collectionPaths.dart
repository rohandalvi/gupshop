import 'package:gupshop/responsive/textConfig.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionPaths{

  static getBase(String collectionName){
    return Firestore.instance.collection(collectionName);
  }

  static CollectionReference usersLocationCollectionPath = getBase(TextConfig.usersLocationCollectionName);
  //Firestore.instance.collection(TextConfig.usersLocationCollectionName);
  static CollectionReference bazaarWalasLocationCollectionPath =  getBase(TextConfig.bazaarWalasLocationCollectionName);
  //Firestore.instance.collection(TextConfig.bazaarWalasLocationCollectionName);
  static CollectionReference usersCollectionPath =  getBase(TextConfig.usersCollectionName);
  //Firestore.instance.collection(TextConfig.usersCollectionName);
  static CollectionReference recentChatsCollectionPath =  getBase(TextConfig.recentChatsCollectionName);
  //Firestore.instance.collection(TextConfig.recentChatsCollectionName);
  static CollectionReference profilePicturesChatsCollectionPath =  getBase(TextConfig.profilePicturesCollectionName);
  //Firestore.instance.collection(TextConfig.profilePicturesCollectionName);
  static CollectionReference getFriendsCollectionPath({String userPhoneNo}){
    CollectionReference c =  Firestore.instance.collection(TextConfig.getFriendsCollectionName(userPhoneNo: userPhoneNo));
    return c;
  }
  static CollectionReference conversationMetadataCollectionPath = getBase(TextConfig.conversationMetadataCollectionName);
}