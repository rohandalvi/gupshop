import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateBazaarCategories{
  String category;
  String subCategory;
  String userNumber;

  UpdateBazaarCategories({this.subCategory, this.userNumber, this.category});

}