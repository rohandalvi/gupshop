import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarReviewsCollection.dart';
import 'package:gupshop/responsive/textConfig.dart';

class BazaarReviewsCollection{
  String productWalaNumber;
  String categoryData;
  String subCategoryData;

  BazaarReviewsCollection({this.productWalaNumber, this.categoryData,this.subCategoryData});


  DocumentReference path(){
    return PushToBazaarReviewsCollection().path(productWalaNumber);
  }

  Stream<DocumentSnapshot> getStream() {
    Stream<DocumentSnapshot> stream =  path()
        .collection(categoryData).document(subCategoryData).snapshots();
    return stream;
  }
  
  Stream<QuerySnapshot> getOrderedStream(){
    DocumentReference dr = path();
    Stream<QuerySnapshot> stream =  path().collection(categoryData).document(subCategoryData)
        .collection(TextConfig.reviewsCollectionName)
        .orderBy(TextConfig.timeStamp, descending: true).snapshots();
    return stream;
  }

  check() async{
    DocumentSnapshot dr2 = await path().collection(categoryData).document(subCategoryData)
        .collection(TextConfig.reviewsCollectionName).document("4CHkVgYSogA9AQy6j5Kk").get();
    print("details : ${dr2.data}");
  }
  
}