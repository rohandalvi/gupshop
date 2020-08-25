import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaar/bazaarIndividualCategoryListData.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/image/gridViewContainer.dart';
import 'package:gupshop/responsive/sizeConfig.dart';
import 'package:gupshop/bazaar/customGridView.dart';
import 'package:gupshop/widgets/customText.dart';

class BazaarHomeGridView extends StatefulWidget {
  @override
  _BazaarHomeGridViewState createState() => _BazaarHomeGridViewState();
}

//class _BazaarHomeGridViewState extends State<BazaarHomeGridView> {
//  @override
//  Widget build(BuildContext context) {
//    return StreamBuilder<QuerySnapshot>(
//      stream: Firestore.instance.collection("bazaarCategoryTypesAndImages").snapshots(),
//      builder: (context, snapshot) {
//        if(snapshot.data == null) return CircularProgressIndicator();//for avoding  the error
//
//        int categoryLength = snapshot.data.documents.length;//for using in
//        return Flexible(
//          child: GridView.builder(
//              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                  crossAxisCount: 2,
//                crossAxisSpacing: 2,///spaces between the boxes verically
//                mainAxisSpacing: 2,///spaces between the boxes horizaontally
//                //childAspectRatio: 0.9,///size of the box 1.3, 0.85
//              ),
//              itemCount: categoryLength,
//              itemBuilder: (BuildContext context, int index){
//                String catergoryName = snapshot.data.documents[index].data['name'];
//                String categoryNameForBazaarIndividualCategoryList = snapshot.data.documents[index].documentID;
//                String image = snapshot.data.documents[index].data['icon'];
//
//                return Container(
//                  width: SizeConfig.widthMultiplier,/// todo - required?
//                  height: SizeConfig.heightMultiplier,/// todo - required?
//                  padding: EdgeInsets.all(16),
//                  decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(10),
//                    color: Colors.white,
//                  ),
//                  child: pictureContainer(image, catergoryName),
//                );
//              },
//          ),
//        );
//      }
//    );
//  }
//
//  pictureContainer(String image,  String catergoryName,){
//    return Column(
//      children: <Widget>[
//        InkWell(
//            onTap: (){
//              Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                    builder: (context) => BazaarIndividualCategoryListData(
//                      category : catergoryName,
//                      //category: categoryNameForBazaarIndividualCategoryList,
//                    ),//pass Name() here and pass Home()in name_screen
//                  )
//              );
//            },
//            child: Container(
//              width: MediaQuery.of(context).size.width * 1.25,
//              height: MediaQuery.of(context).size.height * 0.13,
//              child: Image(
//                fit: BoxFit.cover,
//                image: NetworkImage(image),
//              ),
//            )
//        ),
//        Container(
//          color: white,
//            child: CustomText(text: catergoryName, fontWeight: FontWeight.bold,)
//        ),
//      ].toList(),
//    );
//  }
//}

class _BazaarHomeGridViewState extends State<BazaarHomeGridView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("bazaarCategoryTypesAndImages").snapshots(),
        builder: (context, snapshot) {
          if(snapshot.data == null) return CircularProgressIndicator();//for avoding  the error

          int categoryLength = snapshot.data.documents.length;//for using in
          return CustomGridView(
            itemCount: categoryLength,
            itemBuilder: (BuildContext context, int index){
              String catergoryName = snapshot.data.documents[index].data['name'];
              String categoryNameForBazaarIndividualCategoryList = snapshot.data.documents[index].documentID;
              String imageURL = snapshot.data.documents[index].data['icon'];

              return GridViewContainer(
                onPictureTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BazaarIndividualCategoryListData(
                          category : catergoryName,
                          //category: categoryNameForBazaarIndividualCategoryList,
                        ),//pass Name() here and pass Home()in name_screen
                      )
                  );
                },
                imageName: catergoryName,
                imageURL: imageURL,
              );
            },
          );
        }
    );
  }
}

