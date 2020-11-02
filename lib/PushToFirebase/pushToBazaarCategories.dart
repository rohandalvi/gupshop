import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarTrace.dart';
import 'package:gupshop/responsive/collectionPaths.dart';
import 'package:gupshop/responsive/textConfig.dart';

class PushToBazaarCategories{

  CollectionReference path(){
    CollectionReference dc = CollectionPaths.bazaarCategoriesCollectionPath;
    return dc;
  }

  addUser(String category, String subCategory, String userName, String userPhoneNo){
    path().document(category).setData({}, merge: true);///creating document to avoid error document(i

    var result = {
      userPhoneNo: {
        TextConfig.nameBazaarCategories: userName
      }
    };
    path().document(category)
    .collection(TextConfig.subCategories).document(subCategory).setData(result,merge: true);

    ///Trace:
    BazaarTrace(category: category,subCategory: subCategory).subCategoryAdded();
  }

}