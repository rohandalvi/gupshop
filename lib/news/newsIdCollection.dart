import 'package:cloud_firestore/cloud_firestore.dart';

class NewsIdCollection{
  createNewsId(var newsData) async{
    DocumentReference idReference = await Firestore.instance.collection("newsIds").add(newsData);
    String id =  idReference.documentID;
    await Firestore.instance.collection("newsIds").document(id).setData({'newsId':id , 'title': newsData["title"], 'link': newsData["link"], 'news':newsData["news"]});
    return id;
  }

//  getNewsId(){
//    Firestore.instance.collection("newsIds").where(field)
//  }
}