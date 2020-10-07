import 'package:gupshop/responsive/textConfig.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionPaths{

  static getBase(String collectionName){
    return Firestore.instance.collection(collectionName);
  }

  static CollectionReference usersLocationCollectionPath = getBase(TextConfig.usersLocationCollectionName);
  static CollectionReference bazaarWalasLocationCollectionPath =  getBase(TextConfig.bazaarWalasLocationCollectionName);
  static CollectionReference bazaarReviewsCollectionPath =  getBase(TextConfig.bazaarReviewsCollectionName);
  static CollectionReference usersCollectionPath =  getBase(TextConfig.usersCollectionName);
  static CollectionReference recentChatsCollectionPath =  getBase(TextConfig.recentChatsCollectionName);
  static CollectionReference profilePicturesChatsCollectionPath =  getBase(TextConfig.profilePicturesCollectionName);
  static CollectionReference getFriendsCollectionPath({String userPhoneNo}){
    CollectionReference c =  Firestore.instance.collection(TextConfig.getFriendsCollectionName(userPhoneNo: userPhoneNo));
    return c;
  }
  static CollectionReference conversationMetadataCollectionPath = getBase(TextConfig.conversationMetadataCollectionName);
  static CollectionReference bazaarCategoriesCollectionPath =  getBase(TextConfig.bazaarCategoriesCollectionName);
  static CollectionReference bazaarRatingNumbersCollectionPath =  getBase(TextConfig.bazaarRatingNumbersCollectionName);
  static CollectionReference bazaarWalasBasicProfileCollectionPath =  getBase(TextConfig.bazaarWalasBasicProfileCollectionName);
}