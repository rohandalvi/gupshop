import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gupshop/bazaar/bazaarIndividualCategoryListData.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/image/displayPicture.dart';
import 'package:gupshop/widgets/customText.dart';

class BazaarHomeGridView extends StatefulWidget {
  @override
  _BazaarHomeGridViewState createState() => _BazaarHomeGridViewState();
}

class _BazaarHomeGridViewState extends State<BazaarHomeGridView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("bazaarCategoryTypesAndImages").snapshots(),
      builder: (context, snapshot) {
        if(snapshot.data == null) return CircularProgressIndicator();//for avoding  the error

        int categoryLength = snapshot.data.documents.length;//for using in
        return Flexible(
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                crossAxisSpacing: 2,///spaces between the boxes verically
                mainAxisSpacing: 2,///spaces between the boxes horizaontally
                //childAspectRatio: 0.9,///size of the box 1.3, 0.85
              ),
              itemCount: categoryLength,
              itemBuilder: (BuildContext context, int index){
                String catergoryName = snapshot.data.documents[index].data['name'];
                String categoryNameForBazaarIndividualCategoryList = snapshot.data.documents[index].documentID;
                String image = snapshot.data.documents[index].data['icon'];

                return Container(
                  padding: EdgeInsets.all(16),
                  //padding: EdgeInsets.only(left: 16, right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: pictureContainer(image, categoryNameForBazaarIndividualCategoryList, catergoryName),
//                    Column(
//                      mainAxisSize: MainAxisSize.min,
//                      children: <Widget>[
//                        //SizedBox(height: 14,),//for space between icon and box on top
//                        InkWell(
//                          onTap: (){
//                            print("categoryNameForBazaarIndividualCategoryList in onTap: $categoryNameForBazaarIndividualCategoryList");
//                            Navigator.push(
//                                context,
//                                MaterialPageRoute(
//                                  builder: (context) => BazaarIndividualCategoryListData(category: categoryNameForBazaarIndividualCategoryList,),//pass Name() here and pass Home()in name_screen
//                                )
//                            );
//                          },
//                          child:
//                          //DisplayPicture(imageURL: image,).forGrid(context),
//                          Image(
//                            image: NetworkImage(image),
//                          )
//                        ),
//                        SizedBox(height: 14,),//this creates a good padding between category name and icon
//                        CustomText(text: catergoryName,),
//                      ],
//                    ),
                );
              },
          ),
        );
      }
    );
  }

  pictureContainer(String image, String categoryNameForBazaarIndividualCategoryList, String catergoryName){
    return Column(
      children: <Widget>[
        InkWell(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BazaarIndividualCategoryListData(category: categoryNameForBazaarIndividualCategoryList,),//pass Name() here and pass Home()in name_screen
                  )
              );
            },
            child:
            //DisplayPicture(imageURL: image,).forGrid(context),
            Container(
              width: MediaQuery.of(context).size.width * 1.25,
              height: MediaQuery.of(context).size.height * 0.13,
              child: Image(
                fit: BoxFit.cover,
                image: NetworkImage(image),
              ),
            )
        ),
        Container(
          color: white,
            child: CustomText(text: catergoryName, fontSize: 18, fontWeight: FontWeight.bold,)
        ),
      ].toList(),
    );
  }
}

